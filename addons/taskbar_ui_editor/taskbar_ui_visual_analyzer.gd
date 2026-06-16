@tool
extends RefCounted

const ROOT_NAMES: Array[String] = [
	"self",
	"interface_root",
	"scaled_root",
	"menu_root",
	"design_root",
	"main_interface_root",
	"root",
	"canvas",
	"shop_root"
]

const CONTROL_TYPES: Array[String] = [
	"Control",
	"Panel",
	"PanelContainer",
	"ColorRect",
	"TextureRect",
	"Label",
	"Button",
	"OptionButton",
	"CheckBox",
	"HSlider",
	"VSlider",
	"ProgressBar",
	"TextureProgressBar",
	"NinePatchRect",
	"ScrollContainer",
	"MarginContainer",
	"VBoxContainer",
	"HBoxContainer",
	"GridContainer",
	"CenterContainer"
]


static func analyze(
	_path: String,
	source: String,
	input_elements: Array,
	_images: Array,
	base_canvas_size: Vector2 = Vector2(900.0, 240.0)
) -> Dictionary:
	# Esta edición trabaja únicamente sobre la capa visual. No recalcula posiciones,
	# jerarquías ni escalas: conserva exactamente las coordenadas de la versión 1.4.
	var elements: Array = input_elements
	var colors: Dictionary = _parse_color_constants(source)
	var vectors: Dictionary = _parse_vector_constants(source)

	_ensure_element_defaults(elements)
	_add_full_rect_visual_controls(source, elements, base_canvas_size, vectors)
	_apply_control_types(source, elements)
	_apply_helper_metadata(source, elements, colors)
	_apply_helper_definition_styles(source, elements, colors)
	_apply_direct_visual_metadata(source, elements, colors)
	_mark_canvas_backgrounds(elements, base_canvas_size)
	_suppress_non_control_text(elements)
	_apply_runtime_styles(elements, colors)

	var styled_count: int = 0
	for raw_element: Variant in elements:
		if not (raw_element is Dictionary):
			continue
		var element: Dictionary = raw_element
		if element.has("fill_color") or element.has("border_color") or element.has("shadow_color"):
			styled_count += 1

	return {
		"elements": elements,
		"canvas_size": base_canvas_size,
		"canvas_variants": [],
		"canvas_color": _choose_canvas_color(elements, colors, base_canvas_size),
		"detected_colors": colors.size(),
		"styled_elements": styled_count
	}


static func _ensure_element_defaults(elements: Array) -> void:
	for index: int in range(elements.size()):
		if not (elements[index] is Dictionary):
			continue
		var element: Dictionary = elements[index]
		var rect: Rect2 = element.get("rect", Rect2())
		if not element.has("local_rect"):
			element["local_rect"] = rect
		if not element.has("parent_name"):
			element["parent_name"] = ""
		if not element.has("parent_offset"):
			element["parent_offset"] = Vector2.ZERO
		if not element.has("control_type"):
			element["control_type"] = "Control"
		if not element.has("preview_style"):
			element["preview_style"] = _style_from_name(str(element.get("name", "")))
		if not element.has("visible"):
			element["visible"] = true
		if not element.has("text_color"):
			element["text_color"] = Color(0.95, 0.95, 0.95, 1.0)
		if not element.has("horizontal_alignment"):
			element["horizontal_alignment"] = HORIZONTAL_ALIGNMENT_CENTER
		if not element.has("vertical_alignment"):
			element["vertical_alignment"] = VERTICAL_ALIGNMENT_CENTER
		if not element.has("z_index"):
			element["z_index"] = 0
		if not element.has("draw_order"):
			element["draw_order"] = int(element.get("line", index))
		if not element.has("editable"):
			element["editable"] = not bool(element.get("runtime_only", false))
		elements[index] = element


static func _detect_canvas_variants(source: String) -> Array:
	var variants: Array = []
	var seen: Dictionary = {}
	var regex: RegEx = RegEx.new()
	(
		regex
		. compile(
			"(?mi)^\\s*(?:@export(?:_[a-z]+)?(?:\\([^\\n]*\\))?\\s+)?(?:const|var)\\s+([A-Za-z_][A-Za-z0-9_]*(?:WINDOW_SIZE|MENU_SIZE|REFERENCE_SIZE|BASE_UI_SIZE|SCREEN_SIZE))\\s*(?::[^=\\n]+)?=\\s*Vector2i?\\(\\s*(\\d+(?:\\.\\d+)?)\\s*,\\s*(\\d+(?:\\.\\d+)?)\\s*\\)"
		)
	)
	for match: RegExMatch in regex.search_all(source):
		var constant_name: String = match.get_string(1)
		if constant_name.to_upper().begins_with("MINIMUM_"):
			continue
		var size: Vector2 = Vector2(float(match.get_string(2)), float(match.get_string(3)))
		var key: String = "%sx%s" % [int(size.x), int(size.y)]
		if seen.has(key):
			continue
		seen[key] = true
		variants.append(
			{
				"name": _canvas_label(constant_name),
				"constant": constant_name,
				"tag": _canvas_tag(constant_name),
				"size": size
			}
		)
	if variants.is_empty():
		variants.append(
			{"name": "Vista principal", "constant": "", "tag": "all", "size": Vector2(900.0, 240.0)}
		)
	variants.sort_custom(
		func(a: Dictionary, b: Dictionary) -> bool:
			var priority_a: int = _canvas_priority(str(a.get("constant", "")))
			var priority_b: int = _canvas_priority(str(b.get("constant", "")))
			if priority_a != priority_b:
				return priority_a < priority_b
			var size_a: Vector2 = a.get("size", Vector2.ZERO)
			var size_b: Vector2 = b.get("size", Vector2.ZERO)
			return size_a.x * size_a.y > size_b.x * size_b.y
	)
	return variants


static func _canvas_priority(constant_name: String) -> int:
	var upper: String = constant_name.to_upper()
	if upper.contains("REFERENCE") or upper.contains("BASE_UI"):
		return 0
	if upper.contains("FACTION"):
		return 1
	if upper.contains("CHARACTER"):
		return 2
	if upper.contains("MENU"):
		return 3
	return 4


static func _choose_default_canvas(variants: Array) -> Vector2:
	if variants.is_empty():
		return Vector2(900.0, 240.0)
	return (variants[0] as Dictionary).get("size", Vector2(900.0, 240.0))


static func _canvas_label(constant_name: String) -> String:
	var upper: String = constant_name.to_upper()
	if upper.contains("CHARACTER"):
		return "Personaje"
	if upper.contains("FACTION"):
		return "Facción"
	if upper.contains("REFERENCE"):
		return "Vista completa"
	if upper.contains("MENU"):
		return "Menú"
	if upper.contains("SHOP") or upper.contains("TIENDA"):
		return "Tienda"
	if upper.contains("INVENTORY") or upper.contains("INVENTARIO"):
		return "Inventario"
	if upper.contains("FORGE") or upper.contains("FORJA"):
		return "Forja"
	if upper.contains("SKILL") or upper.contains("HABILIDAD"):
		return "Árbol de habilidades"
	return constant_name.replace("_", " ").capitalize()


static func _canvas_tag(constant_name: String) -> String:
	var lower: String = constant_name.to_lower()
	if lower.contains("character"):
		return "character"
	if lower.contains("faction"):
		return "faction"
	if lower.contains("menu"):
		return "menu"
	return "all"


static func _parse_color_constants(source: String) -> Dictionary:
	var result: Dictionary = {
		"COLOR_BLACK": Color.BLACK,
		"COLOR_WHITE": Color.WHITE,
		"BLACK": Color.BLACK,
		"WHITE": Color.WHITE,
		"TRANSPARENT": Color(0, 0, 0, 0)
	}
	var regex: RegEx = RegEx.new()
	regex.compile("(?mi)^\\s*(?:const|var)\\s+([A-Za-z_][A-Za-z0-9_]*)\\s*(?::\\s*Color)?\\s*=\\s*")
	for match: RegExMatch in regex.search_all(source):
		var name: String = match.get_string(1)
		var expression: String = _read_expression(source, match.get_end(0))
		var color_value: Variant = _resolve_color(expression, result)
		if color_value is Color:
			result[name] = color_value
	return result


static func _parse_vector_constants(source: String) -> Dictionary:
	var result: Dictionary = {}
	var regex: RegEx = RegEx.new()
	(
		regex
		. compile(
			"(?mi)^\\s*(?:const|var)\\s+([A-Za-z_][A-Za-z0-9_]*)\\s*(?::[^=\\n]+)?=\\s*(Vector2i?\\(\\s*[-+]?\\d+(?:\\.\\d+)?\\s*,\\s*[-+]?\\d+(?:\\.\\d+)?\\s*\\))"
		)
	)
	for match: RegExMatch in regex.search_all(source):
		var value: Variant = _resolve_vector(match.get_string(2), result, {})
		if value is Vector2:
			result[match.get_string(1)] = value
	return result


