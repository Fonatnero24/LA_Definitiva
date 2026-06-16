@tool
extends Control

signal selection_changed(index: int)
signal element_rect_changed(index: int, rect: Rect2, finished: bool)

var canvas_size: Vector2 = Vector2(900.0, 240.0)
var canvas_color: Color = Color(0.008, 0.012, 0.018, 1.0)
var elements: Array = []
var images: Array = []
var selected_index: int = -1
var snap_enabled: bool = true
var snap_step: float = 1.0
var show_images: bool = true
var show_background: bool = true
var show_real_text: bool = true
var show_styles: bool = true
var show_metrics: bool = false
var show_runtime_preview: bool = true
var show_guides: bool = false
var show_hidden: bool = false
var active_view_tag: String = "all"
var background_path: String = ""
var preview_font: Font

var _view_scale: float = 1.0
var _view_offset: Vector2 = Vector2.ZERO
var _dragging: bool = false
var _resizing: bool = false
var _drag_origin_mouse: Vector2 = Vector2.ZERO
var _drag_origin_rect: Rect2 = Rect2()
var _texture_cache: Dictionary = {}


func _ready() -> void:
	custom_minimum_size = Vector2(520.0, 360.0)
	mouse_filter = Control.MOUSE_FILTER_STOP
	texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	resized.connect(queue_redraw)


func set_document(
	new_canvas_size: Vector2,
	new_elements: Array,
	new_images: Array = [],
	new_background_path: String = "",
	new_canvas_color: Color = Color(0.008, 0.012, 0.018, 1.0),
	new_font_path: String = ""
) -> void:
	canvas_size = Vector2(maxf(1.0, new_canvas_size.x), maxf(1.0, new_canvas_size.y))
	elements = new_elements
	images = new_images
	background_path = new_background_path
	canvas_color = new_canvas_color
	preview_font = null
	if not new_font_path.is_empty() and ResourceLoader.exists(new_font_path):
		preview_font = load(new_font_path) as Font
	selected_index = -1
	_texture_cache.clear()
	queue_redraw()


func set_canvas_size(value: Vector2) -> void:
	canvas_size = Vector2(maxf(1.0, value.x), maxf(1.0, value.y))
	selected_index = -1
	queue_redraw()


func set_active_view(tag: String) -> void:
	active_view_tag = tag if not tag.is_empty() else "all"
	selected_index = -1
	queue_redraw()


func set_background_path(path: String) -> void:
	background_path = path
	queue_redraw()


func set_show_images(enabled: bool) -> void:
	show_images = enabled
	queue_redraw()


func set_show_background(enabled: bool) -> void:
	show_background = enabled
	queue_redraw()


func set_show_real_text(enabled: bool) -> void:
	show_real_text = enabled
	queue_redraw()


func set_show_styles(enabled: bool) -> void:
	show_styles = enabled
	queue_redraw()


func set_show_metrics(enabled: bool) -> void:
	show_metrics = enabled
	queue_redraw()


func set_show_runtime_preview(enabled: bool) -> void:
	show_runtime_preview = enabled
	queue_redraw()


func set_show_guides(enabled: bool) -> void:
	show_guides = enabled
	queue_redraw()


func set_show_hidden(enabled: bool) -> void:
	show_hidden = enabled
	queue_redraw()


func set_element_image(index: int, path: String) -> void:
	if index < 0 or index >= elements.size():
		return
	elements[index]["image_path"] = path
	queue_redraw()


func select_element(index: int) -> void:
	selected_index = clampi(index, -1, elements.size() - 1)
	queue_redraw()


func _draw() -> void:
	draw_rect(Rect2(Vector2.ZERO, size), Color(0.025, 0.032, 0.043, 1.0), true)
	_update_view_transform()
	var canvas_rect: Rect2 = Rect2(_view_offset, canvas_size * _view_scale)
	draw_rect(
		canvas_rect, canvas_color if show_background else Color(0.008, 0.012, 0.018, 1.0), true
	)
	_draw_background(canvas_rect)
	if show_guides:
		_draw_grid(canvas_rect)
	for index: int in range(elements.size()):
		if not (elements[index] is Dictionary):
			continue
		var element: Dictionary = elements[index]
		if not _element_is_drawable(element):
			continue
		_draw_element(index, element)
	if show_guides:
		draw_rect(canvas_rect, Color(0.36, 0.47, 0.62, 0.72), false, 1.0)


