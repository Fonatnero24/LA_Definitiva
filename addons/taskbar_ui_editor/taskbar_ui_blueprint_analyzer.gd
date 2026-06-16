@tool
extends RefCounted

const GOLD: Color = Color("#E7C45E")
const GOLD_BRIGHT: Color = Color("#FFE59A")
const EMERALD: Color = Color("#4CF0A5")
const TEXT: Color = Color("#F5EBD7")
const MUTED: Color = Color("#DDD3C0")


static func apply(
	path: String,
	source: String,
	input_elements: Array,
	images: Array,
	fallback_canvas: Vector2
) -> Dictionary:
	var elements: Array = input_elements
	var module: String = _detect_module(path, source)
	if module.is_empty():
		return {
			"elements": elements,
			"canvas_size": fallback_canvas,
			"views": [],
			"default_view": "all",
			"background_path": ""
		}

	_mark_all_as_templates(elements)
	match module:
		"shop":
			return _build_shop(source, elements, images)
		"forge":
			return _build_forge(source, elements, images)
		"inventory":
			return _build_inventory(source, elements, images)
		"selection":
			return _build_selection(source, elements, images)
		"skills":
			return _build_skill_tree(source, elements, images)
		"main_menu":
			return _build_main_menu(source, elements)
		"atlas":
			return _build_generic_module(
				source,
				elements,
				images,
				_vector_constant(source, "BASE_UI_SIZE", Vector2(900.0, 240.0)),
				["atlas", "mapa", "mundo"]
			)
		"main":
			return _build_generic_module(
				source,
				elements,
				images,
				_vector_constant(source, "BASE_UI_SIZE", Vector2(900.0, 240.0)),
				["0-1", "mundo1", "valdoria"]
			)
		_:
			return {
				"elements": elements,
				"canvas_size": fallback_canvas,
				"views": [],
				"default_view": "all",
				"background_path": ""
			}


static func _detect_module(path: String, source: String) -> String:
	var normalized: String = path.get_file().get_basename().to_lower()
	if normalized.contains("tienda") or source.contains("class_name TiendaUI"):
		return "shop"
	if normalized.contains("forja") or source.contains("class_name ForjaUI"):
		return "forge"
	if normalized.contains("inventario") or source.contains("class_name InventarioUI"):
		return "inventory"
	if normalized.contains("menu_principal") or source.contains("TASKBAR ADVENTURES RPG"):
		return "main_menu"
	if normalized.contains("seleccion") or source.contains("enum ScreenMode"):
		return "selection"
	if normalized.contains("arbol") or source.contains("class_name ArbolHabilidadesUI"):
		return "skills"
	if normalized.contains("mapa_mundos") or normalized.contains("atlas"):
		return "atlas"
	if normalized == "main":
		return "main"
	return ""


static func _mark_all_as_templates(elements: Array) -> void:
	for index: int in range(elements.size()):
		if not (elements[index] is Dictionary):
			continue
		var element: Dictionary = elements[index]
		element["template_only"] = true
		elements[index] = element


static func _build_shop(source: String, elements: Array, images: Array) -> Dictionary:
	var canvas_size: Vector2 = _vector_constant(
		source, "REFERENCE_SIZE", Vector2(1448.0, 1086.0)
	)
	var background_path: String = _resource_variable(source, "shop_background_path")
	if background_path.is_empty():
		background_path = _best_image(images, ["/tienda/tienda_base", "tienda_base"])
	var merchant_path: String = _resource_variable(source, "merchant_texture_path")
	if merchant_path.is_empty():
		merchant_path = _best_image(images, ["elfa_tendera", "lyria", "merchant"])

	_upsert_texture(
		elements,
		"background_rect",
		Rect2(Vector2.ZERO, canvas_size),
		background_path,
		"stretch",
		-40
	)
	_upsert_texture(
		elements,
		"merchant_rect",
		_source_rect(
			source,
			"merchant_rect",
			Rect2(Vector2(972.0, 58.0), Vector2(360.0, 465.0))
		),
		merchant_path,
		"contain",
		4
	)
	var counter_region: Rect2 = _rect_constant(
		source,
		"MERCHANT_COUNTER_REGION",
		Rect2(900.0, 395.0, 505.0, 175.0)
	)
	var counter: Dictionary = _visual_element(
		"merchant_counter_overlay", counter_region, "", "TextureRect", 5
	)
	counter["image_path"] = background_path
	counter["image_mode"] = "region"
	counter["image_region"] = counter_region
	_upsert(elements, counter)

	_upsert_label(
		elements,
		"gold_label",
		_source_rect(
			source,
			"gold_label",
			Rect2(Vector2(48.0, 26.0), Vector2(238.0, 62.0))
		),
		"ORO: 4684",
		31,
		GOLD_BRIGHT,
		HORIZONTAL_ALIGNMENT_CENTER,
		7
	)
	_upsert_label(
		elements,
		"title_label",
		_source_rect(
			source,
			"title_label",
			Rect2(Vector2(320.0, 18.0), Vector2(600.0, 75.0))
		),
		_translation(source, "title", "TIENDA ERRANTE DE LYRIA"),
		40,
		GOLD_BRIGHT,
		HORIZONTAL_ALIGNMENT_CENTER,
		7
	)
	_upsert_button(
		elements,
		"close_button",
		_source_rect(
			source,
			"close_button",
			Rect2(Vector2(1370.0, 20.0), Vector2(54.0, 54.0))
		),
		"×",
		26,
		Color(0.28, 0.035, 0.045, 0.96),
		Color("#CF5B61"),
		7
	)

	_build_shop_categories(source, elements)
	_build_shop_products(source, elements)

	_upsert_label(
		elements,
		"merchant_name_label",
		_source_rect(
			source,
			"merchant_name_label",
			Rect2(Vector2(950.0, 446.0), Vector2(420.0, 38.0))
		),
		_translation(source, "merchant_name", "LYRIA · MERCADERA DEL VELO"),
		23,
		GOLD_BRIGHT,
		HORIZONTAL_ALIGNMENT_CENTER,
		8
	)
	_upsert_label(
		elements,
		"merchant_quote_label",
		_source_rect(
			source,
			"merchant_quote_label",
			Rect2(Vector2(972.0, 482.0), Vector2(376.0, 56.0))
		),
		_translation(
			source,
			"merchant_quote",
			"Toda ruta esconde un tesoro. Algunas también esconden dientes."
		),
		18,
		MUTED,
		HORIZONTAL_ALIGNMENT_CENTER,
		8
	)

	var icon_paths: Dictionary = _string_dictionary(source, "PRODUCT_ICON_PATHS")
	var products: Array = _parse_shop_products(source)
	var selected: Dictionary = products[0] if not products.is_empty() else {}
	var selected_icon: String = str(
		icon_paths.get(str(selected.get("icon_key", "pocion_menor")), "")
	)
	_upsert_texture(
		elements,
		"detail_icon",
		_source_rect(
			source,
			"detail_icon",
			Rect2(Vector2(960.0, 575.0), Vector2(130.0, 130.0))
		),
		selected_icon,
		"contain",
		8
	)
	_upsert_label(
		elements,
		"detail_name_label",
		_source_rect(
			source,
			"detail_name_label",
			Rect2(Vector2(1090.0, 550.0), Vector2(275.0, 46.0))
		),
		str(selected.get("name", "POCIÓN MENOR DE VIDA")),
		27,
		EMERALD,
		HORIZONTAL_ALIGNMENT_CENTER,
		8
	)
	_upsert_label(
		elements,
		"detail_rarity_label",
		_source_rect(
			source,
			"detail_rarity_label",
			Rect2(Vector2(1090.0, 596.0), Vector2(275.0, 30.0))
		),
		"COMÚN",
		19,
		GOLD,
		HORIZONTAL_ALIGNMENT_CENTER,
		8
	)
	_upsert_label(
		elements,
		"detail_description_label",
		_source_rect(
			source,
			"detail_description_label",
			Rect2(Vector2(1098.0, 635.0), Vector2(260.0, 115.0))
		),
		str(selected.get("description", "Restaura 25 puntos de vida. Se puede acumular.")),
		19,
		TEXT,
		HORIZONTAL_ALIGNMENT_LEFT,
		8
	)
	_upsert_label(
		elements,
		"quantity_title_label",
		_source_rect(
			source,
			"quantity_title_label",
			Rect2(Vector2(1040.0, 792.0), Vector2(250.0, 30.0))
		),
		_translation(source, "quantity", "CANTIDAD"),
		19,
		EMERALD,
		HORIZONTAL_ALIGNMENT_CENTER,
		8
	)
	_upsert_button(
		elements,
		"minus_button",
		_source_rect(
			source,
			"minus_button",
			Rect2(Vector2(1030.0, 828.0), Vector2(58.0, 48.0))
		),
		"◀",
		18,
		Color(0.012, 0.026, 0.038, 0.98),
		GOLD,
		8
	)
	_upsert_button(
		elements,
		"quantity_value_label",
		_source_rect(
			source,
			"quantity_value_label",
			Rect2(Vector2(1100.0, 828.0), Vector2(170.0, 48.0))
		),
		"1",
		25,
		Color(0.004, 0.008, 0.012, 0.94),
		Color(0.32, 0.28, 0.20, 0.80),
		8
	)
	_upsert_button(
		elements,
		"plus_button",
		_source_rect(
			source,
			"plus_button",
			Rect2(Vector2(1280.0, 828.0), Vector2(58.0, 48.0))
		),
		"▶",
		18,
		Color(0.012, 0.026, 0.038, 0.98),
		GOLD,
		8
	)
	_upsert_label(
		elements,
		"total_label",
		_source_rect(
			source,
			"total_label",
			Rect2(Vector2(985.0, 890.0), Vector2(380.0, 42.0))
		),
		"TOTAL: %d" % int(selected.get("price", 120)),
		25,
		GOLD_BRIGHT,
		HORIZONTAL_ALIGNMENT_CENTER,
		8
	)
	_upsert_button(
		elements,
		"buy_button",
		_source_rect(
			source,
			"buy_button",
			Rect2(Vector2(990.0, 940.0), Vector2(370.0, 72.0))
		),
		_translation(source, "buy", "COMPRAR"),
		30,
		Color(0.14, 0.36, 0.05, 0.98),
		Color("#A7DC39"),
		8
	)
	_upsert_label(
		elements,
		"region_label",
		_source_rect(
			source,
			"region_label",
			Rect2(Vector2(42.0, 1020.0), Vector2(350.0, 42.0))
		),
		"Mercancía vinculada a Ruta de Valdoria",
		17,
		EMERALD,
		HORIZONTAL_ALIGNMENT_LEFT,
		8
	)
	_upsert_label(
		elements,
		"footer_label",
		_source_rect(
			source,
			"footer_label",
			Rect2(Vector2(395.0, 1020.0), Vector2(540.0, 42.0))
		),
		_translation(
			source,
			"footer",
			"Nuevas leyendas nacen cuando alguien decide pagar el precio."
		),
		18,
		GOLD,
		HORIZONTAL_ALIGNMENT_CENTER,
		8
	)

	_make_shop_controls_editable(source, elements)

	return {
		"elements": elements,
		"canvas_size": canvas_size,
		"views": [],
		"default_view": "all",
		"background_path": background_path
	}


