@tool
extends RefCounted

const INVENTORY_STAT_LABELS: Dictionary = {
	"vida": "VIDA", "daño": "DAÑO", "dano": "DAÑO", "def": "DEF", "vel": "VEL", "magia": "MAGIA"
}

const INVENTORY_STAT_SAMPLES: Dictionary = {
	"vida": "346", "daño": "37", "dano": "37", "def": "37", "vel": "25", "magia": "18"
}

const BRANCH_COLORS: Dictionary = {
	"core": Color("#F5D674"),
	"offense": Color("#FF9872"),
	"defense": Color("#8BC7FF"),
	"fortune": Color("#8AEC9D"),
	"alchemy": Color("#E49BFF"),
	"progression": Color("#FFD26A"),
	"legacy": Color("#7DECF0")
}


static func enhance(
	path: String, source: String, input_elements: Array, images: Array, canvas_size: Vector2
) -> Dictionary:
	var elements: Array = input_elements
	var views: Array = []
	var default_view: String = "all"
	var background_override: String = ""
	var resolved_canvas_size: Vector2 = canvas_size
	var normalized: String = (path.get_file().get_basename() + " " + source.left(500)).to_lower()

	_enhance_shared_position_arrays(source, elements)

	if normalized.contains("inventario") or source.contains("class_name InventarioUI"):
		background_override = _enhance_inventory(source, elements, images)
	elif normalized.contains("tienda") or source.contains("class_name TiendaUI"):
		background_override = _enhance_shop(source, elements, images)
		resolved_canvas_size = _vector2_constant(source, "REFERENCE_SIZE", canvas_size)
	elif normalized.contains("forja") or source.contains("class_name ForjaUI"):
		background_override = _enhance_forge(source, elements, images)
	elif normalized.contains("arbol") or source.contains("class_name ArbolHabilidadesUI"):
		background_override = _enhance_skill_tree(source, elements, images)
	elif normalized.contains("seleccion") or source.contains("enum ScreenMode"):
		var selection_data: Dictionary = _enhance_selection(source, elements, images)
		views = selection_data.get("views", [])
		default_view = str(selection_data.get("default_view", "faction"))
		resolved_canvas_size = selection_data.get("canvas_size", canvas_size)

	_apply_generic_image_modes(source, elements)
	_sort_by_layer(elements)

	return {
		"elements": elements,
		"views": views,
		"default_view": default_view,
		"background_path": background_override,
		"canvas_size": resolved_canvas_size
	}


static func _enhance_inventory(source: String, elements: Array, images: Array) -> String:
	var background_path: String = _path_for_variable(source, "inventory_background_path")
	if background_path.is_empty():
		background_path = _best_image(images, ["inventario_rpg_base", "inventario", "inventory"])
	var character_path: String = _path_for_variable(source, "character_texture_path")
	if character_path.is_empty():
		character_path = _best_image(images, ["paladin1", "personaje", "character"])

	_set_image(
		elements,
		["background", "background_rect", "FondoInventario"],
		background_path,
		"stretch",
		0.0
	)
	_set_image(
		elements, ["character_preview", "PersonajeInventario"], character_path, "contain", 0.0
	)
	_enhance_inventory_roster(source, elements)
	_enhance_inventory_stats(source, elements)
	_enrich_inventory_tabs(elements)
	_enrich_inventory_grid(elements)
	return background_path


static func _enhance_inventory_roster(source: String, elements: Array) -> void:
	var block: Dictionary = _function_block(source, "_build_character_roster_slots")
	if block.is_empty():
		return
	var block_text: String = str(block.get("text", ""))
	var block_start: int = int(block.get("start", 0))
	var positions: Array = _vector_array_in_text(block_text, block_start, "positions", source)
	var button_size: Vector2 = Vector2(92.0, 54.0)
	var size_data: Dictionary = _property_vector_in_text(block_text, block_start, "button", "size")
	if size_data.get("value", null) is Vector2:
		button_size = size_data.get("value", button_size)

	var labels: Array[String] = ["◆ PAL\nNv.14", "◆ ARQ\nBLOQUEADO", "◆ ARC\nBLOQUEADO"]
	var borders: Array[Color] = [Color("#F4D47A"), Color("#7BCF8B"), Color("#B08BD8")]
	var fills: Array[Color] = [
		Color(0.025, 0.065, 0.09, 0.96),
		Color(0.025, 0.055, 0.035, 0.95),
		Color(0.055, 0.035, 0.07, 0.95)
	]
	for index: int in range(positions.size()):
		var data: Dictionary = positions[index]
		var position: Vector2 = data.get("value", Vector2.ZERO)
		var element: Dictionary = _base_element(
			"inventory_character_slot_%d" % index,
			Rect2(position, button_size),
			labels[index] if index < labels.size() else "CAMPEÓN %d" % (index + 1),
			int(data.get("line", 0)),
			"Bucle de campeones · posición editable",
			"Button"
		)
		element["kind"] = "position_only"
		element["span_a_start"] = int(data.get("start", -1))
		element["span_a_end"] = int(data.get("end", -1))
		element["editable"] = true
		element["allow_resize"] = false
		element["font_size"] = 11
		element["fill_color"] = fills[index] if index < fills.size() else fills[0]
		element["border_color"] = borders[index] if index < borders.size() else borders[0]
		element["border_width"] = 2.0
		element["corner_radius"] = 9.0
		element["text_color"] = Color("#F5E9C7")
		element["z_index"] = 30
		_add_or_merge(elements, element)


static func _enhance_inventory_stats(source: String, elements: Array) -> void:
	var block: Dictionary = _function_block(source, "_build_stats_panel")
	if block.is_empty():
		return
	var block_text: String = str(block.get("text", ""))
	var block_start: int = int(block.get("start", 0))
	var row_regex: RegEx = RegEx.new()
	(
		row_regex
		. compile(
			"[\\{,]\\s*[\\\"']id[\\\"']\\s*:\\s*[\\\"']([^\\\"']+)[\\\"'][^\\n\\}]*[\\\"']position[\\\"']\\s*:\\s*(Vector2\\(\\s*([-+]?\\d+(?:\\.\\d+)?)\\s*,\\s*([-+]?\\d+(?:\\.\\d+)?)\\s*\\))"
		)
	)
	for match: RegExMatch in row_regex.search_all(block_text):
		var stat_id: String = match.get_string(1).to_lower()
		var row_position: Vector2 = Vector2(float(match.get_string(3)), float(match.get_string(4)))
		var absolute_start: int = block_start + match.get_start(2)
		var driver_name: String = "inventory_stat_%s_name" % stat_id.replace("ñ", "n")
		var name_element: Dictionary = _base_element(
			driver_name,
			Rect2(row_position, Vector2(115.0, 28.0)),
			str(INVENTORY_STAT_LABELS.get(stat_id, stat_id.to_upper())),
			_line_at(source, absolute_start),
			"Fila de atributo · posición editable",
			"Label"
		)
		name_element["kind"] = "position_only"
		name_element["span_a_start"] = absolute_start
		name_element["span_a_end"] = block_start + match.get_end(2)
		name_element["editable"] = true
		name_element["allow_resize"] = false
		name_element["font_size"] = 15
		name_element["horizontal_alignment"] = HORIZONTAL_ALIGNMENT_LEFT
		name_element["text_color"] = Color("#E9C66D")
		_add_or_merge(elements, name_element)

		var value_element: Dictionary = _base_element(
			"inventory_stat_%s_value" % stat_id.replace("ñ", "n"),
			Rect2(row_position + Vector2(116.0, 0.0), Vector2(96.0, 28.0)),
			str(INVENTORY_STAT_SAMPLES.get(stat_id, "0")),
			_line_at(source, absolute_start),
			"Valor PLAY enlazado al atributo",
			"Label"
		)
		value_element["runtime_only"] = true
		value_element["editable"] = false
		value_element["font_size"] = 15
		value_element["horizontal_alignment"] = HORIZONTAL_ALIGNMENT_RIGHT
		value_element["text_color"] = Color("#F5E9C7")
		value_element["linked_to"] = driver_name
		value_element["linked_offset"] = Vector2(116.0, 0.0)
		_add_or_merge(elements, value_element)