static func _add_missing_controls(
	source: String, elements: Array, canvas_size: Vector2, vectors: Dictionary
) -> void:
	var existing: Dictionary = {}
	for raw_element: Variant in elements:
		if raw_element is Dictionary:
			existing[str((raw_element as Dictionary).get("name", ""))] = true

	var declarations: Dictionary = _control_declarations(source)
	var element_rects: Dictionary = {}
	for raw_element: Variant in elements:
		if raw_element is Dictionary:
			var e: Dictionary = raw_element
			element_rects[str(e.get("name", ""))] = e.get("rect", Rect2())

	for variable_name: String in declarations.keys():
		if existing.has(variable_name):
			continue
		var declaration: Dictionary = declarations[variable_name]
		var position_expression: String = _property_expression(source, variable_name, "position")
		var size_expression: String = _property_expression(source, variable_name, "size")
		var is_full_rect: bool = _has_full_rect_preset(source, variable_name)
		var position_value: Variant = (
			Vector2.ZERO
			if is_full_rect
			else _resolve_vector(position_expression, vectors, element_rects)
		)
		var size_value: Variant = (
			canvas_size
			if is_full_rect
			else _resolve_vector(size_expression, vectors, element_rects)
		)
		if not (position_value is Vector2) or not (size_value is Vector2):
			var call_data: Dictionary = _assigned_helper_call(source, variable_name)
			if not call_data.is_empty():
				var call_rect: Variant = _rect_from_helper_call(call_data, vectors, element_rects)
				if call_rect is Rect2:
					position_value = call_rect.position
					size_value = call_rect.size
		if not (position_value is Vector2) or not (size_value is Vector2):
			continue
		var size_vector: Vector2 = size_value
		if size_vector.x <= 0.0 or size_vector.y <= 0.0:
			continue
		var new_rect: Rect2 = Rect2(position_value, size_vector)
		var call_info: Dictionary = _assigned_helper_call(source, variable_name)
		var parent_name: String = str(call_info.get("parent_name", ""))
		elements.append(
			{
				"name": variable_name,
				"rect": new_rect,
				"local_rect": new_rect,
				"parent_name": parent_name,
				"parent_offset": Vector2.ZERO,
				"kind": "derived",
				"span_a_start": -1,
				"span_a_end": -1,
				"span_b_start": -1,
				"span_b_end": -1,
				"line": int(declaration.get("line", 0)),
				"draw_order": int(declaration.get("line", 0)),
				"source_kind": "Control generado",
				"dirty": false,
				"image_path": "",
				"display_text": _text_from_call(call_info),
				"friendly_name": _friendly_name(variable_name),
				"font_size": _font_from_call(call_info),
				"text_expression": "",
				"runtime_only": false,
				"editable": false,
				"control_type": str(declaration.get("type", "Control")),
				"preview_style":
				_style_for_type(str(declaration.get("type", "Control")), variable_name),
				"visible": true
			}
		)
		existing[variable_name] = true
		element_rects[variable_name] = new_rect


static func _add_full_rect_visual_controls(
	source: String, elements: Array, canvas_size: Vector2, _vectors: Dictionary
) -> void:
	# Algunos fondos no tienen position/size: usan PRESET_FULL_RECT. La versión 1.4
	# no los veía porque solo analizaba rectángulos numéricos. Añadimos únicamente
	# esos fondos visuales, sin tocar ningún elemento editable ni sus coordenadas.
	var existing: Dictionary = {}
	for raw_element: Variant in elements:
		if raw_element is Dictionary:
			existing[str((raw_element as Dictionary).get("name", ""))] = true

	var declarations: Dictionary = _control_declarations(source)
	for variable_name: String in declarations.keys():
		if existing.has(variable_name):
			continue
		var declaration: Dictionary = declarations[variable_name]
		var type_name: String = str(declaration.get("type", "Control"))
		if type_name not in ["ColorRect", "Panel", "PanelContainer"]:
			continue
		if not _has_full_rect_preset(source, variable_name):
			continue
		var rect: Rect2 = Rect2(Vector2.ZERO, canvas_size)
		elements.push_front(
			{
				"name": variable_name,
				"rect": rect,
				"local_rect": rect,
				"parent_name": "self",
				"parent_offset": Vector2.ZERO,
				"kind": "visual_full_rect",
				"span_a_start": -1,
				"span_a_end": -1,
				"span_b_start": -1,
				"span_b_end": -1,
				"line": 0,
				"draw_order": -100000,
				"source_kind": "Fondo PRESET_FULL_RECT",
				"is_canvas_background": type_name == "ColorRect",
				"dirty": false,
				"image_path": "",
				"display_text": "",
				"friendly_name": _friendly_name(variable_name),
				"font_size": 0,
				"text_expression": "",
				"runtime_only": false,
				"editable": false,
				"control_type": type_name,
				"preview_style": _style_for_type(type_name, variable_name),
				"visible": true
			}
		)
		existing[variable_name] = true


static func _mark_canvas_backgrounds(elements: Array, canvas_size: Vector2) -> void:
	var canvas_area: float = maxf(1.0, canvas_size.x * canvas_size.y)
	for index: int in range(elements.size()):
		if not (elements[index] is Dictionary):
			continue
		var element: Dictionary = elements[index]
		if str(element.get("control_type", "")) != "ColorRect":
			continue
		if not element.has("fill_color"):
			continue
		var rect: Rect2 = element.get("rect", Rect2())
		var coverage: float = maxf(0.0, rect.size.x * rect.size.y) / canvas_area
		var normalized_name: String = str(element.get("name", "")).to_lower()
		if (
			coverage >= 0.72
			or normalized_name.contains("background")
			or normalized_name.contains("fondo")
		):
			element["is_canvas_background"] = true
			element["editable"] = bool(element.get("editable", true))
			elements[index] = element


static func _control_declarations(source: String) -> Dictionary:
	var result: Dictionary = {}
	var typed_regex: RegEx = RegEx.new()
	typed_regex.compile(
		"(?mi)^\\s*(?:var\\s+)?([A-Za-z_][A-Za-z0-9_]*)\\s*:\\s*([A-Za-z_][A-Za-z0-9_]*)"
	)
	for match: RegExMatch in typed_regex.search_all(source):
		var type_name: String = match.get_string(2)
		if not CONTROL_TYPES.has(type_name):
			continue
		result[match.get_string(1)] = {
			"type": type_name, "line": _line_at(source, match.get_start(0))
		}
	var new_regex: RegEx = RegEx.new()
	(
		new_regex
		. compile(
			"(?mi)^\\s*(?:var\\s+)?([A-Za-z_][A-Za-z0-9_]*)[^=\\n]*=\\s*([A-Za-z_][A-Za-z0-9_]*)\\.new\\(\\)"
		)
	)
	for match: RegExMatch in new_regex.search_all(source):
		var type_name: String = match.get_string(2)
		if CONTROL_TYPES.has(type_name):
			result[match.get_string(1)] = {
				"type": type_name, "line": _line_at(source, match.get_start(0))
			}
	return result


static func _apply_control_types(source: String, elements: Array) -> void:
	var declarations: Dictionary = _control_declarations(source)
	for index: int in range(elements.size()):
		if not (elements[index] is Dictionary):
			continue
		var element: Dictionary = elements[index]
		var name: String = str(element.get("name", ""))
		if declarations.has(name):
			element["control_type"] = str((declarations[name] as Dictionary).get("type", "Control"))
		var helper: String = str(element.get("helper_name", ""))
		if helper.is_empty():
			var call_data: Dictionary = _assigned_helper_call(source, name)
			helper = str(call_data.get("helper_name", ""))
			if not helper.is_empty():
				element["helper_name"] = helper
		var inferred_type: String = _type_from_helper(helper)
		if str(element.get("control_type", "Control")) == "Control" and inferred_type != "Control":
			element["control_type"] = inferred_type
		element["preview_style"] = _style_for_type(
			str(element.get("control_type", "Control")), name
		)
		elements[index] = element


static func _apply_helper_metadata(source: String, elements: Array, colors: Dictionary) -> void:
	for index: int in range(elements.size()):
		if not (elements[index] is Dictionary):
			continue
		var element: Dictionary = elements[index]
		var name: String = str(element.get("name", ""))
		var call_data: Dictionary = _assigned_helper_call(source, name)
		if call_data.is_empty():
			continue
		var helper_name: String = str(call_data.get("helper_name", ""))
		var arguments: Array[String] = call_data.get("arguments", [])
		element["helper_name"] = helper_name
		var parent_name: String = str(call_data.get("parent_name", ""))
		if not parent_name.is_empty():
			element["parent_name"] = parent_name
		var text: String = _text_from_call(call_data)
		if (
			not text.is_empty()
			and (
				str(element.get("display_text", "")).is_empty()
				or str(element.get("display_text", "")) == str(element.get("friendly_name", ""))
			)
		):
			element["display_text"] = text
		var font_size: int = _font_from_call(call_data)
		if font_size > 0:
			element["font_size"] = font_size
		var lower_helper: String = helper_name.to_lower()
		if (
			lower_helper.contains("color_rect")
			or lower_helper.contains("ambient_glow")
			or lower_helper.contains("separator")
		):
			var color_value: Variant = _last_resolved_color(arguments, colors)
			if color_value is Color:
				element["fill_color"] = color_value
			element["preview_style"] = "color_rect"
		elif lower_helper.contains("label"):
			var label_color: Variant = _last_resolved_color(arguments, colors)
			if label_color is Color:
				element["text_color"] = label_color
			element["preview_style"] = "label"
		elif lower_helper.contains("button"):
			var button_color: Variant = _last_resolved_color(arguments, colors)
			if button_color is Color and lower_helper.contains("small"):
				element["fill_color"] = button_color
				element["border_color"] = button_color.lightened(0.25)
			element["preview_style"] = "button"
		elif (
			lower_helper.contains("frame")
			or lower_helper.contains("panel")
			or lower_helper.contains("card")
		):
			element["preview_style"] = "panel"
		for argument: String in arguments:
			if argument.contains("HORIZONTAL_ALIGNMENT_LEFT"):
				element["horizontal_alignment"] = HORIZONTAL_ALIGNMENT_LEFT
			elif argument.contains("HORIZONTAL_ALIGNMENT_RIGHT"):
				element["horizontal_alignment"] = HORIZONTAL_ALIGNMENT_RIGHT
			elif argument.contains("HORIZONTAL_ALIGNMENT_CENTER"):
				element["horizontal_alignment"] = HORIZONTAL_ALIGNMENT_CENTER
		elements[index] = element