func _update_view_transform() -> void:
	var margin: float = 16.0
	var available: Vector2 = Vector2(
		maxf(1.0, size.x - margin * 2.0), maxf(1.0, size.y - margin * 2.0)
	)
	_view_scale = minf(available.x / canvas_size.x, available.y / canvas_size.y)
	_view_scale = maxf(0.03, _view_scale)
	var displayed_size: Vector2 = canvas_size * _view_scale
	_view_offset = (size - displayed_size) * 0.5


func _draw_background(canvas_rect: Rect2) -> void:
	if not show_background or background_path.is_empty():
		return
	var texture: Texture2D = _get_texture(background_path)
	if texture == null:
		return
	draw_texture_rect(texture, canvas_rect, false, Color.WHITE)


func _draw_element(index: int, element: Dictionary) -> void:
	var rect: Rect2 = element.get("rect", Rect2())
	if rect.size.x <= 0.0 or rect.size.y <= 0.0:
		return
	var screen_rect: Rect2 = Rect2(
		_view_offset + rect.position * _view_scale, rect.size * _view_scale
	)
	if not Rect2(Vector2.ZERO, size).intersects(screen_rect):
		return
	var faded: bool = (
		not bool(element.get("visible", true)) or bool(element.get("template_only", false))
	)
	var opacity: float = 0.36 if faded else 1.0
	_draw_element_surface(element, screen_rect, opacity)
	_draw_element_image(element, screen_rect, opacity)
	_draw_element_special(element, screen_rect, opacity)
	_draw_element_text(element, screen_rect, opacity)
	if show_metrics:
		_draw_metrics(element, screen_rect)
	if show_guides or index == selected_index:
		_draw_element_guide(index, element, screen_rect)


func _draw_element_surface(element: Dictionary, screen_rect: Rect2, opacity: float) -> void:
	if not show_styles:
		return
	var style_name: String = str(element.get("preview_style", "label"))
	var has_explicit_fill: bool = element.has("fill_color")
	var has_explicit_border: bool = element.has("border_color")
	var allow_fallback: bool = (
		bool(element.get("runtime_only", false)) or style_name in ["progress", "slider"]
	)
	if not has_explicit_fill and not has_explicit_border and not allow_fallback:
		return
	var fill: Color = _fallback_fill(style_name) if allow_fallback else Color(0.0, 0.0, 0.0, 0.0)
	var border: Color = (
		_fallback_border(style_name) if allow_fallback else Color(0.0, 0.0, 0.0, 0.0)
	)
	if has_explicit_fill:
		fill = element.get("fill_color", fill)
	if has_explicit_border:
		border = element.get("border_color", border)
	fill.a *= opacity
	border.a *= opacity
	var fallback_border_width: float = 1.0 if border.a > 0.001 else 0.0
	var border_width: float = float(
		element.get("border_width", 1.0 if has_explicit_border else fallback_border_width)
	)
	var radius: float = float(element.get("corner_radius", 0.0))
	var shadow_color: Color = element.get("shadow_color", Color(0.0, 0.0, 0.0, 0.0))
	shadow_color.a *= opacity
	var shadow_size: float = float(element.get("shadow_size", 0.0))
	var shadow_offset: Vector2 = element.get("shadow_offset", Vector2.ZERO)
	if fill.a <= 0.001 and border.a <= 0.001 and shadow_color.a <= 0.001:
		return
	var style: StyleBoxFlat = StyleBoxFlat.new()
	style.bg_color = fill
	style.border_color = border
	var scaled_border_width: int = 0
	if border_width > 0.0:
		scaled_border_width = maxi(1, int(round(border_width * _view_scale)))
	style.set_border_width_all(scaled_border_width)
	var scaled_radius: int = maxi(0, int(round(radius * _view_scale)))
	style.corner_radius_top_left = scaled_radius
	style.corner_radius_top_right = scaled_radius
	style.corner_radius_bottom_left = scaled_radius
	style.corner_radius_bottom_right = scaled_radius
	style.shadow_color = shadow_color
	style.shadow_size = maxi(0, int(round(shadow_size * _view_scale)))
	style.shadow_offset = shadow_offset * _view_scale
	draw_style_box(style, screen_rect)


