@tool
extends VBoxContainer

const Parser = preload("res://addons/taskbar_ui_editor/taskbar_ui_parser.gd")
const Preview = preload("res://addons/taskbar_ui_editor/taskbar_ui_preview.gd")
const IMAGE_EXTENSIONS: Array[String] = ["png", "jpg", "jpeg", "webp", "svg"]

var script_picker: OptionButton
var background_picker: OptionButton
var view_picker: OptionButton
var element_image_picker: OptionButton
var element_list: ItemList
var preview: Control
var x_spin: SpinBox
var y_spin: SpinBox
var width_spin: SpinBox
var height_spin: SpinBox
var snap_check: CheckBox
var snap_spin: SpinBox
var show_images_check: CheckBox
var show_background_check: CheckBox
var show_text_check: CheckBox
var show_styles_check: CheckBox
var show_guides_check: CheckBox
var show_metrics_check: CheckBox
var show_hidden_check: CheckBox
var show_runtime_check: CheckBox
var status_label: Label
var save_button: Button
var undo_button: Button
var scripts: Array[String] = []
var project_images: Array[String] = []
var document: Dictionary = {}
var selected_element: int = -1
var updating_fields: bool = false
var updating_image_controls: bool = false
var updating_view_picker: bool = false


func _ready() -> void:
	_build_ui()
	call_deferred("_scan_project")