static func _apply_helper_definition_styles(
	source: String, elements: Array, colors: Dictionary
) -> void:
	var cache: Dictionary = {}
	for index: int in range(elements.size()):
		if not (elements[index] is Dictionary):
			continue
		var element: Dictionary = elements[index]
		var helper_name: String = str(element.get("helper_name", ""))
		if helper_name.is_empty() or not helper_name.begins_with("_"):
			continue
		if not cache.has(helper_name):
			cache[helper_name] = _style_from_helper_definition(source, helper_name, colors)
		var helper_style: Dictionary = cache[helper_name]
		for key: Variant in helper_style.keys():
			if not element.has(key):
				element[key] = helper_style[key]
		elements[index] = element


static func _style_from_helper_definition(
	source: String, helper_name: String, colors: Dictionary
) -> Dictionary:
	var body: String = _function_body(source, helper_name)
	if body.is_empty():
		return {}
	var result: Dictionary = {}
	var normal_regex: RegEx = RegEx.new()
	normal_regex.compile(
		"add_theme_stylebox_override\\(\\s*[\"']" + "(?:normal|panel|read_only)" + "[\"']\\s*,"
	)
	var normal_match: RegExMatch = normal_regex.search(body)
	if normal_match != null:
		var open_index: int = body.find("(", normal_match.get_start(0))
		var close_index: int = _balanced_end(body, open_index, "(", ")")
		if open_index >= 0 and close_index >= 0:
			var arguments: Array[String] = _split_arguments(
				body.substr(open_index + 1, close_index - open_index - 1)
			)
			if arguments.size() >= 2:
				var style_expression: String = arguments[1].strip_edges()
				var lower_style_expression: String = style_expression.to_lower()
				if (
					lower_style_expression.contains("style")
					or lower_style_expression.contains("estilo")
				):
					result = _style_from_make_call(style_expression, colors)
	if result.is_empty():
		var style_index: int = body.find("_make_style(")
		if style_index >= 0:
			var open_index: int = body.find("(", style_index)
			var close_index: int = _balanced_end(body, open_index, "(", ")")
			if close_index >= 0:
				result = _style_from_make_call(
					body.substr(style_index, close_index - style_index + 1), colors
				)
	var font_regex: RegEx = RegEx.new()
	font_regex.compile(
		"add_theme_color_override\\(\\s*[\"']font_color" + "[\"']\\s*,\\s*([^\\n\\r\\)]+)"
	)
	var font_match: RegExMatch = font_regex.search(body)
	if font_match != null:
		var font_color: Variant = _resolve_color(font_match.get_string(1), colors)
		if font_color is Color:
			result["text_color"] = font_color
	return result


static func _function_body(source: String, function_name: String) -> String:
	var regex: RegEx = RegEx.new()
	regex.compile("(?m)^func\\s+" + _escape_regex(function_name) + "\\s*\\(")
	var function_match: RegExMatch = regex.search(source)
	if function_match == null:
		return ""
	var next_regex: RegEx = RegEx.new()
	next_regex.compile("(?m)^func\\s+")
	var next_match: RegExMatch = next_regex.search(source, function_match.get_end(0))
	var end_index: int = next_match.get_start(0) if next_match != null else source.length()
	return source.substr(function_match.get_start(0), end_index - function_match.get_start(0))


static func _apply_direct_visual_metadata(
	source: String, elements: Array, colors: Dictionary
) -> void:
	var style_variables: Dictionary = _parse_style_variables(source, colors)
	for index: int in range(elements.size()):
		if not (elements[index] is Dictionary):
			continue
		var element: Dictionary = elements[index]
		var name: String = str(element.get("name", ""))
		var color_expression: String = _property_expression(source, name, "color")
		var color_value: Variant = _resolve_color(color_expression, colors)
		if color_value is Color:
			element["fill_color"] = color_value
			element["preview_style"] = "color_rect"

		var visible_expression: String = _property_expression(source, name, "visible")
		if visible_expression == "false":
			element["visible"] = false
		elif visible_expression == "true":
			element["visible"] = true

		var z_expression: String = _property_expression(source, name, "z_index")
		if z_expression.is_valid_int():
			element["z_index"] = int(z_expression)

		var rotation_expression: String = _property_expression(source, name, "rotation")
		if rotation_expression.contains("deg_to_rad"):
			var inside: String = _inside_parentheses(rotation_expression)
			if inside.is_valid_float():
				element["rotation"] = deg_to_rad(float(inside))
		elif rotation_expression.is_valid_float():
			element["rotation"] = float(rotation_expression)

		var horizontal_expression: String = _property_expression(
			source, name, "horizontal_alignment"
		)
		if horizontal_expression.contains("LEFT"):
			element["horizontal_alignment"] = HORIZONTAL_ALIGNMENT_LEFT
		elif horizontal_expression.contains("RIGHT"):
			element["horizontal_alignment"] = HORIZONTAL_ALIGNMENT_RIGHT
		elif horizontal_expression.contains("CENTER"):
			element["horizontal_alignment"] = HORIZONTAL_ALIGNMENT_CENTER

		var vertical_expression: String = _property_expression(source, name, "vertical_alignment")
		if vertical_expression.contains("TOP"):
			element["vertical_alignment"] = VERTICAL_ALIGNMENT_TOP
		elif vertical_expression.contains("BOTTOM"):
			element["vertical_alignment"] = VERTICAL_ALIGNMENT_BOTTOM
		elif vertical_expression.contains("CENTER"):
			element["vertical_alignment"] = VERTICAL_ALIGNMENT_CENTER

		var autowrap_expression: String = _property_expression(source, name, "autowrap_mode")
		if not autowrap_expression.is_empty():
			element["autowrap"] = not autowrap_expression.contains("AUTOWRAP_OFF")

		var stretch_expression: String = _property_expression(source, name, "stretch_mode")
		if stretch_expression.contains("KEEP_ASPECT_COVERED"):
			element["image_mode"] = "cover"
		elif stretch_expression.contains("KEEP_ASPECT"):
			element["image_mode"] = "contain"
		elif not stretch_expression.is_empty():
			element["image_mode"] = "stretch"

		_apply_theme_color(source, name, element, colors)
		_apply_theme_constants(source, name, element)
		_apply_style_overrides(source, name, element, colors, style_variables)
		elements[index] = element


static func _parse_style_variables(source: String, colors: Dictionary) -> Dictionary:
	var result: Dictionary = {}
	var regex: RegEx = RegEx.new()
	regex.compile(
		"(?mi)^\\s*(?:var\\s+)?([A-Za-z_][A-Za-z0-9_]*)[^=\\n]*=\\s*StyleBoxFlat\\.new\\(\\)"
	)
	for match: RegExMatch in regex.search_all(source):
		var style_name: String = match.get_string(1)
		var style: Dictionary = {}
		var bg: Variant = _resolve_color(
			_property_expression(source, style_name, "bg_color"), colors
		)
		if bg is Color:
			style["fill_color"] = bg
		var border: Variant = _resolve_color(
			_property_expression(source, style_name, "border_color"), colors
		)
		if border is Color:
			style["border_color"] = border
		var shadow: Variant = _resolve_color(
			_property_expression(source, style_name, "shadow_color"), colors
		)
		if shadow is Color:
			style["shadow_color"] = shadow
		var shadow_size: String = _property_expression(source, style_name, "shadow_size")
		if shadow_size.is_valid_float():
			style["shadow_size"] = float(shadow_size)
		var shadow_offset: Variant = _resolve_vector(
			_property_expression(source, style_name, "shadow_offset"), {}, {}
		)
		if shadow_offset is Vector2:
			style["shadow_offset"] = shadow_offset
		var border_width: float = _style_method_number(source, style_name, "set_border_width_all")
		if border_width <= 0.0:
			for property: String in [
				"border_width_left", "border_width_top", "border_width_right", "border_width_bottom"
			]:
				var width_expression: String = _property_expression(source, style_name, property)
				if width_expression.is_valid_float():
					border_width = maxf(border_width, float(width_expression))
		if border_width > 0.0:
			style["border_width"] = border_width
		var radius: float = 0.0
		for property: String in [
			"corner_radius_top_left",
			"corner_radius_top_right",
			"corner_radius_bottom_left",
			"corner_radius_bottom_right"
		]:
			var radius_expression: String = _property_expression(source, style_name, property)
			if radius_expression.is_valid_float():
				radius = maxf(radius, float(radius_expression))
		if radius > 0.0:
			style["corner_radius"] = radius
		result[style_name] = style
	return result