func _draw_element_image(element: Dictionary, screen_rect: Rect2, opacity: float) -> void:
	if not show_images:
		return
	var image_path: String = str(element.get("image_path", ""))
	if image_path.is_empty() or image_path == background_path:
		return
	var texture: Texture2D = _get_texture(image_path)
	if texture == null:
		return
	var padding: float = maxf(0.0, float(element.get("image_padding", 0.0)) * _view_scale)
	var target: Rect2 = screen_rect.grow(-padding)
	var image_mode: String = str(element.get("image_mode", "contain"))
	var modulate: Color = Color(1.0, 1.0, 1.0, opacity)
	if image_mode == "region" and element.get("image_region", null) is Rect2:
		var region: Rect2 = element.get("image_region", Rect2())
		draw_texture_rect_region(texture, target, region, modulate)
	elif image_mode == "cover":
		_draw_texture_covered(texture, target, modulate)
	elif image_mode == "stretch":
		draw_texture_rect(texture, target, false, modulate)
	else:
		_draw_texture_contained(texture, target, modulate)


func _draw_element_special(element: Dictionary, screen_rect: Rect2, opacity: float) -> void:
	var style_name: String = str(element.get("preview_style", ""))
	if style_name == "progress":
		var progress_rect: Rect2 = screen_rect.grow(-2.0 * _view_scale)
		var progress: float = clampf(float(element.get("preview_progress", 0.62)), 0.0, 1.0)
		var fill: Color = element.get("progress_color", Color(0.27, 0.78, 0.50, 0.90))
		fill.a *= opacity
		progress_rect.size.x *= progress
		draw_rect(progress_rect, fill, true)
	elif style_name == "slider":
		var center_y: float = screen_rect.get_center().y
		var line_rect: Rect2 = Rect2(
			Vector2(screen_rect.position.x + 4.0, center_y - 2.0),
			Vector2(maxf(1.0, screen_rect.size.x - 8.0), 4.0)
		)
		draw_rect(line_rect, Color(0.35, 0.43, 0.52, 0.82 * opacity), true)
		var knob_radius: float = maxf(3.0, 7.0 * _view_scale)
		draw_circle(
			Vector2(line_rect.position.x + line_rect.size.x * 0.72, center_y),
			knob_radius,
			Color(0.92, 0.73, 0.32, opacity)
		)


func _draw_element_text(element: Dictionary, screen_rect: Rect2, opacity: float) -> void:
	var display_text: String = str(
		element.get("display_text", element.get("friendly_name", element.get("name", "")))
	)
	var source_name: String = str(element.get("friendly_name", element.get("name", "")))
	var text: String = display_text if show_real_text else source_name
	text = text.replace("\\n", "\n").strip_edges()
	if text.is_empty():
		return
	var base_size: int = maxi(8, int(element.get("font_size", 12)))
	var font_size: int = clampi(int(round(float(base_size) * _view_scale)), 6, 52)
	var font: Font = preview_font if is_instance_valid(preview_font) else ThemeDB.fallback_font
	var padding: float = maxf(2.0, 4.0 * _view_scale)
	var text_rect: Rect2 = screen_rect.grow(-padding)
	if text_rect.size.x <= 3.0 or text_rect.size.y <= 3.0:
		return
	var lines: Array[String] = _wrap_text(text, text_rect.size.x, font_size)
	var line_height: float = maxf(float(font_size) * 1.12, font.get_height(font_size))
	var maximum_lines: int = maxi(1, int(floor(text_rect.size.y / line_height)))
	if lines.size() > maximum_lines:
		lines.resize(maximum_lines)
		if not lines.is_empty():
			lines[lines.size() - 1] = _ellipsize(
				lines[lines.size() - 1], text_rect.size.x, font_size
			)
	var total_height: float = line_height * float(lines.size())
	var vertical_alignment: int = int(element.get("vertical_alignment", VERTICAL_ALIGNMENT_CENTER))
	var top: float = text_rect.position.y
	if vertical_alignment == VERTICAL_ALIGNMENT_CENTER:
		top += maxf(0.0, (text_rect.size.y - total_height) * 0.5)
	elif vertical_alignment == VERTICAL_ALIGNMENT_BOTTOM:
		top += maxf(0.0, text_rect.size.y - total_height)
	var ascent: float = font.get_ascent(font_size)
	var horizontal_alignment: int = int(
		element.get("horizontal_alignment", HORIZONTAL_ALIGNMENT_CENTER)
	)
	var text_color: Color = element.get("text_color", Color(0.95, 0.95, 0.95, 1.0))
	text_color.a *= opacity
	var outline_color: Color = element.get("outline_color", Color(0.0, 0.0, 0.0, 0.92))
	outline_color.a *= opacity
	var outline_size: int = maxi(
		0, int(round(float(element.get("outline_size", 0.0)) * _view_scale))
	)
	var shadow_color: Color = element.get("shadow_text_color", Color(0.0, 0.0, 0.0, 0.0))
	shadow_color.a *= opacity
	var shadow_offset: Vector2 = (
		Vector2(
			float(element.get("text_shadow_offset_x", 0.0)),
			float(element.get("text_shadow_offset_y", 0.0))
		)
		* _view_scale
	)
	for line_index: int in range(lines.size()):
		var baseline: Vector2 = Vector2(
			text_rect.position.x, top + ascent + line_height * float(line_index)
		)
		if shadow_color.a > 0.001:
			_draw_text_line(
				font,
				baseline + shadow_offset,
				lines[line_index],
				horizontal_alignment,
				text_rect.size.x,
				font_size,
				shadow_color
			)
		if outline_size > 0 and outline_color.a > 0.001:
			_draw_text_outline(
				font,
				baseline,
				lines[line_index],
				horizontal_alignment,
				text_rect.size.x,
				font_size,
				outline_size,
				outline_color
			)
		_draw_text_line(
			font,
			baseline,
			lines[line_index],
			horizontal_alignment,
			text_rect.size.x,
			font_size,
			text_color
		)