static func _enrich_inventory_tabs(elements: Array) -> void:
	var names: Array[String] = ["EQUIPO", "OBJETOS", "MATERIALES", "MISIONES", "HABILIDADES"]
	for index: int in range(names.size()):
		var target_name: String = "TAB_RECTS_%d" % index
		var element_index: int = _find_element(elements, target_name)
		if element_index < 0:
			continue
		var element: Dictionary = elements[element_index]
		element["display_text"] = names[index]
		element["friendly_name"] = "Pestaña " + names[index].capitalize()
		element["control_type"] = "Button"
		element["preview_style"] = "button"
		element["font_size"] = 16
		element["text_color"] = Color("#E7FFF6") if index == 0 else Color("#E9D5A1")
		element["fill_color"] = (
			Color(0.04, 0.43, 0.30, 0.33) if index == 0 else Color(0.0, 0.0, 0.0, 0.02)
		)
		element["border_color"] = Color("#67F0BC") if index == 0 else Color(0.82, 0.65, 0.24, 0.18)
		element["border_width"] = 1.0
		element["corner_radius"] = 5.0
		elements[element_index] = element


static func _enrich_inventory_grid(elements: Array) -> void:
	for index: int in range(elements.size()):
		if not (elements[index] is Dictionary):
			continue
		var element: Dictionary = elements[index]
		var name: String = str(element.get("name", ""))
		if name.begins_with("runtime_inventory_slot_"):
			element["fill_color"] = Color(0.002, 0.006, 0.010, 0.54)
			element["border_color"] = Color(0.68, 0.49, 0.16, 0.55)
			element["border_width"] = 1.0
			element["corner_radius"] = 4.0
			element["display_text"] = ""
			elements[index] = element


static func _enhance_shop(source: String, elements: Array, images: Array) -> String:
	var background_path: String = _path_for_variable(source, "shop_background_path")
	if background_path.is_empty():
		background_path = _best_image(images, ["tienda_base", "fondo_tienda", "shop_background"])
	var merchant_path: String = _path_for_variable(source, "merchant_texture_path")
	if merchant_path.is_empty():
		merchant_path = _best_image(images, ["elfa_tendera", "lyria", "merchant"])
	_set_image(elements, ["background_rect", "FondoTienda"], background_path, "stretch", 0.0)
	_set_image(elements, ["merchant_rect", "Lyria"], merchant_path, "contain", 0.0)
	_set_image(
		elements, ["merchant_counter_overlay", "FrontalMostrador"], background_path, "region", 0.0
	)
	_set_region(
		elements,
		["merchant_counter_overlay", "FrontalMostrador"],
		_rect_constant(source, "MERCHANT_COUNTER_REGION")
	)
	_set_z_index(elements, ["background_rect", "FondoTienda"], -30)
	_set_z_index(elements, ["merchant_rect", "Lyria"], 4)
	_set_z_index(elements, ["merchant_counter_overlay", "FrontalMostrador"], 5)
	_set_z_index(
		elements,
		[
			"title_label", "gold_label", "merchant_name_label", "merchant_quote_label",
			"detail_name_label", "detail_rarity_label", "detail_description_label",
			"quantity_title_label", "quantity_value_label", "total_label",
			"buy_button", "close_button", "footer_label", "region_label"
		],
		7
	)

	_mark_function_templates(source, elements, "_build_categories", ["button"])
	_mark_function_templates(
		source,
		elements,
		"_build_product_grid",
		["card", "icon", "name_label", "description_label", "price_label"]
	)
	_enhance_shop_categories(source, elements)
	var products: Array = _parse_shop_products(source)
	_enhance_shop_cards(source, elements, products)
	_enhance_shop_dynamic_text(source, elements, products)
	return background_path


static func _enhance_shop_categories(source: String, elements: Array) -> void:
	var block: Dictionary = _function_block(source, "_build_categories")
	if block.is_empty():
		return
	var text: String = str(block.get("text", ""))
	var base: int = int(block.get("start", 0))
	var regex: RegEx = RegEx.new()
	(
		regex
		. compile(
			"[\\{,]\\s*[\\\"']id[\\\"']\\s*:\\s*([^,\\}]+)[^\\n\\}]*[\\\"']key[\\\"']\\s*:\\s*[\\\"']([^\\\"']+)[\\\"'][^\\n\\}]*[\\\"']y[\\\"']\\s*:\\s*([-+]?\\d+(?:\\.\\d+)?)"
		)
	)
	var fallback_names: Dictionary = {
		"recommended": "RECOMENDADO",
		"potions": "POCIONES",
		"chests": "COFRES DE RANGO",
		"all": "TODO"
	}
	var index: int = 0
	for match: RegExMatch in regex.search_all(text):
		var key: String = match.get_string(2)
		var y: float = float(match.get_string(3))
		var element: Dictionary = _base_element(
			"shop_category_%d" % index,
			Rect2(Vector2(34.0, y), Vector2(235.0, 76.0)),
			str(fallback_names.get(key, key.to_upper())),
			_line_at(source, base + match.get_start(0)),
			"Categoría generada en PLAY",
			"Button"
		)
		element["runtime_only"] = true
		element["editable"] = false
		element["font_size"] = 23
		element["z_index"] = 7
		element["fill_color"] = (
			Color(0.02, 0.07, 0.055, 0.94) if index == 0 else Color(0.006, 0.015, 0.020, 0.84)
		)
		element["border_color"] = Color("#4CF0A5") if index == 0 else Color(0.55, 0.40, 0.16, 0.68)
		element["border_width"] = 2.0 if index == 0 else 1.0
		element["corner_radius"] = 5.0
		element["text_color"] = Color("#F5EBD7")
		_add_or_merge(elements, element)
		index += 1