static func _apply_style_overrides(
	source: String,
	control_name: String,
	element: Dictionary,
	colors: Dictionary,
	style_variables: Dictionary
) -> void:
	var regex: RegEx = RegEx.new()
	regex.compile(
		(
			"(?m)^\\s*"
			+ _escape_regex(control_name)
			+ "\\.add_theme_stylebox_override\\(\\s*[\\\"']([^\\\"']+)[\\\"']\\s*,"
		)
	)
	for match: RegExMatch in regex.search_all(source):
		var open_index: int = source.find("(", match.get_start(0))
		var close_index: int = _balanced_end(source, open_index, "(", ")")
		if open_index < 0 or close_index < 0:
			continue
		var arguments: Array[String] = _split_arguments(
			source.substr(open_index + 1, close_index - open_index - 1)
		)
		if arguments.size() < 2:
			continue
		var state_name: String = (
			str(arguments[0]).trim_prefix('"').trim_suffix('"').trim_prefix("'").trim_suffix("'")
		)
		if state_name not in ["panel", "normal", "read_only", "slider", "grabber_area"]:
			continue
		var style_expression: String = arguments[1].strip_edges()
		var style: Dictionary = {}
		var lower_style_expression: String = style_expression.to_lower()
		if lower_style_expression.contains("style") or lower_style_expression.contains("estilo"):
			style = _style_from_make_call(style_expression, colors)
		elif style_variables.has(style_expression):
			style = (style_variables[style_expression] as Dictionary).duplicate(true)
		for key: Variant in style.keys():
			element[key] = style[key]
		if state_name == "slider":
			element["preview_style"] = "slider"
		elif str(element.get("control_type", "")) == "Label":
			element["preview_style"] = "label_box"
		elif (
			str(element.get("control_type", "")) == "Button"
			or str(element.get("control_type", "")) == "OptionButton"
		):
			element["preview_style"] = "button"
		else:
			element["preview_style"] = "panel"


static func _style_from_make_call(expression: String, colors: Dictionary) -> Dictionary:
	var result: Dictionary = {}
	var open_index: int = expression.find("(")
	if open_index < 0:
		return result
	var close_index: int = _balanced_end(expression, open_index, "(", ")")
	if close_index < 0:
		close_index = expression.length() - 1
	var arguments: Array[String] = _split_arguments(
		expression.substr(open_index + 1, close_index - open_index - 1)
	)
	if arguments.size() > 0:
		var bg: Variant = _resolve_color(arguments[0], colors)
		if bg is Color:
			result["fill_color"] = bg
	if arguments.size() > 1:
		var border: Variant = _resolve_color(arguments[1], colors)
		if border is Color:
			result["border_color"] = border
	if arguments.size() > 2 and arguments[2].strip_edges().is_valid_float():
		result["border_width"] = float(arguments[2])
	if arguments.size() > 3 and arguments[3].strip_edges().is_valid_float():
		result["corner_radius"] = float(arguments[3])
	if arguments.size() > 4:
		var shadow: Variant = _resolve_color(arguments[4], colors)
		if shadow is Color:
			result["shadow_color"] = shadow
	if arguments.size() > 5 and arguments[5].strip_edges().is_valid_float():
		result["shadow_size"] = float(arguments[5])
	if arguments.size() > 6:
		var offset: Variant = _resolve_vector(arguments[6], {}, {})
		if offset is Vector2:
			result["shadow_offset"] = offset
	return result


static func _apply_theme_color(
	source: String, control_name: String, element: Dictionary, colors: Dictionary
) -> void:
	var regex: RegEx = RegEx.new()
	regex.compile(
		(
			"(?m)^\\s*"
			+ _escape_regex(control_name)
			+ "\\.add_theme_color_override\\(\\s*[\\\"']([^\\\"']+)[\\\"']\\s*,"
		)
	)
	for match: RegExMatch in regex.search_all(source):
		var open_index: int = source.find("(", match.get_start(0))
		var close_index: int = _balanced_end(source, open_index, "(", ")")
		if open_index < 0 or close_index < 0:
			continue
		var arguments: Array[String] = _split_arguments(
			source.substr(open_index + 1, close_index - open_index - 1)
		)
		if arguments.size() < 2:
			continue
		var key: String = arguments[0].replace('"', "").replace("'", "").strip_edges()
		var value: Variant = _resolve_color(arguments[1], colors)
		if not (value is Color):
			continue
		if key in ["font_color", "font_hover_color", "font_pressed_color", "font_focus_color"]:
			element["text_color"] = value
		elif key == "font_outline_color":
			element["outline_color"] = value
		elif key == "font_shadow_color":
			element["shadow_text_color"] = value


static func _apply_theme_constants(
	source: String, control_name: String, element: Dictionary
) -> void:
	var regex: RegEx = RegEx.new()
	(
		regex
		. compile(
			(
				"(?m)^\\s*"
				+ _escape_regex(control_name)
				+ "\\.add_theme_constant_override\\(\\s*[\\\"']([^\\\"']+)[\\\"']\\s*,\\s*([-+]?\\d+(?:\\.\\d+)?)"
			)
		)
	)
	for match: RegExMatch in regex.search_all(source):
		var key: String = match.get_string(1)
		var value: float = float(match.get_string(2))
		if key == "outline_size":
			element["outline_size"] = value
		elif key == "shadow_offset_x":
			element["text_shadow_offset_x"] = value
		elif key == "shadow_offset_y":
			element["text_shadow_offset_y"] = value


static func _suppress_non_control_text(elements: Array) -> void:
	var text_types: Array[String] = ["Label", "Button", "OptionButton", "CheckBox"]
	for index: int in range(elements.size()):
		if not (elements[index] is Dictionary):
			continue
		var element: Dictionary = elements[index]
		if bool(element.get("runtime_only", false)):
			continue
		var control_type: String = str(element.get("control_type", "Control"))
		if text_types.has(control_type):
			continue
		var expression: String = str(element.get("text_expression", "")).strip_edges()
		if expression.is_empty():
			element["display_text"] = ""
		elements[index] = element


static func _apply_parent_relationships(source: String, elements: Array) -> void:
	var relations: Dictionary = {}
	var regex: RegEx = RegEx.new()
	regex.compile(
		"(?m)^\\s*([A-Za-z_][A-Za-z0-9_]*)\\.add_child\\(\\s*([A-Za-z_][A-Za-z0-9_]*)\\s*\\)"
	)
	for match: RegExMatch in regex.search_all(source):
		relations[match.get_string(2)] = match.get_string(1)
	var root_regex: RegEx = RegEx.new()
	root_regex.compile("(?m)^\\s*add_child\\(\\s*([A-Za-z_][A-Za-z0-9_]*)\\s*\\)")
	for match: RegExMatch in root_regex.search_all(source):
		relations[match.get_string(1)] = "self"
	for index: int in range(elements.size()):
		if not (elements[index] is Dictionary):
			continue
		var element: Dictionary = elements[index]
		var name: String = str(element.get("name", ""))
		if str(element.get("parent_name", "")).is_empty() and relations.has(name):
			element["parent_name"] = str(relations[name])
		elements[index] = element


static func _resolve_hierarchy(elements: Array) -> void:
	var name_indices: Dictionary = {}
	for index: int in range(elements.size()):
		if not (elements[index] is Dictionary):
			continue
		var name: String = str((elements[index] as Dictionary).get("name", ""))
		if not name_indices.has(name):
			name_indices[name] = []
		(name_indices[name] as Array).append(index)
	var resolved: Dictionary = {}
	for index: int in range(elements.size()):
		_resolve_element(index, elements, name_indices, resolved, {})


static func _resolve_element(
	index: int, elements: Array, name_indices: Dictionary, resolved: Dictionary, stack: Dictionary
) -> Vector2:
	if resolved.has(index):
		return resolved[index]
	if stack.has(index) or index < 0 or index >= elements.size():
		return Vector2.ZERO
	stack[index] = true
	var element: Dictionary = elements[index]
	var local_rect: Rect2 = element.get("local_rect", element.get("rect", Rect2()))
	var parent_name: String = str(element.get("parent_name", ""))
	var parent_offset: Vector2 = Vector2.ZERO
	var parent_index: int = _find_parent_index(index, parent_name, elements, name_indices)
	if parent_index >= 0:
		_resolve_element(parent_index, elements, name_indices, resolved, stack)
		var parent_rect: Rect2 = (elements[parent_index] as Dictionary).get("rect", Rect2())
		parent_offset = parent_rect.position
	elif not parent_name.is_empty() and not ROOT_NAMES.has(parent_name):
		element["unresolved_parent"] = true
	element["parent_offset"] = parent_offset
	element["rect"] = Rect2(parent_offset + local_rect.position, local_rect.size)
	elements[index] = element
	resolved[index] = parent_offset
	stack.erase(index)
	return parent_offset