static func _build_shop_categories(source: String, elements: Array) -> void:
	var entries: Array = [
		{"key": "recommended", "text": "RECOMENDADO", "y": 116.0},
		{"key": "potions", "text": "POCIONES", "y": 207.0},
		{"key": "chests", "text": "COFRES DE RANGO", "y": 298.0},
		{"key": "all", "text": "TODO", "y": 389.0}
	]
	for index: int in range(entries.size()):
		var data: Dictionary = entries[index]
		var selected: bool = index == 0
		var element: Dictionary = _visual_element(
			"shop_category_%d" % index,
			Rect2(Vector2(34.0, float(data["y"])), Vector2(235.0, 76.0)),
			_translation(source, str(data["key"]), str(data["text"])),
			"Button",
			9
		)
		element["font_size"] = 23
		element["fill_color"] = (
			Color(0.02, 0.07, 0.055, 0.94)
			if selected
			else Color(0.006, 0.015, 0.020, 0.84)
		)
		element["border_color"] = EMERALD if selected else Color(0.55, 0.40, 0.16, 0.68)
		element["border_width"] = 2.0 if selected else 1.0
		element["corner_radius"] = 5.0
		element["text_color"] = TEXT
		_upsert(elements, element)


static func _build_shop_products(source: String, elements: Array) -> void:
	var products: Array = _parse_shop_products(source)
	var icon_paths: Dictionary = _string_dictionary(source, "PRODUCT_ICON_PATHS")
	var start_x_data: Dictionary = _number_variable_data(source, "start_x", 305.0)
	var start_y_data: Dictionary = _number_variable_data(source, "start_y", 130.0)
	var start: Vector2 = Vector2(
		float(start_x_data.get("value", 305.0)),
		float(start_y_data.get("value", 130.0))
	)
	var card_size: Vector2 = Vector2(280.0, 140.0)
	var gap: Vector2 = Vector2(20.0, 20.0)
	var grid_driver: Dictionary = _visual_element(
		"shop_product_grid_origin",
		Rect2(start, Vector2(580.0, 780.0)),
		"",
		"Control",
		-1
	)
	grid_driver["friendly_name"] = "Rejilla de productos (mover todo)"
	grid_driver["kind"] = "scalar_position"
	grid_driver["span_x_start"] = int(start_x_data.get("start", -1))
	grid_driver["span_x_end"] = int(start_x_data.get("end", -1))
	grid_driver["span_y_start"] = int(start_y_data.get("start", -1))
	grid_driver["span_y_end"] = int(start_y_data.get("end", -1))
	grid_driver["runtime_only"] = false
	grid_driver["editable"] = (
		int(grid_driver["span_x_start"]) >= 0 and int(grid_driver["span_y_start"]) >= 0
	)
	grid_driver["allow_resize"] = false
	grid_driver["fill_color"] = Color.TRANSPARENT
	grid_driver["border_color"] = Color.TRANSPARENT
	_upsert(elements, grid_driver)

	for index: int in range(10):
		var column: int = index % 2
		var row: int = index >> 1
		var position: Vector2 = start + Vector2(
			float(column) * (card_size.x + gap.x),
			float(row) * (card_size.y + gap.y)
		)
		var visible_count: int = mini(6, products.size())
		var product: Dictionary = products[index] if index < visible_count else {}
		var card_name: String = "shop_product_card_%02d" % index
		var card: Dictionary = _visual_element(
			card_name,
			Rect2(position, card_size),
			"",
			"Button",
			7
		)
		card["fill_color"] = Color(0.005, 0.010, 0.014, 0.36)
		card["border_color"] = Color(0.30, 0.22, 0.12, 0.55)
		card["border_width"] = 1.0
		card["corner_radius"] = 5.0
		card["linked_to"] = "shop_product_grid_origin"
		card["linked_offset"] = position - start
		card["drag_driver"] = "shop_product_grid_origin"
		_upsert(elements, card)
		if product.is_empty():
			continue
		var icon_path: String = str(
			icon_paths.get(str(product.get("icon_key", "")), "")
		)
		var icon_name: String = "shop_product_icon_%02d" % index
		var icon: Dictionary = _visual_element(
			icon_name,
			Rect2(position + Vector2(12.0, 24.0), Vector2(76.0, 76.0)),
			"",
			"TextureRect",
			10
		)
		icon["image_path"] = icon_path
		icon["image_mode"] = "contain"
		icon["linked_to"] = "shop_product_grid_origin"
		icon["linked_offset"] = position + Vector2(12.0, 24.0) - start
		icon["drag_driver"] = "shop_product_grid_origin"
		_upsert(elements, icon)
		var name_label: String = "shop_product_name_%02d" % index
		_upsert_label(
			elements,
			name_label,
			Rect2(position + Vector2(94.0, 12.0), Vector2(174.0, 34.0)),
			str(product.get("name", "")),
			22,
			TEXT,
			HORIZONTAL_ALIGNMENT_LEFT,
			10
		)
		_link_element(
			elements,
			name_label,
			"shop_product_grid_origin",
			position + Vector2(94.0, 12.0) - start
		)
		_set_drag_driver(elements, name_label, "shop_product_grid_origin")
		var desc_label: String = "shop_product_desc_%02d" % index
		_upsert_label(
			elements,
			desc_label,
			Rect2(position + Vector2(94.0, 45.0), Vector2(174.0, 58.0)),
			str(product.get("description", "")),
			17,
			MUTED,
			HORIZONTAL_ALIGNMENT_LEFT,
			10
		)
		_link_element(
			elements,
			desc_label,
			"shop_product_grid_origin",
			position + Vector2(94.0, 45.0) - start
		)
		_set_drag_driver(elements, desc_label, "shop_product_grid_origin")
		var price_label: String = "shop_product_price_%02d" % index
		_upsert_label(
			elements,
			price_label,
			Rect2(position + Vector2(94.0, 104.0), Vector2(174.0, 28.0)),
			"◆ %d" % int(product.get("price", 0)),
			20,
			GOLD_BRIGHT,
			HORIZONTAL_ALIGNMENT_LEFT,
			10
		)
		_link_element(
			elements,
			price_label,
			"shop_product_grid_origin",
			position + Vector2(94.0, 104.0) - start
		)
		_set_drag_driver(elements, price_label, "shop_product_grid_origin")


static func _make_shop_controls_editable(source: String, elements: Array) -> void:
	var call_controls: Array[String] = [
		"gold_label",
		"title_label",
		"close_button",
		"merchant_name_label",
		"merchant_quote_label",
		"detail_name_label",
		"detail_rarity_label",
		"detail_description_label",
		"quantity_title_label",
		"minus_button",
		"quantity_value_label",
		"plus_button",
		"total_label",
		"buy_button",
		"status_label",
		"region_label",
		"footer_label"
	]
	for control_name: String in call_controls:
		_attach_call_rect_source(source, elements, control_name)

	_attach_property_rect_source(source, elements, "merchant_rect")
	_attach_property_rect_source(source, elements, "detail_icon")
	_attach_shop_category_sources(source, elements)


static func _attach_call_rect_source(source: String, elements: Array, variable_name: String) -> void:
	var number: String = "[-+]?\\d+(?:\\.\\d+)?"
	var regex: RegEx = RegEx.new()
	regex.compile(
		"(?ms)^\\s*"
		+ variable_name
		+ "\\s*=\\s*_[A-Za-z0-9_]+\\s*\\(.*?"
		+ "(Vector2\\(\\s*"
		+ number
		+ "\\s*,\\s*"
		+ number
		+ "\\s*\\)).*?"
		+ "(Vector2\\(\\s*"
		+ number
		+ "\\s*,\\s*"
		+ number
		+ "\\s*\\))"
	)
	var match: RegExMatch = regex.search(source)
	if match == null:
		return
	_mark_element_source_spans(
		elements,
		variable_name,
		match.get_start(1),
		match.get_end(1),
		match.get_start(2),
		match.get_end(2),
		_line_at(source, match.get_start(1))
	)


static func _attach_property_rect_source(source: String, elements: Array, variable_name: String) -> void:
	var position_data: Dictionary = _property_vector_data(source, variable_name, "position")
	var size_data: Dictionary = _property_vector_data(source, variable_name, "size")
	if position_data.is_empty() or size_data.is_empty():
		return
	_mark_element_source_spans(
		elements,
		variable_name,
		int(position_data.get("start", -1)),
		int(position_data.get("end", -1)),
		int(size_data.get("start", -1)),
		int(size_data.get("end", -1)),
		int(position_data.get("line", 0))
	)