static func _parse_shop_products(source: String) -> Array:
	var result: Array = []
	var regex: RegEx = RegEx.new()
	(
		regex
		. compile(
			"(?m)^\\s*\\{[\\\"']id[\\\"']\\s*:\\s*[\\\"']([^\\\"']+)[\\\"'][^\\n]*[\\\"']name_key[\\\"']\\s*:\\s*[\\\"']([^\\\"']+)[\\\"'][^\\n]*[\\\"']description_key[\\\"']\\s*:\\s*[\\\"']([^\\\"']+)[\\\"'][^\\n]*[\\\"']price[\\\"']\\s*:\\s*(\\d+)[^\\n]*[\\\"']icon_key[\\\"']\\s*:\\s*[\\\"']([^\\\"']+)[\\\"']"
		)
	)
	for match: RegExMatch in regex.search_all(source):
		var name_key: String = match.get_string(2)
		var desc_key: String = match.get_string(3)
		result.append(
			{
				"id": match.get_string(1),
				"name": _translation_value(source, name_key, name_key),
				"description": _translation_value(source, desc_key, ""),
				"price": int(match.get_string(4)),
				"icon_key": match.get_string(5),
				"line": _line_at(source, match.get_start(0))
			}
		)
	return result


static func _enhance_shop_cards(source: String, elements: Array, products: Array) -> void:
	var visible_count: int = mini(6, products.size())
	var icon_paths: Dictionary = _string_dictionary(source, "PRODUCT_ICON_PATHS")
	for index: int in range(visible_count):
		var product: Dictionary = products[index]
		var column: int = index % 2
		var row: int = index >> 1
		var card_position: Vector2 = Vector2(
			305.0 + float(column) * 300.0, 130.0 + float(row) * 160.0
		)
		var card_name: String = "shop_product_card_%02d" % index
		var card: Dictionary = _base_element(
			card_name,
			Rect2(card_position, Vector2(280.0, 140.0)),
			"",
			int(product.get("line", 0)),
			"Tarjeta de producto generada en PLAY",
			"Button"
		)
		card["runtime_only"] = true
		card["editable"] = false
		card["z_index"] = 6
		card["fill_color"] = Color(0.005, 0.010, 0.014, 0.36)
		card["border_color"] = Color(0.30, 0.22, 0.12, 0.55)
		card["border_width"] = 1.0
		card["corner_radius"] = 5.0
		_add_or_merge(elements, card)

		var icon_path: String = str(icon_paths.get(str(product.get("icon_key", "")), ""))
		var icon: Dictionary = _base_element(
			"shop_product_icon_%02d" % index,
			Rect2(card_position + Vector2(12.0, 24.0), Vector2(76.0, 76.0)),
			"",
			int(product.get("line", 0)),
			"Icono de producto PLAY",
			"TextureRect"
		)
		icon["runtime_only"] = true
		icon["editable"] = false
		icon["image_path"] = icon_path
		icon["image_mode"] = "contain"
		icon["image_padding"] = 0.0
		icon["z_index"] = 8
		_add_or_merge(elements, icon)

		_add_shop_card_label(
			elements,
			"name",
			index,
			card_position + Vector2(94.0, 12.0),
			Vector2(174.0, 34.0),
			str(product.get("name", "")),
			22,
			Color("#F5EBD7")
		)
		_add_shop_card_label(
			elements,
			"desc",
			index,
			card_position + Vector2(94.0, 45.0),
			Vector2(174.0, 58.0),
			str(product.get("description", "")),
			17,
			Color("#DDD3C0")
		)
		_add_shop_card_label(
			elements,
			"price",
			index,
			card_position + Vector2(94.0, 104.0),
			Vector2(174.0, 28.0),
			"◆ %d" % int(product.get("price", 0)),
			20,
			Color("#FFE59A")
		)


static func _add_shop_card_label(
	elements: Array,
	kind: String,
	index: int,
	position: Vector2,
	dimensions: Vector2,
	text: String,
	font_size: int,
	color: Color
) -> void:
	var element: Dictionary = _base_element(
		"shop_product_%s_%02d" % [kind, index],
		Rect2(position, dimensions),
		text,
		0,
		"Texto de producto PLAY",
		"Label"
	)
	element["runtime_only"] = true
	element["editable"] = false
	element["font_size"] = font_size
	element["horizontal_alignment"] = HORIZONTAL_ALIGNMENT_LEFT
	element["text_color"] = color
	element["z_index"] = 9
	_add_or_merge(elements, element)


static func _enhance_shop_dynamic_text(source: String, elements: Array, products: Array) -> void:
	var selected: Dictionary = products[0] if not products.is_empty() else {}
	_set_element_text(elements, "gold_label", "ORO: 4367")
	_set_element_text(
		elements, "title_label", _translation_value(source, "title", "TIENDA ERRANTE DE LYRIA")
	)
	_set_element_text(
		elements,
		"merchant_name_label",
		_translation_value(source, "merchant_name", "LYRIA · MERCADERA DEL VELO")
	)
	_set_element_text(
		elements,
		"merchant_quote_label",
		_translation_value(source, "merchant_quote", "Toda ruta esconde un tesoro.")
	)
	_set_element_text(
		elements, "detail_name_label", str(selected.get("name", "Poción Menor de Vida"))
	)
	_set_element_text(elements, "detail_rarity_label", "COMÚN")
	_set_element_text(
		elements,
		"detail_description_label",
		str(selected.get("description", "Restaura 25 puntos de vida."))
	)
	_set_element_text(
		elements, "quantity_title_label", _translation_value(source, "quantity", "CANTIDAD")
	)
	_set_element_text(elements, "quantity_value_label", "1")
	_set_element_text(elements, "total_label", "TOTAL: %d" % int(selected.get("price", 120)))
	_set_element_text(elements, "buy_button", _translation_value(source, "buy", "COMPRAR"))
	_set_element_text(elements, "region_label", "Mercancía vinculada a Ruta de Valdoria")
	_set_element_text(
		elements,
		"footer_label",
		_translation_value(
			source, "footer", "Nuevas leyendas nacen cuando alguien decide pagar el precio."
		)
	)
	var icon_paths: Dictionary = _string_dictionary(source, "PRODUCT_ICON_PATHS")
	_set_image(
		elements,
		["detail_icon"],
		str(icon_paths.get(str(selected.get("icon_key", "pocion_menor")), "")),
		"contain",
		0.0
	)


static func _enhance_forge(source: String, elements: Array, images: Array) -> String:
	var background_path: String = _path_for_variable(source, "forge_background_path")
	if background_path.is_empty():
		background_path = _best_image(images, ["forja_pixel", "forja", "forge"])
	_set_image(
		elements, ["background_rect", "background", "FondoForja"], background_path, "stretch", 0.0
	)
	for index: int in range(elements.size()):
		if not (elements[index] is Dictionary):
			continue
		var element: Dictionary = elements[index]
		if str(element.get("name", "")).begins_with("SLOT_RECTS_"):
			element["display_text"] = ""
			element["control_type"] = "Button"
			element["fill_color"] = Color(0.005, 0.010, 0.014, 0.42)
			element["border_color"] = Color(0.62, 0.45, 0.16, 0.72)
			element["border_width"] = 1.0
			element["corner_radius"] = 7.0
			elements[index] = element
	return background_path


