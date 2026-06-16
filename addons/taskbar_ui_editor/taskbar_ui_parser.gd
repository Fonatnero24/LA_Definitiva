@tool
extends RefCounted

const VisualAnalyzer = preload("res://addons/taskbar_ui_editor/taskbar_ui_visual_analyzer.gd")
const DynamicAnalyzer = preload("res://addons/taskbar_ui_editor/taskbar_ui_dynamic_analyzer.gd")
const BlueprintAnalyzer = preload("res://addons/taskbar_ui_editor/taskbar_ui_blueprint_analyzer.gd")

const IMAGE_EXTENSIONS: Array[String] = ["png", "jpg", "jpeg", "webp", "svg"]
const PROJECT_FONT_CANDIDATES: Array[String] = [
	"res://Recursos/Fuentes/RPGPixel.ttf",
	"res://Recursos/Fuentes/RPGPixel.otf",
	"res://Recursos/Fuentes/PixelRPG.ttf",
	"res://Recursos/Fuentes/PixelRPG.otf",
	"res://Recursos/Fuentes/PixelOperator.ttf",
	"res://Recursos/Fuentes/PixelOperator.otf",
	"res://Recursos/Fuentes/PixelifySans-Regular.ttf",
	"res://Recursos/Fuentes/PressStart2P-Regular.ttf",
	"res://Recursos/Fuentes/Silkscreen-Regular.ttf"
]
const BACKGROUND_HINTS: Array[String] = [
	"background", "fondo", "base", "canvas", "panel_base", "world", "mundo"
]
const CHARACTER_HINTS: Array[String] = [
	"character",
	"personaje",
	"paladin",
	"arquero",
	"arcanista",
	"hero",
	"heroe",
	"portrait",
	"retrato",
	"preview",
	"vista"
]
const MERCHANT_HINTS: Array[String] = ["merchant", "mercader", "elfa", "tendera", "lyria"]
const COMMON_NAME_PARTS: Array[String] = [
	"rect",
	"texture",
	"textura",
	"path",
	"ruta",
	"image",
	"imagen",
	"icon",
	"icono",
	"button",
	"boton",
	"label",
	"etiqueta",
	"visual",
	"control",
	"slot",
	"placeholder"
]
const CONTROL_SUFFIXES: Array[String] = [
	"_label", "_button", "_panel", "_rect", "_control", "_visual", "_container", "_scroll", "_list"
]
const FRIENDLY_WORDS: Dictionary = {
	"inventory": "Inventario",
	"inventario": "Inventario",
	"character": "Personaje",
	"personaje": "Personaje",
	"progress": "Progreso",
	"progreso": "Progreso",
	"title": "Título",
	"titulo": "Título",
	"subtitle": "Subtítulo",
	"subtitulo": "Subtítulo",
	"close": "Cerrar",
	"cerrar": "Cerrar",
	"open": "Abrir",
	"abrir": "Abrir",
	"health": "Vida",
	"hp": "Vida",
	"vida": "Vida",
	"shield": "Escudo",
	"escudo": "Escudo",
	"enemy": "Enemigo",
	"enemigo": "Enemigo",
	"hero": "Héroe",
	"heroe": "Héroe",
	"gold": "Oro",
	"oro": "Oro",
	"level": "Nivel",
	"nivel": "Nivel",
	"phase": "Fase",
	"fase": "Fase",
	"mission": "Misión",
	"missions": "Misiones",
	"mision": "Misión",
	"misiones": "Misiones",
	"equipment": "Equipo",
	"equipo": "Equipo",
	"items": "Objetos",
	"objects": "Objetos",
	"objetos": "Objetos",
	"materials": "Materiales",
	"materiales": "Materiales",
	"stats": "Atributos",
	"attributes": "Atributos",
	"atributos": "Atributos",
	"selected": "Seleccionado",
	"seleccionado": "Seleccionado",
	"current": "Actual",
	"actual": "Actual",
	"available": "Disponible",
	"disponible": "Disponible",
	"points": "Puntos",
	"puntos": "Puntos",
	"bonus": "Bonificación",
	"bonificacion": "Bonificación",
	"reset": "Reiniciar",
	"reiniciar": "Reiniciar",
	"unlock": "Desbloquear",
	"desbloquear": "Desbloquear",
	"shop": "Tienda",
	"tienda": "Tienda",
	"forge": "Forja",
	"forja": "Forja",
	"map": "Mapa",
	"mapa": "Mapa",
	"world": "Mundo",
	"mundo": "Mundo"
}


static func _resolve_path(path: String) -> String:
	if path.begins_with("res://") or path.begins_with("user://"):
		return ProjectSettings.globalize_path(path)
	return path


static func read_text(path: String) -> String:
	var file: FileAccess = FileAccess.open(_resolve_path(path), FileAccess.READ)
	if file == null:
		return ""
	var text: String = file.get_as_text()
	file.close()
	return text


static func write_text(path: String, text: String) -> bool:
	var absolute_path: String = _resolve_path(path)
	var file: FileAccess = FileAccess.open(absolute_path, FileAccess.WRITE)
	if file == null:
		return false
	file.store_string(text)
	file.flush()
	file.close()
	return read_text(path) == text


static func parse_script(path: String) -> Dictionary:
	return parse_source(path, read_text(path))


static func parse_source(path: String, source: String) -> Dictionary:
	if source.is_empty():
		return {
			"path": path,
			"source": source,
			"canvas_size": Vector2(900.0, 240.0),
			"canvas_color": Color(0.008, 0.012, 0.018, 1.0),
			"detected_colors": 0,
			"styled_elements": 0,
			"views": [],
			"default_view": "all",
			"elements": [],
			"images": [],
			"background_path": "",
			"font_path": _detect_project_font()
		}
	var result: Dictionary = {
		"path": path,
		"source": source,
		"canvas_size": _detect_canvas_size(source),
		"canvas_color": Color(0.008, 0.012, 0.018, 1.0),
		"detected_colors": 0,
		"styled_elements": 0,
		"views": [],
		"default_view": "all",
		"elements": [],
		"images": [],
		"background_path": "",
		"font_path": _detect_project_font()
	}
	var elements: Array = []
	var occupied_spans: Dictionary = {}
	_parse_rect_constants(source, elements, occupied_spans)
	_parse_rect_arrays(source, elements, occupied_spans)
	_parse_layout_positions(source, elements, occupied_spans)
	_parse_position_size_pairs(source, elements, occupied_spans)
	_parse_create_calls(source, elements, occupied_spans)
	_enrich_elements_with_text(path, source, elements)
	_add_runtime_preview_elements(path, source, elements)
	var images: Array = _parse_images(source)
	_bind_images_to_elements(source, elements, images)
	var visual_data: Dictionary = VisualAnalyzer.analyze(
		path, source, elements, images, result.get("canvas_size", Vector2(900.0, 240.0))
	)
	elements = visual_data.get("elements", elements)
	var dynamic_data: Dictionary = DynamicAnalyzer.enhance(
		path, source, elements, images, result.get("canvas_size", Vector2(900.0, 240.0))
	)
	elements = dynamic_data.get("elements", elements)
	result["canvas_size"] = dynamic_data.get(
		"canvas_size", result.get("canvas_size", Vector2(900.0, 240.0))
	)
	var blueprint_data: Dictionary = BlueprintAnalyzer.apply(
		path, source, elements, images, result.get("canvas_size", Vector2(900.0, 240.0))
	)
	elements = blueprint_data.get("elements", elements)
	result["canvas_size"] = blueprint_data.get(
		"canvas_size", result.get("canvas_size", Vector2(900.0, 240.0))
	)
	result["canvas_color"] = visual_data.get("canvas_color", Color(0.008, 0.012, 0.018, 1.0))
	result["detected_colors"] = int(visual_data.get("detected_colors", 0))
	var styled_count: int = 0
	for raw_element: Variant in elements:
		if not (raw_element is Dictionary):
			continue
		var element: Dictionary = raw_element
		if (
			element.has("fill_color")
			or element.has("border_color")
			or element.has("shadow_color")
			or not str(element.get("image_path", "")).is_empty()
		):
			styled_count += 1
	result["styled_elements"] = styled_count
	var blueprint_views: Array = blueprint_data.get("views", [])
	result["views"] = (
		blueprint_views if not blueprint_views.is_empty() else dynamic_data.get("views", [])
	)
	var blueprint_default: String = str(blueprint_data.get("default_view", ""))
	result["default_view"] = (
		blueprint_default if not blueprint_default.is_empty() else str(dynamic_data.get("default_view", "all"))
	)
	result["elements"] = elements
	result["images"] = images
	var blueprint_background: String = str(blueprint_data.get("background_path", ""))
	var dynamic_background: String = str(dynamic_data.get("background_path", ""))
	if not blueprint_background.is_empty():
		result["background_path"] = blueprint_background
	elif not dynamic_background.is_empty():
		result["background_path"] = dynamic_background
	else:
		result["background_path"] = _choose_background_path(images)
	return result