static func _mark_element_source_spans(
	elements: Array,
	name: String,
	position_start: int,
	position_end: int,
	size_start: int,
	size_end: int,
	line: int
) -> void:
	var index: int = _find_element(elements, name)
	if index < 0:
		return
	if position_start < 0 or position_end <= position_start:
		return
	if size_start < 0 or size_end <= size_start:
		return
	var element: Dictionary = elements[index]
	element["kind"] = "position_size"
	element["span_a_start"] = position_start
	element["span_a_end"] = position_end
	element["span_b_start"] = size_start
	element["span_b_end"] = size_end
	element["line"] = line
	element["source_kind"] = "Posición y tamaño editables del script"
	element["runtime_only"] = false
	element["editable"] = true
	element["allow_resize"] = true
	elements[index] = element


static func _property_vector_data(source: String, variable_name: String, property_name: String) -> Dictionary:
	var regex: RegEx = RegEx.new()
	regex.compile(
		"(?m)^\\s*"
		+ variable_name
		+ "\\."
		+ property_name
		+ "\\s*=\\s*(Vector2\\(\\s*[-+]?\\d+(?:\\.\\d+)?\\s*,\\s*[-+]?\\d+(?:\\.\\d+)?\\s*\\))"
	)
	var match: RegExMatch = regex.search(source)
	if match == null:
		return {}
	return {
		"start": match.get_start(1),
		"end": match.get_end(1),
		"line": _line_at(source, match.get_start(1))
	}


static func _attach_shop_category_sources(source: String, elements: Array) -> void:
	var x_regex: RegEx = RegEx.new()
	x_regex.compile(
		"(?ms)func\\s+_build_categories\\s*\\([^)]*\\).*?"
		+ "Vector2\\(\\s*([-+]?\\d+(?:\\.\\d+)?)\\s*,\\s*float\\(definition\\.get\\(\\s*[\\\"']y[\\\"']"
	)
	var x_match: RegExMatch = x_regex.search(source)
	if x_match == null:
		return
	var x_start: int = x_match.get_start(1)
	var x_end: int = x_match.get_end(1)

	var y_regex: RegEx = RegEx.new()
	y_regex.compile(
		"[\\\"']key[\\\"']\\s*:\\s*[\\\"']([^\\\"']+)[\\\"'][^\\n\\}]*"
		+ "[\\\"']y[\\\"']\\s*:\\s*([-+]?\\d+(?:\\.\\d+)?)"
	)
	var matches: Array[RegExMatch] = y_regex.search_all(source)
	var expected_keys: Array[String] = ["recommended", "potions", "chests", "all"]
	for index: int in range(expected_keys.size()):
		var selected_match: RegExMatch = null
		for candidate: RegExMatch in matches:
			if candidate.get_string(1) == expected_keys[index]:
				selected_match = candidate
				break
		if selected_match == null:
			continue
		var element_index: int = _find_element(elements, "shop_category_%d" % index)
		if element_index < 0:
			continue
		var element: Dictionary = elements[element_index]
		element["kind"] = "scalar_position"
		element["span_x_start"] = x_start
		element["span_x_end"] = x_end
		element["span_y_start"] = selected_match.get_start(2)
		element["span_y_end"] = selected_match.get_end(2)
		element["line"] = _line_at(source, selected_match.get_start(2))
		element["source_kind"] = "Botón de categoría editable"
		element["runtime_only"] = false
		element["editable"] = true
		element["allow_resize"] = false
		element["shared_x_group"] = "shop_categories"
		elements[element_index] = element


static func _set_drag_driver(elements: Array, name: String, driver_name: String) -> void:
	var index: int = _find_element(elements, name)
	if index < 0:
		return
	var element: Dictionary = elements[index]
	element["drag_driver"] = driver_name
	elements[index] = element


static func _build_forge(source: String, elements: Array, images: Array) -> Dictionary:
	var canvas_size: Vector2 = _vector_constant(
		source, "REFERENCE_SIZE", Vector2(1666.0, 922.0)
	)
	var background_path: String = _resource_variable(source, "forge_background_path")
	if background_path.is_empty():
		background_path = _best_image(images, ["forja_pixel", "forja"])
	_upsert_texture(
		elements,
		"background_rect",
		Rect2(Vector2.ZERO, canvas_size),
		background_path,
		"stretch",
		-40
	)
	_upsert_label(
		elements,
		"title_label",
		_source_rect(
			source,
			"title_label",
			Rect2(Vector2(699.0, 170.0), Vector2(746.0, 35.0))
		),
		"FORJA ANCESTRAL",
		28,
		Color("#F3CE72"),
		HORIZONTAL_ALIGNMENT_CENTER,
		6
	)
	_upsert_label(
		elements,
		"description_label",
		_source_rect(
			source,
			"description_label",
			Rect2(Vector2(703.0, 206.0), Vector2(742.0, 28.0))
		),
		"Coloca 10 objetos de la misma rareza. La forja los consumirá y creará un objeto aleatorio del siguiente grado.",
		15,
		Color("#D8D0C2"),
		HORIZONTAL_ALIGNMENT_CENTER,
		6
	)
	for index: int in range(10):
		var fallback: Rect2 = Rect2(
			Vector2(708.0 + float(index % 5) * 160.0, 404.0 + float(index / 5) * 146.0),
			Vector2(104.0, 104.0)
		)
		var slot_rect: Rect2 = _rect_array_item(source, "SLOT_RECTS", index, fallback)
		var slot: Dictionary = _visual_element(
			"SLOT_RECTS_%d" % index, slot_rect, "", "Button", 8
		)
		slot["fill_color"] = Color(0.005, 0.010, 0.014, 0.12)
		slot["border_color"] = Color(0.72, 0.52, 0.18, 0.82)
		slot["border_width"] = 2.0
		slot["corner_radius"] = 8.0
		_upsert(elements, slot)
	_upsert_label(
		elements,
		"progress_label",
		_source_rect(
			source,
			"progress_label",
			Rect2(Vector2(690.0, 681.0), Vector2(750.0, 28.0))
		),
		"0 / 10 OBJETOS",
		17,
		Color("#F1D275"),
		HORIZONTAL_ALIGNMENT_CENTER,
		8
	)
	_upsert_label(
		elements,
		"status_label",
		_source_rect(
			source,
			"status_label",
			Rect2(Vector2(692.0, 716.0), Vector2(765.0, 33.0))
		),
		"Necesitas 10 objetos de la misma rareza.",
		14,
		Color("#E9E0D2"),
		HORIZONTAL_ALIGNMENT_CENTER,
		8
	)
	_upsert_button(
		elements,
		"clear_button",
		_source_rect(
			source,
			"clear_button",
			Rect2(Vector2(290.0, 803.0), Vector2(260.0, 43.0))
		),
		"VACIAR",
		18,
		Color("#1D2730"),
		Color("#C79A43"),
		8
	)
	_upsert_button(
		elements,
		"forge_button",
		_source_rect(
			source,
			"forge_button",
			Rect2(Vector2(1108.0, 803.0), Vector2(260.0, 43.0))
		),
		"MEJORAR",
		18,
		Color("#4A1F08"),
		Color("#FFB34D"),
		8
	)
	_upsert_button(
		elements,
		"close_button",
		_source_rect(
			source,
			"close_button",
			Rect2(Vector2(1493.0, 133.0), Vector2(42.0, 42.0))
		),
		"×",
		24,
		Color("#42100E"),
		Color("#E3AF42"),
		9
	)
	return {
		"elements": elements,
		"canvas_size": canvas_size,
		"views": [],
		"default_view": "all",
		"background_path": background_path
	}