static func _find_parent_index(
	child_index: int, parent_name: String, elements: Array, name_indices: Dictionary
) -> int:
	if parent_name.is_empty() or ROOT_NAMES.has(parent_name) or not name_indices.has(parent_name):
		return -1
	var child_line: int = int((elements[child_index] as Dictionary).get("line", 0))
	var best_index: int = -1
	var best_distance: int = 1 << 30
	for raw_index: Variant in name_indices[parent_name] as Array:
		var candidate_index: int = int(raw_index)
		if candidate_index == child_index:
			continue
		var candidate_line: int = int((elements[candidate_index] as Dictionary).get("line", 0))
		var distance: int = absi(child_line - candidate_line)
		if candidate_line <= child_line and distance < best_distance:
			best_distance = distance
			best_index = candidate_index
	if best_index >= 0:
		return best_index
	return int((name_indices[parent_name] as Array)[0])


static func _apply_visibility_hierarchy(elements: Array) -> void:
	var by_name: Dictionary = {}
	for raw_element: Variant in elements:
		if raw_element is Dictionary:
			by_name[str((raw_element as Dictionary).get("name", ""))] = raw_element
	for index: int in range(elements.size()):
		if not (elements[index] is Dictionary):
			continue
		var element: Dictionary = elements[index]
		var parent_name: String = str(element.get("parent_name", ""))
		var guard: int = 0
		while not parent_name.is_empty() and by_name.has(parent_name) and guard < 32:
			var parent: Dictionary = by_name[parent_name]
			if not bool(parent.get("visible", true)):
				element["visible"] = false
				element["hidden_by_parent"] = true
				break
			parent_name = str(parent.get("parent_name", ""))
			guard += 1
		elements[index] = element


static func _mark_template_elements(path: String, elements: Array) -> void:
	var file_name: String = path.get_file().get_basename().to_lower()
	var generic_names: Array[String] = [
		"card",
		"button",
		"icon",
		"name_label",
		"description_label",
		"price_label",
		"value_label",
		"glow"
	]
	for index: int in range(elements.size()):
		if not (elements[index] is Dictionary):
			continue
		var element: Dictionary = elements[index]
		if bool(element.get("runtime_only", false)):
			continue
		var name: String = str(element.get("name", "")).to_lower()
		if bool(element.get("unresolved_parent", false)):
			element["template_only"] = true
		if file_name.contains("tienda") and generic_names.has(name):
			element["template_only"] = true
		if file_name.contains("seleccion"):
			element["template_only"] = true
		elements[index] = element


static func _add_special_runtime_views(
	path: String, source: String, elements: Array, images: Array, colors: Dictionary
) -> void:
	var file_name: String = path.get_file().get_basename().to_lower()
	if file_name.contains("seleccion"):
		_add_selection_runtime(source, elements, images, colors)


static func _add_selection_runtime(
	_source: String, elements: Array, images: Array, colors: Dictionary
) -> void:
	var gold: Color = _color_or(colors, "COLOR_GOLD_BRIGHT", Color("#FFD66B"))
	var text: Color = _color_or(colors, "COLOR_TEXT", Color("#F0E7D7"))
	var muted: Color = _color_or(colors, "COLOR_MUTED", Color("#BBB3A3"))
	var frame_color: Color = _color_or(colors, "COLOR_FRAME", Color(0.008, 0.013, 0.022, 0.97))
	var card_color: Color = _color_or(colors, "COLOR_CARD", Color(0.018, 0.025, 0.038, 0.98))
	var alba: Color = _color_or(colors, "COLOR_ALBA", Color("#8DBBFF"))
	var umbral: Color = _color_or(colors, "COLOR_UMBRAL", Color("#D578FF"))
	var paladin_path: String = _find_image(images, ["paladin1", "paladin/seleccion", "paladin"])

	# Vista de facción.
	var faction_frame: Rect2 = Rect2(18.0, 20.0, 964.0, 560.0)
	elements.append(
		_runtime_visual(
			"runtime_faction_frame",
			faction_frame,
			"",
			0,
			"panel",
			frame_color,
			gold,
			text,
			"faction"
		)
	)
	elements.append(
		_runtime_visual(
			"runtime_faction_title",
			Rect2(48.0, 31.0, 904.0, 50.0),
			"ELIGE TU DESTINO",
			33,
			"label",
			Color(0, 0, 0, 0),
			Color(0, 0, 0, 0),
			gold,
			"faction"
		)
	)
	elements.append(
		_runtime_visual(
			"runtime_faction_subtitle",
			Rect2(48.0, 78.0, 904.0, 28.0),
			"La Fractura se abre ante ti. Decide qué juramento guiará tu aventura.",
			16,
			"label",
			Color(0, 0, 0, 0),
			Color(0, 0, 0, 0),
			muted,
			"faction"
		)
	)
	var faction_cards: Array[Dictionary] = [
		{
			"rect": Rect2(70.0, 135.0, 405.0, 350.0),
			"title": "JURAMENTO DEL ALBA",
			"subtitle": "LA SENDA DE LA LUZ",
			"description": "Defiende los reinos y contiene la Fractura.",
			"enemies": "Bandidos · Monstruos · Cultistas · Demonios",
			"classes": "Paladín · Arquero · Arcanista",
			"destiny": "PROTEGER",
			"accent": alba,
			"fill": _color_or(colors, "COLOR_ALBA_BG", Color(0.020, 0.045, 0.082, 0.98))
		},
		{
			"rect": Rect2(525.0, 135.0, 405.0, 350.0),
			"title": "PACTO DEL UMBRAL",
			"subtitle": "LA SENDA DE LA NOCHE",
			"description": "Domina la Fractura y somete los reinos.",
			"enemies": "Aventureros · Guardias · Paladines · Inquisidores",
			"classes": "Nigromante · Caballero de Sangre · Asesino",
			"destiny": "CONQUISTAR",
			"accent": umbral,
			"fill": _color_or(colors, "COLOR_UMBRAL_BG", Color(0.065, 0.022, 0.088, 0.98))
		}
	]
	for index: int in range(faction_cards.size()):
		var data: Dictionary = faction_cards[index]
		var rect: Rect2 = data["rect"]
		var accent: Color = data["accent"]
		elements.append(
			_runtime_visual(
				"runtime_faction_card_%d" % index,
				rect,
				"",
				0,
				"panel",
				data["fill"],
				accent,
				text,
				"faction"
			)
		)
		elements.append(
			_runtime_visual(
				"runtime_faction_emblem_%d" % index,
				Rect2(rect.position + Vector2(145, 18), Vector2(115, 115)),
				"✦" if index == 0 else "◆",
				42,
				"panel",
				Color(accent.r * 0.08, accent.g * 0.08, accent.b * 0.08, 0.42),
				accent,
				accent,
				"faction"
			)
		)
		elements.append(
			_runtime_visual(
				"runtime_faction_name_%d" % index,
				Rect2(rect.position + Vector2(46, 140), Vector2(313, 40)),
				str(data["title"]),
				18,
				"panel",
				Color(0.17, 0.11, 0.04, 0.97),
				gold,
				text,
				"faction"
			)
		)
		elements.append(
			_runtime_visual(
				"runtime_faction_role_%d" % index,
				Rect2(rect.position + Vector2(30, 187), Vector2(345, 20)),
				str(data["subtitle"]),
				13,
				"label",
				Color(0, 0, 0, 0),
				Color(0, 0, 0, 0),
				accent,
				"faction"
			)
		)
		elements.append(
			_runtime_visual(
				"runtime_faction_desc_%d" % index,
				Rect2(rect.position + Vector2(34, 210), Vector2(337, 32)),
				str(data["description"]),
				12,
				"label",
				Color(0, 0, 0, 0),
				Color(0, 0, 0, 0),
				text,
				"faction"
			)
		)
		elements.append(
			_runtime_visual(
				"runtime_faction_info_%d" % index,
				Rect2(rect.position + Vector2(30, 245), Vector2(345, 64)),
				"ENEMIGOS   %s\nCLASES       %s" % [str(data["enemies"]), str(data["classes"])],
				10,
				"panel",
				Color(0, 0, 0, 0.92),
				gold,
				text,
				"faction"
			)
		)
		elements.append(
			_runtime_visual(
				"runtime_faction_destiny_%d" % index,
				Rect2(rect.position + Vector2(122, 316), Vector2(161, 27)),
				str(data["destiny"]),
				11,
				"panel",
				Color(0.07, 0.045, 0.018, 0.97),
				gold,
				accent,
				"faction"
			)
		)
	elements.append(
		_runtime_visual(
			"runtime_faction_status",
			Rect2(285, 486, 430, 32),
			"Selecciona una facción para continuar.",
			13,
			"label",
			Color(0, 0, 0, 0),
			Color(0, 0, 0, 0),
			muted,
			"faction"
		)
	)
	elements.append(
		_runtime_visual(
			"runtime_faction_back",
			Rect2(270, 528, 220, 40),
			"VOLVER",
			15,
			"button",
			Color(0.025, 0.035, 0.05, 0.98),
			gold,
			text,
			"faction"
		)
	)
	elements.append(
		_runtime_visual(
			"runtime_faction_confirm",
			Rect2(510, 528, 220, 40),
			"CONFIRMAR",
			15,
			"button",
			Color(0.04, 0.16, 0.12, 0.98),
			gold,
			text,
			"faction"
		)
	)

	# Vista de personaje.
	var character_frame: Rect2 = Rect2(18.0, 20.0, 1144.0, 720.0)
	elements.append(
		_runtime_visual(
			"runtime_character_frame",
			character_frame,
			"",
			0,
			"panel",
			frame_color,
			gold,
			text,
			"character"
		)
	)
	elements.append(
		_runtime_visual(
			"runtime_character_title",
			Rect2(48.0, 31.0, 1084.0, 50.0),
			"ELIGE A TU CAMPEÓN",
			33,
			"label",
			Color(0, 0, 0, 0),
			Color(0, 0, 0, 0),
			gold,
			"character"
		)
	)
	elements.append(
		_runtime_visual(
			"runtime_character_subtitle",
			Rect2(48.0, 78.0, 1084.0, 28.0),
			"Selecciona un personaje para continuar.",
			16,
			"label",
			Color(0, 0, 0, 0),
			Color(0, 0, 0, 0),
			muted,
			"character"
		)
	)
	var character_data: Array[Dictionary] = [
		{
			"name": "PALADÍN DEL ALBA",
			"role": "Defensor sagrado",
			"description": "Protegido por la luz.\nResiste el daño y puede curarse.",
			"ability": "ESCUDO SAGRADO",
			"ability_desc": "Bloquea temporalmente el daño recibido.",
			"accent": Color("#72B7FF"),
			"image": paladin_path,
			"stats": "VIDA  ★★★★★\nDAÑO  ★★★☆☆\nVEL.  ★★☆☆☆\nMAGIA ★★★☆☆"
		},
		{
			"name": "ARQUERO DEL BOSQUE",
			"role": "Atacante a distancia",
			"description": "Preciso a larga distancia.\nDestaca por su velocidad.",
			"ability": "DISPARO TRIPLE",
			"ability_desc": "Lanza tres flechas rápidamente.",
			"accent": Color("#6DE18D"),
			"image": "",
			"stats": "VIDA  ★★★☆☆\nDAÑO  ★★★★☆\nVEL.  ★★★★★\nMAGIA ★☆☆☆☆"
		},
		{
			"name": "ARCANISTA ESTELAR",
			"role": "Hechicero ofensivo",
			"description": "Domina fuerzas celestiales.\nDaña a varios enemigos.",
			"ability": "LLUVIA ARCANA",
			"ability_desc": "Golpea a varios enemigos con magia celestial.",
			"accent": Color("#B98DFF"),
			"image": "",
			"stats": "VIDA  ★★☆☆☆\nDAÑO  ★★★★★\nVEL.  ★★☆☆☆\nMAGIA ★★★★★"
		}
	]
	var positions: Array[Vector2] = [Vector2(60, 120), Vector2(425, 120), Vector2(790, 120)]
	for index: int in range(character_data.size()):
		var data: Dictionary = character_data[index]
		var rect: Rect2 = Rect2(positions[index], Vector2(330, 540))
		var accent: Color = data["accent"]
		elements.append(
			_runtime_visual(
				"runtime_character_card_%d" % index,
				rect,
				"",
				0,
				"panel",
				card_color,
				accent,
				text,
				"character"
			)
		)
		elements.append(
			_runtime_visual(
				"runtime_character_portrait_%d" % index,
				Rect2(rect.position + Vector2(15, 60), Vector2(300, 220)),
				"RETRATO EN DESARROLLO" if str(data["image"]).is_empty() else "",
				13,
				"image",
				Color(0.008, 0.016, 0.028, 0.96),
				Color(accent.r, accent.g, accent.b, 0.55),
				muted,
				"character",
				str(data["image"])
			)
		)
		elements.append(
			_runtime_visual(
				"runtime_character_name_%d" % index,
				Rect2(rect.position + Vector2(20, 286), Vector2(290, 42)),
				str(data["name"]),
				17,
				"panel",
				Color(0.10, 0.065, 0.025, 0.96),
				gold,
				text,
				"character"
			)
		)
		elements.append(
			_runtime_visual(
				"runtime_character_role_%d" % index,
				Rect2(rect.position + Vector2(25, 331), Vector2(280, 22)),
				str(data["role"]),
				12,
				"label",
				Color(0, 0, 0, 0),
				Color(0, 0, 0, 0),
				accent,
				"character"
			)
		)
		elements.append(
			_runtime_visual(
				"runtime_character_desc_%d" % index,
				Rect2(rect.position + Vector2(25, 356), Vector2(280, 48)),
				str(data["description"]),
				11,
				"label",
				Color(0, 0, 0, 0),
				Color(0, 0, 0, 0),
				text,
				"character"
			)
		)
		elements.append(
			_runtime_visual(
				"runtime_character_stats_%d" % index,
				Rect2(rect.position + Vector2(25, 410), Vector2(130, 88)),
				str(data["stats"]),
				10,
				"panel",
				Color(0, 0, 0, 0.58),
				Color(accent.r, accent.g, accent.b, 0.42),
				text,
				"character"
			)
		)
		elements.append(
			_runtime_visual(
				"runtime_character_ability_%d" % index,
				Rect2(rect.position + Vector2(165, 410), Vector2(140, 88)),
				"%s\n%s" % [str(data["ability"]), str(data["ability_desc"])],
				10,
				"panel",
				Color(0.025, 0.035, 0.055, 0.96),
				gold,
				text,
				"character"
			)
		)
	elements.append(
		_runtime_visual(
			"runtime_character_status",
			Rect2(375, 666, 430, 28),
			"Selecciona un personaje para continuar.",
			13,
			"label",
			Color(0, 0, 0, 0),
			Color(0, 0, 0, 0),
			muted,
			"character"
		)
	)
	elements.append(
		_runtime_visual(
			"runtime_character_back",
			Rect2(340, 700, 220, 36),
			"VOLVER",
			14,
			"button",
			Color(0.025, 0.035, 0.05, 0.98),
			gold,
			text,
			"character"
		)
	)
	elements.append(
		_runtime_visual(
			"runtime_character_confirm",
			Rect2(620, 700, 220, 36),
			"CONFIRMAR",
			14,
			"button",
			Color(0.04, 0.16, 0.12, 0.98),
			gold,
			text,
			"character"
		)
	)