func _build_ui() -> void:
	size_flags_vertical = Control.SIZE_EXPAND_FILL
	var title: Label = Label.new()
	title.text = "TASKBAR UI EDITOR"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 18)
	add_child(title)

	var toolbar: HBoxContainer = HBoxContainer.new()
	add_child(toolbar)
	var scan_button: Button = Button.new()
	scan_button.text = "Escanear Scripts"
	scan_button.pressed.connect(_scan_project)
	toolbar.add_child(scan_button)
	script_picker = OptionButton.new()
	script_picker.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	script_picker.item_selected.connect(_on_script_selected)
	toolbar.add_child(script_picker)
	var open_button: Button = Button.new()
	open_button.text = "Abrir"
	open_button.pressed.connect(_open_current_script)
	toolbar.add_child(open_button)

	var visibility_row: HBoxContainer = HBoxContainer.new()
	add_child(visibility_row)
	show_background_check = CheckBox.new()
	show_background_check.text = "Fondo"
	show_background_check.button_pressed = true
	show_background_check.toggled.connect(_on_show_background_toggled)
	visibility_row.add_child(show_background_check)
	show_images_check = CheckBox.new()
	show_images_check.text = "Imágenes"
	show_images_check.button_pressed = true
	show_images_check.toggled.connect(_on_show_images_toggled)
	visibility_row.add_child(show_images_check)
	show_styles_check = CheckBox.new()
	show_styles_check.text = "Colores"
	show_styles_check.button_pressed = true
	show_styles_check.tooltip_text = "Muestra ColorRect, StyleBoxFlat, fondos, bordes, esquinas y sombras detectados."
	show_styles_check.toggled.connect(_on_show_styles_toggled)
	visibility_row.add_child(show_styles_check)
	show_text_check = CheckBox.new()
	show_text_check.text = "Textos"
	show_text_check.button_pressed = true
	show_text_check.toggled.connect(_on_show_text_toggled)
	visibility_row.add_child(show_text_check)
	show_runtime_check = CheckBox.new()
	show_runtime_check.text = "Vista PLAY"
	show_runtime_check.button_pressed = true
	show_runtime_check.tooltip_text = "Muestra valores, botones y controles generados durante la ejecución."
	show_runtime_check.toggled.connect(_on_show_runtime_toggled)
	visibility_row.add_child(show_runtime_check)

	var detail_row: HBoxContainer = HBoxContainer.new()
	add_child(detail_row)
	show_guides_check = CheckBox.new()
	show_guides_check.text = "Guías"
	show_guides_check.button_pressed = false
	show_guides_check.tooltip_text = "Dibuja las cajas de selección sin alterar la posición real."
	show_guides_check.toggled.connect(_on_show_guides_toggled)
	detail_row.add_child(show_guides_check)
	show_metrics_check = CheckBox.new()
	show_metrics_check.text = "Medidas"
	show_metrics_check.button_pressed = false
	show_metrics_check.toggled.connect(_on_show_metrics_toggled)
	detail_row.add_child(show_metrics_check)
	show_hidden_check = CheckBox.new()
	show_hidden_check.text = "Ocultos"
	show_hidden_check.button_pressed = false
	show_hidden_check.tooltip_text = "Muestra controles con visible = false como referencia de depuración."
	show_hidden_check.toggled.connect(_on_show_hidden_toggled)
	detail_row.add_child(show_hidden_check)
	var view_label: Label = Label.new()
	view_label.text = "Vista:"
	detail_row.add_child(view_label)
	view_picker = OptionButton.new()
	view_picker.custom_minimum_size = Vector2(150.0, 0.0)
	view_picker.item_selected.connect(_on_view_selected)
	detail_row.add_child(view_picker)
	var background_label: Label = Label.new()
	background_label.text = "Fondo:"
	detail_row.add_child(background_label)
	background_picker = OptionButton.new()
	background_picker.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	background_picker.item_selected.connect(_on_background_selected)
	detail_row.add_child(background_picker)

	var image_row: HBoxContainer = HBoxContainer.new()
	add_child(image_row)
	var image_label: Label = Label.new()
	image_label.text = "Imagen del elemento:"
	image_row.add_child(image_label)
	element_image_picker = OptionButton.new()
	element_image_picker.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	element_image_picker.item_selected.connect(_on_element_image_selected)
	image_row.add_child(element_image_picker)

	var splitter: VSplitContainer = VSplitContainer.new()
	splitter.size_flags_vertical = Control.SIZE_EXPAND_FILL
	add_child(splitter)
	preview = Preview.new()
	preview.size_flags_vertical = Control.SIZE_EXPAND_FILL
	preview.selection_changed.connect(_on_preview_selection_changed)
	preview.element_rect_changed.connect(_on_preview_rect_changed)
	splitter.add_child(preview)

	element_list = ItemList.new()
	element_list.custom_minimum_size = Vector2(0.0, 140.0)
	element_list.item_selected.connect(_on_element_selected)
	splitter.add_child(element_list)

	var values: GridContainer = GridContainer.new()
	values.columns = 4
	add_child(values)
	x_spin = _add_spin(values, "X")
	y_spin = _add_spin(values, "Y")
	width_spin = _add_spin(values, "Ancho")
	height_spin = _add_spin(values, "Alto")

	var options: HBoxContainer = HBoxContainer.new()
	add_child(options)
	snap_check = CheckBox.new()
	snap_check.text = "Ajustar a rejilla"
	snap_check.button_pressed = true
	snap_check.toggled.connect(_on_snap_toggled)
	options.add_child(snap_check)
	snap_spin = SpinBox.new()
	snap_spin.min_value = 1.0
	snap_spin.max_value = 64.0
	snap_spin.value = 1.0
	snap_spin.value_changed.connect(_on_snap_step_changed)
	options.add_child(snap_spin)

	var actions: HBoxContainer = HBoxContainer.new()
	add_child(actions)
	save_button = Button.new()
	save_button.text = "Guardar posiciones"
	save_button.disabled = true
	save_button.pressed.connect(_save_changes)
	actions.add_child(save_button)
	undo_button = Button.new()
	undo_button.text = "Restaurar copia"
	undo_button.disabled = true
	undo_button.pressed.connect(_restore_backup)
	actions.add_child(undo_button)

	status_label = Label.new()
	status_label.text = "Buscando interfaces visuales e imágenes..."
	status_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	add_child(status_label)


func _add_spin(parent: GridContainer, label_text: String) -> SpinBox:
	var label: Label = Label.new()
	label.text = label_text
	parent.add_child(label)
	var spin: SpinBox = SpinBox.new()
	spin.min_value = -10000.0
	spin.max_value = 10000.0
	spin.step = 1.0
	spin.allow_greater = true
	spin.allow_lesser = true
	spin.value_changed.connect(_on_numeric_changed)
	parent.add_child(spin)
	return spin