static func _detect_project_font() -> String:
	for font_path: String in PROJECT_FONT_CANDIDATES:
		if ResourceLoader.exists(font_path):
			return font_path
	return ""


static func _detect_canvas_size(source: String) -> Vector2:
	var regex: RegEx = RegEx.new()
	(
		regex
		. compile(
			"const\\s+(?:BASE_UI_SIZE|REFERENCE_SIZE)\\s*[^=]*=\\s*Vector2i?\\(\\s*([-+]?\\d+(?:\\.\\d+)?)\\s*,\\s*([-+]?\\d+(?:\\.\\d+)?)\\s*\\)"
		)
	)
	var match: RegExMatch = regex.search(source)
	if match != null:
		return Vector2(float(match.get_string(1)), float(match.get_string(2)))
	return Vector2(900.0, 240.0)


static func _parse_rect_constants(
	source: String, elements: Array, occupied_spans: Dictionary
) -> void:
	var regex: RegEx = RegEx.new()
	(
		regex
		. compile(
			"(?m)^\\s*[\\\"']([^\\\"']+)[\\\"']\\s*:\\s*(Rect2\\(\\s*([-+]?\\d+(?:\\.\\d+)?)\\s*,\\s*([-+]?\\d+(?:\\.\\d+)?)\\s*,\\s*([-+]?\\d+(?:\\.\\d+)?)\\s*,\\s*([-+]?\\d+(?:\\.\\d+)?)\\s*\\))"
		)
	)
	for match: RegExMatch in regex.search_all(source):
		var start_index: int = match.get_start(2)
		var end_index: int = match.get_end(2)
		occupied_spans[start_index] = true
		elements.append(
			{
				"name": match.get_string(1),
				"rect":
				Rect2(
					float(match.get_string(3)),
					float(match.get_string(4)),
					float(match.get_string(5)),
					float(match.get_string(6))
				),
				"kind": "rect2",
				"span_a_start": start_index,
				"span_a_end": end_index,
				"span_b_start": -1,
				"span_b_end": -1,
				"line": _line_at(source, start_index),
				"source_kind": "Rect2",
				"dirty": false,
				"image_path": "",
				"display_text": "",
				"friendly_name": "",
				"font_size": 0,
				"text_expression": ""
			}
		)


static func _parse_rect_arrays(source: String, elements: Array, occupied_spans: Dictionary) -> void:
	var array_regex: RegEx = RegEx.new()
	array_regex.compile(
		"(?ms)(?:const|var)\\s+([A-Za-z_][A-Za-z0-9_]*)\\s*(?::[^=\\n]+)?=\\s*\\[(.*?)\\]"
	)
	var rect_regex: RegEx = RegEx.new()
	(
		rect_regex
		. compile(
			"(Rect2\\(\\s*([-+]?\\d+(?:\\.\\d+)?)\\s*,\\s*([-+]?\\d+(?:\\.\\d+)?)\\s*,\\s*([-+]?\\d+(?:\\.\\d+)?)\\s*,\\s*([-+]?\\d+(?:\\.\\d+)?)\\s*\\))"
		)
	)
	for array_match: RegExMatch in array_regex.search_all(source):
		var array_name: String = array_match.get_string(1)
		var content: String = array_match.get_string(2)
		var content_start: int = array_match.get_start(2)
		var index: int = 0
		for rect_match: RegExMatch in rect_regex.search_all(content):
			var rect_start: int = content_start + rect_match.get_start(1)
			if occupied_spans.has(rect_start):
				continue
			occupied_spans[rect_start] = true
			var friendly: String = _friendly_control_name(array_name)
			if array_name.to_lower().contains("slot") or array_name.to_lower().contains("hueco"):
				friendly = "Hueco %d" % (index + 1)
			elif array_name.to_lower().contains("tab") or array_name.to_lower().contains("pest"):
				friendly = "Pestaña %d" % (index + 1)
			elements.append(
				{
					"name": "%s_%d" % [array_name, index],
					"rect":
					Rect2(
						float(rect_match.get_string(2)),
						float(rect_match.get_string(3)),
						float(rect_match.get_string(4)),
						float(rect_match.get_string(5))
					),
					"kind": "rect2",
					"span_a_start": rect_start,
					"span_a_end": content_start + rect_match.get_end(1),
					"span_b_start": -1,
					"span_b_end": -1,
					"line": _line_at(source, rect_start),
					"source_kind": "Rect2 de array",
					"dirty": false,
					"image_path": "",
					"display_text": friendly,
					"friendly_name": friendly,
					"font_size": 0,
					"text_expression": "",
					"runtime_only": false
				}
			)
			index += 1


static func _parse_layout_positions(
	source: String, elements: Array, occupied_spans: Dictionary
) -> void:
	var dictionary_regex: RegEx = RegEx.new()
	dictionary_regex.compile("\\{([^{}]{0,700})\\}")
	var id_regex: RegEx = RegEx.new()
	id_regex.compile("[\\\"']id[\\\"']\\s*:\\s*[\\\"']([^\\\"']+)[\\\"']")
	var key_regex: RegEx = RegEx.new()
	key_regex.compile("[\\\"'](?:text_key|key)[\\\"']\\s*:\\s*[\\\"']([^\\\"']+)[\\\"']")
	var position_regex: RegEx = RegEx.new()
	(
		position_regex
		. compile(
			"[\\\"']position[\\\"']\\s*:\\s*(Vector2\\(\\s*([-+]?\\d+(?:\\.\\d+)?)\\s*,\\s*([-+]?\\d+(?:\\.\\d+)?)\\s*\\))"
		)
	)
	for dictionary_match: RegExMatch in dictionary_regex.search_all(source):
		var block: String = dictionary_match.get_string(1)
		var id_match: RegExMatch = id_regex.search(block)
		var position_match: RegExMatch = position_regex.search(block)
		if id_match == null or position_match == null:
			continue
		var position_start: int = dictionary_match.get_start(1) + position_match.get_start(1)
		if occupied_spans.has(position_start):
			continue
		occupied_spans[position_start] = true
		var layout_id: String = id_match.get_string(1)
		var key_match: RegExMatch = key_regex.search(block)
		var key: String = key_match.get_string(1) if key_match != null else layout_id
		var sample_value: String = _sample_value_for_name(layout_id)
		var friendly: String = _friendly_control_name(key)
		var visible_text: String = friendly
		if not sample_value.is_empty():
			visible_text += "   " + sample_value
		elements.append(
			{
				"name": "layout_" + layout_id,
				"rect":
				Rect2(
					float(position_match.get_string(2)),
					float(position_match.get_string(3)),
					212.0,
					28.0
				),
				"kind": "position_only",
				"span_a_start": position_start,
				"span_a_end": dictionary_match.get_start(1) + position_match.get_end(1),
				"span_b_start": -1,
				"span_b_end": -1,
				"line": _line_at(source, position_start),
				"source_kind": "posición de diseño",
				"dirty": false,
				"image_path": "",
				"display_text": visible_text,
				"friendly_name": friendly,
				"font_size": 15,
				"text_expression": "",
				"runtime_only": false
			}
		)