static func _enhance_skill_tree(source: String, elements: Array, images: Array) -> String:
	var background_path: String = _path_for_variable(source, "skill_tree_background_path")
	if background_path.is_empty():
		background_path = _best_image(
			images, ["arbol_habilidades_cosmico", "fondoastral", "skill_tree"]
		)
	_set_image(elements, ["background_rect", "FondoAstral"], background_path, "stretch", 0.0)
	_mark_function_templates(source, elements, "_build_skill_nodes", ["button", "rank_badge"])
	_mark_function_templates(source, elements, "_create_skill_caption", ["panel", "caption"])
	_parse_skill_definitions(source, elements)
	_set_element_text(elements, "top_stats_label", "NIVEL 14 · ORO 4367")
	_set_element_text(elements, "top_phase_label", "0-1 · FASE 35")
	_set_element_text(elements, "points_label", "PUNTOS DISPONIBLES: 5")
	_set_element_text(elements, "character_tokens_label", "FICHAS DE PERSONAJE: 0")
	_set_element_text(elements, "tree_level_label", "NIVEL DEL ÁRBOL\n14")
	_set_element_text(elements, "potion_counter_label", "POCIONES HOY: 3 / 24")
	return background_path


static func _parse_skill_definitions(source: String, elements: Array) -> void:
	var line_start: int = 0
	for line: String in source.split("\n", true):
		if line.contains('{"id"') and line.contains('"position"') and line.contains('"size"'):
			var id_match: RegExMatch = _search(
				line, "[\\\"']id[\\\"']\\s*:\\s*[\\\"']([^\\\"']+)[\\\"']"
			)
			var branch_match: RegExMatch = _search(
				line, "[\\\"']branch[\\\"']\\s*:\\s*[\\\"']([^\\\"']+)[\\\"']"
			)
			var position_match: RegExMatch = _search(
				line,
				"[\\\"']position[\\\"']\\s*:\\s*(Vector2\\(\\s*([-+]?\\d+(?:\\.\\d+)?)\\s*,\\s*([-+]?\\d+(?:\\.\\d+)?)\\s*\\))"
			)
			var size_match: RegExMatch = _search(
				line,
				"[\\\"']size[\\\"']\\s*:\\s*(Vector2\\(\\s*([-+]?\\d+(?:\\.\\d+)?)\\s*,\\s*([-+]?\\d+(?:\\.\\d+)?)\\s*\\))"
			)
			var title_match: RegExMatch = _search(
				line, "[\\\"']title_es[\\\"']\\s*:\\s*[\\\"']([^\\\"']+)[\\\"']"
			)
			var max_rank_match: RegExMatch = _search(line, "[\\\"']max_rank[\\\"']\\s*:\\s*(\\d+)")
			if id_match != null and position_match != null and size_match != null:
				var skill_id: String = id_match.get_string(1)
				var branch: String = branch_match.get_string(1) if branch_match != null else "core"
				var position: Vector2 = Vector2(
					float(position_match.get_string(2)), float(position_match.get_string(3))
				)
				var dimensions: Vector2 = Vector2(
					float(size_match.get_string(2)), float(size_match.get_string(3))
				)
				var title: String = (
					title_match.get_string(1) if title_match != null else skill_id.capitalize()
				)
				var absolute_position_start: int = line_start + position_match.get_start(1)
				var absolute_size_start: int = line_start + size_match.get_start(1)
				var accent: Color = BRANCH_COLORS.get(branch, Color("#F5D674"))
				var node: Dictionary = _base_element(
					"skill_node_" + skill_id,
					Rect2(position, dimensions),
					"✦",
					_line_at(source, line_start),
					"Nodo del árbol · posición y tamaño editables",
					"Button"
				)
				node["kind"] = "vector_pair"
				node["span_a_start"] = absolute_position_start
				node["span_a_end"] = line_start + position_match.get_end(1)
				node["span_b_start"] = absolute_size_start
				node["span_b_end"] = line_start + size_match.get_end(1)
				node["editable"] = true
				node["font_size"] = 20
				node["fill_color"] = Color(0.008, 0.016, 0.030, 0.88)
				node["border_color"] = accent
				node["border_width"] = 2.0
				node["corner_radius"] = dimensions.x * 0.5
				node["text_color"] = accent
				node["z_index"] = 20
				_add_or_merge(elements, node)

				var rank: Dictionary = _base_element(
					"skill_rank_" + skill_id,
					Rect2(
						position + Vector2(dimensions.x - 27.0, dimensions.y - 19.0),
						Vector2(27.0, 18.0)
					),
					"0/%d" % (int(max_rank_match.get_string(1)) if max_rank_match != null else 1),
					_line_at(source, line_start),
					"Rango PLAY del nodo",
					"Label"
				)
				rank["runtime_only"] = true
				rank["editable"] = false
				rank["font_size"] = 8
				rank["fill_color"] = Color(0, 0, 0, 0.82)
				rank["border_color"] = Color(1, 1, 1, 0.22)
				rank["border_width"] = 1.0
				rank["corner_radius"] = 7.0
				rank["linked_to"] = "skill_node_" + skill_id
				rank["linked_offset"] = Vector2(dimensions.x - 27.0, dimensions.y - 19.0)
				rank["z_index"] = 23
				_add_or_merge(elements, rank)

				if skill_id != "core" and dimensions.x <= 60.0:
					_add_skill_caption(
						elements,
						skill_id,
						title,
						branch,
						position,
						dimensions,
						_line_at(source, line_start)
					)
		line_start += line.length() + 1


static func _add_skill_caption(
	elements: Array,
	skill_id: String,
	title: String,
	branch: String,
	position: Vector2,
	dimensions: Vector2,
	line: int
) -> void:
	var center: Vector2 = position + dimensions * 0.5
	var radial: Vector2 = (center - Vector2(735.0, 540.0)).normalized()
	if radial == Vector2.ZERO:
		radial = Vector2.DOWN
	var caption_size: Vector2 = Vector2(104.0, 34.0)
	var caption_center: Vector2 = center + radial * 43.0
	if center.y < 180.0:
		caption_center = center + Vector2(0.0, 47.0)
	elif center.y > 875.0:
		caption_center = center + Vector2(0.0, -47.0)
	var caption_position: Vector2 = caption_center - caption_size * 0.5
	caption_position.x = clampf(caption_position.x, 304.0, 1114.0 - caption_size.x)
	caption_position.y = clampf(caption_position.y, 58.0, 995.0 - caption_size.y)
	var accent: Color = BRANCH_COLORS.get(branch, Color("#F5D674"))
	var caption: Dictionary = _base_element(
		"skill_caption_" + skill_id,
		Rect2(caption_position, caption_size),
		title,
		line,
		"Nombre PLAY del nodo",
		"Label"
	)
	caption["runtime_only"] = true
	caption["editable"] = false
	caption["font_size"] = 9
	caption["fill_color"] = Color(0.005, 0.012, 0.022, 0.76)
	caption["border_color"] = Color(accent.r, accent.g, accent.b, 0.28)
	caption["border_width"] = 1.0
	caption["corner_radius"] = 7.0
	caption["text_color"] = Color("#F0E7D6")
	caption["z_index"] = 22
	caption["linked_to"] = "skill_node_" + skill_id
	caption["linked_offset"] = caption_position - position
	_add_or_merge(elements, caption)