func _draw_text_line(
	font: Font,
	position: Vector2,
	text: String,
	alignment: int,
	width: float,
	font_size: int,
	color: Color
) -> void:
	draw_string(font, position, text, alignment, width, font_size, color)


func _draw_text_outline(
	font: Font,
	position: Vector2,
	text: String,
	alignment: int,
	width: float,
	font_size: int,
	outline_size: int,
	color: Color
) -> void:
	var radius: float = float(mini(4, outline_size))
	for direction: Vector2 in [
		Vector2(-1.0, 0.0),
		Vector2(1.0, 0.0),
		Vector2(0.0, -1.0),
		Vector2(0.0, 1.0),
		Vector2(-0.7, -0.7),
		Vector2(0.7, -0.7),
		Vector2(-0.7, 0.7),
		Vector2(0.7, 0.7)
	]:
		_draw_text_line(
			font, position + direction * radius, text, alignment, width, font_size, color
		)


func _draw_metrics(element: Dictionary, screen_rect: Rect2) -> void:
	var rect: Rect2 = element.get("rect", Rect2())
	var metric_text: String = "%s×%s" % [_format_metric(rect.size.x), _format_metric(rect.size.y)]
	if int(element.get("font_size", 0)) > 0:
		metric_text += " · %dpx" % int(element.get("font_size", 0))
	var font_size: int = clampi(int(round(9.0 * maxf(_view_scale, 0.75))), 8, 11)
	var font: Font = preview_font if is_instance_valid(preview_font) else ThemeDB.fallback_font
	draw_string(
		font,
		screen_rect.position + Vector2(3.0, screen_rect.size.y - 3.0),
		metric_text,
		HORIZONTAL_ALIGNMENT_LEFT,
		maxf(18.0, screen_rect.size.x - 6.0),
		font_size,
		Color(1.0, 0.84, 0.42, 0.96)
	)


func _draw_element_guide(index: int, element: Dictionary, screen_rect: Rect2) -> void:
	var selected: bool = index == selected_index
	var border: Color = Color(0.36, 1.0, 0.72, 1.0) if selected else Color(0.34, 0.62, 1.0, 0.68)
	draw_rect(screen_rect, border, false, 2.0 if selected else 1.0)
	if show_guides and not selected:
		var name: String = str(element.get("friendly_name", ""))
		if not name.is_empty() and screen_rect.size.y >= 18.0:
			var font: Font = (
				preview_font if is_instance_valid(preview_font) else ThemeDB.fallback_font
			)
			draw_string(
				font,
				screen_rect.position + Vector2(3.0, 11.0),
				name,
				HORIZONTAL_ALIGNMENT_LEFT,
				maxf(20.0, screen_rect.size.x - 6.0),
				8,
				Color(0.68, 0.82, 1.0, 0.82)
			)
	if selected and bool(element.get("editable", true)) and bool(element.get("allow_resize", true)):
		var handle_size: float = 8.0
		draw_rect(
			Rect2(
				screen_rect.end - Vector2(handle_size, handle_size),
				Vector2(handle_size, handle_size)
			),
			Color(1.0, 0.82, 0.28, 1.0),
			true
		)