static func _parse_position_size_pairs(
	source: String, elements: Array, occupied_spans: Dictionary
) -> void:
	var position_regex: RegEx = RegEx.new()
	(
		position_regex
		. compile(
			"(?m)^\\s*([A-Za-z_][A-Za-z0-9_]*)\\.position\\s*=\\s*(Vector2\\(\\s*([-+]?\\d+(?:\\.\\d+)?)\\s*,\\s*([-+]?\\d+(?:\\.\\d+)?)\\s*\\))"
		)
	)
	var size_regex: RegEx = RegEx.new()
	(
		size_regex
		. compile(
			"(?m)^\\s*([A-Za-z_][A-Za-z0-9_]*)\\.size\\s*=\\s*(Vector2\\(\\s*([-+]?\\d+(?:\\.\\d+)?)\\s*,\\s*([-+]?\\d+(?:\\.\\d+)?)\\s*\\))"
		)
	)
	var positions: Dictionary = {}
	var sizes: Dictionary = {}
	for match: RegExMatch in position_regex.search_all(source):
		positions[match.get_string(1)] = match
	for match: RegExMatch in size_regex.search_all(source):
		sizes[match.get_string(1)] = match
	for variable_name: String in positions.keys():
		if not sizes.has(variable_name):
			continue
		var position_match: RegExMatch = positions[variable_name]
		var size_match: RegExMatch = sizes[variable_name]
		var position_start: int = position_match.get_start(2)
		var size_start: int = size_match.get_start(2)
		if occupied_spans.has(position_start) or occupied_spans.has(size_start):
			continue
		occupied_spans[position_start] = true
		occupied_spans[size_start] = true
		elements.append(
			{
				"name": variable_name,
				"rect":
				Rect2(
					float(position_match.get_string(3)),
					float(position_match.get_string(4)),
					float(size_match.get_string(3)),
					float(size_match.get_string(4))
				),
				"kind": "vector_pair",
				"span_a_start": position_start,
				"span_a_end": position_match.get_end(2),
				"span_b_start": size_start,
				"span_b_end": size_match.get_end(2),
				"line": _line_at(source, mini(position_start, size_start)),
				"source_kind": "position + size",
				"dirty": false,
				"image_path": "",
				"display_text": "",
				"friendly_name": "",
				"font_size": 0,
				"text_expression": ""
			}
		)


static func _parse_create_calls(
	source: String, elements: Array, occupied_spans: Dictionary
) -> void:
	var start_regex: RegEx = RegEx.new()
	(
		start_regex
		. compile(
			"(?m)^\\s*(?:var\\s+)?([A-Za-z_][A-Za-z0-9_]*)(?:\\s*:[^=\\n]+)?\\s*:?=\\s*(_(?:create_label|create_color_rect|color_rect|create_health_bar|create_overlay_button|create_icon_button|create_action_button|create_button|menu_button|label))\\s*\\("
		)
	)
	var vector_regex: RegEx = RegEx.new()
	vector_regex.compile(
		"(Vector2\\(\\s*([-+]?\\d+(?:\\.\\d+)?)\\s*,\\s*([-+]?\\d+(?:\\.\\d+)?)\\s*\\))"
	)
	var rect_regex: RegEx = RegEx.new()
	(
		rect_regex
		. compile(
			"(Rect2\\(\\s*([-+]?\\d+(?:\\.\\d+)?)\\s*,\\s*([-+]?\\d+(?:\\.\\d+)?)\\s*,\\s*([-+]?\\d+(?:\\.\\d+)?)\\s*,\\s*([-+]?\\d+(?:\\.\\d+)?)\\s*\\))"
		)
	)
	for start_match: RegExMatch in start_regex.search_all(source):
		var variable_name: String = start_match.get_string(1)
		var function_name: String = start_match.get_string(2)
		var open_index: int = source.find("(", start_match.get_start(0))
		if open_index < 0:
			continue
		var close_index: int = _balanced_parenthesis_end(source, open_index)
		if close_index < 0:
			continue
		var call_text: String = source.substr(open_index, close_index - open_index + 1)
		var arguments: Array[String] = _split_top_level_arguments(
			call_text.substr(1, call_text.length() - 2)
		)
		var text_expression: String = _text_argument_for_call(function_name, arguments)
		var detected_font_size: int = _font_size_for_call(function_name, arguments)
		var rect_match: RegExMatch = rect_regex.search(call_text)
		if rect_match != null:
			var rect_start: int = open_index + rect_match.get_start(1)
			if occupied_spans.has(rect_start):
				continue
			occupied_spans[rect_start] = true
			elements.append(
				{
					"name": variable_name,
					"rect":
					Rect2(
						float(rect_match.get_string(2)),
						float(rect_match.get_string(3)),
						float(rect_match.get_string(4)),
						float(rect_match.get_string(5))
					),
					"kind": "rect2",
					"span_a_start": rect_start,
					"span_a_end": open_index + rect_match.get_end(1),
					"span_b_start": -1,
					"span_b_end": -1,
					"line": _line_at(source, rect_start),
					"source_kind": "llamada Rect2",
					"dirty": false,
					"image_path": "",
					"display_text": "",
					"friendly_name": "",
					"font_size": detected_font_size,
					"text_expression": text_expression
				}
			)
			continue
		var vector_matches: Array[RegExMatch] = vector_regex.search_all(call_text)
		if vector_matches.size() < 2:
			continue
		var position_match: RegExMatch = vector_matches[0]
		var size_match: RegExMatch = vector_matches[1]
		var position_start: int = open_index + position_match.get_start(1)
		var size_start: int = open_index + size_match.get_start(1)
		if occupied_spans.has(position_start) or occupied_spans.has(size_start):
			continue
		occupied_spans[position_start] = true
		occupied_spans[size_start] = true
		elements.append(
			{
				"name": variable_name,
				"rect":
				Rect2(
					float(position_match.get_string(2)),
					float(position_match.get_string(3)),
					float(size_match.get_string(2)),
					float(size_match.get_string(3))
				),
				"kind": "vector_pair",
				"span_a_start": position_start,
				"span_a_end": open_index + position_match.get_end(1),
				"span_b_start": size_start,
				"span_b_end": open_index + size_match.get_end(1),
				"line": _line_at(source, position_start),
				"source_kind": "llamada Vector2",
				"dirty": false,
				"image_path": "",
				"display_text": "",
				"friendly_name": "",
				"font_size": detected_font_size,
				"text_expression": text_expression
			}
		)


static func _enrich_elements_with_text(path: String, source: String, elements: Array) -> void:
	var translations: Dictionary = _parse_text_dictionary(source)
	var assignments: Dictionary = _parse_text_assignments(source)
	var font_sizes: Dictionary = _parse_font_size_assignments(source)
	for index: int in range(elements.size()):
		var element: Dictionary = elements[index]
		var element_name: String = str(element.get("name", ""))
		var expression: String = str(element.get("text_expression", ""))
		if assignments.has(element_name):
			expression = str(assignments[element_name])
		var resolved: String = _resolve_text_expression(expression, translations)
		var friendly: String = _friendly_control_name(element_name)
		resolved = _runtime_sample_text(path, element_name, resolved, expression, translations)
		if resolved.is_empty():
			resolved = friendly
		if font_sizes.has(element_name):
			element["font_size"] = int(font_sizes[element_name])
		element["friendly_name"] = friendly
		element["display_text"] = resolved
		element["text_expression"] = expression
		elements[index] = element


static func _runtime_sample_text(
	path: String,
	element_name: String,
	resolved: String,
	expression: String,
	translations: Dictionary
) -> String:
	var normalized_name: String = element_name.to_lower()
	var file_name: String = path.get_file().get_basename().to_lower()
	if normalized_name.contains("gold") or normalized_name.contains("oro"):
		return str(_saved_gold())
	if normalized_name.contains("capacity") or normalized_name.contains("capacidad"):
		return "%d / 40" % _saved_inventory_count()
	if normalized_name.contains("progress_label") and file_name.contains("forja"):
		return "%d / 10 OBJETOS" % _saved_forge_count()
	if normalized_name.contains("status_label") and file_name.contains("forja"):
		return "Necesitas 10 objetos de la misma rareza."
	if normalized_name.contains("level_progress") or normalized_name.contains("character_progress"):
		return _saved_level_progress()
	if normalized_name.contains("points") and resolved.contains("0"):
		return resolved.replace("0", "5")
	if normalized_name.contains("potion") and resolved.contains("0"):
		return resolved.replace("0 / 0", "3 / 24")
	if resolved == "0" and normalized_name.contains("value"):
		return "278"
	if resolved.is_empty() and not expression.is_empty():
		var strings: Array[String] = _extract_string_literals(expression)
		if not strings.is_empty():
			return _preview_format_text(str(strings[0]))
	return _contextual_format_text(resolved, expression, translations)