static func _runtime_visual(
	name: String,
	rect: Rect2,
	display_text: String,
	font_size: int,
	style: String,
	fill: Color,
	border: Color,
	text_color: Color,
	view_tag: String,
	image_path: String = ""
) -> Dictionary:
	return {
		"name": name,
		"rect": rect,
		"local_rect": rect,
		"parent_name": "",
		"parent_offset": Vector2.ZERO,
		"kind": "runtime",
		"span_a_start": -1,
		"span_a_end": -1,
		"span_b_start": -1,
		"span_b_end": -1,
		"line": 0,
		"draw_order": 100000,
		"source_kind": "Vista PLAY reconstruida",
		"dirty": false,
		"image_path": image_path,
		"display_text": display_text,
		"friendly_name": display_text if not display_text.is_empty() else _friendly_name(name),
		"font_size": font_size,
		"text_expression": "",
		"runtime_only": true,
		"editable": false,
		"preview_style": style,
		"control_type":
		(
			"TextureRect"
			if style == "image"
			else ("Label" if style == "label" else ("Button" if style == "button" else "Panel"))
		),
		"fill_color": fill,
		"border_color": border,
		"border_width": 2.0 if border.a > 0.0 else 0.0,
		"corner_radius": 10.0 if style in ["panel", "button"] else 0.0,
		"text_color": text_color,
		"visible": true,
		"view_tag": view_tag,
		"horizontal_alignment": HORIZONTAL_ALIGNMENT_CENTER,
		"vertical_alignment": VERTICAL_ALIGNMENT_CENTER,
		"image_mode": "contain"
	}


static func _apply_runtime_styles(elements: Array, colors: Dictionary) -> void:
	var gold: Color = _color_or(colors, "COLOR_GOLD", Color("#D6AD54"))
	var bright_gold: Color = _color_or(colors, "COLOR_GOLD_BRIGHT", Color("#FFE59A"))
	var emerald: Color = _color_or(colors, "COLOR_EMERALD", Color("#4CF0A5"))
	var text: Color = _color_or(colors, "COLOR_TEXT", Color("#F5EBD7"))
	for index: int in range(elements.size()):
		if not (elements[index] is Dictionary):
			continue
		var element: Dictionary = elements[index]
		if not bool(element.get("runtime_only", false)):
			continue
		if element.has("fill_color"):
			continue
		var style: String = str(element.get("preview_style", "label"))
		var name: String = str(element.get("name", "")).to_lower()
		if style == "button":
			element["fill_color"] = Color(0.035, 0.095, 0.085, 0.94)
			element["border_color"] = gold
			element["border_width"] = 1.0
			element["corner_radius"] = 6.0
			element["text_color"] = text
		elif style == "card":
			element["fill_color"] = Color(0.006, 0.012, 0.016, 0.92)
			element["border_color"] = gold
			element["border_width"] = 1.0
			element["corner_radius"] = 5.0
			element["text_color"] = text
		elif style == "slot":
			element["fill_color"] = Color(0.004, 0.008, 0.012, 0.72)
			element["border_color"] = Color(gold.r, gold.g, gold.b, 0.72)
			element["border_width"] = 1.0
			element["corner_radius"] = 4.0
		elif style == "image":
			element["fill_color"] = Color(0, 0, 0, 0)
		else:
			element["fill_color"] = Color(0, 0, 0, 0)
			element["text_color"] = (
				bright_gold
				if (name.contains("title") or name.contains("gold") or name.contains("total"))
				else (emerald if name.contains("region") else text)
			)
		elements[index] = element