func _scan_project() -> void:
	scripts.clear()
	project_images.clear()
	script_picker.clear()
	_scan_image_directory("res://")
	_scan_directory("res://Scripts")
	if scripts.is_empty():
		_scan_directory("res://")
	scripts.sort()
	project_images.sort()
	for path: String in scripts:
		script_picker.add_item(path.get_file())
		script_picker.set_item_metadata(script_picker.item_count - 1, path)
	if scripts.is_empty():
		status_label.text = "No se encontraron scripts con posiciones visuales."
		_set_document({})
		return
	script_picker.select(0)
	_load_script(scripts[0])


func _scan_directory(path: String) -> void:
	var directory: DirAccess = DirAccess.open(path)
	if directory == null:
		return
	directory.list_dir_begin()
	while true:
		var entry: String = directory.get_next()
		if entry.is_empty():
			break
		if entry.begins_with(".") or entry == "addons":
			continue
		var full_path: String = path.path_join(entry)
		if directory.current_is_dir():
			_scan_directory(full_path)
		elif entry.get_extension().to_lower() == "gd":
			var parsed: Dictionary = Parser.parse_script(full_path)
			var parsed_elements: Array = parsed.get("elements", [])
			if not parsed_elements.is_empty():
				scripts.append(full_path)
	directory.list_dir_end()


func _scan_image_directory(path: String) -> void:
	var directory: DirAccess = DirAccess.open(path)
	if directory == null:
		return
	directory.list_dir_begin()
	while true:
		var entry: String = directory.get_next()
		if entry.is_empty():
			break
		if entry.begins_with(".") or entry == "addons" or entry == ".godot":
			continue
		var full_path: String = path.path_join(entry)
		if directory.current_is_dir():
			_scan_image_directory(full_path)
		elif IMAGE_EXTENSIONS.has(entry.get_extension().to_lower()):
			project_images.append(full_path)
	directory.list_dir_end()


func _on_script_selected(index: int) -> void:
	if index < 0 or index >= script_picker.item_count:
		return
	_load_script(str(script_picker.get_item_metadata(index)))


func _load_script(path: String) -> void:
	var editor_text: String = _get_open_editor_text(path)
	if editor_text.is_empty():
		_set_document(Parser.parse_script(path))
	else:
		_set_document(Parser.parse_source(path, editor_text))


func _set_document(new_document: Dictionary) -> void:
	document = new_document
	_apply_forced_module_canvas()
	selected_element = -1
	element_list.clear()
	var elements: Array = document.get("elements", [])
	for raw_element: Variant in elements:
		var element: Dictionary = raw_element
		var image_marker: String = (
			" · IMG" if not str(element.get("image_path", "")).is_empty() else ""
		)
		var style_marker: String = (
			" · COLOR" if element.has("fill_color") or element.has("border_color") else ""
		)
		var hidden_marker: String = " · OCULTO" if not bool(element.get("visible", true)) else ""
		var runtime_marker: String = " · PLAY" if bool(element.get("runtime_only", false)) else ""
		var rect: Rect2 = element.get("rect", Rect2())
		var visible_name: String = str(element.get("display_text", "")).strip_edges()
		if visible_name.is_empty():
			visible_name = str(element.get("friendly_name", element.get("name", "UI")))
		var font_marker: String = (
			" · texto %dpx" % int(element.get("font_size", 0))
			if int(element.get("font_size", 0)) > 0
			else ""
		)
		element_list.add_item(
			(
				"%s · %sx%s%s · línea %d%s%s%s%s"
				% [
					visible_name,
					Parser.format_number(rect.size.x),
					Parser.format_number(rect.size.y),
					font_marker,
					int(element.get("line", 0)),
					image_marker,
					style_marker,
					hidden_marker,
					runtime_marker
				]
			)
		)
		element_list.set_item_tooltip(
			element_list.item_count - 1,
			(
				"Control: %s\nTipo: %s\nPosición: %s, %s\nTamaño: %s × %s\nCódigo: %s%s"
				% [
					str(element.get("name", "UI")),
					str(element.get("control_type", "Control")),
					Parser.format_number(rect.position.x),
					Parser.format_number(rect.position.y),
					Parser.format_number(rect.size.x),
					Parser.format_number(rect.size.y),
					str(element.get("source_kind", "")),
					_element_style_summary(element)
				]
			)
		)
	var script_images: Array = document.get("images", [])
	var script_path: String = str(document.get("path", ""))
	var background_path: String = str(document.get("background_path", ""))
	if script_path.get_file().get_basename().to_lower().contains("tienda"):
		var shop_background: String = _guess_project_background(script_path)
		if not shop_background.is_empty():
			background_path = shop_background
	elif background_path.is_empty():
		background_path = _guess_project_background(script_path)
	_populate_view_picker()
	preview.set_document(
		document.get("canvas_size", Vector2(900.0, 240.0)),
		elements,
		script_images,
		background_path,
		document.get("canvas_color", Color(0.008, 0.012, 0.018, 1.0)),
		str(document.get("font_path", ""))
	)
	var default_view: String = str(document.get("default_view", "all"))
	preview.set_active_view(default_view)
	_apply_view_canvas_size(default_view)
	_populate_image_controls(background_path)
	status_label.text = (
		"%d elementos · %d con color/estilo · %d colores · %d imágenes · %s"
		% [
			elements.size(),
			int(document.get("styled_elements", 0)),
			int(document.get("detected_colors", 0)),
			script_images.size(),
			str(document.get("path", ""))
		]
	)
	save_button.disabled = true
	undo_button.disabled = not FileAccess.file_exists(
		str(document.get("path", "")) + ".taskbar_ui_editor.bak"
	)
	_clear_fields()