static func _contextual_format_text(
	value: String, expression: String, _translations: Dictionary
) -> String:
	var result: String = value
	var lower: String = (value + " " + expression).to_lower()
	if result.is_empty():
		return result
	if lower.contains("objetos") or lower.contains("items"):
		if result.contains("0 / 0"):
			result = result.replace("0 / 0", "0 / 10")
		elif result.contains("0"):
			result = result.replace("0", "10")
	if lower.contains("nivel") or lower.contains("level"):
		result = result.replace("0", "10")
	if lower.contains("oro") or lower.contains("gold"):
		result = result.replace("0", "1613")
	return result


static func _sample_value_for_name(value: String) -> String:
	match value.to_lower():
		"vida", "health", "hp":
			return str(_config_value("user://partida.cfg", "jugador", "vida_maxima", 278))
		"daño", "dano", "damage":
			return str(_config_value("user://partida.cfg", "jugador", "daño", 29))
		"def", "defense", "defensa":
			return str(_config_value("user://partida.cfg", "jugador", "defensa", 29))
		"vel", "speed", "velocidad":
			return str(_config_value("user://partida.cfg", "jugador", "velocidad", 23))
		"magia", "magic":
			return str(_config_value("user://partida.cfg", "jugador", "magia", 14))
		_:
			return ""


static func _add_runtime_preview_elements(path: String, source: String, elements: Array) -> void:
	var file_name: String = path.get_file().get_basename().to_lower()
	if file_name.contains("inventario"):
		_add_inventory_runtime_preview(source, elements)
	elif file_name.contains("forja"):
		_add_forge_runtime_preview(elements)


static func _add_inventory_runtime_preview(source: String, elements: Array) -> void:
	var existing_names: Dictionary = {}
	for raw_element: Variant in elements:
		if raw_element is Dictionary:
			existing_names[str((raw_element as Dictionary).get("name", ""))] = true
	if not existing_names.has("runtime_level_progress"):
		elements.append(
			_runtime_element(
				"runtime_level_progress",
				Rect2(218.0, 882.0, 300.0, 28.0),
				_saved_level_progress(),
				14,
				"Estado de partida"
			)
		)
	var grid_values: Dictionary = _parse_grid_constants(source)
	if not grid_values.is_empty():
		var columns: int = int(grid_values.get("columns", 0))
		var rows: int = int(grid_values.get("rows", 0))
		var origin: Vector2 = grid_values.get("origin", Vector2.ZERO)
		var slot_size: Vector2 = grid_values.get("slot_size", Vector2.ZERO)
		var gap: Vector2 = grid_values.get("gap", Vector2.ZERO)
		for row: int in range(rows):
			for column: int in range(columns):
				var index: int = row * columns + column
				var rect: Rect2 = Rect2(
					(
						origin
						+ Vector2(
							float(column) * (slot_size.x + gap.x),
							float(row) * (slot_size.y + gap.y)
						)
					),
					slot_size
				)
				elements.append(
					_runtime_element(
						"runtime_inventory_slot_%d" % index, rect, "", 0, "Casilla generada"
					)
				)


static func _add_forge_runtime_preview(elements: Array) -> void:
	var names: Dictionary = {}
	for raw_element: Variant in elements:
		if raw_element is Dictionary:
			names[str((raw_element as Dictionary).get("name", ""))] = true
	if not names.has("progress_label"):
		elements.append(
			_runtime_element(
				"runtime_forge_progress",
				Rect2(690.0, 681.0, 750.0, 28.0),
				"%d / 10 OBJETOS" % _saved_forge_count(),
				17,
				"Estado de partida"
			)
		)
	if not names.has("status_label"):
		elements.append(
			_runtime_element(
				"runtime_forge_status",
				Rect2(675.0, 710.0, 780.0, 42.0),
				"Necesitas 10 objetos de la misma rareza.",
				14,
				"Estado simulado"
			)
		)


static func _runtime_element(
	name: String, rect: Rect2, text: String, font_size: int, source_kind: String
) -> Dictionary:
	return {
		"name": name,
		"rect": rect,
		"kind": "runtime",
		"span_a_start": -1,
		"span_a_end": -1,
		"span_b_start": -1,
		"span_b_end": -1,
		"line": 0,
		"source_kind": source_kind,
		"dirty": false,
		"image_path": "",
		"display_text": text,
		"friendly_name": text if not text.is_empty() else _friendly_control_name(name),
		"font_size": font_size,
		"text_expression": "",
		"runtime_only": true
	}


static func _config_value(path: String, section: String, key: String, fallback: Variant) -> Variant:
	var config: ConfigFile = ConfigFile.new()
	if config.load(path) != OK:
		return fallback
	return config.get_value(section, key, fallback)


static func _saved_gold() -> int:
	var inventory_gold: Variant = _config_value("user://inventario.cfg", "inventario", "oro", -1)
	if int(inventory_gold) >= 0:
		return int(inventory_gold)
	return int(_config_value("user://partida.cfg", "jugador", "oro", 1613))


static func _saved_inventory_count() -> int:
	var raw_items: Variant = _config_value("user://inventario.cfg", "inventario", "items", [])
	return (raw_items as Array).size() if raw_items is Array else 0


static func _saved_forge_count() -> int:
	var raw_items: Variant = _config_value("user://forja.cfg", "forja", "items", [])
	if not (raw_items is Array):
		return 0
	var count: int = 0
	for item: Variant in raw_items as Array:
		if item is Dictionary and not (item as Dictionary).is_empty():
			count += 1
	return count


static func _saved_level_progress() -> String:
	var level: int = int(_config_value("user://partida.cfg", "jugador", "nivel", 10))
	var xp: int = int(_config_value("user://partida.cfg", "jugador", "experiencia", 296))
	var required: int = int(
		_config_value("user://partida.cfg", "jugador", "experiencia_necesaria", 448)
	)
	return "NIVEL %d · EXP %d / %d" % [level, xp, required]


static func _parse_grid_constants(source: String) -> Dictionary:
	var result: Dictionary = {}
	var int_regex: RegEx = RegEx.new()
	int_regex.compile("const\\s+(GRID_COLUMNS|GRID_ROWS)\\s*[^=]*=\\s*(\\d+)")
	for match: RegExMatch in int_regex.search_all(source):
		result["columns" if match.get_string(1) == "GRID_COLUMNS" else "rows"] = int(
			match.get_string(2)
		)
	var vector_regex: RegEx = RegEx.new()
	(
		vector_regex
		. compile(
			"const\\s+(GRID_ORIGIN|GRID_SLOT_SIZE|GRID_GAP)\\s*[^=]*=\\s*Vector2\\(\\s*([-+]?\\d+(?:\\.\\d+)?)\\s*,\\s*([-+]?\\d+(?:\\.\\d+)?)\\s*\\)"
		)
	)
	for match: RegExMatch in vector_regex.search_all(source):
		var key: String = "origin"
		if match.get_string(1) == "GRID_SLOT_SIZE":
			key = "slot_size"
		elif match.get_string(1) == "GRID_GAP":
			key = "gap"
		result[key] = Vector2(float(match.get_string(2)), float(match.get_string(3)))
	if (
		not result.has("columns")
		or not result.has("rows")
		or not result.has("origin")
		or not result.has("slot_size")
		or not result.has("gap")
	):
		return {}
	return result


static func _parse_text_dictionary(source: String) -> Dictionary:
	var result: Dictionary = {}
	var regex: RegEx = RegEx.new()
	regex.compile("[\\\"']([^\\\"']+)[\\\"']\\s*:\\s*[\\\"']((?:\\\\.|[^\\\"'])*)[\\\"']")
	for match: RegExMatch in regex.search_all(source):
		var key: String = match.get_string(1)
		var value: String = _unescape_string(match.get_string(2))
		if value.begins_with("res://") or value.begins_with("user://"):
			continue
		if value.length() > 260:
			continue
		if not result.has(key):
			result[key] = value
	return result


static func _parse_text_assignments(source: String) -> Dictionary:
	var result: Dictionary = {}
	var regex: RegEx = RegEx.new()
	regex.compile("(?m)^\\s*([A-Za-z_][A-Za-z0-9_]*)\\.text\\s*=\\s*(.+)$")
	for match: RegExMatch in regex.search_all(source):
		result[match.get_string(1)] = match.get_string(2).strip_edges()
	return result