static func _choose_canvas_color(
	elements: Array, colors: Dictionary, canvas_size: Vector2 = Vector2(900.0, 240.0)
) -> Color:
	var canvas_area: float = maxf(1.0, canvas_size.x * canvas_size.y)
	for raw_element: Variant in elements:
		if not (raw_element is Dictionary):
			continue
		var element: Dictionary = raw_element
		if str(element.get("control_type", "")) != "ColorRect":
			continue
		if not element.has("fill_color"):
			continue
		var rect: Rect2 = element.get("rect", Rect2())
		var coverage: float = maxf(0.0, rect.size.x * rect.size.y) / canvas_area
		var normalized_name: String = str(element.get("name", "")).to_lower()
		if (
			coverage >= 0.72
			or normalized_name.contains("background")
			or normalized_name.contains("fondo")
		):
			return element.get("fill_color", Color(0.01, 0.015, 0.02, 1.0))
	for key: String in [
		"COLOR_BACKGROUND",
		"BACKGROUND_COLOR",
		"COLOR_BG",
		"BG_COLOR",
		"FONDO_COLOR",
		"COLOR_FONDO",
		"BACKGROUND",
		"FONDO"
	]:
		if colors.has(key):
			return colors[key]
	return Color(0.008, 0.012, 0.018, 1.0)


static func _assigned_helper_call(source: String, variable_name: String) -> Dictionary:
	if variable_name.is_empty():
		return {}
	var regex: RegEx = RegEx.new()
	regex.compile(
		(
			"(?m)^\\s*(?:var\\s+)?"
			+ _escape_regex(variable_name)
			+ "(?:\\s*:\\s*[A-Za-z_][A-Za-z0-9_\\[\\]]*)?\\s*=\\s*([A-Za-z_][A-Za-z0-9_]*)\\s*\\("
		)
	)
	var match: RegExMatch = regex.search(source)
	if match == null:
		return {}
	var helper_name: String = match.get_string(1)
	if helper_name.ends_with(".new"):
		return {}
	var open_index: int = source.find("(", match.get_start(0))
	var close_index: int = _balanced_end(source, open_index, "(", ")")
	if open_index < 0 or close_index < 0:
		return {}
	var args: Array[String] = _split_arguments(
		source.substr(open_index + 1, close_index - open_index - 1)
	)
	var parent_name: String = ""
	if not args.is_empty():
		var first: String = args[0].strip_edges()
		if _is_identifier(first) and not first.begins_with("Vector2"):
			parent_name = first
	return {
		"helper_name": helper_name,
		"arguments": args,
		"parent_name": parent_name,
		"line": _line_at(source, match.get_start(0))
	}


static func _rect_from_helper_call(
	call_data: Dictionary, vectors: Dictionary, element_rects: Dictionary
) -> Variant:
	var helper: String = str(call_data.get("helper_name", "")).to_lower()
	var args: Array[String] = call_data.get("arguments", [])
	var position_index: int = -1
	var size_index: int = -1
	if helper.contains("label") or helper.contains("button"):
		position_index = 2 if args.size() > 3 and _is_identifier(args[0].strip_edges()) else 1
		size_index = position_index + 1
	elif (
		helper.contains("color_rect")
		or helper.contains("ambient_glow")
		or helper.contains("separator")
	):
		position_index = 1 if args.size() > 2 and _is_identifier(args[0].strip_edges()) else 0
		size_index = position_index + 1
	elif helper.contains("frame") or helper.contains("panel") or helper.contains("card"):
		position_index = 1 if args.size() > 2 and _is_identifier(args[0].strip_edges()) else 0
		size_index = position_index + 1
	if position_index < 0 or size_index >= args.size():
		var resolved_vectors: Array[Vector2] = []
		for argument: String in args:
			var value: Variant = _resolve_vector(argument, vectors, element_rects)
			if value is Vector2:
				resolved_vectors.append(value)
		if resolved_vectors.size() >= 2:
			return Rect2(resolved_vectors[0], resolved_vectors[1])
		return null
	var position: Variant = _resolve_vector(args[position_index], vectors, element_rects)
	var size: Variant = _resolve_vector(args[size_index], vectors, element_rects)
	if position is Vector2 and size is Vector2:
		return Rect2(position, size)
	return null


static func _text_from_call(call_data: Dictionary) -> String:
	if call_data.is_empty():
		return ""
	var helper: String = str(call_data.get("helper_name", "")).to_lower()
	var args: Array[String] = call_data.get("arguments", [])
	var index: int = -1
	if helper.contains("label") or helper.contains("button"):
		index = 1 if args.size() > 1 and _is_identifier(args[0].strip_edges()) else 0
	if index < 0 or index >= args.size():
		return ""
	return _literal_text(args[index])


static func _font_from_call(call_data: Dictionary) -> int:
	if call_data.is_empty():
		return 0
	var helper: String = str(call_data.get("helper_name", "")).to_lower()
	var args: Array[String] = call_data.get("arguments", [])
	if not (helper.contains("label") or helper.contains("button")):
		return 0
	for index: int in range(args.size() - 1, -1, -1):
		var value: String = args[index].strip_edges()
		if value.is_valid_int():
			var number: int = int(value)
			if number >= 7 and number <= 96:
				return number
	return 0


static func _last_resolved_color(arguments: Array[String], colors: Dictionary) -> Variant:
	for index: int in range(arguments.size() - 1, -1, -1):
		var value: Variant = _resolve_color(arguments[index], colors)
		if value is Color:
			return value
	return null


static func _property_expression(
	source: String, variable_name: String, property_name: String
) -> String:
	if variable_name.is_empty():
		return ""
	var regex: RegEx = RegEx.new()
	regex.compile(
		(
			"(?m)^\\s*"
			+ _escape_regex(variable_name)
			+ "\\."
			+ _escape_regex(property_name)
			+ "\\s*=\\s*"
		)
	)
	var matches: Array[RegExMatch] = regex.search_all(source)
	if matches.is_empty():
		return ""
	var match: RegExMatch = matches[0]
	return _read_expression(source, match.get_end(0)).strip_edges()


static func _has_full_rect_preset(source: String, variable_name: String) -> bool:
	var escaped_name: String = _escape_regex(variable_name)
	var regex: RegEx = RegEx.new()
	(
		regex
		. compile(
			(
				escaped_name
				+ "\\.(?:set_anchors_and_offsets_preset|set_anchors_preset|set_offsets_preset)\\(\\s*Control\\.PRESET_FULL_RECT"
			)
		)
	)
	if regex.search(source) != null:
		return true
	var anchors_regex: RegEx = RegEx.new()
	anchors_regex.compile(escaped_name + "\\.anchor_(?:right|bottom)\\s*=\\s*1(?:\\.0+)?")
	return anchors_regex.search_all(source).size() >= 2


static func _style_method_number(
	source: String, variable_name: String, method_name: String
) -> float:
	var regex: RegEx = RegEx.new()
	regex.compile(
		(
			_escape_regex(variable_name)
			+ "\\."
			+ _escape_regex(method_name)
			+ "\\(\\s*([-+]?\\d+(?:\\.\\d+)?)"
		)
	)
	var match: RegExMatch = regex.search(source)
	return float(match.get_string(1)) if match != null else 0.0


static func _resolve_color(expression: String, colors: Dictionary) -> Variant:
	var clean: String = expression.strip_edges().trim_suffix(",")
	if clean.is_empty():
		return null
	if colors.has(clean):
		return colors[clean]
	match clean:
		"Color.BLACK", "Color.BLACK_SMOKE", "BLACK":
			return Color.BLACK
		"Color.WHITE", "WHITE":
			return Color.WHITE
		"Color.TRANSPARENT", "TRANSPARENT":
			return Color(0, 0, 0, 0)
	if clean.begins_with("Color("):
		var open_index: int = clean.find("(")
		var close_index: int = _balanced_end(clean, open_index, "(", ")")
		if close_index < 0:
			return null
		var args: Array[String] = _split_arguments(
			clean.substr(open_index + 1, close_index - open_index - 1)
		)
		if args.size() == 1:
			var value: String = (
				args[0]
				. strip_edges()
				. trim_prefix('"')
				. trim_suffix('"')
				. trim_prefix("'")
				. trim_suffix("'")
			)
			if value.begins_with("#"):
				return Color.from_string(value, Color.WHITE)
			if colors.has(value):
				return colors[value]
		if args.size() >= 3:
			var components: Array[float] = []
			for i: int in range(mini(4, args.size())):
				var component: Variant = _resolve_color_component(args[i], colors)
				if component == null:
					return null
				components.append(float(component))
			while components.size() < 4:
				components.append(1.0)
			return Color(components[0], components[1], components[2], components[3])
	return null