static func _enhance_selection(source: String, elements: Array, images: Array) -> Dictionary:
	var faction_block: Dictionary = _function_block(source, "_create_faction_screen")
	var character_block: Dictionary = _function_block(source, "_create_character_screen")
	_mark_range_view(elements, faction_block, "faction")
	_mark_range_view(elements, character_block, "character")
	for function_name: String in ["_create_faction_card", "_create_info_row"]:
		_mark_range_view(elements, _function_block(source, function_name), "faction")
	for function_name: String in [
		"_create_character_card",
		"_create_paladin_static_art",
		"_create_paladin_animation",
		"_create_stats_block",
		"_create_sigil_placeholder"
	]:
		_mark_range_view(elements, _function_block(source, function_name), "character")
	for function_name: String in ["_create_faction_card", "_create_info_row"]:
		_mark_block_as_template(source, elements, function_name)
	for function_name: String in [
		"_create_character_card",
		"_create_paladin_static_art",
		"_create_paladin_animation",
		"_create_stats_block",
		"_create_sigil_placeholder"
	]:
		_mark_block_as_template(source, elements, function_name)
	for index: int in range(elements.size()):
		if not (elements[index] is Dictionary):
			continue
		var element: Dictionary = elements[index]
		var name: String = str(element.get("name", ""))
		if name.begins_with("FACTION_CARD_POSITIONS_"):
			element["view_tag"] = "faction"
		elif name.begins_with("CHARACTER_CARD_POSITIONS_"):
			element["view_tag"] = "character"
		elements[index] = element
	var paladin_path: String = _path_for_variable(source, "PALADIN_TEXTURE_PATH")
	if paladin_path.is_empty():
		paladin_path = _best_image(images, ["paladin1", "paladin"])
	_set_image(
		elements,
		["portrait", "portrait_texture", "paladin_texture", "character_portrait"],
		paladin_path,
		"contain",
		0.0
	)
	_synthesize_faction_cards(elements)
	_synthesize_character_cards(elements, paladin_path)
	var faction_size: Vector2 = _vector_constant_data(source, "FACTION_WINDOW_SIZE").get(
		"value", Vector2(1000.0, 600.0)
	)
	var character_size: Vector2 = _vector_constant_data(source, "CHARACTER_WINDOW_SIZE").get(
		"value", Vector2(1180.0, 760.0)
	)
	return {
		"views":
		[
			{"tag": "faction", "name": "Selección de facción", "canvas_size": faction_size},
			{"tag": "character", "name": "Selección de personaje", "canvas_size": character_size}
		],
		"default_view": "faction",
		"canvas_size": faction_size
	}


static func _synthesize_faction_cards(elements: Array) -> void:
	var cards: Array[Dictionary] = [
		{
			"title": "JURAMENTO DEL ALBA",
			"subtitle": "LA SENDA DE LA LUZ",
			"description": "Defiende los reinos y contiene la Fractura.",
			"enemies": "Bandidos · Monstruos · Cultistas · Demonios",
			"classes": "Paladín · Arquero · Arcanista",
			"destiny": "PROTEGER",
			"symbol": "✦",
			"accent": Color("#8DBBFF")
		},
		{
			"title": "PACTO DEL UMBRAL",
			"subtitle": "LA SENDA DE LA NOCHE",
			"description": "Domina la Fractura y somete los reinos.",
			"enemies": "Aventureros · Guardias · Paladines · Inquisidores",
			"classes": "Nigromante · Caballero de Sangre · Asesino",
			"destiny": "CONQUISTAR",
			"symbol": "◆",
			"accent": Color("#D578FF")
		}
	]
	for index: int in range(cards.size()):
		var driver_name: String = "FACTION_CARD_POSITIONS_%d" % index
		var driver_index: int = _find_element(elements, driver_name)
		if driver_index < 0:
			continue
		var driver: Dictionary = elements[driver_index]
		driver["display_text"] = ""
		driver["friendly_name"] = "Tarjeta de facción %d" % (index + 1)
		driver["view_tag"] = "faction"
		driver["z_index"] = 5
		elements[driver_index] = driver
		var driver_rect: Rect2 = driver.get("rect", Rect2())
		var origin: Vector2 = driver_rect.position
		var data: Dictionary = cards[index]
		var accent: Color = data.get("accent", Color("#D8B85E"))
		_add_linked_runtime(
			elements,
			driver_name + "_emblem",
			driver_name,
			origin,
			Rect2(Vector2(145.0, 18.0), Vector2(115.0, 115.0)),
			str(data.get("symbol", "◆")),
			"Panel",
			42,
			Color(accent.r * 0.08, accent.g * 0.08, accent.b * 0.08, 0.82),
			accent,
			58.0,
			"faction"
		)
		_add_linked_runtime(
			elements,
			driver_name + "_title",
			driver_name,
			origin,
			Rect2(Vector2(46.0, 140.0), Vector2(313.0, 40.0)),
			str(data.get("title", "")),
			"Label",
			18,
			Color(0.17, 0.11, 0.04, 0.97),
			Color("#FFD66B"),
			10.0,
			"faction"
		)
		_add_linked_runtime(
			elements,
			driver_name + "_subtitle",
			driver_name,
			origin,
			Rect2(Vector2(30.0, 187.0), Vector2(345.0, 20.0)),
			str(data.get("subtitle", "")),
			"Label",
			13,
			Color.TRANSPARENT,
			Color.TRANSPARENT,
			0.0,
			"faction",
			accent
		)
		_add_linked_runtime(
			elements,
			driver_name + "_description",
			driver_name,
			origin,
			Rect2(Vector2(34.0, 210.0), Vector2(337.0, 32.0)),
			str(data.get("description", "")),
			"Label",
			12,
			Color.TRANSPARENT,
			Color.TRANSPARENT,
			0.0,
			"faction"
		)
		_add_linked_runtime(
			elements,
			driver_name + "_info",
			driver_name,
			origin,
			Rect2(Vector2(30.0, 245.0), Vector2(345.0, 64.0)),
			(
				"ENEMIGOS   %s\nCLASES       %s"
				% [str(data.get("enemies", "")), str(data.get("classes", ""))]
			),
			"Panel",
			10,
			Color(0.0, 0.0, 0.0, 0.92),
			Color("#FFD66B"),
			12.0,
			"faction"
		)
		_add_linked_runtime(
			elements,
			driver_name + "_destiny",
			driver_name,
			origin,
			Rect2(Vector2(122.0, 316.0), Vector2(161.0, 27.0)),
			str(data.get("destiny", "")),
			"Panel",
			11,
			Color(0.07, 0.045, 0.018, 0.97),
			Color("#FFD66B"),
			10.0,
			"faction",
			accent
		)