func _element_is_drawable(element: Dictionary) -> bool:
	# Los ColorRect de fondo ya se dibujan como color del lienzo, antes de la imagen.
	if bool(element.get("is_canvas_background", false)):
		return false
	var runtime_only: bool = bool(element.get("runtime_only", false))
	if runtime_only and not show_runtime_preview:
		return false
	var view_tag: String = str(element.get("view_tag", "all"))
	if active_view_tag != "all" and view_tag != "all" and view_tag != active_view_tag:
		return false
	if bool(element.get("template_only", false)) and show_runtime_preview and not show_hidden:
		return false
	if not bool(element.get("visible", true)) and not show_hidden:
		return false
	return true


func _fallback_fill(style_name: String) -> Color:
	match style_name:
		"button":
			return Color(0.055, 0.095, 0.12, 0.92)
		"panel", "card", "slot", "label_box":
			return Color(0.008, 0.014, 0.022, 0.86)
		"progress", "slider":
			return Color(0.012, 0.020, 0.030, 0.94)
		_:
			return Color(0.0, 0.0, 0.0, 0.0)


func _fallback_border(style_name: String) -> Color:
	match style_name:
		"button", "panel", "card", "slot", "label_box":
			return Color(0.74, 0.57, 0.25, 0.78)
		_:
			return Color(0.0, 0.0, 0.0, 0.0)


func _wrap_text(value: String, available_width: float, font_size: int) -> Array[String]:
	var result: Array[String] = []
	var approximate_width: float = maxf(3.5, float(font_size) * 0.56)
	var maximum_characters: int = maxi(
		1, int(floor(maxf(4.0, available_width) / approximate_width))
	)
	for paragraph: String in value.split("\n", true):
		if paragraph.is_empty():
			result.append("")
			continue
		var words: PackedStringArray = paragraph.split(" ", false)
		var current: String = ""
		for word: String in words:
			if word.length() > maximum_characters:
				if not current.is_empty():
					result.append(current)
					current = ""
				var cursor: int = 0
				while cursor < word.length():
					result.append(word.substr(cursor, maximum_characters))
					cursor += maximum_characters
				continue
			var candidate: String = word if current.is_empty() else current + " " + word
			if candidate.length() <= maximum_characters:
				current = candidate
			else:
				result.append(current)
				current = word
		if not current.is_empty():
			result.append(current)
	return result


func _ellipsize(value: String, available_width: float, font_size: int) -> String:
	var approximate_width: float = maxf(3.5, float(font_size) * 0.56)
	var maximum_characters: int = maxi(
		2, int(floor(maxf(4.0, available_width) / approximate_width))
	)
	if value.length() <= maximum_characters:
		return value
	return value.substr(0, maximum_characters - 1) + "…"


func _format_metric(value: float) -> String:
	if is_equal_approx(value, round(value)):
		return str(int(round(value)))
	return "%.1f" % value


func _draw_texture_contained(texture: Texture2D, target_rect: Rect2, modulate: Color) -> void:
	if target_rect.size.x <= 0.0 or target_rect.size.y <= 0.0:
		return
	var texture_size: Vector2 = texture.get_size()
	if texture_size.x <= 0.0 or texture_size.y <= 0.0:
		return
	var scale_factor: float = minf(
		target_rect.size.x / texture_size.x, target_rect.size.y / texture_size.y
	)
	var draw_size: Vector2 = texture_size * scale_factor
	var draw_position: Vector2 = target_rect.position + (target_rect.size - draw_size) * 0.5
	draw_texture_rect(texture, Rect2(draw_position, draw_size), false, modulate)