func _apply_forced_module_canvas() -> void:
	var path: String = str(document.get("path", ""))
	var name: String = path.get_file().get_basename().to_lower()
	if name.contains("tienda"):
		document["canvas_size"] = Vector2(1448.0, 1086.0)
	elif name.contains("forja"):
		document["canvas_size"] = Vector2(1666.0, 922.0)
	elif name.contains("inventario"):
		document["canvas_size"] = Vector2(1672.0, 941.0)
	elif name.contains("arbol") or name.contains("habilidad"):
		document["canvas_size"] = Vector2(1448.0, 1086.0)
	elif name.contains("menu_principal"):
		document["canvas_size"] = Vector2(900.0, 600.0)
	elif name == "main" or name.contains("mapa_mundos"):
		document["canvas_size"] = Vector2(900.0, 240.0)


func _populate_image_controls(background_path: String) -> void:
	updating_image_controls = true
	background_picker.clear()
	element_image_picker.clear()
	background_picker.add_item("Sin fondo")
	background_picker.set_item_metadata(0, "")
	element_image_picker.add_item("Automática / sin imagen")
	element_image_picker.set_item_metadata(0, "")
	var paths: Array[String] = _get_relevant_images()
	if not background_path.is_empty() and not paths.has(background_path):
		paths.insert(0, background_path)
	for path: String in paths:
		var label: String = _image_display_name(path)
		background_picker.add_item(label)
		background_picker.set_item_metadata(background_picker.item_count - 1, path)
		element_image_picker.add_item(label)
		element_image_picker.set_item_metadata(element_image_picker.item_count - 1, path)
	_select_option_by_metadata(background_picker, background_path)
	element_image_picker.select(0)
	updating_image_controls = false


func _get_relevant_images() -> Array[String]:
	var result: Array[String] = []
	var seen: Dictionary = {}
	var script_images: Array = document.get("images", [])
	for raw_image: Variant in script_images:
		if not (raw_image is Dictionary):
			continue
		var path: String = str((raw_image as Dictionary).get("path", ""))
		if not path.is_empty() and not seen.has(path):
			seen[path] = true
			result.append(path)
	var script_path: String = str(document.get("path", ""))
	var keywords: Array[String] = _script_image_keywords(script_path)
	for path: String in project_images:
		if seen.has(path):
			continue
		var normalized: String = path.to_lower()
		var matches: bool = false
		for keyword: String in keywords:
			if normalized.contains(keyword):
				matches = true
				break
		if matches:
			seen[path] = true
			result.append(path)
			if result.size() >= 160:
				break
	return result