static func _synthesize_character_cards(elements: Array, paladin_path: String) -> void:
	var cards: Array[Dictionary] = [
		{
			"name": "PALADÍN DEL ALBA",
			"role": "Defensor sagrado",
			"description": "Protegido por la luz.\nResiste el daño y puede curarse.",
			"stats": "VIDA ★★★★★\nDAÑO ★★★☆☆\nDEF  ★★★★☆",
			"ability": "✦ ESCUDO SAGRADO",
			"accent": Color("#72B7FF"),
			"placeholder": ""
		},
		{
			"name": "ARQUERO DEL BOSQUE",
			"role": "Atacante a distancia",
			"description": "Preciso a larga distancia.\nDestaca por su velocidad.",
			"stats": "VIDA ★★★☆☆\nDAÑO ★★★★☆\nDEF  ★★★★☆",
			"ability": "✦ DISPARO TRIPLE",
			"accent": Color("#73D982"),
			"placeholder": "ARQ"
		},
		{
			"name": "ARCANISTA ESTELAR",
			"role": "Hechicero ofensivo",
			"description": "Domina fuerzas celestiales.\nDaña a varios enemigos.",
			"stats": "VIDA ★★☆☆☆\nDAÑO ★★★★★\nDEF  ★★★☆☆",
			"ability": "✦ LLUVIA ARCANA",
			"accent": Color("#B985FF"),
			"placeholder": "ARC"
		}
	]
	for index: int in range(cards.size()):
		var driver_name: String = "CHARACTER_CARD_POSITIONS_%d" % index
		var driver_index: int = _find_element(elements, driver_name)
		if driver_index < 0:
			continue
		var driver: Dictionary = elements[driver_index]
		driver["display_text"] = ""
		driver["friendly_name"] = "Tarjeta de personaje %d" % (index + 1)
		driver["view_tag"] = "character"
		driver["z_index"] = 5
		elements[driver_index] = driver
		var driver_rect: Rect2 = driver.get("rect", Rect2())
		var origin: Vector2 = driver_rect.position
		var data: Dictionary = cards[index]
		var accent: Color = data.get("accent", Color("#D8B85E"))
		_add_linked_runtime(
			elements,
			driver_name + "_portrait",
			driver_name,
			origin,
			Rect2(Vector2(15.0, 18.0), Vector2(300.0, 330.0)),
			str(data.get("placeholder", "")),
			"TextureRect" if index == 0 else "Panel",
			32,
			Color(accent.r * 0.045, accent.g * 0.045, accent.b * 0.045, 0.99),
			Color(accent.r, accent.g, accent.b, 0.78),
			15.0,
			"character",
			accent,
			paladin_path if index == 0 else ""
		)
		_add_linked_runtime(
			elements,
			driver_name + "_name",
			driver_name,
			origin,
			Rect2(Vector2(22.0, 313.0), Vector2(286.0, 41.0)),
			str(data.get("name", "")),
			"Panel",
			16,
			Color(accent.r * 0.15, accent.g * 0.15, accent.b * 0.15, 0.98),
			Color("#FFD66B"),
			9.0,
			"character"
		)
		_add_linked_runtime(
			elements,
			driver_name + "_description",
			driver_name,
			origin,
			Rect2(Vector2(20.0, 362.0), Vector2(290.0, 42.0)),
			str(data.get("description", "")),
			"Panel",
			10,
			Color(0.0, 0.0, 0.0, 0.78),
			Color(accent.r, accent.g, accent.b, 0.18),
			9.0,
			"character"
		)
		_add_linked_runtime(
			elements,
			driver_name + "_stats",
			driver_name,
			origin,
			Rect2(Vector2(47.0, 409.0), Vector2(236.0, 70.0)),
			str(data.get("stats", "")),
			"Panel",
			11,
			Color(0.0, 0.0, 0.0, 0.94),
			accent,
			13.0,
			"character",
			Color("#FFE9A0")
		)
		_add_linked_runtime(
			elements,
			driver_name + "_role",
			driver_name,
			origin,
			Rect2(Vector2(26.0, 484.0), Vector2(278.0, 18.0)),
			str(data.get("role", "")),
			"Label",
			13,
			Color.TRANSPARENT,
			Color.TRANSPARENT,
			0.0,
			"character",
			accent
		)
		_add_linked_runtime(
			elements,
			driver_name + "_ability",
			driver_name,
			origin,
			Rect2(Vector2(34.0, 507.0), Vector2(262.0, 23.0)),
			str(data.get("ability", "")),
			"Panel",
			10,
			Color(accent.r * 0.10, accent.g * 0.10, accent.b * 0.10, 0.98),
			Color("#FFD66B"),
			7.0,
			"character",
			Color("#FFE9A0")
		)


static func _add_linked_runtime(
	elements: Array,
	name: String,
	driver_name: String,
	driver_origin: Vector2,
	local_rect: Rect2,
	text: String,
	control_type: String,
	font_size: int,
	fill: Color,
	border: Color,
	radius: float,
	view_tag: String,
	text_color: Color = Color("#F0E7D7"),
	image_path: String = ""
) -> void:
	var element: Dictionary = _base_element(
		name,
		Rect2(driver_origin + local_rect.position, local_rect.size),
		text,
		0,
		"Reconstrucción PLAY enlazada",
		control_type
	)
	element["runtime_only"] = true
	element["editable"] = false
	element["font_size"] = font_size
	element["fill_color"] = fill
	element["border_color"] = border
	element["border_width"] = 2.0 if border.a > 0.001 else 0.0
	element["corner_radius"] = radius
	element["text_color"] = text_color
	element["linked_to"] = driver_name
	element["linked_offset"] = local_rect.position
	element["view_tag"] = view_tag
	element["z_index"] = 12
	if not image_path.is_empty():
		element["image_path"] = image_path
		element["image_mode"] = "contain"
		element["image_padding"] = 2.0
	_add_or_merge(elements, element)


static func _enhance_shared_position_arrays(source: String, elements: Array) -> void:
	var regex: RegEx = RegEx.new()
	regex.compile(
		"(?ms)(?:const|var)\\s+([A-Za-z_][A-Za-z0-9_]*_POSITIONS)\\s*(?::[^=\\n]+)?=\\s*\\[(.*?)\\]"
	)
	for array_match: RegExMatch in regex.search_all(source):
		var array_name: String = array_match.get_string(1)
		var base_name: String = array_name.trim_suffix("_POSITIONS")
		var size_data: Dictionary = _vector_constant_data(source, base_name + "_SIZE")
		if size_data.is_empty():
			continue
		var dimensions: Vector2 = size_data.get("value", Vector2(100.0, 100.0))
		var content: String = array_match.get_string(2)
		var content_start: int = array_match.get_start(2)
		var vectors: Array = _vector_literals(content, content_start, source)
		for index: int in range(vectors.size()):
			var data: Dictionary = vectors[index]
			var friendly: String = _friendly_array_name(array_name, index)
			var element: Dictionary = _base_element(
				"%s_%d" % [array_name, index],
				Rect2(data.get("value", Vector2.ZERO), dimensions),
				friendly,
				int(data.get("line", 0)),
				"Posición de tarjeta compartida · editable",
				"Panel"
			)
			element["kind"] = "position_only"
			element["span_a_start"] = int(data.get("start", -1))
			element["span_a_end"] = int(data.get("end", -1))
			element["editable"] = true
			element["allow_resize"] = false
			element["fill_color"] = Color(0.012, 0.020, 0.032, 0.90)
			element["border_color"] = Color("#D8B85E")
			element["border_width"] = 2.0
			element["corner_radius"] = 14.0
			element["text_color"] = Color("#F0E7D7")
			element["font_size"] = 16
			_add_or_merge(elements, element)