static func _build_inventory(source: String, elements: Array, images: Array) -> Dictionary:
	var canvas_size: Vector2 = _vector_constant(
		source, "REFERENCE_SIZE", Vector2(1672.0, 941.0)
	)
	var background_path: String = _resource_variable(source, "inventory_background_path")
	if background_path.is_empty():
		background_path = _best_image(images, ["inventario_rpg_base", "inventario"])
	var character_path: String = _resource_variable(source, "character_texture_path")
	if character_path.is_empty():
		character_path = _best_image(images, ["paladin1", "paladin"])
	_upsert_texture(
		elements,
		"background",
		Rect2(Vector2.ZERO, canvas_size),
		background_path,
		"stretch",
		-40
	)
	_upsert_label(
		elements,
		"inventory_title_label",
		_source_rect(
			source,
			"inventory_title_label",
			Rect2(Vector2(500.0, 48.0), Vector2(672.0, 62.0))
		),
		"INVENTARIO",
		42,
		Color("#F4D47A"),
		HORIZONTAL_ALIGNMENT_CENTER,
		8
	)
	_upsert_label(
		elements,
		"inventory_subtitle_label",
		_source_rect(
			source,
			"inventory_subtitle_label",
			Rect2(Vector2(540.0, 104.0), Vector2(592.0, 30.0))
		),
		"EQUIPO DEL CAMPEÓN",
		18,
		Color("#9DD7FF"),
		HORIZONTAL_ALIGNMENT_CENTER,
		8
	)
	_upsert_texture(
		elements,
		"character_preview",
		_source_rect(
			source,
			"character_preview",
			Rect2(Vector2(260.0, 176.0), Vector2(330.0, 330.0))
		),
		character_path,
		"contain",
		7
	)
	_upsert_label(
		elements,
		"roster_title",
		Rect2(Vector2(278.0, 96.0), Vector2(300.0, 26.0)),
		"CAMPEONES",
		13,
		Color("#F3D77A"),
		HORIZONTAL_ALIGNMENT_CENTER,
		9
	)
	var roster_positions: Array[Vector2] = [
		Vector2(282.0, 124.0),
		Vector2(382.0, 124.0),
		Vector2(482.0, 124.0)
	]
	var roster_texts: Array[String] = ["◆ PAL\nNv.14", "◆ ARQ", "◆ ARC"]
	for index: int in range(3):
		var element_name: String = "inventory_character_slot_%d" % index
		var existing_index: int = _find_element(elements, element_name)
		var position: Vector2 = roster_positions[index]
		if existing_index >= 0:
			var existing: Dictionary = elements[existing_index]
			var existing_rect: Rect2 = existing.get(
				"rect", Rect2(position, Vector2.ZERO)
			)
			position = existing_rect.position
		var button: Dictionary = _visual_element(
			element_name,
			Rect2(position, Vector2(92.0, 54.0)),
			roster_texts[index],
			"Button",
			10
		)
		button["font_size"] = 11
		button["fill_color"] = Color(0.02, 0.04, 0.06, 0.94)
		button["border_color"] = [
			Color("#F4D47A"), Color("#7BCF8B"), Color("#B08BD8")
		][index]
		button["border_width"] = 2.0
		button["corner_radius"] = 9.0
		_upsert(elements, button)

	var equipment_names: Array[String] = [
		"casco", "armadura", "guantes", "botas", "arma", "estandarte",
		"amuleto", "reliquia", "anillo_1", "anillo_2", "escudo"
	]
	for slot_name: String in equipment_names:
		var slot_rect: Rect2 = _dictionary_rect(source, "EQUIPMENT_SLOT_RECTS", slot_name)
		if slot_rect.size == Vector2.ZERO:
			continue
		var slot_element_name: String = _first_existing_name(
			elements,
			[slot_name, "EQUIPMENT_SLOT_RECTS_%s" % slot_name, "equipment_%s" % slot_name],
			"equipment_%s" % slot_name
		)
		var slot: Dictionary = _visual_element(
			slot_element_name, slot_rect, "", "Button", 8
		)
		slot["fill_color"] = Color(0.0, 0.0, 0.0, 0.02)
		slot["border_color"] = Color(0.78, 0.58, 0.18, 0.25)
		slot["border_width"] = 1.0
		slot["corner_radius"] = 8.0
		_upsert(elements, slot)

	_upsert_label(
		elements,
		"attributes_title_label",
		_source_rect(
			source,
			"attributes_title_label",
			Rect2(Vector2(245.0, 648.0), Vector2(350.0, 30.0))
		),
		"ATRIBUTOS",
		18,
		Color("#F0C965"),
		HORIZONTAL_ALIGNMENT_CENTER,
		8
	)
	_upsert_label(
		elements,
		"character_progress_label",
		_source_rect(
			source,
			"character_progress_label",
			Rect2(Vector2(245.0, 842.0), Vector2(350.0, 28.0))
		),
		"NIVEL 14 · EXP 251 / 1489",
		14,
		Color("#9FD9FF"),
		HORIZONTAL_ALIGNMENT_CENTER,
		8
	)
	_build_inventory_stats(elements)
	_build_inventory_tabs(source, elements)
	_build_inventory_grid(source, elements)
	_upsert_label(
		elements,
		"gold_label",
		_source_rect(
			source,
			"gold_label",
			Rect2(Vector2(815.0, 699.0), Vector2(175.0, 42.0))
		),
		"4684",
		18,
		Color("#F1CA62"),
		HORIZONTAL_ALIGNMENT_LEFT,
		8
	)
	_upsert_label(
		elements,
		"capacity_label",
		_source_rect(
			source,
			"capacity_label",
			Rect2(Vector2(1097.0, 699.0), Vector2(160.0, 42.0))
		),
		"4 / 40",
		18,
		Color("#A9D7FF"),
		HORIZONTAL_ALIGNMENT_CENTER,
		8
	)
	_upsert_label(
		elements,
		"selected_item_label",
		_source_rect(
			source,
			"selected_item_label",
			Rect2(Vector2(790.0, 742.0), Vector2(690.0, 34.0))
		),
		"Arrastra un objeto para equiparlo",
		16,
		Color("#D9CFB8"),
		HORIZONTAL_ALIGNMENT_CENTER,
		8
	)
	_build_inventory_actions(elements)
	return {
		"elements": elements,
		"canvas_size": canvas_size,
		"views": [],
		"default_view": "all",
		"background_path": background_path
	}


static func _build_inventory_stats(elements: Array) -> void:
	var rows: Array = [
		{"id": "vida", "name": "VIDA", "value": "346", "position": Vector2(166.0, 696.0)},
		{"id": "dano", "name": "DAÑO", "value": "37", "position": Vector2(166.0, 746.0)},
		{"id": "def", "name": "DEF", "value": "37", "position": Vector2(166.0, 796.0)},
		{"id": "vel", "name": "VEL", "value": "25", "position": Vector2(452.0, 696.0)},
		{"id": "magia", "name": "MAGIA", "value": "18", "position": Vector2(452.0, 746.0)}
	]
	for data: Dictionary in rows:
		var base_name: String = "inventory_stat_%s_name" % str(data["id"])
		var position: Vector2 = data["position"]
		var driver_index: int = _find_element(elements, base_name)
		if driver_index >= 0:
			var driver_element: Dictionary = elements[driver_index]
			var driver_rect: Rect2 = driver_element.get(
				"rect", Rect2(position, Vector2.ZERO)
			)
			position = driver_rect.position
		_upsert_label(
			elements,
			base_name,
			Rect2(position, Vector2(115.0, 28.0)),
			str(data["name"]),
			15,
			Color("#E9C66D"),
			HORIZONTAL_ALIGNMENT_LEFT,
			9
		)
		var value: Dictionary = _visual_element(
			"inventory_stat_%s_value" % str(data["id"]),
			Rect2(position + Vector2(116.0, 0.0), Vector2(96.0, 28.0)),
			str(data["value"]),
			"Label",
			9
		)
		value["font_size"] = 15
		value["text_color"] = Color("#F5E9C7")
		value["horizontal_alignment"] = HORIZONTAL_ALIGNMENT_RIGHT
		value["linked_to"] = base_name
		value["linked_offset"] = Vector2(116.0, 0.0)
		_upsert(elements, value)


static func _build_inventory_tabs(source: String, elements: Array) -> void:
	var names: Array[String] = ["EQUIPO", "OBJETOS", "MATERIALES", "MISIONES", "HABILIDADES"]
	for index: int in range(5):
		var fallback: Rect2 = Rect2(
			Vector2(774.0 + float(index) * 144.0, 160.0),
			Vector2(136.0 if index < 4 else 150.0, 45.0)
		)
		var tab_rect: Rect2 = _rect_array_item(source, "TAB_RECTS", index, fallback)
		var tab: Dictionary = _visual_element(
			"TAB_RECTS_%d" % index, tab_rect, names[index], "Button", 8
		)
		tab["font_size"] = 16
		tab["fill_color"] = (
			Color(0.04, 0.43, 0.30, 0.33)
			if index == 0
			else Color(0.0, 0.0, 0.0, 0.02)
		)
		tab["border_color"] = (
			Color("#67F0BC")
			if index == 0
			else Color(0.82, 0.65, 0.24, 0.18)
		)
		tab["border_width"] = 1.0
		tab["corner_radius"] = 5.0
		_upsert(elements, tab)


static func _build_inventory_grid(source: String, elements: Array) -> void:
	var origin_data: Dictionary = _vector_constant_data(
		source, "GRID_ORIGIN", Vector2(771.0, 235.0)
	)
	var origin: Vector2 = origin_data.get("value", Vector2(771.0, 235.0))
	var slot_size: Vector2 = _vector_constant(
		source, "GRID_SLOT_SIZE", Vector2(80.0, 78.0)
	)
	var gap: Vector2 = _vector_constant(source, "GRID_GAP", Vector2(13.0, 10.0))
	var grid_driver: Dictionary = _visual_element(
		"inventory_grid_origin",
		Rect2(origin, Vector2(731.0, 430.0)),
		"",
		"Control",
		-1
	)
	grid_driver["friendly_name"] = "Rejilla del inventario (mover todo)"
	grid_driver["kind"] = "position_only"
	grid_driver["span_a_start"] = int(origin_data.get("start", -1))
	grid_driver["span_a_end"] = int(origin_data.get("end", -1))
	grid_driver["runtime_only"] = false
	grid_driver["editable"] = int(grid_driver["span_a_start"]) >= 0
	grid_driver["allow_resize"] = false
	grid_driver["fill_color"] = Color.TRANSPARENT
	grid_driver["border_color"] = Color.TRANSPARENT
	_upsert(elements, grid_driver)
	for index: int in range(40):
		var column: int = index % 8
		var row: int = index >> 3
		var position: Vector2 = origin + Vector2(
			float(column) * (slot_size.x + gap.x),
			float(row) * (slot_size.y + gap.y)
		)
		var slot: Dictionary = _visual_element(
			"runtime_inventory_slot_%d" % index,
			Rect2(position, slot_size),
			"",
			"Button",
			7
		)
		slot["fill_color"] = Color(0.002, 0.006, 0.010, 0.40)
		slot["border_color"] = Color(0.68, 0.49, 0.16, 0.50)
		slot["border_width"] = 1.0
		slot["corner_radius"] = 4.0
		slot["linked_to"] = "inventory_grid_origin"
		slot["linked_offset"] = position - origin
		_upsert(elements, slot)