func _script_image_keywords(script_path: String) -> Array[String]:
	var name: String = script_path.get_file().get_basename().to_lower()
	if name.contains("inventario"):
		return ["inventario", "/slots/", "paladin", "personajes"]
	if name.contains("tienda"):
		return ["tienda", "elfa", "lyria", "mercader"]
	if name.contains("forja"):
		return ["forja", "anvil", "yunque"]
	if name.contains("arbol") or name.contains("habilidad"):
		return ["arbol", "habilidad", "skill"]
	if name.contains("seleccion"):
		return ["seleccion", "personajes", "paladin", "faccion"]
	if name.contains("mapa") or name.contains("atlas"):
		return ["mapa", "atlas", "mundo"]
	if name == "main":
		return ["/mundos/", "mundo1", "0-1", "0-2", "iconosbarra"]
	return [name]


func _guess_project_background(script_path: String) -> String:
	var name: String = script_path.get_file().get_basename().to_lower()
	var preferred_tokens: Array[String] = []
	if name.contains("inventario"):
		preferred_tokens = ["inventario_rpg_base", "inventario_base"]
	elif name.contains("tienda"):
		preferred_tokens = ["tienda_base"]
	elif name.contains("forja"):
		preferred_tokens = ["forja_pixel", "forja_base"]
	elif name.contains("arbol") or name.contains("habilidad"):
		preferred_tokens = ["arbol_habilidades", "cosmico_sin_texto"]
	elif name == "main":
		preferred_tokens = ["/mundos/mundo1/0-1.png", "/mundos/mundo1/0-2.png"]
	for token: String in preferred_tokens:
		for path: String in project_images:
			if path.to_lower().contains(token):
				return path
	return ""


func _image_display_name(path: String) -> String:
	var parent_name: String = path.get_base_dir().get_file()
	return "%s · %s" % [path.get_file(), parent_name]


func _select_option_by_metadata(option: OptionButton, metadata: String) -> void:
	for index: int in range(option.item_count):
		if str(option.get_item_metadata(index)) == metadata:
			option.select(index)
			return
	option.select(0)


func _on_background_selected(index: int) -> void:
	if updating_image_controls or index < 0 or index >= background_picker.item_count:
		return
	preview.set_background_path(str(background_picker.get_item_metadata(index)))


func _on_element_image_selected(index: int) -> void:
	if updating_image_controls or selected_element < 0:
		return
	if index < 0 or index >= element_image_picker.item_count:
		return
	var path: String = str(element_image_picker.get_item_metadata(index))
	var elements: Array = document.get("elements", [])
	if selected_element >= elements.size():
		return
	elements[selected_element]["image_path"] = path
	document["elements"] = elements
	preview.set_element_image(selected_element, path)
	_refresh_element_list_marker(selected_element)


func _on_show_images_toggled(enabled: bool) -> void:
	preview.set_show_images(enabled)


func _on_show_background_toggled(enabled: bool) -> void:
	preview.set_show_background(enabled)


func _on_show_text_toggled(enabled: bool) -> void:
	preview.set_show_real_text(enabled)


func _on_show_styles_toggled(enabled: bool) -> void:
	preview.set_show_styles(enabled)


func _on_show_guides_toggled(enabled: bool) -> void:
	preview.set_show_guides(enabled)


func _on_show_hidden_toggled(enabled: bool) -> void:
	preview.set_show_hidden(enabled)


func _on_show_metrics_toggled(enabled: bool) -> void:
	preview.set_show_metrics(enabled)


func _on_show_runtime_toggled(enabled: bool) -> void:
	preview.set_show_runtime_preview(enabled)


func _on_element_selected(index: int) -> void:
	_select_element(index)


func _on_preview_selection_changed(index: int) -> void:
	if index >= 0 and index < element_list.item_count:
		element_list.select(index)
	_select_element(index)