static func _apply_generic_image_modes(source: String, elements: Array) -> void:
	for index: int in range(elements.size()):
		if not (elements[index] is Dictionary):
			continue
		var element: Dictionary = elements[index]
		var name: String = str(element.get("name", ""))
		if str(element.get("image_path", "")).is_empty():
			continue
		if source.contains(name + ".stretch_mode = TextureRect.STRETCH_SCALE"):
			element["image_mode"] = "stretch"
		elif source.contains(name + ".stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED"):
			element["image_mode"] = "cover"
		else:
			element["image_mode"] = str(element.get("image_mode", "contain"))
		element["image_padding"] = float(element.get("image_padding", 0.0))
		elements[index] = element


static func _mark_function_templates(
	source: String, elements: Array, function_name: String, names: Array[String]
) -> void:
	var block: Dictionary = _function_block(source, function_name)
	if block.is_empty():
		return
	var start_line: int = _line_at(source, int(block.get("start", 0)))
	var end_line: int = _line_at(source, int(block.get("end", source.length())))
	for index: int in range(elements.size()):
		if not (elements[index] is Dictionary):
			continue
		var element: Dictionary = elements[index]
		var line: int = int(element.get("line", 0))
		if line < start_line or line > end_line:
			continue
		if names.has(str(element.get("name", ""))):
			element["template_only"] = true
			element["editable"] = false
			elements[index] = element


static func _mark_block_as_template(source: String, elements: Array, function_name: String) -> void:
	var block: Dictionary = _function_block(source, function_name)
	if block.is_empty():
		return
	var start_line: int = int(block.get("start_line", 0))
	var end_line: int = int(block.get("end_line", 1 << 30))
	for index: int in range(elements.size()):
		if not (elements[index] is Dictionary):
			continue
		var element: Dictionary = elements[index]
		var line: int = int(element.get("line", 0))
		if line >= start_line and line <= end_line:
			element["template_only"] = true
			element["editable"] = false
			elements[index] = element


static func _mark_range_view(elements: Array, block: Dictionary, view_tag: String) -> void:
	if block.is_empty():
		return
	var start_line: int = int(block.get("start_line", 0))
	var end_line: int = int(block.get("end_line", 1 << 30))
	for index: int in range(elements.size()):
		if not (elements[index] is Dictionary):
			continue
		var element: Dictionary = elements[index]
		var line: int = int(element.get("line", 0))
		if line >= start_line and line <= end_line:
			element["view_tag"] = view_tag
			elements[index] = element


static func _set_image(
	elements: Array, names: Array[String], path: String, mode: String, padding: float
) -> void:
	if path.is_empty():
		return
	for index: int in range(elements.size()):
		if not (elements[index] is Dictionary):
			continue
		var element: Dictionary = elements[index]
		var element_name: String = str(element.get("name", ""))
		if names.has(element_name) or names.has(str(element.get("friendly_name", ""))):
			element["image_path"] = path
			element["image_mode"] = mode
			element["image_padding"] = padding
			elements[index] = element


static func _set_region(elements: Array, names: Array[String], region: Rect2) -> void:
	if region.size == Vector2.ZERO:
		return
	for index: int in range(elements.size()):
		if not (elements[index] is Dictionary):
			continue
		var element: Dictionary = elements[index]
		if names.has(str(element.get("name", ""))):
			element["image_region"] = region
			element["image_mode"] = "region"
			elements[index] = element


static func _set_element_text(elements: Array, name: String, text: String) -> void:
	var index: int = _find_element(elements, name)
	if index < 0:
		return
	var element: Dictionary = elements[index]
	element["display_text"] = text
	elements[index] = element


static func _add_or_merge(elements: Array, new_element: Dictionary) -> void:
	var index: int = _find_element(elements, str(new_element.get("name", "")))
	if index < 0:
		elements.append(new_element)
		return
	var current: Dictionary = elements[index]
	for key: Variant in new_element.keys():
		current[key] = new_element[key]
	elements[index] = current


static func _find_element(elements: Array, name: String) -> int:
	for index: int in range(elements.size()):
		if (
			elements[index] is Dictionary
			and str((elements[index] as Dictionary).get("name", "")) == name
		):
			return index
	return -1


static func _base_element(
	name: String, rect: Rect2, text: String, line: int, source_kind: String, control_type: String
) -> Dictionary:
	return {
		"name": name,
		"rect": rect,
		"local_rect": rect,
		"kind": "derived",
		"span_a_start": -1,
		"span_a_end": -1,
		"span_b_start": -1,
		"span_b_end": -1,
		"line": line,
		"draw_order": line,
		"source_kind": source_kind,
		"dirty": false,
		"image_path": "",
		"display_text": text,
		"friendly_name": text if not text.is_empty() else name.capitalize(),
		"font_size": 0,
		"text_expression": "",
		"runtime_only": false,
		"editable": false,
		"allow_resize": true,
		"control_type": control_type,
		"preview_style": _style_for_type(control_type),
		"visible": true,
		"horizontal_alignment": HORIZONTAL_ALIGNMENT_CENTER,
		"vertical_alignment": VERTICAL_ALIGNMENT_CENTER,
		"text_color": Color(0.95, 0.95, 0.95, 1.0),
		"z_index": 0
	}


static func _style_for_type(type_name: String) -> String:
	match type_name:
		"Button", "OptionButton", "CheckBox":
			return "button"
		"Panel", "PanelContainer":
			return "panel"
		"TextureRect", "NinePatchRect":
			return "image"
		"ProgressBar", "TextureProgressBar":
			return "progress"
		_:
			return "label"


static func _function_block(source: String, function_name: String) -> Dictionary:
	var regex: RegEx = RegEx.new()
	regex.compile("(?m)^func\\s+" + function_name + "\\s*\\(")
	var match: RegExMatch = regex.search(source)
	if match == null:
		return {}
	var start: int = match.get_start(0)
	var next_regex: RegEx = RegEx.new()
	next_regex.compile("(?m)^func\\s+[A-Za-z_][A-Za-z0-9_]*\\s*\\(")
	var next_match: RegExMatch = next_regex.search(source, match.get_end(0))
	var end: int = next_match.get_start(0) if next_match != null else source.length()
	return {
		"start": start,
		"end": end,
		"start_line": _line_at(source, start),
		"end_line": _line_at(source, end),
		"text": source.substr(start, end - start)
	}


static func _vector_array_in_text(
	text: String, base: int, array_name: String, full_source: String
) -> Array:
	var regex: RegEx = RegEx.new()
	regex.compile("(?ms)(?:var|const)\\s+" + array_name + "\\s*(?::[^=\\n]+)?=\\s*\\[(.*?)\\]")
	var match: RegExMatch = regex.search(text)
	if match == null:
		return []
	return _vector_literals(match.get_string(1), base + match.get_start(1), full_source)