static func _build_inventory_actions(elements: Array) -> void:
	var buttons: Array = [
		{"name": "equip_button", "rect": Rect2(858.0, 794.0, 148.0, 34.0), "text": "EQUIPAR", "accent": Color("#5FF0B5")},
		{"name": "use_button", "rect": Rect2(1100.0, 794.0, 136.0, 34.0), "text": "USAR", "accent": Color("#91D5FF")},
		{"name": "close_bottom_button", "rect": Rect2(1370.0, 794.0, 122.0, 34.0), "text": "Cerrar", "accent": Color("#F2D175")},
		{"name": "sort_button", "rect": Rect2(1414.0, 711.0, 78.0, 28.0), "text": "ORDENAR", "accent": Color("#E8CA6A")},
		{"name": "close_top_button", "rect": Rect2(1484.0, 57.0, 58.0, 58.0), "text": "×", "accent": Color("#FFB186")}
	]
	for data: Dictionary in buttons:
		_upsert_button(
			elements,
			str(data["name"]),
			data["rect"],
			str(data["text"]),
			10 if str(data["name"]) == "sort_button" else 14,
			Color(0.005, 0.012, 0.018, 0.45),
			data["accent"],
			10
		)


static func _build_selection(source: String, elements: Array, images: Array) -> Dictionary:
	var faction_size: Vector2 = _vector_constant(
		source, "FACTION_WINDOW_SIZE", Vector2(1000.0, 600.0)
	)
	var character_size: Vector2 = _vector_constant(
		source, "CHARACTER_WINDOW_SIZE", Vector2(1180.0, 760.0)
	)
	_build_faction_view(source, elements)
	_build_character_view(source, elements, images)
	return {
		"elements": elements,
		"canvas_size": faction_size,
		"views": [
			{"tag": "faction", "name": "Selección de facción", "canvas_size": faction_size},
			{"tag": "character", "name": "Selección de personaje", "canvas_size": character_size}
		],
		"default_view": "faction",
		"background_path": ""
	}