func _select_element(index: int) -> void:
	var elements: Array = document.get("elements", [])
	if index >= 0 and index < elements.size() and elements[index] is Dictionary:
		var driver_name: String = str((elements[index] as Dictionary).get("drag_driver", ""))
		if not driver_name.is_empty():
			var driver_index: int = _find_element_index(elements, driver_name)
			if driver_index >= 0:
				index = driver_index
				if index < element_list.item_count:
					element_list.select(index)
	selected_element = index
	preview.select_element(index)
	if index < 0:
		_clear_fields()
		updating_image_controls = true
		element_image_picker.select(0)
		updating_image_controls = false
		return
	if index >= elements.size():
		return
	var element: Dictionary = elements[index]
	var rect: Rect2 = element.get("rect", Rect2())
	_update_fields(rect)
	var is_runtime_only: bool = bool(element.get("runtime_only", false))
	var is_editable: bool = bool(element.get("editable", not is_runtime_only))
	if is_runtime_only:
		is_editable = true
	var allow_resize: bool = bool(element.get("allow_resize", true))
	if is_runtime_only and not element.has("allow_resize"):
		allow_resize = false
	_set_edit_fields_enabled(is_editable, allow_resize)
	if is_runtime_only:
		status_label.text = "Vista PLAY: puedes mover el elemento. Si está vinculado al código, se guardará en el script."
	elif not is_editable:
		status_label.text = "Elemento visual detectado automáticamente; no cambia las coordenadas del script."
	var image_path: String = str(elements[index].get("image_path", ""))
	updating_image_controls = true
	_select_option_by_metadata(element_image_picker, image_path)
	updating_image_controls = false


func _refresh_element_list_marker(index: int) -> void:
	var elements: Array = document.get("elements", [])
	if index < 0 or index >= elements.size() or index >= element_list.item_count:
		return
	var element: Dictionary = elements[index]
	var image_marker: String = " · IMG" if not str(element.get("image_path", "")).is_empty() else ""
	var style_marker: String = (
		" · COLOR" if element.has("fill_color") or element.has("border_color") else ""
	)
	var hidden_marker: String = " · OCULTO" if not bool(element.get("visible", true)) else ""
	var runtime_marker: String = " · PLAY" if bool(element.get("runtime_only", false)) else ""
	var rect: Rect2 = element.get("rect", Rect2())
	var visible_name: String = str(element.get("display_text", "")).strip_edges()
	if visible_name.is_empty():
		visible_name = str(element.get("friendly_name", element.get("name", "UI")))
	var font_marker: String = (
		" · texto %dpx" % int(element.get("font_size", 0))
		if int(element.get("font_size", 0)) > 0
		else ""
	)
	element_list.set_item_text(
		index,
		(
			"%s · %sx%s%s · línea %d%s%s%s%s"
			% [
				visible_name,
				Parser.format_number(rect.size.x),
				Parser.format_number(rect.size.y),
				font_marker,
				int(element.get("line", 0)),
				image_marker,
				style_marker,
				hidden_marker,
				runtime_marker
			]
		)
	)


func _element_style_summary(element: Dictionary) -> String:
	var lines: Array[String] = []
	if element.has("fill_color"):
		var fill: Color = element.get("fill_color", Color.TRANSPARENT)
		lines.append("Fondo: #" + fill.to_html(true))
	if element.has("border_color"):
		var border: Color = element.get("border_color", Color.TRANSPARENT)
		lines.append("Borde: #" + border.to_html(true))
	if element.has("text_color"):
		var text_color: Color = element.get("text_color", Color.WHITE)
		lines.append("Texto: #" + text_color.to_html(true))
	if lines.is_empty():
		return ""
	return "\n" + "\n".join(lines)


func _on_preview_rect_changed(index: int, rect: Rect2, _finished: bool) -> void:
	var elements: Array = document.get("elements", [])
	if index < 0 or index >= elements.size():
		return
	elements[index]["rect"] = rect
	elements[index]["dirty"] = true
	_sync_shared_axis_groups(elements, index, rect)
	_sync_linked_elements(elements, str(elements[index].get("name", "")), rect)
	document["elements"] = elements
	selected_element = index
	_update_fields(rect)
	save_button.disabled = false