func _draw_texture_covered(texture: Texture2D, target_rect: Rect2, modulate: Color) -> void:
	var texture_size: Vector2 = texture.get_size()
	if (
		target_rect.size.x <= 0.0
		or target_rect.size.y <= 0.0
		or texture_size.x <= 0.0
		or texture_size.y <= 0.0
	):
		return
	var target_aspect: float = target_rect.size.x / target_rect.size.y
	var texture_aspect: float = texture_size.x / texture_size.y
	var source_rect: Rect2 = Rect2(Vector2.ZERO, texture_size)
	if texture_aspect > target_aspect:
		var source_width: float = texture_size.y * target_aspect
		source_rect.position.x = (texture_size.x - source_width) * 0.5
		source_rect.size.x = source_width
	else:
		var source_height: float = texture_size.x / target_aspect
		source_rect.position.y = (texture_size.y - source_height) * 0.5
		source_rect.size.y = source_height
	draw_texture_rect_region(texture, target_rect, source_rect, modulate)


func _get_texture(path: String) -> Texture2D:
	if path.is_empty():
		return null
	if _texture_cache.has(path):
		return _texture_cache[path] as Texture2D
	if not ResourceLoader.exists(path):
		_texture_cache[path] = null
		return null
	var resource: Resource = ResourceLoader.load(path, "Texture2D", ResourceLoader.CACHE_MODE_REUSE)
	var texture: Texture2D = resource as Texture2D
	_texture_cache[path] = texture
	return texture


func _draw_grid(canvas_rect: Rect2) -> void:
	var design_step: float = 16.0
	var screen_step: float = design_step * _view_scale
	while screen_step < 8.0:
		design_step *= 2.0
		screen_step = design_step * _view_scale
	var x: float = canvas_rect.position.x
	while x <= canvas_rect.end.x:
		draw_line(
			Vector2(x, canvas_rect.position.y),
			Vector2(x, canvas_rect.end.y),
			Color(0.18, 0.24, 0.31, 0.22),
			1.0
		)
		x += screen_step
	var y: float = canvas_rect.position.y
	while y <= canvas_rect.end.y:
		draw_line(
			Vector2(canvas_rect.position.x, y),
			Vector2(canvas_rect.end.x, y),
			Color(0.18, 0.24, 0.31, 0.22),
			1.0
		)
		y += screen_step


func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var mouse_event: InputEventMouseButton = event as InputEventMouseButton
		if mouse_event.button_index != MOUSE_BUTTON_LEFT:
			return
		if mouse_event.pressed:
			_begin_pointer_action(mouse_event.position)
		else:
			_finish_pointer_action()
	elif event is InputEventMouseMotion:
		var motion_event: InputEventMouseMotion = event as InputEventMouseMotion
		_update_pointer_action(motion_event.position)


func _can_move_element(element: Dictionary) -> bool:
	if bool(element.get("movement_locked", false)):
		return false
	if bool(element.get("editable", true)):
		return true
	if show_runtime_preview and bool(element.get("runtime_only", false)):
		return true
	return false


func _begin_pointer_action(mouse_position: Vector2) -> void:
	var index: int = _hit_test(mouse_position)
	if index < 0:
		selected_index = -1
		selection_changed.emit(-1)
		queue_redraw()
		return
	selected_index = index
	selection_changed.emit(index)
	var element: Dictionary = elements[index]
	_drag_origin_rect = element.get("rect", Rect2())
	_drag_origin_mouse = _screen_to_canvas(mouse_position)
	var editable: bool = _can_move_element(element)
	if editable:
		var allow_resize: bool = bool(element.get("allow_resize", true))
		if bool(element.get("runtime_only", false)) and not element.has("allow_resize"):
			allow_resize = false
		_resizing = allow_resize and _is_on_resize_handle(mouse_position, _drag_origin_rect)
		_dragging = not _resizing
	else:
		_resizing = false
		_dragging = false
	queue_redraw()


func _finish_pointer_action() -> void:
	if not _dragging and not _resizing:
		return
	_dragging = false
	_resizing = false
	if selected_index >= 0 and selected_index < elements.size():
		element_rect_changed.emit(
			selected_index, elements[selected_index].get("rect", Rect2()), true
		)