static func _build_faction_view(source: String, elements: Array) -> void:
	var frame_pos: Vector2 = _vector_constant(
		source, "FACTION_FRAME_POSITION", Vector2(18.0, 20.0)
	)
	var frame_size: Vector2 = _vector_constant(
		source, "FACTION_FRAME_SIZE", Vector2(964.0, 560.0)
	)
	_add_selection_frame(elements, frame_pos, frame_size, "faction")
	_add_selection_glow(
		elements,
		"selection_faction_glow_left",
		Rect2(frame_pos + Vector2(10.0, 92.0), Vector2(462.0, 390.0)),
		Color(0.025, 0.105, 0.235, 0.17),
		"faction"
	)
	_add_selection_glow(
		elements,
		"selection_faction_glow_right",
		Rect2(frame_pos + Vector2(492.0, 92.0), Vector2(462.0, 390.0)),
		Color(0.170, 0.020, 0.225, 0.16),
		"faction"
	)
	_add_selection_header(
		elements,
		frame_pos,
		frame_size.x,
		"ELIGE TU DESTINO",
		"La Fractura se abre ante ti. Decide qué juramento guiará tu aventura.",
		"faction"
	)
	var card_size: Vector2 = _vector_constant(
		source, "FACTION_CARD_SIZE", Vector2(405.0, 350.0)
	)
	var card_data: Array = [
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
	for index: int in range(2):
		var fallback: Vector2 = Vector2(52.0 + float(index) * 455.0, 115.0)
		var local_pos: Vector2 = _vector_array_item(
			source, "FACTION_CARD_POSITIONS", index, fallback
		)
		var driver_name: String = "FACTION_CARD_POSITIONS_%d" % index
		var driver: Dictionary = _visual_element(
			driver_name,
			Rect2(frame_pos + local_pos, card_size),
			"",
			"Button",
			6
		)
		driver["fill_color"] = Color(0.018, 0.025, 0.038, 0.98)
		driver["border_color"] = card_data[index]["accent"]
		driver["border_width"] = 2.0
		driver["corner_radius"] = 22.0
		driver["view_tag"] = "faction"
		driver["save_offset"] = frame_pos
		_upsert(elements, driver)
		_add_faction_card_children(
			elements,
			driver_name,
			frame_pos + local_pos,
			card_data[index]
		)
	_add_selection_status(
		elements,
		frame_pos,
		"Selecciona una facción para continuar.",
		Vector2(267.0, 466.0),
		Vector2(430.0, 32.0),
		Vector2(252.0, 508.0),
		Vector2(492.0, 508.0),
		"faction"
	)


static func _add_faction_card_children(
	elements: Array,
	driver_name: String,
	origin: Vector2,
	data: Dictionary
) -> void:
	var accent: Color = data["accent"]
	_add_linked(
		elements, driver_name + "_emblem", driver_name, origin,
		Rect2(Vector2(145.0, 18.0), Vector2(115.0, 115.0)),
		str(data["symbol"]), "Panel", 42,
		Color(accent.r * 0.08, accent.g * 0.08, accent.b * 0.08, 0.42),
		accent, 58.0, "faction", accent
	)
	_add_linked(
		elements, driver_name + "_name", driver_name, origin,
		Rect2(Vector2(46.0, 140.0), Vector2(313.0, 40.0)),
		str(data["title"]), "Panel", 18,
		Color(0.17, 0.11, 0.04, 0.97), GOLD_BRIGHT, 10.0,
		"faction", TEXT
	)
	_add_linked(
		elements, driver_name + "_subtitle", driver_name, origin,
		Rect2(Vector2(30.0, 187.0), Vector2(345.0, 20.0)),
		str(data["subtitle"]), "Label", 13,
		Color.TRANSPARENT, Color.TRANSPARENT, 0.0,
		"faction", accent
	)
	_add_linked(
		elements, driver_name + "_description", driver_name, origin,
		Rect2(Vector2(34.0, 210.0), Vector2(337.0, 32.0)),
		str(data["description"]), "Label", 12,
		Color.TRANSPARENT, Color.TRANSPARENT, 0.0,
		"faction", TEXT
	)
	_add_linked(
		elements, driver_name + "_info", driver_name, origin,
		Rect2(Vector2(30.0, 245.0), Vector2(345.0, 64.0)),
		"ENEMIGOS   %s\nCLASES       %s" % [str(data["enemies"]), str(data["classes"])],
		"Panel", 10, Color(0.0, 0.0, 0.0, 0.92), GOLD_BRIGHT, 12.0,
		"faction", TEXT
	)
	_add_linked(
		elements, driver_name + "_destiny", driver_name, origin,
		Rect2(Vector2(122.0, 316.0), Vector2(161.0, 27.0)),
		str(data["destiny"]), "Panel", 11,
		Color(0.07, 0.045, 0.018, 0.97), GOLD_BRIGHT, 10.0,
		"faction", accent
	)


static func _build_character_view(source: String, elements: Array, images: Array) -> void:
	var frame_pos: Vector2 = _vector_constant(
		source, "CHARACTER_FRAME_POSITION", Vector2(18.0, 20.0)
	)
	var frame_size: Vector2 = _vector_constant(
		source, "CHARACTER_FRAME_SIZE", Vector2(1144.0, 720.0)
	)
	_add_selection_frame(elements, frame_pos, frame_size, "character")
	_add_selection_glow(
		elements,
		"selection_character_header_glow",
		Rect2(frame_pos + Vector2(135.0, 0.0), Vector2(874.0, 106.0)),
		Color(0.30, 0.20, 0.04, 0.09),
		"character"
	)
	_add_selection_header(
		elements,
		frame_pos,
		frame_size.x,
		"ELIGE A TU CAMPEÓN",
		"JURAMENTO DEL ALBA",
		"character"
	)
	var card_size: Vector2 = _vector_constant(
		source, "CHARACTER_CARD_SIZE", Vector2(330.0, 540.0)
	)
	var paladin_path: String = _resource_variable(source, "PALADIN_TEXTURE_PATH")
	if paladin_path.is_empty():
		paladin_path = _best_image(images, ["paladin1", "paladin"])
	var cards: Array = [
		{"name": "PALADÍN DEL ALBA", "role": "Defensor sagrado", "description": "Protegido por la luz.\nResiste el daño y puede curarse.", "stats": "VIDA ★★★★★\nDAÑO ★★★☆☆\nDEF  ★★★★☆", "ability": "✦ ESCUDO SAGRADO", "accent": Color("#72B7FF"), "sigil": "", "image": paladin_path},
		{"name": "ARQUERO DEL BOSQUE", "role": "Atacante a distancia", "description": "Preciso a larga distancia.\nDestaca por su velocidad.", "stats": "VIDA ★★★☆☆\nDAÑO ★★★★☆\nDEF  ★★★★☆", "ability": "✦ DISPARO TRIPLE", "accent": Color("#73D982"), "sigil": "ARQ", "image": ""},
		{"name": "ARCANISTA ESTELAR", "role": "Hechicero ofensivo", "description": "Domina fuerzas celestiales.\nDaña a varios enemigos.", "stats": "VIDA ★★☆☆☆\nDAÑO ★★★★★\nDEF  ★★★☆☆", "ability": "✦ LLUVIA ARCANA", "accent": Color("#B985FF"), "sigil": "ARC", "image": ""}
	]
	for index: int in range(3):
		var fallback: Vector2 = Vector2(42.0 + float(index) * 365.0, 100.0)
		var local_pos: Vector2 = _vector_array_item(
			source, "CHARACTER_CARD_POSITIONS", index, fallback
		)
		var driver_name: String = "CHARACTER_CARD_POSITIONS_%d" % index
		var driver: Dictionary = _visual_element(
			driver_name,
			Rect2(frame_pos + local_pos, card_size),
			"",
			"Button",
			6
		)
		driver["fill_color"] = Color(0.018, 0.025, 0.038, 0.98)
		driver["border_color"] = cards[index]["accent"]
		driver["border_width"] = 2.0
		driver["corner_radius"] = 22.0
		driver["view_tag"] = "character"
		driver["save_offset"] = frame_pos
		_upsert(elements, driver)
		_add_character_card_children(
			elements,
			driver_name,
			frame_pos + local_pos,
			cards[index]
		)
	_add_selection_status(
		elements,
		frame_pos,
		"Selecciona un personaje para continuar.",
		Vector2(272.0, 642.0),
		Vector2(600.0, 28.0),
		Vector2(317.0, 672.0),
		Vector2(587.0, 672.0),
		"character"
	)


static func _add_character_card_children(
	elements: Array,
	driver_name: String,
	origin: Vector2,
	data: Dictionary
) -> void:
	var accent: Color = data["accent"]
	_add_linked(
		elements, driver_name + "_portrait", driver_name, origin,
		Rect2(Vector2(15.0, 18.0), Vector2(300.0, 330.0)),
		str(data["sigil"]), "TextureRect" if not str(data["image"]).is_empty() else "Panel",
		32,
		Color(accent.r * 0.045, accent.g * 0.045, accent.b * 0.045, 0.99),
		Color(accent.r, accent.g, accent.b, 0.78), 15.0,
		"character", accent, str(data["image"])
	)
	_add_linked(
		elements, driver_name + "_name", driver_name, origin,
		Rect2(Vector2(22.0, 313.0), Vector2(286.0, 41.0)),
		str(data["name"]), "Panel", 16,
		Color(accent.r * 0.15, accent.g * 0.15, accent.b * 0.15, 0.98),
		GOLD_BRIGHT, 9.0, "character", TEXT
	)
	_add_linked(
		elements, driver_name + "_description", driver_name, origin,
		Rect2(Vector2(20.0, 362.0), Vector2(290.0, 42.0)),
		str(data["description"]), "Panel", 10,
		Color(0.0, 0.0, 0.0, 0.78), Color(accent.r, accent.g, accent.b, 0.18),
		9.0, "character", TEXT
	)
	_add_linked(
		elements, driver_name + "_stats", driver_name, origin,
		Rect2(Vector2(47.0, 409.0), Vector2(236.0, 70.0)),
		str(data["stats"]), "Panel", 11,
		Color(0.0, 0.0, 0.0, 0.94), accent, 13.0,
		"character", Color("#FFE9A0")
	)
	_add_linked(
		elements, driver_name + "_role", driver_name, origin,
		Rect2(Vector2(26.0, 484.0), Vector2(278.0, 18.0)),
		str(data["role"]), "Label", 13,
		Color.TRANSPARENT, Color.TRANSPARENT, 0.0,
		"character", accent
	)
	_add_linked(
		elements, driver_name + "_ability", driver_name, origin,
		Rect2(Vector2(34.0, 507.0), Vector2(262.0, 23.0)),
		str(data["ability"]), "Panel", 10,
		Color(accent.r * 0.10, accent.g * 0.10, accent.b * 0.10, 0.98),
		GOLD_BRIGHT, 7.0, "character", Color("#FFE9A0")
	)


static func _add_selection_glow(
	elements: Array,
	name: String,
	rect: Rect2,
	color: Color,
	view_tag: String
) -> void:
	var glow: Dictionary = _visual_element(name, rect, "", "ColorRect", -1)
	glow["fill_color"] = color
	glow["view_tag"] = view_tag
	_upsert(elements, glow)


static func _add_selection_frame(
	elements: Array,
	frame_pos: Vector2,
	frame_size: Vector2,
	view_tag: String
) -> void:
	var shadow: Dictionary = _visual_element(
		"selection_%s_shadow" % view_tag,
		Rect2(frame_pos + Vector2(4.0, 6.0), frame_size),
		"",
		"Panel",
		-4
	)
	shadow["fill_color"] = Color(0.0, 0.0, 0.0, 0.72)
	shadow["border_color"] = Color(0.82, 0.64, 0.18, 0.16)
	shadow["border_width"] = 1.0
	shadow["corner_radius"] = 30.0
	shadow["view_tag"] = view_tag
	_upsert(elements, shadow)
	var frame: Dictionary = _visual_element(
		"selection_%s_frame" % view_tag,
		Rect2(frame_pos, frame_size),
		"",
		"Panel",
		-3
	)
	frame["fill_color"] = Color(0.008, 0.013, 0.022, 0.97)
	frame["border_color"] = Color("#FFD66B")
	frame["border_width"] = 6.0
	frame["corner_radius"] = 32.0
	frame["view_tag"] = view_tag
	_upsert(elements, frame)
	var inner: Dictionary = _visual_element(
		"selection_%s_inner" % view_tag,
		Rect2(frame_pos + Vector2(10.0, 10.0), frame_size - Vector2(20.0, 20.0)),
		"",
		"Panel",
		-2
	)
	inner["fill_color"] = Color.TRANSPARENT
	inner["border_color"] = Color(0.99, 0.86, 0.42, 0.52)
	inner["border_width"] = 3.0
	inner["corner_radius"] = 26.0
	inner["view_tag"] = view_tag
	_upsert(elements, inner)


static func _add_selection_header(
	elements: Array,
	frame_pos: Vector2,
	frame_width: float,
	title: String,
	subtitle: String,
	view_tag: String
) -> void:
	var title_element: Dictionary = _visual_element(
		"selection_%s_title" % view_tag,
		Rect2(frame_pos + Vector2(30.0, 11.0), Vector2(frame_width - 60.0, 50.0)),
		title,
		"Label",
		2
	)
	title_element["font_size"] = 33
	title_element["text_color"] = Color("#E7C873")
	title_element["view_tag"] = view_tag
	_upsert(elements, title_element)
	var subtitle_element: Dictionary = _visual_element(
		"selection_%s_subtitle" % view_tag,
		Rect2(frame_pos + Vector2(30.0, 57.0), Vector2(frame_width - 60.0, 28.0)),
		subtitle,
		"Label",
		2
	)
	subtitle_element["font_size"] = 18
	subtitle_element["text_color"] = Color("#BBB3A3")
	subtitle_element["view_tag"] = view_tag
	_upsert(elements, subtitle_element)

	var line_width: float = (frame_width - 250.0) / 2.0
	var left_line: Dictionary = _visual_element(
		"selection_%s_header_line_left" % view_tag,
		Rect2(
			frame_pos + Vector2(78.0, 96.0),
			Vector2(line_width - 78.0, 1.0)
		),
		"",
		"ColorRect",
		2
	)
	left_line["fill_color"] = Color(0.90, 0.70, 0.24, 0.58)
	left_line["view_tag"] = view_tag
	_upsert(elements, left_line)
	var right_line: Dictionary = _visual_element(
		"selection_%s_header_line_right" % view_tag,
		Rect2(
			frame_pos + Vector2(frame_width / 2.0 + 82.0, 96.0),
			Vector2(line_width - 78.0, 1.0)
		),
		"",
		"ColorRect",
		2
	)
	right_line["fill_color"] = Color(0.90, 0.70, 0.24, 0.58)
	right_line["view_tag"] = view_tag
	_upsert(elements, right_line)
	var gem: Dictionary = _visual_element(
		"selection_%s_header_gem" % view_tag,
		Rect2(
			frame_pos + Vector2(frame_width / 2.0 - 7.0, 89.0),
			Vector2(14.0, 14.0)
		),
		"◆",
		"Panel",
		3
	)
	gem["font_size"] = 10
	gem["fill_color"] = Color("#FFD66B")
	gem["border_color"] = Color("#FFF1B0")
	gem["border_width"] = 1.0
	gem["corner_radius"] = 2.0
	gem["view_tag"] = view_tag
	_upsert(elements, gem)


static func _add_selection_status(
	elements: Array,
	frame_pos: Vector2,
	status_text: String,
	status_pos: Vector2,
	status_size: Vector2,
	back_pos: Vector2,
	confirm_pos: Vector2,
	view_tag: String
) -> void:
	var status: Dictionary = _visual_element(
		"selection_%s_status" % view_tag,
		Rect2(frame_pos + status_pos + Vector2(0.0, 2.0), status_size - Vector2(0.0, 4.0)),
		status_text,
		"Label",
		9
	)
	status["font_size"] = 15
	status["text_color"] = Color("#EFE5CF")
	status["view_tag"] = view_tag
	_upsert(elements, status)
	var back: Dictionary = _visual_element(
		"selection_%s_back" % view_tag,
		Rect2(frame_pos + back_pos, Vector2(240.0, 44.0)),
		"VOLVER",
		"Button",
		9
	)
	back["font_size"] = 16
	back["fill_color"] = Color(0.040, 0.055, 0.083, 0.98)
	back["border_color"] = Color(0.72, 0.56, 0.22, 0.95)
	back["border_width"] = 2.0
	back["corner_radius"] = 11.0
	back["view_tag"] = view_tag
	_upsert(elements, back)
	var confirm: Dictionary = _visual_element(
		"selection_%s_confirm" % view_tag,
		Rect2(frame_pos + confirm_pos, Vector2(240.0, 44.0)),
		"CONFIRMAR",
		"Button",
		9
	)
	confirm["font_size"] = 16
	confirm["fill_color"] = Color(0.025, 0.030, 0.043, 0.92)
	confirm["border_color"] = Color("#413B30")
	confirm["border_width"] = 1.0
	confirm["corner_radius"] = 11.0
	confirm["view_tag"] = view_tag
	_upsert(elements, confirm)


static func _build_main_menu(source: String, elements: Array) -> Dictionary:
	var canvas_size: Vector2 = Vector2(900.0, 600.0)
	var frame_position: Vector2 = Vector2(140.0, 65.0)
	var frame_size: Vector2 = Vector2(620.0, 470.0)
	var background: Dictionary = _visual_element(
		"menu_background",
		Rect2(Vector2.ZERO, canvas_size),
		"",
		"ColorRect",
		-40
	)
	background["fill_color"] = Color("#050A10")
	_upsert(elements, background)
	var lower: Dictionary = _visual_element(
		"menu_lower_tint",
		Rect2(Vector2(0.0, 348.0), Vector2(900.0, 252.0)),
		"",
		"ColorRect",
		-39
	)
	lower["fill_color"] = Color(0.015, 0.08, 0.065, 0.18)
	_upsert(elements, lower)
	var frame: Dictionary = _visual_element(
		"menu_frame",
		Rect2(frame_position, frame_size),
		"",
		"Panel",
		-2
	)
	frame["fill_color"] = Color(0.006, 0.013, 0.021, 0.98)
	frame["border_color"] = Color("#D5B254")
	frame["border_width"] = 3.0
	frame["corner_radius"] = 18.0
	_upsert(elements, frame)
	_upsert_label(
		elements,
		"title_label",
		Rect2(frame_position + Vector2(35.0, 35.0), Vector2(550.0, 70.0)),
		"TASKBAR ADVENTURES RPG",
		38,
		Color("#FFE18A"),
		HORIZONTAL_ALIGNMENT_CENTER,
		4
	)
	_set_save_offset(elements, "title_label", frame_position)
	_upsert_label(
		elements,
		"subtitle_label",
		Rect2(frame_position + Vector2(55.0, 102.0), Vector2(510.0, 50.0)),
		"CRÓNICAS DE LA FRACTURA",
		18,
		Color("#A9C8D8"),
		HORIZONTAL_ALIGNMENT_CENTER,
		4
	)
	_set_save_offset(elements, "subtitle_label", frame_position)
	var buttons: Array = [
		{"name": "continue_button", "text": "CONTINUAR AVENTURA", "position": Vector2(135.0, 175.0), "danger": false},
		{"name": "new_button", "text": "NUEVA PARTIDA", "position": Vector2(135.0, 235.0), "danger": false},
		{"name": "options_button", "text": "OPCIONES", "position": Vector2(135.0, 295.0), "danger": false},
		{"name": "exit_button", "text": "SALIR", "position": Vector2(135.0, 355.0), "danger": true}
	]
	for data: Dictionary in buttons:
		var accent: Color = Color("#C24C58") if bool(data["danger"]) else Color("#D5B254")
		_upsert_button(
			elements,
			str(data["name"]),
			Rect2(frame_position + data["position"], Vector2(350.0, 48.0)),
			str(data["text"]),
			21,
			Color(0.012, 0.026, 0.038, 0.98),
			accent,
			5
		)
		_set_save_offset(elements, str(data["name"]), frame_position)
	return {
		"elements": elements,
		"canvas_size": canvas_size,
		"views": [],
		"default_view": "all",
		"background_path": ""
	}


static func _build_skill_tree(source: String, elements: Array, images: Array) -> Dictionary:
	var canvas_size: Vector2 = _vector_constant(
		source, "REFERENCE_SIZE", Vector2(1448.0, 1086.0)
	)
	var background_path: String = _resource_variable(source, "skill_tree_background_path")
	if background_path.is_empty():
		background_path = _best_image(images, ["arbol_habilidades", "cosmico"])
	# El analizador dinámico ya reconstruye los nodos editables. Aquí se asegura
	# el lienzo y se recuperan sus elementos en PLAY.
	for index: int in range(elements.size()):
		if not (elements[index] is Dictionary):
			continue
		var element: Dictionary = elements[index]
		var name: String = str(element.get("name", ""))
		if name.begins_with("skill_") or name.contains("label") or name.contains("button"):
			element["template_only"] = false
			elements[index] = element
	_upsert_texture(
		elements,
		"background_rect",
		Rect2(Vector2.ZERO, canvas_size),
		background_path,
		"stretch",
		-40
	)
	return {
		"elements": elements,
		"canvas_size": canvas_size,
		"views": [],
		"default_view": "all",
		"background_path": background_path
	}


static func _build_generic_module(
	_source: String,
	elements: Array,
	images: Array,
	canvas_size: Vector2,
	background_hints: Array[String]
) -> Dictionary:
	for index: int in range(elements.size()):
		if elements[index] is Dictionary:
			var element: Dictionary = elements[index]
			element["template_only"] = false
			elements[index] = element
	return {
		"elements": elements,
		"canvas_size": canvas_size,
		"views": [],
		"default_view": "all",
		"background_path": _best_image(images, background_hints)
	}


static func _add_linked(
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
	text_color: Color = TEXT,
	image_path: String = ""
) -> void:
	var element: Dictionary = _visual_element(
		name,
		Rect2(driver_origin + local_rect.position, local_rect.size),
		text,
		control_type,
		12
	)
	element["font_size"] = font_size
	element["fill_color"] = fill
	element["border_color"] = border
	element["border_width"] = 2.0 if border.a > 0.001 else 0.0
	element["corner_radius"] = radius
	element["text_color"] = text_color
	element["linked_to"] = driver_name
	element["linked_offset"] = local_rect.position
	element["view_tag"] = view_tag
	if not image_path.is_empty():
		element["image_path"] = image_path
		element["image_mode"] = "contain"
	_upsert(elements, element)


static func _visual_element(
	name: String,
	rect: Rect2,
	text: String,
	control_type: String,
	z_index: int
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
		"line": 0,
		"draw_order": z_index,
		"source_kind": "Vista PLAY reconstruida",
		"dirty": false,
		"image_path": "",
		"image_mode": "contain",
		"image_padding": 0.0,
		"display_text": text,
		"friendly_name": name.replace("_", " ").capitalize(),
		"font_size": 0,
		"text_expression": "",
		"runtime_only": true,
		"editable": false,
		"allow_resize": true,
		"control_type": control_type,
		"preview_style": _style_for_type(control_type),
		"visible": true,
		"template_only": false,
		"text_color": TEXT,
		"horizontal_alignment": HORIZONTAL_ALIGNMENT_CENTER,
		"vertical_alignment": VERTICAL_ALIGNMENT_CENTER,
		"z_index": z_index
	}


static func _upsert(elements: Array, blueprint: Dictionary) -> void:
	var index: int = _find_element(elements, str(blueprint.get("name", "")))
	if index < 0:
		elements.append(blueprint)
		return
	var current: Dictionary = elements[index]
	var source_kind: String = str(current.get("kind", "derived"))
	var span_a_start: int = int(current.get("span_a_start", -1))
	var span_a_end: int = int(current.get("span_a_end", -1))
	var span_b_start: int = int(current.get("span_b_start", -1))
	var span_b_end: int = int(current.get("span_b_end", -1))
	var source_line: int = int(current.get("line", 0))
	for key: Variant in blueprint.keys():
		current[key] = blueprint[key]
	if span_a_start >= 0 and span_a_end >= span_a_start:
		current["kind"] = source_kind
		current["span_a_start"] = span_a_start
		current["span_a_end"] = span_a_end
		current["span_b_start"] = span_b_start
		current["span_b_end"] = span_b_end
		current["line"] = source_line
		current["runtime_only"] = false
		current["editable"] = true
	current["template_only"] = false
	elements[index] = current


static func _upsert_texture(
	elements: Array,
	name: String,
	rect: Rect2,
	path: String,
	mode: String,
	z_index: int
) -> void:
	var element: Dictionary = _visual_element(name, rect, "", "TextureRect", z_index)
	element["image_path"] = path
	element["image_mode"] = mode
	_upsert(elements, element)


static func _upsert_label(
	elements: Array,
	name: String,
	rect: Rect2,
	text: String,
	font_size: int,
	color: Color,
	alignment: int,
	z_index: int
) -> void:
	var element: Dictionary = _visual_element(name, rect, text, "Label", z_index)
	element["font_size"] = font_size
	element["text_color"] = color
	element["horizontal_alignment"] = alignment
	_upsert(elements, element)


static func _upsert_button(
	elements: Array,
	name: String,
	rect: Rect2,
	text: String,
	font_size: int,
	fill: Color,
	border: Color,
	z_index: int
) -> void:
	var element: Dictionary = _visual_element(name, rect, text, "Button", z_index)
	element["font_size"] = font_size
	element["fill_color"] = fill
	element["border_color"] = border
	element["border_width"] = 2.0
	element["corner_radius"] = 6.0
	_upsert(elements, element)


static func _set_save_offset(
	elements: Array,
	name: String,
	offset: Vector2
) -> void:
	var index: int = _find_element(elements, name)
	if index < 0:
		return
	var element: Dictionary = elements[index]
	element["save_offset"] = offset
	elements[index] = element


static func _first_existing_name(
	elements: Array,
	candidates: Array[String],
	fallback: String
) -> String:
	for candidate: String in candidates:
		if _find_element(elements, candidate) >= 0:
			return candidate
	return fallback


static func _link_element(
	elements: Array,
	name: String,
	driver_name: String,
	offset: Vector2
) -> void:
	var index: int = _find_element(elements, name)
	if index < 0:
		return
	var element: Dictionary = elements[index]
	element["linked_to"] = driver_name
	element["linked_offset"] = offset
	elements[index] = element


static func _number_variable_data(
	source: String,
	name: String,
	fallback: float
) -> Dictionary:
	var regex: RegEx = RegEx.new()
	regex.compile(
		"(?m)^\\s*(?:var|const)\\s+" + name
		+ "\\s*(?::[^=\\n]+)?=\\s*([-+]?\\d+(?:\\.\\d+)?)"
	)
	var match: RegExMatch = regex.search(source)
	if match == null:
		return {"value": fallback, "start": -1, "end": -1}
	return {
		"value": float(match.get_string(1)),
		"start": match.get_start(1),
		"end": match.get_end(1)
	}


static func _find_element(elements: Array, name: String) -> int:
	for index: int in range(elements.size()):
		if elements[index] is Dictionary and str((elements[index] as Dictionary).get("name", "")) == name:
			return index
	return -1


static func _line_at(source: String, index: int) -> int:
	if index <= 0:
		return 1
	return source.substr(0, mini(index, source.length())).count("\n") + 1


static func _style_for_type(control_type: String) -> String:
	match control_type:
		"Button":
			return "button"
		"Panel", "PanelContainer":
			return "panel"
		"TextureRect":
			return "image"
		_:
			return "label"


static func _resource_variable(source: String, variable_name: String) -> String:
	var regex: RegEx = RegEx.new()
	regex.compile(
		"(?ms)(?:const|var)\\s+" + variable_name
		+ "\\s*(?::[^=\\n]+)?=\\s*\\(?\\s*[\\\"'](res://[^\\\"']+)[\\\"']"
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
				str(image.get("name", "")) + " " + str(image.get("path", ""))
			).to_lower()
			if combined.contains(hint.to_lower()):
				return str(image.get("path", ""))
	return ""


static func _vector_constant_data(
	source: String,
	name: String,
	fallback: Vector2
) -> Dictionary:
	var regex: RegEx = RegEx.new()
	regex.compile(
		"(?m)^\\s*(?:const|var)\\s+" + name
		+ "\\s*(?::[^=\\n]+)?=\\s*(Vector2i?\\(\\s*([-+]?\\d+(?:\\.\\d+)?)"
		+ "\\s*,\\s*([-+]?\\d+(?:\\.\\d+)?)\\s*\\))"
	)
	var match: RegExMatch = regex.search(source)
	if match == null:
		return {"value": fallback, "start": -1, "end": -1}
	return {
		"value": Vector2(float(match.get_string(2)), float(match.get_string(3))),
		"start": match.get_start(1),
		"end": match.get_end(1)
	}


static func _vector_constant(source: String, name: String, fallback: Vector2) -> Vector2:
	var regex: RegEx = RegEx.new()
	regex.compile(
		"(?m)^\\s*(?:const|var)\\s+" + name
		+ "\\s*(?::[^=\\n]+)?=\\s*Vector2i?\\(\\s*([-+]?\\d+(?:\\.\\d+)?)"
		+ "\\s*,\\s*([-+]?\\d+(?:\\.\\d+)?)\\s*\\)"
	)
	var match: RegExMatch = regex.search(source)
	if match == null:
		return fallback
	return Vector2(float(match.get_string(1)), float(match.get_string(2)))


static func _rect_constant(source: String, name: String, fallback: Rect2) -> Rect2:
	var regex: RegEx = RegEx.new()
	regex.compile(
		"(?m)^\\s*(?:const|var)\\s+" + name
		+ "\\s*(?::[^=\\n]+)?=\\s*Rect2\\(\\s*([-+]?\\d+(?:\\.\\d+)?)"
		+ "\\s*,\\s*([-+]?\\d+(?:\\.\\d+)?)"
		+ "\\s*,\\s*([-+]?\\d+(?:\\.\\d+)?)"
		+ "\\s*,\\s*([-+]?\\d+(?:\\.\\d+)?)\\s*\\)"
	)
	var match: RegExMatch = regex.search(source)
	if match == null:
		return fallback
	return Rect2(
		float(match.get_string(1)),
		float(match.get_string(2)),
		float(match.get_string(3)),
		float(match.get_string(4))
	)


static func _source_rect(source: String, variable_name: String, fallback: Rect2) -> Rect2:
	var position: Vector2 = fallback.position
	var dimensions: Vector2 = fallback.size
	var position_regex: RegEx = RegEx.new()
	position_regex.compile(
		"(?m)^\\s*" + variable_name
		+ "\\.position\\s*=\\s*Vector2\\(\\s*([-+]?\\d+(?:\\.\\d+)?)"
		+ "\\s*,\\s*([-+]?\\d+(?:\\.\\d+)?)\\s*\\)"
	)
	var position_match: RegExMatch = position_regex.search(source)
	if position_match != null:
		position = Vector2(
			float(position_match.get_string(1)),
			float(position_match.get_string(2))
		)
	var size_regex: RegEx = RegEx.new()
	size_regex.compile(
		"(?m)^\\s*" + variable_name
		+ "\\.size\\s*=\\s*Vector2\\(\\s*([-+]?\\d+(?:\\.\\d+)?)"
		+ "\\s*,\\s*([-+]?\\d+(?:\\.\\d+)?)\\s*\\)"
	)
	var size_match: RegExMatch = size_regex.search(source)
	if size_match != null:
		dimensions = Vector2(
			float(size_match.get_string(1)),
			float(size_match.get_string(2))
		)
	return Rect2(position, dimensions)


static func _rect_array_item(
	source: String,
	array_name: String,
	item_index: int,
	fallback: Rect2
) -> Rect2:
	var block: String = _array_block(source, array_name)
	if block.is_empty():
		return fallback
	var regex: RegEx = RegEx.new()
	regex.compile(
		"Rect2\\(\\s*([-+]?\\d+(?:\\.\\d+)?)\\s*,"
		+ "\\s*([-+]?\\d+(?:\\.\\d+)?)\\s*,"
		+ "\\s*([-+]?\\d+(?:\\.\\d+)?)\\s*,"
		+ "\\s*([-+]?\\d+(?:\\.\\d+)?)\\s*\\)"
	)
	var matches: Array[RegExMatch] = regex.search_all(block)
	if item_index < 0 or item_index >= matches.size():
		return fallback
	var match: RegExMatch = matches[item_index]
	return Rect2(
		float(match.get_string(1)),
		float(match.get_string(2)),
		float(match.get_string(3)),
		float(match.get_string(4))
	)


static func _vector_array_item(
	source: String,
	array_name: String,
	item_index: int,
	fallback: Vector2
) -> Vector2:
	var block: String = _array_block(source, array_name)
	if block.is_empty():
		return fallback
	var regex: RegEx = RegEx.new()
	regex.compile(
		"Vector2\\(\\s*([-+]?\\d+(?:\\.\\d+)?)"
		+ "\\s*,\\s*([-+]?\\d+(?:\\.\\d+)?)\\s*\\)"
	)
	var matches: Array[RegExMatch] = regex.search_all(block)
	if item_index < 0 or item_index >= matches.size():
		return fallback
	return Vector2(
		float(matches[item_index].get_string(1)),
		float(matches[item_index].get_string(2))
	)


static func _array_block(source: String, name: String) -> String:
	var regex: RegEx = RegEx.new()
	regex.compile(
		"(?ms)(?:const|var)\\s+" + name
		+ "\\s*(?::[^=\\n]+)?=\\s*\\[(.*?)\\]"
	)
	var match: RegExMatch = regex.search(source)
	return match.get_string(1) if match != null else ""


static func _dictionary_rect(source: String, dictionary_name: String, key: String) -> Rect2:
	var block: String = _dictionary_block(source, dictionary_name)
	if block.is_empty():
		return Rect2()
	var regex: RegEx = RegEx.new()
	regex.compile(
		"[\\\"']" + key + "[\\\"']\\s*:\\s*Rect2\\("
		+ "\\s*([-+]?\\d+(?:\\.\\d+)?)\\s*,"
		+ "\\s*([-+]?\\d+(?:\\.\\d+)?)\\s*,"
		+ "\\s*([-+]?\\d+(?:\\.\\d+)?)\\s*,"
		+ "\\s*([-+]?\\d+(?:\\.\\d+)?)\\s*\\)"
	)
	var match: RegExMatch = regex.search(block)
	if match == null:
		return Rect2()
	return Rect2(
		float(match.get_string(1)),
		float(match.get_string(2)),
		float(match.get_string(3)),
		float(match.get_string(4))
	)


static func _dictionary_block(source: String, name: String) -> String:
	var regex: RegEx = RegEx.new()
	regex.compile(
		"(?ms)(?:const|var)\\s+" + name
		+ "\\s*(?::[^=\\n]+)?=\\s*\\{(.*?)\\n\\}"
	)
	var match: RegExMatch = regex.search(source)
	return match.get_string(1) if match != null else ""


static func _translation(source: String, key: String, fallback: String) -> String:
	var regex: RegEx = RegEx.new()
	regex.compile(
		"[\\\"']" + key + "[\\\"']\\s*:\\s*[\\\"']((?:\\\\.|[^\\\"'])*)[\\\"']"
	)
	var match: RegExMatch = regex.search(source)
	if match == null:
		return fallback
	return match.get_string(1).replace("\\n", "\n")


static func _string_dictionary(source: String, name: String) -> Dictionary:
	var result: Dictionary = {}
	var block: String = _dictionary_block(source, name)
	if block.is_empty():
		return result
	var regex: RegEx = RegEx.new()
	regex.compile(
		"[\\\"']([^\\\"']+)[\\\"']\\s*:\\s*[\\\"']([^\\\"']+)[\\\"']"
	)
	for match: RegExMatch in regex.search_all(block):
		result[match.get_string(1)] = match.get_string(2)
	return result


static func _parse_shop_products(source: String) -> Array:
	var result: Array = []
	var regex: RegEx = RegEx.new()
	regex.compile(
		"(?m)^\\s*\\{[\\\"']id[\\\"']\\s*:\\s*[\\\"']([^\\\"']+)[\\\"']"
		+ "[^\\n]*[\\\"']name_key[\\\"']\\s*:\\s*[\\\"']([^\\\"']+)[\\\"']"
		+ "[^\\n]*[\\\"']description_key[\\\"']\\s*:\\s*[\\\"']([^\\\"']+)[\\\"']"
		+ "[^\\n]*[\\\"']price[\\\"']\\s*:\\s*(\\d+)"
		+ "[^\\n]*[\\\"']icon_key[\\\"']\\s*:\\s*[\\\"']([^\\\"']+)[\\\"']"
	)
	for match: RegExMatch in regex.search_all(source):
		var name_key: String = match.get_string(2)
		var description_key: String = match.get_string(3)
		result.append(
			{
				"id": match.get_string(1),
				"name": _translation(source, name_key, name_key),
				"description": _translation(source, description_key, ""),
				"price": int(match.get_string(4)),
				"icon_key": match.get_string(5)
			}
		)
	return result