static func _parse_font_size_assignments(source: String) -> Dictionary:
	var result: Dictionary = {}
	var regex: RegEx = RegEx.new()
	(
		regex
		. compile(
			"(?m)^\\s*([A-Za-z_][A-Za-z0-9_]*)\\.add_theme_font_size_override\\(\\s*[\\\"']font_size[\\\"']\\s*,\\s*(\\d+)\\s*\\)"
		)
	)
	for match: RegExMatch in regex.search_all(source):
		result[match.get_string(1)] = int(match.get_string(2))
	return result


static func _resolve_text_expression(expression: String, translations: Dictionary) -> String:
	var clean: String = expression.strip_edges()
	if clean.is_empty():
		return ""
	var translation_regex: RegEx = RegEx.new()
	translation_regex.compile("(?:_text|_inv_text|_t|tr)\\(\\s*[\\\"']([^\\\"']+)[\\\"']\\s*\\)")
	var translation_match: RegExMatch = translation_regex.search(clean)
	if translation_match != null:
		var key: String = translation_match.get_string(1)
		if translations.has(key):
			return _preview_format_text(str(translations[key]))
		return _friendly_control_name(key)
	var strings: Array[String] = _extract_string_literals(clean)
	if not strings.is_empty():
		for candidate: String in strings:
			if (
				not candidate.is_empty()
				and not candidate.begins_with("res://")
				and candidate != "font_size"
			):
				return _preview_format_text(candidate)
	return ""


static func _extract_string_literals(expression: String) -> Array[String]:
	var result: Array[String] = []
	var regex: RegEx = RegEx.new()
	regex.compile("[\\\"']((?:\\\\.|[^\\\"'])*)[\\\"']")
	for match: RegExMatch in regex.search_all(expression):
		result.append(_unescape_string(match.get_string(1)))
	return result


static func _preview_format_text(value: String) -> String:
	var result: String = value.replace("\\n", " ").replace("\n", " ").strip_edges()
	var format_regex: RegEx = RegEx.new()
	format_regex.compile("%(?:\\d+\\$)?[dfs]")
	result = format_regex.sub(result, "0", true)
	while result.contains("  "):
		result = result.replace("  ", " ")
	return result


static func _unescape_string(value: String) -> String:
	return value.replace("\\n", "\n").replace("\\t", " ").replace('\\"', '"').replace("\\'", "'")


static func _friendly_control_name(value: String) -> String:
	var clean: String = value.to_lower().strip_edges()
	for suffix: String in CONTROL_SUFFIXES:
		if clean.ends_with(suffix):
			clean = clean.trim_suffix(suffix)
	clean = clean.replace("__", "_")
	var words: PackedStringArray = clean.split("_", false)
	var friendly_words: Array[String] = []
	for word: String in words:
		if word.is_empty():
			continue
		friendly_words.append(str(FRIENDLY_WORDS.get(word, word.capitalize())))
	return " ".join(friendly_words) if not friendly_words.is_empty() else "Elemento visual"


static func _split_top_level_arguments(value: String) -> Array[String]:
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


static func _text_argument_for_call(function_name: String, arguments: Array[String]) -> String:
	match function_name:
		"_create_label", "_label", "_create_icon_button", "_create_button":
			return arguments[1] if arguments.size() > 1 else ""
		"_create_overlay_button", "_create_action_button":
			return arguments[0] if not arguments.is_empty() else ""
		_:
			return ""


static func _font_size_for_call(function_name: String, arguments: Array[String]) -> int:
	var index: int = -1
	match function_name:
		"_create_label", "_label", "_create_icon_button", "_create_button":
			index = 4
		"_create_action_button":
			return 18
		_:
			return 0
	if index < 0 or index >= arguments.size():
		return 0
	var value: String = arguments[index].strip_edges()
	return int(value) if value.is_valid_int() else 0


static func _parse_images(source: String) -> Array:
	var images: Array = []
	var seen: Dictionary = {}
	var named_regex: RegEx = RegEx.new()
	(
		named_regex
		. compile(
			"(?ms)^\\s*(?:@export_file\\([^\\n]*\\)\\s*)?(?:const\\s+|var\\s+)?([A-Za-z_][A-Za-z0-9_]*)\\s*(?::[^=\\n]+)?=\\s*\\(?(?:\\s|\\n)*[\\\"'](res://[^\\\"']+\\.(?:png|jpg|jpeg|webp|svg))[\\\"']"
		)
	)
	for match: RegExMatch in named_regex.search_all(source):
		_add_image(
			images,
			seen,
			match.get_string(1),
			match.get_string(2),
			"variable",
			_line_at(source, match.get_start(2))
		)
	var dictionary_regex: RegEx = RegEx.new()
	(
		dictionary_regex
		. compile(
			"[\\\"']([^\\\"']+)[\\\"']\\s*:\\s*[\\\"'](res://[^\\\"']+\\.(?:png|jpg|jpeg|webp|svg))[\\\"']"
		)
	)
	for match: RegExMatch in dictionary_regex.search_all(source):
		_add_image(
			images,
			seen,
			match.get_string(1),
			match.get_string(2),
			"dictionary",
			_line_at(source, match.get_start(2))
		)
	var direct_regex: RegEx = RegEx.new()
	direct_regex.compile("[\\\"'](res://[^\\\"']+\\.(?:png|jpg|jpeg|webp|svg))[\\\"']")
	for match: RegExMatch in direct_regex.search_all(source):
		var path: String = match.get_string(1)
		_add_image(
			images,
			seen,
			path.get_file().get_basename(),
			path,
			"path",
			_line_at(source, match.get_start(1))
		)
	images.sort_custom(
		func(a: Dictionary, b: Dictionary) -> bool:
			var a_background: bool = bool(a.get("is_background", false))
			var b_background: bool = bool(b.get("is_background", false))
			if a_background != b_background:
				return a_background
			return str(a.get("name", "")) < str(b.get("name", ""))
	)
	return images


static func _add_image(
	images: Array,
	seen: Dictionary,
	image_name: String,
	path: String,
	source_kind: String,
	line: int
) -> void:
	if path.is_empty() or seen.has(path):
		return
	seen[path] = true
	var normalized_name: String = _normalize_name(image_name + "_" + path.get_file().get_basename())
	images.append(
		{
			"name": image_name,
			"path": path,
			"source_kind": source_kind,
			"line": line,
			"is_background": _contains_any(normalized_name, BACKGROUND_HINTS),
			"bound_control": ""
		}
	)


static func _bind_images_to_elements(source: String, elements: Array, images: Array) -> void:
	var path_by_name: Dictionary = {}
	for raw_image: Variant in images:
		if not (raw_image is Dictionary):
			continue
		var image: Dictionary = raw_image
		path_by_name[str(image.get("name", ""))] = str(image.get("path", ""))
	var direct_bindings: Dictionary = _parse_direct_image_bindings(source, path_by_name)
	for raw_image: Variant in images:
		if not (raw_image is Dictionary):
			continue
		var image: Dictionary = raw_image
		var image_path: String = str(image.get("path", ""))
		for control_name: String in direct_bindings.keys():
			if str(direct_bindings[control_name]) == image_path:
				image["bound_control"] = control_name
	for index: int in range(elements.size()):
		var element: Dictionary = elements[index]
		var element_name: String = str(element.get("name", ""))
		if direct_bindings.has(element_name):
			element["image_path"] = str(direct_bindings[element_name])
			elements[index] = element
			continue
		var best_path: String = _best_image_for_element(element_name, images)
		if not best_path.is_empty():
			element["image_path"] = best_path
			elements[index] = element


static func _parse_direct_image_bindings(source: String, path_by_name: Dictionary) -> Dictionary:
	var result: Dictionary = {}
	var aliases: Dictionary = path_by_name.duplicate()
	var resolver_regex: RegEx = RegEx.new()
	(
		resolver_regex
		. compile(
			"(?ms)^\\s*(?:var\\s+)?([A-Za-z_][A-Za-z0-9_]*)\\s*(?::[^=\\n]+)?\\s*:?=\\s*_resolve_resource_path\\(\\s*([A-Za-z_][A-Za-z0-9_]*)"
		)
	)
	for resolver_match: RegExMatch in resolver_regex.search_all(source):
		var alias_name: String = resolver_match.get_string(1)
		var source_name: String = resolver_match.get_string(2)
		if aliases.has(source_name):
			aliases[alias_name] = aliases[source_name]
	var direct_regex: RegEx = RegEx.new()
	(
		direct_regex
		. compile(
			"(?m)^\\s*([A-Za-z_][A-Za-z0-9_]*)\\.(?:texture|icon)\\s*=\\s*(?:load|preload)?\\s*\\(?\\s*(?:[\"'](res://[^\"']+\\.(?:png|jpg|jpeg|webp|svg))[\"']|([A-Za-z_][A-Za-z0-9_]*))"
		)
	)
	for match: RegExMatch in direct_regex.search_all(source):
		var control_name: String = match.get_string(1)
		var direct_path: String = match.get_string(2)
		var resource_name: String = match.get_string(3)
		if not direct_path.is_empty():
			result[control_name] = direct_path
		elif aliases.has(resource_name):
			result[control_name] = str(aliases[resource_name])
	return result