func _update_pointer_action(mouse_position: Vector2) -> void:
	if selected_index < 0 or (not _dragging and not _resizing):
		return
	var mouse_canvas: Vector2 = _screen_to_canvas(mouse_position)
	var delta: Vector2 = mouse_canvas - _drag_origin_mouse
	var rect: Rect2 = _drag_origin_rect
	if _resizing:
		rect.size = Vector2(maxf(4.0, rect.size.x + delta.x), maxf(4.0, rect.size.y + delta.y))
	else:
		rect.position += delta
	if snap_enabled:
		rect.position = rect.position.snapped(Vector2.ONE * snap_step)
		rect.size = rect.size.snapped(Vector2.ONE * snap_step)
		rect.size.x = maxf(4.0, rect.size.x)
		rect.size.y = maxf(4.0, rect.size.y)
	elements[selected_index]["rect"] = rect
	elements[selected_index]["dirty"] = true
	_sync_shared_axis_groups(selected_index, rect)
	_sync_linked_elements(str(elements[selected_index].get("name", "")), rect)
	element_rect_changed.emit(selected_index, rect, false)
	queue_redraw()


func _hit_test(mouse_position: Vector2) -> int:
	var fallback_index: int = -1
	for index: int in range(elements.size() - 1, -1, -1):
		if not (elements[index] is Dictionary):
			continue
		var element: Dictionary = elements[index] as Dictionary
		if not _element_is_drawable(element):
			continue
		var rect: Rect2 = element.get("rect", Rect2())
		var screen_rect: Rect2 = Rect2(
			_view_offset + rect.position * _view_scale, rect.size * _view_scale
		)
		if not screen_rect.has_point(mouse_position):
			continue
		var target_index: int = index
		var driver_name: String = str(element.get("drag_driver", ""))
		if not driver_name.is_empty():
			var driver_index: int = _find_element_index(driver_name)
			if driver_index >= 0:
				target_index = driver_index
		if fallback_index < 0:
			fallback_index = target_index
		if target_index < 0 or target_index >= elements.size():
			continue
		if not (elements[target_index] is Dictionary):
			continue
		var target_element: Dictionary = elements[target_index] as Dictionary
		if _can_move_element(target_element):
			return target_index
	return fallback_index


func _find_element_index(name: String) -> int:
	for index: int in range(elements.size()):
		if not (elements[index] is Dictionary):
			continue
		if str((elements[index] as Dictionary).get("name", "")) == name:
			return index
	return -1


func _sync_shared_axis_groups(source_index: int, source_rect: Rect2) -> void:
	if source_index < 0 or source_index >= elements.size():
		return
	if not (elements[source_index] is Dictionary):
		return
	var source: Dictionary = elements[source_index]
	var shared_x_group: String = str(source.get("shared_x_group", ""))
	var shared_y_group: String = str(source.get("shared_y_group", ""))
	if shared_x_group.is_empty() and shared_y_group.is_empty():
		return
	for index: int in range(elements.size()):
		if index == source_index or not (elements[index] is Dictionary):
			continue
		var element: Dictionary = elements[index]
		var rect: Rect2 = element.get("rect", Rect2())
		var changed: bool = false
		if not shared_x_group.is_empty() and str(element.get("shared_x_group", "")) == shared_x_group:
			rect.position.x = source_rect.position.x
			changed = true
		if not shared_y_group.is_empty() and str(element.get("shared_y_group", "")) == shared_y_group:
			rect.position.y = source_rect.position.y
			changed = true
		if changed:
			element["rect"] = rect
			elements[index] = element


func _sync_linked_elements(driver_name: String, driver_rect: Rect2) -> void:
	if driver_name.is_empty():
		return
	for index: int in range(elements.size()):
		if not (elements[index] is Dictionary):
			continue
		var element: Dictionary = elements[index]
		if str(element.get("linked_to", "")) != driver_name:
			continue
		var linked_rect: Rect2 = element.get("rect", Rect2())
		linked_rect.position = driver_rect.position + element.get("linked_offset", Vector2.ZERO)
		element["rect"] = linked_rect
		elements[index] = element


func _screen_to_canvas(mouse_position: Vector2) -> Vector2:
	return (mouse_position - _view_offset) / maxf(0.001, _view_scale)


func _is_on_resize_handle(mouse_position: Vector2, rect: Rect2) -> bool:
	var screen_rect: Rect2 = Rect2(
		_view_offset + rect.position * _view_scale, rect.size * _view_scale
	)
	return Rect2(screen_rect.end - Vector2(14.0, 14.0), Vector2(14.0, 14.0)).has_point(
		mouse_position
	)