static func _resolve_color_component(expression: String, colors: Dictionary) -> Variant:
	var clean: String = expression.strip_edges()
	if clean.is_valid_float():
		return float(clean)
	var channel_regex: RegEx = RegEx.new()
	channel_regex.compile(
		"([A-Za-z_][A-Za-z0-9_]*)\\.(r|g|b|a)(?:\\s*\\*\\s*([-+]?\\d+(?:\\.\\d+)?))?"
	)
	var regex_match: RegExMatch = channel_regex.search(clean)
	if regex_match != null and colors.has(regex_match.get_string(1)):
		var color: Color = colors[regex_match.get_string(1)]
		var value: float = color.r
		match regex_match.get_string(2):
			"g":
				value = color.g
			"b":
				value = color.b
			"a":
				value = color.a
		var multiplier: String = regex_match.get_string(3)
		if not multiplier.is_empty():
			value *= float(multiplier)
		return value
	return null


static func _resolve_vector(
	expression: String, vectors: Dictionary, element_rects: Dictionary
) -> Variant:
	var clean: String = expression.strip_edges().trim_suffix(",")
	if clean.is_empty():
		return null
	if vectors.has(clean):
		return vectors[clean]
	if clean == "Vector2.ZERO" or clean == "Vector2i.ZERO":
		return Vector2.ZERO
	if clean == "Vector2.ONE" or clean == "Vector2i.ONE":
		return Vector2.ONE
	if clean.ends_with(".size"):
		var name: String = clean.trim_suffix(".size")
		if element_rects.has(name):
			return element_rects[name].size
	if clean.ends_with(".position"):
		var position_name: String = clean.trim_suffix(".position")
		if element_rects.has(position_name):
			return element_rects[position_name].position
	for operator: String in [" + ", " - "]:
		var split_index: int = _find_top_level_operator(clean, operator)
		if split_index >= 0:
			var left: Variant = _resolve_vector(
				clean.substr(0, split_index), vectors, element_rects
			)
			var right: Variant = _resolve_vector(
				clean.substr(split_index + operator.length()), vectors, element_rects
			)
			if left is Vector2 and right is Vector2:
				return left + right if operator.strip_edges() == "+" else left - right
	if clean.begins_with("Vector2(") or clean.begins_with("Vector2i("):
		var open_index: int = clean.find("(")
		var close_index: int = _balanced_end(clean, open_index, "(", ")")
		if close_index < 0:
			return null
		var args: Array[String] = _split_arguments(
			clean.substr(open_index + 1, close_index - open_index - 1)
		)
		if args.size() == 1:
			return _resolve_vector(args[0], vectors, element_rects)
		if args.size() >= 2:
			var x: String = args[0].strip_edges()
			var y: String = args[1].strip_edges()
			if x.is_valid_float() and y.is_valid_float():
				return Vector2(float(x), float(y))
	return null


static func _read_expression(source: String, start_index: int) -> String:
	var round_depth: int = 0
	var square_depth: int = 0
	var curly_depth: int = 0
	var in_string: bool = false
	var quote: String = ""
	var escaped: bool = false
	for index: int in range(start_index, source.length()):
		var character: String = source.substr(index, 1)
		if in_string:
			if escaped:
				escaped = false
			elif character == "\\":
				escaped = true
			elif character == quote:
				in_string = false
			continue
		if character == '"' or character == "'":
			in_string = true
			quote = character
			continue
		match character:
			"(":
				round_depth += 1
			")":
				round_depth -= 1
			"[":
				square_depth += 1
			"]":
				square_depth -= 1
			"{":
				curly_depth += 1
			"}":
				curly_depth -= 1
			"\n":
				if round_depth <= 0 and square_depth <= 0 and curly_depth <= 0:
					return source.substr(start_index, index - start_index).strip_edges()
	return source.substr(start_index).strip_edges()


static func _split_arguments(value: String) -> Array[String]:
	var result: Array[String] = []
	var start: int = 0
	var round_depth: int = 0
	var square_depth: int = 0
	var curly_depth: int = 0
	var in_string: bool = false
	var quote: String = ""
	var escaped: bool = false
	for index: int in range(value.length()):
		var character: String = value.substr(index, 1)
		if in_string:
			if escaped:
				escaped = false
			elif character == "\\":
				escaped = true
			elif character == quote:
				in_string = false
			continue
		if character == '"' or character == "'":
			in_string = true
			quote = character
			continue
		match character:
			"(":
				round_depth += 1
			")":
				round_depth -= 1
			"[":
				square_depth += 1
			"]":
				square_depth -= 1
			"{":
				curly_depth += 1
			"}":
				curly_depth -= 1
			",":
				if round_depth == 0 and square_depth == 0 and curly_depth == 0:
					result.append(value.substr(start, index - start).strip_edges())
					start = index + 1
	result.append(value.substr(start).strip_edges())
	return result


static func _balanced_end(
	source: String, open_index: int, open_character: String, close_character: String
) -> int:
	if open_index < 0:
		return -1
	var depth: int = 0
	var in_string: bool = false
	var quote: String = ""
	var escaped: bool = false
	for index: int in range(open_index, source.length()):
		var character: String = source.substr(index, 1)
		if in_string:
			if escaped:
				escaped = false
			elif character == "\\":
				escaped = true
			elif character == quote:
				in_string = false
			continue
		if character == '"' or character == "'":
			in_string = true
			quote = character
			continue
		if character == open_character:
			depth += 1
		elif character == close_character:
			depth -= 1
			if depth == 0:
				return index
	return -1


static func _find_top_level_operator(value: String, operator: String) -> int:
	var depth: int = 0
	var in_string: bool = false
	var quote: String = ""
	for index: int in range(value.length() - operator.length() + 1):
		var character: String = value.substr(index, 1)
		if in_string:
			if character == quote and (index == 0 or value.substr(index - 1, 1) != "\\"):
				in_string = false
			continue
		if character == '"' or character == "'":
			in_string = true
			quote = character
			continue
		if character in ["(", "[", "{"]:
			depth += 1
		elif character in [")", "]", "}"]:
			depth -= 1
		elif depth == 0 and value.substr(index, operator.length()) == operator:
			return index
	return -1


static func _inside_parentheses(value: String) -> String:
	var open_index: int = value.find("(")
	var close_index: int = value.rfind(")")
	if open_index < 0 or close_index <= open_index:
		return ""
	return value.substr(open_index + 1, close_index - open_index - 1).strip_edges()


static func _literal_text(expression: String) -> String:
	var clean: String = expression.strip_edges()
	var regex: RegEx = RegEx.new()
	regex.compile("[\\\"']((?:\\\\.|[^\\\"'])*)[\\\"']")
	var match: RegExMatch = regex.search(clean)
	if match == null:
		return ""
	return match.get_string(1).replace("\\n", "\n").replace("\\t", " ")


static func _type_from_helper(helper_name: String) -> String:
	var lower: String = helper_name.to_lower()
	if lower.contains("label"):
		return "Label"
	if lower.contains("button"):
		return "Button"
	if lower.contains("color_rect") or lower.contains("glow") or lower.contains("separator"):
		return "ColorRect"
	if lower.contains("texture") or lower.contains("image") or lower.contains("icon"):
		return "TextureRect"
	if lower.contains("panel") or lower.contains("frame") or lower.contains("card"):
		return "Panel"
	return "Control"


static func _style_for_type(control_type: String, name: String) -> String:
	match control_type:
		"Label":
			return "label"
		"Button", "OptionButton", "CheckBox":
			return "button"
		"Panel", "PanelContainer", "NinePatchRect":
			return "panel"
		"ColorRect":
			return "color_rect"
		"TextureRect":
			return "image"
		"HSlider", "VSlider":
			return "slider"
		"ProgressBar", "TextureProgressBar":
			return "progress"
		_:
			return _style_from_name(name)


static func _style_from_name(name: String) -> String:
	var lower: String = name.to_lower()
	if lower.contains("button") or lower.contains("boton"):
		return "button"
	if lower.contains("panel") or lower.contains("frame") or lower.contains("card"):
		return "panel"
	if lower.contains("slot") or lower.contains("hueco"):
		return "slot"
	if (
		lower.contains("image")
		or lower.contains("texture")
		or lower.contains("portrait")
		or lower.contains("retrato")
	):
		return "image"
	return "label"


static func _friendly_name(value: String) -> String:
	var clean: String = value.strip_edges().replace("_", " ")
	return clean.capitalize() if not clean.is_empty() else "Elemento visual"


static func _find_image(images: Array, tokens: Array[String]) -> String:
	for raw_image: Variant in images:
		if not (raw_image is Dictionary):
			continue
		var path: String = str((raw_image as Dictionary).get("path", ""))
		var normalized: String = path.to_lower()
		for token: String in tokens:
			if normalized.contains(token.to_lower()):
				return path
	return ""


static func _color_or(colors: Dictionary, key: String, fallback: Color) -> Color:
	return colors[key] if colors.has(key) and colors[key] is Color else fallback


static func _is_identifier(value: String) -> bool:
	var regex: RegEx = RegEx.new()
	regex.compile("^[A-Za-z_][A-Za-z0-9_]*$")
	return regex.search(value.strip_edges()) != null


static func _escape_regex(value: String) -> String:
	var result: String = value
	for character: String in [
		"\\", ".", "+", "*", "?", "[", "]", "(", ")", "{", "}", "^", "$", "|"
	]:
		result = result.replace(character, "\\" + character)
	return result


static func _line_at(source: String, index: int) -> int:
	return source.substr(0, clampi(index, 0, source.length())).count("\n") + 1