static func _best_image_for_element(element_name: String, images: Array) -> String:
	var normalized_element: String = _normalize_name(element_name)
	if normalized_element.is_empty():
		return ""
	var best_score: int = 0
	var best_path: String = ""
	for raw_image: Variant in images:
		if not (raw_image is Dictionary):
			continue
		var image: Dictionary = raw_image
		var image_name: String = _normalize_name(
			str(image.get("name", "")) + "_" + str(image.get("path", "")).get_file().get_basename()
		)
		var score: int = _name_match_score(normalized_element, image_name)
		var bound_control: String = _normalize_name(str(image.get("bound_control", "")))
		if not bound_control.is_empty() and bound_control == normalized_element:
			score += 1000
		var element_is_background: bool = _contains_any(normalized_element, BACKGROUND_HINTS)
		var image_is_background: bool = bool(image.get("is_background", false))
		if element_is_background and image_is_background:
			score += 450
		elif image_is_background and not element_is_background:
			score -= 120
		if (
			_contains_any(normalized_element, CHARACTER_HINTS)
			and _contains_any(image_name, CHARACTER_HINTS)
		):
			score += 300
		if (
			_contains_any(normalized_element, MERCHANT_HINTS)
			and _contains_any(image_name, MERCHANT_HINTS)
		):
			score += 300
		if score > best_score:
			best_score = score
			best_path = str(image.get("path", ""))
	return best_path if best_score >= 90 else ""


static func _choose_background_path(images: Array) -> String:
	var best_score: int = 0
	var best_path: String = ""
	for raw_image: Variant in images:
		if not (raw_image is Dictionary):
			continue
		var image: Dictionary = raw_image
		var normalized: String = _normalize_name(
			str(image.get("name", "")) + "_" + str(image.get("path", ""))
		)
		var score: int = 0
		if bool(image.get("is_background", false)):
			score += 100
		if normalized.contains("background") or normalized.contains("fondo"):
			score += 120
		if normalized.contains("base"):
			score += 55
		if normalized.contains("icon") or normalized.contains("slot"):
			score -= 100
		if score > best_score:
			best_score = score
			best_path = str(image.get("path", ""))
	return best_path if best_score >= 80 else ""


static func _name_match_score(a: String, b: String) -> int:
	if a.is_empty() or b.is_empty():
		return 0
	if a == b:
		return 500
	var score: int = 0
	if a.contains(b) or b.contains(a):
		score += 220
	var a_tokens: PackedStringArray = a.split("_", false)
	var b_tokens: PackedStringArray = b.split("_", false)
	for token: String in a_tokens:
		if token.length() < 3 or COMMON_NAME_PARTS.has(token):
			continue
		if b_tokens.has(token):
			score += 55
		elif b.contains(token):
			score += 28
	return score


static func _normalize_name(value: String) -> String:
	var result: String = value.to_lower().strip_edges()
	for character: String in [" ", "-", ".", "/", "\\", ":"]:
		result = result.replace(character, "_")
	while result.contains("__"):
		result = result.replace("__", "_")
	return result.trim_prefix("_").trim_suffix("_")


static func _contains_any(value: String, hints: Array[String]) -> bool:
	for hint: String in hints:
		if value.contains(hint):
			return true
	return false


static func _balanced_parenthesis_end(source: String, open_index: int) -> int:
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
		if character == "(":
			depth += 1
		elif character == ")":
			depth -= 1
			if depth == 0:
				return index
	return -1


static func _line_at(source: String, index: int) -> int:
	return source.substr(0, clampi(index, 0, source.length())).count("\n") + 1


static func format_number(value: float) -> String:
	if is_equal_approx(value, round(value)):
		return str(int(round(value)))
	return ("%.2f" % value).trim_suffix("0").trim_suffix("0").trim_suffix(".")


static func build_replacements(source: String, elements: Array) -> Array:
	var replacements: Array = []
	for raw_element: Variant in elements:
		if not (raw_element is Dictionary):
			continue
		var original_element: Dictionary = raw_element
		if not bool(original_element.get("dirty", false)):
			continue

		var element: Dictionary = original_element.duplicate(true)
		if not _element_has_writable_source(element):
			var resolved_source: Dictionary = _resolve_element_source(source, element)
			for key: Variant in resolved_source.keys():
				element[key] = resolved_source[key]

		# Los elementos PLAY pueden guardarse siempre que hayan podido vincularse
		# con una posición real del script. Los elementos puramente decorativos
		# continúan ignorándose para no escribir coordenadas inventadas.
		if not _element_has_writable_source(element):
			continue

		var rect: Rect2 = element.get("rect", Rect2())
		var save_offset: Vector2 = element.get("save_offset", Vector2.ZERO)
		if save_offset != Vector2.ZERO:
			rect.position -= save_offset
		var element_kind: String = str(element.get("kind", ""))
		if element_kind == "scalar_position":
			replacements.append(
				{
					"start": int(element.get("span_x_start", -1)),
					"end": int(element.get("span_x_end", -1)),
					"text": format_number(rect.position.x)
				}
			)
			replacements.append(
				{
					"start": int(element.get("span_y_start", -1)),
					"end": int(element.get("span_y_end", -1)),
					"text": format_number(rect.position.y)
				}
			)
		elif element_kind == "rect2":
			replacements.append(
				{
					"start": int(element.get("span_a_start", -1)),
					"end": int(element.get("span_a_end", -1)),
					"text":
					(
						"Rect2(%s, %s, %s, %s)"
						% [
							format_number(rect.position.x),
							format_number(rect.position.y),
							format_number(rect.size.x),
							format_number(rect.size.y)
						]
					)
				}
			)
		else:
			replacements.append(
				{
					"start": int(element.get("span_a_start", -1)),
					"end": int(element.get("span_a_end", -1)),
					"text":
					(
						"Vector2(%s, %s)"
						% [format_number(rect.position.x), format_number(rect.position.y)]
					)
				}
			)
			if element_kind != "position_only":
				replacements.append(
					{
						"start": int(element.get("span_b_start", -1)),
						"end": int(element.get("span_b_end", -1)),
						"text":
						"Vector2(%s, %s)" % [format_number(rect.size.x), format_number(rect.size.y)]
					}
				)
	var unique_replacements: Dictionary = {}
	for raw_replacement: Variant in replacements:
		if not (raw_replacement is Dictionary):
			continue
		var replacement: Dictionary = raw_replacement
		var start_index: int = int(replacement.get("start", -1))
		var end_index: int = int(replacement.get("end", -1))
		if start_index < 0 or end_index <= start_index:
			continue
		unique_replacements["%d:%d" % [start_index, end_index]] = replacement
	replacements = unique_replacements.values()
	replacements.sort_custom(
		func(a: Dictionary, b: Dictionary) -> bool:
			return int(a.get("start", 0)) > int(b.get("start", 0))
	)
	return replacements


static func _element_has_writable_source(element: Dictionary) -> bool:
	var kind: String = str(element.get("kind", ""))
	if kind == "scalar_position":
		return (
			int(element.get("span_x_start", -1)) >= 0
			and int(element.get("span_x_end", -1)) > int(element.get("span_x_start", -1))
			and int(element.get("span_y_start", -1)) >= 0
			and int(element.get("span_y_end", -1)) > int(element.get("span_y_start", -1))
		)
	var position_valid: bool = (
		int(element.get("span_a_start", -1)) >= 0
		and int(element.get("span_a_end", -1)) > int(element.get("span_a_start", -1))
	)
	if not position_valid:
		return false
	if kind in ["position_only", "rect2"]:
		return true
	return (
		int(element.get("span_b_start", -1)) >= 0
		and int(element.get("span_b_end", -1)) > int(element.get("span_b_start", -1))
	)