func _on_numeric_changed(_value: float) -> void:
	if updating_fields or selected_element < 0:
		return
	var elements: Array = document.get("elements", [])
	if selected_element >= elements.size():
		return
	if not bool(
		elements[selected_element].get(
			"editable", not bool(elements[selected_element].get("runtime_only", false))
		)
	):
		return
	var rect: Rect2 = Rect2(
		Vector2(float(x_spin.value), float(y_spin.value)),
		Vector2(maxf(4.0, float(width_spin.value)), maxf(4.0, float(height_spin.value)))
	)
	elements[selected_element]["rect"] = rect
	elements[selected_element]["dirty"] = true
	_sync_shared_axis_groups(elements, selected_element, rect)
	_sync_linked_elements(elements, str(elements[selected_element].get("name", "")), rect)
	document["elements"] = elements
	preview.queue_redraw()
	save_button.disabled = false


func _update_fields(rect: Rect2) -> void:
	updating_fields = true
	x_spin.value = rect.position.x
	y_spin.value = rect.position.y
	width_spin.value = rect.size.x
	height_spin.value = rect.size.y
	updating_fields = false


func _clear_fields() -> void:
	_set_edit_fields_enabled(true, true)
	updating_fields = true
	x_spin.value = 0.0
	y_spin.value = 0.0
	width_spin.value = 0.0
	height_spin.value = 0.0
	updating_fields = false


func _set_edit_fields_enabled(enabled: bool, allow_resize: bool = true) -> void:
	x_spin.editable = enabled
	y_spin.editable = enabled
	width_spin.editable = enabled and allow_resize
	height_spin.editable = enabled and allow_resize


func _populate_view_picker() -> void:
	if not is_instance_valid(view_picker):
		return
	updating_view_picker = true
	view_picker.clear()
	var views: Array = document.get("views", [])
	if views.is_empty():
		view_picker.add_item("Vista completa")
		view_picker.set_item_metadata(0, "all")
		view_picker.disabled = true
		document["default_view"] = "all"
	else:
		view_picker.disabled = false
		var default_tag: String = str(document.get("default_view", "all"))
		var selected_index: int = 0
		for raw_view: Variant in views:
			if not (raw_view is Dictionary):
				continue
			var view: Dictionary = raw_view
			var index: int = view_picker.item_count
			view_picker.add_item(str(view.get("name", view.get("tag", "Vista"))))
			view_picker.set_item_metadata(index, str(view.get("tag", "all")))
			if str(view.get("tag", "all")) == default_tag:
				selected_index = index
		view_picker.select(selected_index)
	updating_view_picker = false


func _on_view_selected(index: int) -> void:
	if updating_view_picker or not is_instance_valid(view_picker):
		return
	if index < 0 or index >= view_picker.item_count:
		return
	var tag: String = str(view_picker.get_item_metadata(index))
	document["default_view"] = tag
	preview.set_active_view(tag)
	_apply_view_canvas_size(tag)


func _apply_view_canvas_size(tag: String) -> void:
	var canvas_size: Vector2 = document.get("canvas_size", Vector2(900.0, 240.0))
	for raw_view: Variant in document.get("views", []):
		if not (raw_view is Dictionary):
			continue
		var view: Dictionary = raw_view
		if str(view.get("tag", "all")) != tag:
			continue
		if view.get("canvas_size", null) is Vector2:
			canvas_size = view.get("canvas_size", canvas_size)
		break
	preview.set_canvas_size(canvas_size)


func _find_element_index(elements: Array, name: String) -> int:
	for index: int in range(elements.size()):
		if not (elements[index] is Dictionary):
			continue
		if str((elements[index] as Dictionary).get("name", "")) == name:
			return index
	return -1


func _sync_shared_axis_groups(elements: Array, source_index: int, source_rect: Rect2) -> void:
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


func _sync_linked_elements(elements: Array, driver_name: String, driver_rect: Rect2) -> void:
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


func _on_snap_toggled(enabled: bool) -> void:
	preview.snap_enabled = enabled


func _on_snap_step_changed(value: float) -> void:
	preview.snap_step = maxf(1.0, value)