static func _vector_literals(text: String, absolute_base: int, source_for_lines: String) -> Array:
	var result: Array = []
	var regex: RegEx = RegEx.new()
	regex.compile(
		"(Vector2i?\\(\\s*([-+]?\\d+(?:\\.\\d+)?)\\s*,\\s*([-+]?\\d+(?:\\.\\d+)?)\\s*\\))"
	)
	for match: RegExMatch in regex.search_all(text):
		var absolute_start: int = absolute_base + match.get_start(1)
		result.append(
			{
				"value": Vector2(float(match.get_string(2)), float(match.get_string(3))),
				"start": absolute_start,
				"end": absolute_base + match.get_end(1),
				"line": _line_at(source_for_lines, absolute_start)
			}
		)
	return result


static func _property_vector_in_text(
	text: String, base: int, variable: String, property_name: String
) -> Dictionary:
	var regex: RegEx = RegEx.new()
	(
		regex
		. compile(
			(
				"(?m)^\\s*"
				+ variable
				+ "\\."
				+ property_name
				+ "\\s*=\\s*(Vector2i?\\(\\s*([-+]?\\d+(?:\\.\\d+)?)\\s*,\\s*([-+]?\\d+(?:\\.\\d+)?)\\s*\\))"
			)
		)
	)
	var match: RegExMatch = regex.search(text)
	if match == null:
		return {}
	return {
		"value": Vector2(float(match.get_string(2)), float(match.get_string(3))),
		"start": base + match.get_start(1),
		"end": base + match.get_end(1)
	}


static func _vector_constant_data(source: String, name: String) -> Dictionary:
	var regex: RegEx = RegEx.new()
	(
		regex
		. compile(
			(
				"(?m)^\\s*(?:const|var)\\s+"
				+ name
				+ "\\s*(?::[^=\\n]+)?=\\s*(Vector2i?\\(\\s*([-+]?\\d+(?:\\.\\d+)?)\\s*,\\s*([-+]?\\d+(?:\\.\\d+)?)\\s*\\))"
			)
		)
	)
	var match: RegExMatch = regex.search(source)
	if match == null:
		return {}
	return {
		"value": Vector2(float(match.get_string(2)), float(match.get_string(3))),
		"start": match.get_start(1),
		"end": match.get_end(1),
		"line": _line_at(source, match.get_start(1))
	}


static func _vector2_constant(source: String, name: String, fallback: Vector2 = Vector2.ZERO) -> Vector2:
	var regex: RegEx = RegEx.new()
	(
		regex
		. compile(
			(
				"(?m)^\\s*(?:const|var)\\s+"
				+ name
				+ "\\s*(?::[^=\\n]+)?=\\s*Vector2i?\\(\\s*([-+]?\\d+(?:\\.\\d+)?)\\s*,\\s*([-+]?\\d+(?:\\.\\d+)?)\\s*\\)"
			)
		)
	)
	var match: RegExMatch = regex.search(source)
	if match == null:
		return fallback
	return Vector2(float(match.get_string(1)), float(match.get_string(2)))


static func _set_z_index(elements: Array, names: Array[String], value: int) -> void:
	for index: int in range(elements.size()):
		if not (elements[index] is Dictionary):
			continue
		var element: Dictionary = elements[index]
		if names.has(str(element.get("name", ""))):
			element["z_index"] = value
			elements[index] = element


static func _path_for_variable(source: String, variable_name: String) -> String:
	var regex: RegEx = RegEx.new()
	(
		regex
		. compile(
			(
				"(?ms)(?:const|var)\\s+"
				+ variable_name
				+ "\\s*(?::[^=\\n]+)?=\\s*\\(?\\s*[\\\"'](res://[^\\\"']+\\.(?:png|jpg|jpeg|webp|svg))[\\\"']"
			)
		)
	)
	var match: RegExMatch = regex.search(source)
	return match.get_string(1) if match != null else ""


static func _best_image(images: Array, hints: Array[String]) -> String:
	for hint: String in hints:
		for raw_image: Variant in images:
			if not (raw_image is Dictionary):
				continue
			var image: Dictionary = raw_image
			var combined: String = (
				(str(image.get("name", "")) + " " + str(image.get("path", ""))).to_lower()
			)
			if combined.contains(hint.to_lower()):
				return str(image.get("path", ""))
	return ""


static func _rect_constant(source: String, name: String) -> Rect2:
	var regex: RegEx = RegEx.new()
	(
		regex
		. compile(
			(
				"(?m)^\\s*(?:const|var)\\s+"
				+ name
				+ "\\s*(?::[^=\\n]+)?=\\s*Rect2\\(\\s*([-+]?\\d+(?:\\.\\d+)?)\\s*,\\s*([-+]?\\d+(?:\\.\\d+)?)\\s*,\\s*([-+]?\\d+(?:\\.\\d+)?)\\s*,\\s*([-+]?\\d+(?:\\.\\d+)?)\\s*\\)"
			)
		)
	)
	var match: RegExMatch = regex.search(source)
	if match == null:
		return Rect2()
	return Rect2(
		float(match.get_string(1)),
		float(match.get_string(2)),
		float(match.get_string(3)),
		float(match.get_string(4))
	)


static func _string_dictionary(source: String, dictionary_name: String) -> Dictionary:
	var result: Dictionary = {}
	var regex: RegEx = RegEx.new()
	regex.compile(
		"(?ms)(?:const|var)\\s+" + dictionary_name + "\\s*(?::[^=\\n]+)?=\\s*\\{(.*?)\\n\\}"
	)
	var match: RegExMatch = regex.search(source)
	if match == null:
		return result
	var pair_regex: RegEx = RegEx.new()
	pair_regex.compile("[\\\"']([^\\\"']+)[\\\"']\\s*:\\s*[\\\"']([^\\\"']+)[\\\"']")
	for pair: RegExMatch in pair_regex.search_all(match.get_string(1)):
		result[pair.get_string(1)] = pair.get_string(2)
	return result


static func _translation_value(source: String, key: String, fallback: String) -> String:
	var regex: RegEx = RegEx.new()
	regex.compile("[\\\"']" + key + "[\\\"']\\s*:\\s*[\\\"']([^\\\"']*)[\\\"']")
	var match: RegExMatch = regex.search(source)
	return match.get_string(1).replace("\\n", "\n") if match != null else fallback


static func _search(text: String, pattern: String) -> RegExMatch:
	var regex: RegEx = RegEx.new()
	regex.compile(pattern)
	return regex.search(text)


static func _friendly_array_name(array_name: String, index: int) -> String:
	var lower: String = array_name.to_lower()
	if lower.contains("faction"):
		return "Facción %d" % (index + 1)
	if lower.contains("character") or lower.contains("personaje"):
		return "Personaje %d" % (index + 1)
	return "%s %d" % [array_name.capitalize(), index + 1]


static func _sort_by_layer(elements: Array) -> void:
	elements.sort_custom(
		func(a: Dictionary, b: Dictionary) -> bool:
			var za: int = int(a.get("z_index", 0))
			var zb: int = int(b.get("z_index", 0))
			if za != zb:
				return za < zb
			return (
				int(a.get("draw_order", a.get("line", 0)))
				< int(b.get("draw_order", b.get("line", 0)))
			)
	)


static func _line_at(source: String, index: int) -> int:
	if index <= 0:
		return 1
	return source.substr(0, mini(index, source.length())).count("\n") + 1