static func _resolve_element_source(source: String, element: Dictionary) -> Dictionary:
	var candidate_names: Array[String] = []
	var explicit_name: String = str(element.get("source_variable", "")).strip_edges()
	if not explicit_name.is_empty():
		candidate_names.append(explicit_name)
	var element_name: String = str(element.get("name", "")).strip_edges()
	if not element_name.is_empty() and not candidate_names.has(element_name):
		candidate_names.append(element_name)
	var source_alias: String = str(element.get("source_alias", "")).strip_edges()
	if not source_alias.is_empty() and not candidate_names.has(source_alias):
		candidate_names.append(source_alias)

	for variable_name: String in candidate_names:
		var property_data: Dictionary = _property_rect_source_data(source, variable_name)
		if not property_data.is_empty():
			return property_data
		var call_data: Dictionary = _assigned_call_source_data(source, variable_name)
		if not call_data.is_empty():
			return call_data

	# Segunda pasada: algunos planos PLAY usan un nombre visual distinto al de la
	# variable real. En ese caso se compara la geometría original del elemento
	# con todos los controles creados en el script. Así se pueden enlazar formas
	# como `var boton := _create_button(...)`, asignaciones tipadas, propiedades
	# `.position/.size` y helpers personalizados sin depender del nombre exacto.
	var geometry_data: Dictionary = _resolve_source_by_geometry(source, element, candidate_names)
	if not geometry_data.is_empty():
		return geometry_data
	return {}


static func _resolve_source_by_geometry(
	source: String, element: Dictionary, candidate_names: Array[String]
) -> Dictionary:
	var candidates: Array = _collect_writable_control_sources(source)
	if candidates.is_empty():
		return {}

	var original_rect: Rect2 = element.get("local_rect", element.get("rect", Rect2()))
	var save_offset: Vector2 = element.get("save_offset", Vector2.ZERO)
	if save_offset != Vector2.ZERO:
		original_rect.position -= save_offset

	var best: Dictionary = {}
	var best_score: float = INF
	for raw_candidate: Variant in candidates:
		if not (raw_candidate is Dictionary):
			continue
		var candidate: Dictionary = raw_candidate
		var candidate_rect: Rect2 = candidate.get("source_rect", Rect2())
		var position_distance: float = original_rect.position.distance_to(candidate_rect.position)
		var size_distance: float = original_rect.size.distance_to(candidate_rect.size)
		var name_bonus: float = _source_name_bonus(
			str(candidate.get("source_variable", "")), candidate_names
		)
		var score: float = position_distance + size_distance * 0.65 - name_bonus

		# Con nombre coincidente permitimos pequeñas diferencias de geometría.
		# Sin coincidencia de nombre exigimos una geometría prácticamente exacta
		# para evitar enlazar el elemento con otro botón cercano.
		var acceptable: bool = false
		if name_bonus >= 100.0:
			acceptable = position_distance <= 96.0 and size_distance <= 96.0
		elif name_bonus > 0.0:
			acceptable = position_distance <= 32.0 and size_distance <= 32.0
		else:
			acceptable = position_distance <= 2.5 and size_distance <= 2.5
		if acceptable and score < best_score:
			best_score = score
			best = candidate

	if best.is_empty():
		return {}
	best.erase("source_rect")
	best.erase("source_variable")
	return best


static func _collect_writable_control_sources(source: String) -> Array:
	var result: Array = []
	var seen: Dictionary = {}
	var number: String = "[-+]?\\d+(?:\\.\\d+)?"
	var vector_regex: RegEx = RegEx.new()
	vector_regex.compile(
		"Vector2i?\\(\\s*(" + number + ")\\s*,\\s*(" + number + ")\\s*\\)"
	)

	# 1) Controles creados mediante cualquier helper asignado a una variable:
	#    label = _create_label(...), var button: Button = _menu_button(...), etc.
	var assignment_regex: RegEx = RegEx.new()
	assignment_regex.compile(
		"(?m)^\\s*(?:var\\s+)?([A-Za-z_][A-Za-z0-9_]*)"
		+ "(?:\\s*:[^:=\\n]+)?\\s*(?::=|=)\\s*"
		+ "_[A-Za-z_][A-Za-z0-9_]*\\s*\\("
	)
	for assignment: RegExMatch in assignment_regex.search_all(source):
		var variable_name: String = assignment.get_string(1)
		var opening_parenthesis: int = assignment.get_end(0) - 1
		var closing_parenthesis: int = _find_matching_parenthesis(source, opening_parenthesis)
		if closing_parenthesis <= opening_parenthesis:
			continue
		var call_text: String = source.substr(
			opening_parenthesis, closing_parenthesis - opening_parenthesis + 1
		)
		var vector_matches: Array[RegExMatch] = vector_regex.search_all(call_text)
		if vector_matches.is_empty():
			continue
		var position_match: RegExMatch = vector_matches[0]
		var position: Vector2 = Vector2(
			float(position_match.get_string(1)), float(position_match.get_string(2))
		)
		var size: Vector2 = Vector2.ZERO
		var data: Dictionary = {
			"kind": "position_only",
			"span_a_start": opening_parenthesis + position_match.get_start(0),
			"span_a_end": opening_parenthesis + position_match.get_end(0),
			"source_rect": Rect2(position, size),
			"source_variable": variable_name
		}
		if vector_matches.size() >= 2:
			var size_match: RegExMatch = vector_matches[1]
			size = Vector2(float(size_match.get_string(1)), float(size_match.get_string(2)))
			data["kind"] = "position_size"
			data["span_b_start"] = opening_parenthesis + size_match.get_start(0)
			data["span_b_end"] = opening_parenthesis + size_match.get_end(0)
			data["source_rect"] = Rect2(position, size)
		var key: String = "%d:%d" % [int(data["span_a_start"]), int(data["span_a_end"])]
		if not seen.has(key):
			seen[key] = true
			result.append(data)

	# 2) Controles construidos con `.new()` y colocados después mediante
	#    `control.position = Vector2(...)` y `control.size = Vector2(...)`.
	var property_regex: RegEx = RegEx.new()
	property_regex.compile(
		"(?m)^\\s*([A-Za-z_][A-Za-z0-9_]*)\\.position\\s*=\\s*"
		+ "(Vector2i?\\(\\s*(" + number + ")\\s*,\\s*(" + number + ")\\s*\\))"
	)
	for position_match: RegExMatch in property_regex.search_all(source):
		var variable_name: String = position_match.get_string(1)
		var size_data: Dictionary = _property_vector_source_data(source, variable_name, "size")
		var position: Vector2 = Vector2(
			float(position_match.get_string(3)), float(position_match.get_string(4))
		)
		var size: Vector2 = Vector2.ZERO
		var data: Dictionary = {
			"kind": "position_only",
			"span_a_start": position_match.get_start(2),
			"span_a_end": position_match.get_end(2),
			"source_rect": Rect2(position, size),
			"source_variable": variable_name
		}
		if not size_data.is_empty():
			var size_text: String = source.substr(
				int(size_data.get("start", -1)),
				int(size_data.get("end", -1)) - int(size_data.get("start", -1))
			)
			var parsed_size: RegExMatch = vector_regex.search(size_text)
			if parsed_size != null:
				size = Vector2(
					float(parsed_size.get_string(1)), float(parsed_size.get_string(2))
				)
			data["kind"] = "position_size"
			data["span_b_start"] = int(size_data.get("start", -1))
			data["span_b_end"] = int(size_data.get("end", -1))
			data["source_rect"] = Rect2(position, size)
		var key: String = "%d:%d" % [int(data["span_a_start"]), int(data["span_a_end"])]
		if not seen.has(key):
			seen[key] = true
			result.append(data)

	# 3) Variantes mediante métodos: control.set_position(Vector2(...)) y
	#    control.set_size(Vector2(...)). Son comunes en interfaces construidas
	#    por código y antes no podían guardarse desde la Vista PLAY.
	var method_regex: RegEx = RegEx.new()
	method_regex.compile(
		"(?m)^\\s*([A-Za-z_][A-Za-z0-9_]*)\\.set_position\\(\\s*"
		+ "(Vector2i?\\(\\s*(" + number + ")\\s*,\\s*(" + number + ")\\s*\\))\\s*\\)"
	)
	for method_match: RegExMatch in method_regex.search_all(source):
		var method_variable_name: String = method_match.get_string(1)
		var method_size_data: Dictionary = _method_vector_source_data(
			source, method_variable_name, "set_size"
		)
		var method_position: Vector2 = Vector2(
			float(method_match.get_string(3)), float(method_match.get_string(4))
		)
		var method_size: Vector2 = Vector2.ZERO
		var method_data: Dictionary = {
			"kind": "position_only",
			"span_a_start": method_match.get_start(2),
			"span_a_end": method_match.get_end(2),
			"source_rect": Rect2(method_position, method_size),
			"source_variable": method_variable_name
		}
		if not method_size_data.is_empty():
			var method_size_text: String = source.substr(
				int(method_size_data.get("start", -1)),
				int(method_size_data.get("end", -1)) - int(method_size_data.get("start", -1))
			)
			var parsed_method_size: RegExMatch = vector_regex.search(method_size_text)
			if parsed_method_size != null:
				method_size = Vector2(
					float(parsed_method_size.get_string(1)),
					float(parsed_method_size.get_string(2))
				)
			method_data["kind"] = "position_size"
			method_data["span_b_start"] = int(method_size_data.get("start", -1))
			method_data["span_b_end"] = int(method_size_data.get("end", -1))
			method_data["source_rect"] = Rect2(method_position, method_size)
		var method_key: String = "%d:%d" % [
			int(method_data["span_a_start"]), int(method_data["span_a_end"])
		]
		if not seen.has(method_key):
			seen[method_key] = true
			result.append(method_data)
	return result