func _save_changes() -> void:
	var path: String = str(document.get("path", ""))
	if path.is_empty():
		return
	var original_source: String = str(document.get("source", ""))
	if original_source.is_empty():
		status_label.text = "No se pudo leer el script."
		return
	var current_editor_text: String = _get_open_editor_text(path)
	if not current_editor_text.is_empty() and current_editor_text != original_source:
		status_label.text = "El script cambió desde el último escaneo. Pulsa Escanear Scripts y vuelve a intentarlo."
		return
	var replacements: Array = Parser.build_replacements(document.get("elements", []))
	if replacements.is_empty():
		status_label.text = "No hay cambios pendientes."
		return
	var backup_path: String = path + ".taskbar_ui_editor.bak"
	if not FileAccess.file_exists(backup_path):
		if not Parser.write_text(backup_path, original_source):
			status_label.text = "No se pudo crear la copia de seguridad."
			return
	var output: String = Parser.apply_replacements(original_source, replacements)
	if output == original_source:
		status_label.text = "No se produjo ningún cambio en el código."
		return
	if not Parser.write_text(path, output):
		status_label.text = "No se pudo escribir el script en disco."
		return
	if Parser.read_text(path) != output:
		status_label.text = "La verificación del guardado falló."
		return
	_sync_open_script(path, output)
	var filesystem: EditorFileSystem = EditorInterface.get_resource_filesystem()
	filesystem.update_file(path)
	filesystem.scan_sources()
	status_label.text = "Guardado real completado en %s" % path
	_load_script(path)


func _restore_backup() -> void:
	var path: String = str(document.get("path", ""))
	var backup_path: String = path + ".taskbar_ui_editor.bak"
	if not FileAccess.file_exists(backup_path):
		return
	var backup_text: String = Parser.read_text(backup_path)
	if Parser.write_text(path, backup_text):
		_sync_open_script(path, backup_text)
		DirAccess.remove_absolute(ProjectSettings.globalize_path(backup_path))
		var filesystem: EditorFileSystem = EditorInterface.get_resource_filesystem()
		filesystem.update_file(path)
		filesystem.scan_sources()
		status_label.text = "Copia restaurada y sincronizada."
		_load_script(path)


func _get_open_editor_text(path: String) -> String:
	var script_editor: ScriptEditor = EditorInterface.get_script_editor()
	var open_scripts: Array[Script] = script_editor.get_open_scripts()
	var open_editors: Array[ScriptEditorBase] = script_editor.get_open_script_editors()
	var count: int = mini(open_scripts.size(), open_editors.size())
	for index: int in range(count):
		var script: Script = open_scripts[index]
		if script == null or script.resource_path != path:
			continue
		var base_editor: Control = open_editors[index].get_base_editor()
		if base_editor is CodeEdit:
			return (base_editor as CodeEdit).text
	return ""


func _sync_open_script(path: String, source: String) -> void:
	var script_editor: ScriptEditor = EditorInterface.get_script_editor()
	var open_scripts: Array[Script] = script_editor.get_open_scripts()
	var open_editors: Array[ScriptEditorBase] = script_editor.get_open_script_editors()
	var count: int = mini(open_scripts.size(), open_editors.size())
	for index: int in range(count):
		var script: Script = open_scripts[index]
		if script == null or script.resource_path != path:
			continue
		script.source_code = source
		script.reload(true)
		var base_editor: Control = open_editors[index].get_base_editor()
		if base_editor is CodeEdit:
			var code_edit: CodeEdit = base_editor as CodeEdit
			var line: int = code_edit.get_caret_line()
			var column: int = code_edit.get_caret_column()
			code_edit.text = source
			code_edit.set_caret_line(clampi(line, 0, maxi(0, code_edit.get_line_count() - 1)))
			code_edit.set_caret_column(maxi(0, column))
			return
	var loaded_script: Script = (
		ResourceLoader.load(path, "GDScript", ResourceLoader.CACHE_MODE_REPLACE) as Script
	)
	if loaded_script != null:
		loaded_script.source_code = source
		loaded_script.reload(true)


func _open_current_script() -> void:
	var path: String = str(document.get("path", ""))
	if path.is_empty() or not ResourceLoader.exists(path):
		return
	var line: int = -1
	var elements: Array = document.get("elements", [])
	if selected_element >= 0 and selected_element < elements.size():
		line = int(elements[selected_element].get("line", -1))
	var script: Script = load(path) as Script
	if script != null:
		EditorInterface.edit_script(script, line)