static func _method_vector_source_data(
	source: String, variable_name: String, method_name: String
) -> Dictionary:
	var regex: RegEx = RegEx.new()
	regex.compile(
		"(?m)^\\s*"
		+ _regex_escape_identifier(variable_name)
		+ "\\."
		+ method_name
		+ "\\(\\s*(Vector2i?\\(\\s*[-+]?\\d+(?:\\.\\d+)?\\s*,\\s*"
		+ "[-+]?\\d+(?:\\.\\d+)?\\s*\\))\\s*\\)"
	)
	var match: RegExMatch = regex.search(source)
	if match == null:
		return {}
	return {"start": match.get_start(1), "end": match.get_end(1)}


static func _source_name_bonus(source_name: String, candidate_names: Array[String]) -> float:
	var normalized_source: String = _normalize_source_identifier(source_name)
	if normalized_source.is_empty():
		return 0.0
	var best: float = 0.0
	for raw_name: String in candidate_names:
		var normalized_candidate: String = _normalize_source_identifier(raw_name)
		if normalized_candidate.is_empty():
			continue
		if normalized_source == normalized_candidate:
			best = maxf(best, 240.0)
		elif normalized_source.contains(normalized_candidate) or normalized_candidate.contains(normalized_source):
			best = maxf(best, 120.0)
		else:
			var source_tokens: PackedStringArray = normalized_source.split("_", false)
			var candidate_tokens: PackedStringArray = normalized_candidate.split("_", false)
			var shared: int = 0
			for token: String in source_tokens:
				if candidate_tokens.has(token):
					shared += 1
			best = maxf(best, float(shared) * 24.0)
	return best


static func _normalize_source_identifier(value: String) -> String:
	var result: String = value.to_lower().strip_edges()
	var prefixes: Array[String] = [
		"runtime_", "play_", "preview_", "blueprint_", "shop_", "inventory_",
		"forge_", "skill_", "menu_", "ui_"
	]
	for prefix: String in prefixes:
		if result.begins_with(prefix):
			result = result.trim_prefix(prefix)
	var suffixes: Array[String] = ["_runtime", "_play", "_preview", "_visual"]
	for suffix: String in suffixes:
		if result.ends_with(suffix):
			result = result.trim_suffix(suffix)
	return result


static func _property_rect_source_data(source: String, variable_name: String) -> Dictionary:
	var position_data: Dictionary = _property_vector_source_data(source, variable_name, "position")
	var size_data: Dictionary = _property_vector_source_data(source, variable_name, "size")
	if position_data.is_empty():
		return {}
	if size_data.is_empty():
		return {
			"kind": "position_only",
			"span_a_start": int(position_data.get("start", -1)),
			"span_a_end": int(position_data.get("end", -1))
		}
	return {
		"kind": "position_size",
		"span_a_start": int(position_data.get("start", -1)),
		"span_a_end": int(position_data.get("end", -1)),
		"span_b_start": int(size_data.get("start", -1)),
		"span_b_end": int(size_data.get("end", -1))
	}


static func _property_vector_source_data(
	source: String, variable_name: String, property_name: String
) -> Dictionary:
	var regex: RegEx = RegEx.new()
	regex.compile(
		"(?m)^\\s*"
		+ _regex_escape_identifier(variable_name)
		+ "\\."
		+ property_name
		+ "\\s*=\\s*(Vector2\\(\\s*[-+]?\\d+(?:\\.\\d+)?\\s*,\\s*[-+]?\\d+(?:\\.\\d+)?\\s*\\))"
	)
	var match: RegExMatch = regex.search(source)
	if match == null:
		return {}
	return {"start": match.get_start(1), "end": match.get_end(1)}


static func _assigned_call_source_data(source: String, variable_name: String) -> Dictionary:
	var assignment_regex: RegEx = RegEx.new()
	assignment_regex.compile(
		"(?m)^\\s*(?:var\\s+)?"
		+ _regex_escape_identifier(variable_name)
		+ "(?:\\s*:[^:=\\n]+)?\\s*(?::=|=)\\s*_[A-Za-z0-9_]+\\s*\\("
	)
	var assignment_match: RegExMatch = assignment_regex.search(source)
	if assignment_match == null:
		return {}
	var opening_parenthesis: int = assignment_match.get_end(0) - 1
	var closing_parenthesis: int = _find_matching_parenthesis(source, opening_parenthesis)
	if closing_parenthesis <= opening_parenthesis:
		return {}
	var call_text: String = source.substr(
		opening_parenthesis, closing_parenthesis - opening_parenthesis + 1
	)
	var vector_regex: RegEx = RegEx.new()
	vector_regex.compile(
		"Vector2\\(\\s*[-+]?\\d+(?:\\.\\d+)?\\s*,\\s*[-+]?\\d+(?:\\.\\d+)?\\s*\\)"
	)
	var vector_matches: Array[RegExMatch] = vector_regex.search_all(call_text)
	if vector_matches.is_empty():
		return {}
	var position_match: RegExMatch = vector_matches[0]
	var result: Dictionary = {
		"kind": "position_only",
		"span_a_start": opening_parenthesis + position_match.get_start(0),
		"span_a_end": opening_parenthesis + position_match.get_end(0)
	}
	if vector_matches.size() >= 2:
		var size_match: RegExMatch = vector_matches[1]
		result["kind"] = "position_size"
		result["span_b_start"] = opening_parenthesis + size_match.get_start(0)
		result["span_b_end"] = opening_parenthesis + size_match.get_end(0)
	return result


static func _find_matching_parenthesis(source: String, opening_index: int) -> int:
	if opening_index < 0 or opening_index >= source.length():
		return -1
	var depth: int = 0
	var quote: String = ""
	var escaped: bool = false
	for index: int in range(opening_index, source.length()):
		var character: String = source.substr(index, 1)
		if not quote.is_empty():
			if escaped:
				escaped = false
			elif character == "\\":
				escaped = true
			elif character == quote:
				quote = ""
			continue
		if character == "\"" or character == "'":
			quote = character
			continue
		if character == "(":
			depth += 1
		elif character == ")":
			depth -= 1
			if depth == 0:
				return index
	return -1


static func _regex_escape_identifier(value: String) -> String:
	# Los nombres de variables GDScript solo usan letras, números y guion bajo.
	var allowed: String = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_"
	var result: String = ""
	for index: int in range(value.length()):
		var character: String = value.substr(index, 1)
		if allowed.contains(character):
			result += character
	return result


static func apply_replacements(source: String, replacements: Array) -> String:
	var output: String = source
	for raw_replacement: Variant in replacements:
		if not (raw_replacement is Dictionary):
			continue
		var replacement: Dictionary = raw_replacement
		var start_index: int = int(replacement.get("start", -1))
		var end_index: int = int(replacement.get("end", -1))
		if start_index < 0 or end_index < start_index or end_index > output.length():
			continue
		output = (
			output.substr(0, start_index)
			+ str(replacement.get("text", ""))
			+ output.substr(end_index)
		)
	return output
