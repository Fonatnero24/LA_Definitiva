extends Control
class_name TiendaUI

signal shop_opened
signal shop_closed
signal purchase_completed(item_data: Dictionary, price: int)
signal purchase_failed(reason: String)

const MODULE_TOP_ICON_PATH: String = (
	"res://Recursos/UI/IconosBarra/tienda.png"
)

@export_group("Recursos")
@export_file("*.png") var shop_background_path: String = (
	"res://Recursos/UI/Tienda/tienda_base.png"
)
@export_file("*.png") var merchant_texture_path: String = (
	"res://Recursos/UI/Tienda/elfa_tendera.png"
)

@export_group("Ventana")
@export var shop_window_size: Vector2i = Vector2i(1080, 810)
@export var minimum_window_size: Vector2i = Vector2i(900, 675)
@export var start_open: bool = false
@export var allow_window_drag: bool = true
@export_range(40.0, 140.0, 1.0) var drag_header_height: float = 92.0

@export_group("Botón superior")
@export var top_button_position: Vector2 = Vector2(308.0, 4.0)
@export var top_button_size: Vector2 = Vector2(24.0, 24.0)

const REFERENCE_SIZE: Vector2 = Vector2(1448.0, 1086.0)
const SETTINGS_PATH: String = "user://opciones.cfg"
const SAVE_PATH: String = "user://partida.cfg"

const EPIC_CHEST_UNLOCK_LEVEL: int = 24
const SHOP_REGULAR_FONT_PATH: String = (
	"res://Recursos/Fuentes/PixelifySans-Regular.ttf"
)
const SHOP_BOLD_FONT_PATH: String = (
	"res://Recursos/Fuentes/PixelifySans-Bold.ttf"
)

const MERCHANT_COUNTER_REGION: Rect2 = Rect2(900.0, 395.0, 505.0, 175.0)

const SHOP_BACKGROUND_FALLBACKS: Array[String] = [
	"res://Recursos/UI/Tienda/tienda_base.png",
	"res://Recursos/UI/tienda_base.png"
]

const MERCHANT_TEXTURE_FALLBACKS: Array[String] = [
	"res://Recursos/UI/Tienda/elfa_tendera.png",
	"res://Recursos/UI/elfa_tendera.png"
]

const SHOP_ICON_ROOTS: Array[String] = [
	"res://Recursos/UI/Tienda/Iconos",
	"res://Recursos/UI/Iconos"
]

const CATEGORY_RECOMMENDED: String = "recommended"
const CATEGORY_POTIONS: String = "potions"
const CATEGORY_CHESTS: String = "chests"
const CATEGORY_ALL: String = "all"

const TYPE_POTION: String = "potion"
const TYPE_CHEST: String = "chest"
const TYPE_SURPRISE_CHEST: String = "surprise_chest"

const COLOR_GOLD: Color = Color("#E7C45E")
const COLOR_GOLD_BRIGHT: Color = Color("#FFE59A")
const COLOR_EMERALD: Color = Color("#4CF0A5")
const COLOR_TEXT: Color = Color("#F5EBD7")
const COLOR_MUTED: Color = Color("#DDD3C0")
const COLOR_DANGER: Color = Color("#FF777D")
const COLOR_PANEL: Color = Color(0.006, 0.012, 0.016, 0.88)
const COLOR_PANEL_HOVER: Color = Color(0.020, 0.070, 0.052, 0.94)

const PRODUCT_ICON_PATHS: Dictionary = {
	"pocion_menor": "res://Recursos/UI/Tienda/Iconos/pocion_menor.png",
	"pocion_vigor": "res://Recursos/UI/Tienda/Iconos/pocion_vigor.png",
	"cofre_comun": "res://Recursos/UI/Tienda/Iconos/cofre_comun.png",
	"cofre_poco_comun": "res://Recursos/UI/Tienda/Iconos/cofre_poco_comun.png",
	"cofre_raro": "res://Recursos/UI/Tienda/Iconos/cofre_raro.png",
	"cofre_epico": "res://Recursos/UI/Tienda/Iconos/cofre_epico.png",
	"cofre_resonancia": "res://Recursos/UI/Tienda/Iconos/cofre_epico.png",
	"cofre_mitico": "res://Recursos/UI/Tienda/Iconos/cofre_mitico.png",
	"cofre_ancestral": "res://Recursos/UI/Tienda/Iconos/cofre_ancestral.png",
	"coin": "res://Recursos/UI/Tienda/Iconos/moneda.png"
}

const TRANSLATIONS: Dictionary = {
	"es": {
		"window_title": "Tienda errante de Lyria",
		"open_shop": "Abrir tienda de Lyria [T]",
		"title": "TIENDA ERRANTE DE LYRIA",
		"gold": "ORO: %d",
		"recommended": "RECOMENDADO",
		"potions": "POCIONES",
		"chests": "COFRES DE RANGO",
		"all": "TODO",
		"merchant_name": "LYRIA · MERCADERA DEL VELO",
		"merchant_quote": "Toda ruta esconde un tesoro. Algunas también esconden dientes.",
		"quantity": "CANTIDAD",
		"total": "TOTAL: %d",
		"buy": "COMPRAR",
		"close": "Cerrar tienda",
		"region": "Mercancía vinculada a %s",
		"select_product": "Selecciona una mercancía.",
		"not_enough_gold": "No tienes suficiente oro.",
		"inventory_full": "El inventario está lleno.",
		"missing_inventory": "No se encontró InventarioUI.",
		"generation_failed": "El cofre no pudo encontrar un objeto compatible.",
		"purchase_success": "Has comprado %s por %d de oro.",
		"chest_success": "El cofre contenía: %s.",
		"rank_chest_note": "Entrega un objeto aleatorio de este rango y de la región actual.",
		"no_legendary_unique": "Lyria solo vende cofres hasta rango Épico.",
		"unlock_level": "SE DESBLOQUEA AL NIVEL %d",
		"unlock_level_desc": "Alcanza el nivel %d para comprar este cofre.",
		"minor_potion_name": "Poción Menor de Vida",
		"minor_potion_desc": "Restaura 25 puntos de vida. Se puede acumular.",
		"vigor_potion_name": "Poción de Vigor",
		"vigor_potion_desc": "Restaura 45 puntos de vida. Se puede acumular.",
		"common_chest_name": "Cofre Común",
		"common_chest_desc": "Una recompensa modesta para continuar el camino.",
		"uncommon_chest_name": "Cofre Poco Común",
		"uncommon_chest_desc": "Botín mejorado con una rareza garantizada.",
		"rare_chest_name": "Cofre Raro",
		"rare_chest_desc": "Una pieza rara compatible con tu aventura.",
		"epic_chest_name": "Cofre Épico",
		"epic_chest_desc": "Poder notable. Su precio también tiene armadura.",
		"resonance_chest_name": "Cofre de Resonancia",
		"resonance_chest_desc": "La Fractura elige la rareza. Puede contener desde un objeto común hasta una reliquia ÚNICA.",
		"resonance_note": "Probabilidades: Común 42% · Poco común 28% · Raro 17% · Épico 8% · Legendario 3,5% · Mítico 1% · Ancestral 0,45% · Único 0,05%.",
		"resonance_title": "RESONANCIA DE LA FRACTURA",
		"resonance_subtitle": "Las reliquias giran. El destino afila sus dientes.",
		"resonance_result": "LA FRACTURA HA ELEGIDO",
		"resonance_close": "RECOGER",
		"mythic_chest_name": "Cofre Mítico",
		"mythic_chest_desc": "Reliquias casi olvidadas por los reinos.",
		"ancestral_chest_name": "Cofre Ancestral",
		"ancestral_chest_desc": "El grado máximo que Lyria acepta vender.",
		"rarity_common": "COMÚN",
		"rarity_uncommon": "POCO COMÚN",
		"rarity_rare": "RARO",
		"rarity_epic": "ÉPICO",
		"rarity_mythic": "MÍTICO",
		"rarity_ancestral": "ANCESTRAL",
		"footer": "Nuevas leyendas nacen cuando alguien decide pagar el precio."
	},
	"en": {
		"window_title": "Lyria's Wandering Shop",
		"open_shop": "Open Lyria's shop [T]",
		"title": "LYRIA'S WANDERING SHOP",
		"gold": "GOLD: %d",
		"recommended": "RECOMMENDED",
		"potions": "POTIONS",
		"chests": "RANK CHESTS",
		"all": "ALL",
		"merchant_name": "LYRIA · VEIL MERCHANT",
		"merchant_quote": "Every road hides treasure. Some roads also hide teeth.",
		"quantity": "QUANTITY",
		"total": "TOTAL: %d",
		"buy": "BUY",
		"close": "Close shop",
		"region": "Goods linked to %s",
		"select_product": "Select an item.",
		"not_enough_gold": "You do not have enough gold.",
		"inventory_full": "Your inventory is full.",
		"missing_inventory": "InventarioUI was not found.",
		"generation_failed": "The chest could not find a compatible item.",
		"purchase_success": "You bought %s for %d gold.",
		"chest_success": "The chest contained: %s.",
		"rank_chest_note": "Grants a random item of this rank from the current region.",
		"no_legendary_unique": "Lyria only sells chests up to Epic rank.",
		"unlock_level": "UNLOCKS AT LEVEL %d",
		"unlock_level_desc": "Reach level %d to purchase this chest.",
		"minor_potion_name": "Minor Health Potion",
		"minor_potion_desc": "Restores 25 health. Stackable.",
		"vigor_potion_name": "Vigor Potion",
		"vigor_potion_desc": "Restores 45 health. Stackable.",
		"common_chest_name": "Common Chest",
		"common_chest_desc": "A modest reward to keep moving.",
		"uncommon_chest_name": "Uncommon Chest",
		"uncommon_chest_desc": "Improved loot with guaranteed rarity.",
		"rare_chest_name": "Rare Chest",
		"rare_chest_desc": "A rare item compatible with your adventure.",
		"epic_chest_name": "Epic Chest",
		"epic_chest_desc": "Notable power. Its price also wears armor.",
		"resonance_chest_name": "Resonance Chest",
		"resonance_chest_desc": "The Fracture chooses the rarity. It may contain anything from a common item to a UNIQUE relic.",
		"resonance_note": "Odds: Common 42% · Uncommon 28% · Rare 17% · Epic 8% · Legendary 3.5% · Mythic 1% · Ancestral 0.45% · Unique 0.05%.",
		"resonance_title": "FRACTURE RESONANCE",
		"resonance_subtitle": "Relics turn. Fate sharpens its teeth.",
		"resonance_result": "THE FRACTURE HAS CHOSEN",
		"resonance_close": "CLAIM",
		"mythic_chest_name": "Mythic Chest",
		"mythic_chest_desc": "Relics almost forgotten by the realms.",
		"ancestral_chest_name": "Ancestral Chest",
		"ancestral_chest_desc": "The highest rank Lyria agrees to sell.",
		"rarity_common": "COMMON",
		"rarity_uncommon": "UNCOMMON",
		"rarity_rare": "RARE",
		"rarity_epic": "EPIC",
		"rarity_mythic": "MYTHIC",
		"rarity_ancestral": "ANCESTRAL",
		"footer": "New legends begin when someone agrees to pay the price."
	}
}

var products: Array[Dictionary] = []
var product_by_id: Dictionary = {}
var active_category: String = CATEGORY_RECOMMENDED
var selected_product_id: String = "pocion_menor"
var purchase_quantity: int = 1

var main_controller: Node
var inventory_ui: Node
var main_interface_root: Control
var game_ui: Node
var current_language: String = "es"
var shop_regular_font: Font
var shop_bold_font: Font

var top_button: Button
var shop_window: Window
var scaled_root: Control
var background_rect: TextureRect
var merchant_rect: TextureRect
var merchant_counter_overlay: TextureRect
var drag_surface: Control

var title_label: Label
var gold_label: Label
var merchant_name_label: Label
var merchant_quote_label: Label
var region_label: Label
var footer_label: Label
var status_label: Label
var detail_name_label: Label
var detail_rarity_label: Label
var detail_description_label: Label
var detail_icon: TextureRect
var quantity_title_label: Label
var quantity_value_label: Label
var total_label: Label
var buy_button: Button
var close_button: Button
var minus_button: Button
var plus_button: Button

var category_buttons: Dictionary = {}
var product_cards: Array[Button] = []
var product_card_icons: Array[TextureRect] = []
var product_card_names: Array[Label] = []
var product_card_descriptions: Array[Label] = []
var product_card_prices: Array[Label] = []

var shop_is_open: bool = false
var initialized: bool = false
var refresh_accumulator: float = 0.0
var dragging_window: bool = false
var drag_offset: Vector2i = Vector2i.ZERO
var status_tween: Tween
var surprise_overlay: Control
var surprise_track: Control
var surprise_result_label: Label
var surprise_rarity_label: Label
var surprise_claim_button: Button
var surprise_animation_running: bool = false
var surprise_pending_item: Dictionary = {}

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	visible = true

	if name != &"TiendaUI" and get_parent() != null:
		if get_parent().get_node_or_null("TiendaUI") == null:
			name = &"TiendaUI"

	_connect_game_ui()
	_load_shop_fonts()
	_build_product_database()
	_load_language()
	call_deferred("_initialize_shop")

func _process(delta: float) -> void:
	if not initialized:
		return

	refresh_accumulator += delta
	var refresh_interval: float = 0.20 if shop_is_open else 0.80
	if refresh_accumulator < refresh_interval:
		return

	refresh_accumulator = 0.0
	_sync_top_button_state()

	if not shop_is_open:
		return

	if _main_blocks_shop_opening():
		close_shop()
		return

	_refresh_references()
	_refresh_gold_only()

func _input(event: InputEvent) -> void:
	if not initialized:
		return

	if event is InputEventKey:
		var key_event: InputEventKey = event as InputEventKey
		if not key_event.pressed or key_event.echo:
			return

		if key_event.keycode == KEY_T:
			if not shop_is_open and is_instance_valid(main_controller):
				if main_controller.has_method("close_world_map"):
					main_controller.call("close_world_map")

			if not _main_blocks_shop_opening() or shop_is_open:
				toggle_shop()
				get_viewport().set_input_as_handled()
			return

		if key_event.keycode == KEY_ESCAPE and shop_is_open:
			close_shop()
			get_viewport().set_input_as_handled()

func _initialize_shop() -> void:
	main_controller = get_parent()

	for _attempt: int in range(180):
		_refresh_references()
		if is_instance_valid(main_interface_root) and is_instance_valid(inventory_ui):
			break
		await get_tree().process_frame

	_mount_top_button()
	_build_shop_window()
	_refresh_all()
	initialized = true

	if start_open:
		open_shop()

func _refresh_references() -> void:
	if not is_instance_valid(main_controller):
		main_controller = get_parent()

	if is_instance_valid(main_controller):
		var root_candidate: Variant = main_controller.get("interface_root")
		if root_candidate is Control:
			main_interface_root = root_candidate as Control

	if not is_instance_valid(inventory_ui):
		var current_scene: Node = get_tree().current_scene
		if current_scene != null:
			inventory_ui = current_scene.find_child("InventarioUI", true, false)
			if not is_instance_valid(inventory_ui):
				for candidate: Node in current_scene.find_children("*", "", true, false):
					if candidate.has_method("add_item") and candidate.has_method("open_inventory"):
						inventory_ui = candidate
						break

func _connect_game_ui() -> void:
	game_ui = get_node_or_null("/root/GameUI")
	if not is_instance_valid(game_ui):
		return

	if game_ui.has_signal("language_changed"):
		var callback: Callable = Callable(self, "_on_global_language_changed")
		if not game_ui.is_connected("language_changed", callback):
			game_ui.connect("language_changed", callback)

func _on_global_language_changed(language_code: String) -> void:
	set_language(language_code)

func _load_language() -> void:
	if is_instance_valid(game_ui) and game_ui.has_method("get_language"):
		set_language(str(game_ui.call("get_language")))
		return

	var config: ConfigFile = ConfigFile.new()
	if config.load(SETTINGS_PATH) == OK:
		set_language(str(config.get_value("general", "idioma", "es")))

func set_language(language_code: String) -> void:
	var normalized: String = language_code.to_lower().strip_edges()
	if normalized != "es" and normalized != "en":
		normalized = "es"
	current_language = normalized

	if initialized:
		_refresh_all()

func _text(key: String) -> String:
	var spanish: Dictionary = TRANSLATIONS.get("es", {})
	var selected: Dictionary = TRANSLATIONS.get(current_language, spanish)
	return str(selected.get(key, spanish.get(key, key)))

func _main_blocks_shop_opening() -> bool:
	if not is_instance_valid(main_controller):
		return false

	if main_controller.has_method("is_modal_ui_open"):
		return bool(main_controller.call("is_modal_ui_open"))

	var options_value: Variant = main_controller.get("options_open")
	if options_value is bool and bool(options_value):
		return true

	var map_node: Node = main_controller.get_node_or_null("MapaMundosUI")
	if is_instance_valid(map_node):
		var map_value: Variant = map_node.get("map_open")
		if map_value is bool and bool(map_value):
			return true

	return false

func _build_product_database() -> void:
	products = [
		{"id":"pocion_menor","type":TYPE_POTION,"category":CATEGORY_POTIONS,"item_id":"pocion_menor","name_key":"minor_potion_name","description_key":"minor_potion_desc","price":120,"rarity":"comun","required_level":1,"icon_key":"pocion_menor"},
		{"id":"pocion_vigor","type":TYPE_POTION,"category":CATEGORY_POTIONS,"item_id":"pocion_vigor","name_key":"vigor_potion_name","description_key":"vigor_potion_desc","price":350,"rarity":"poco_comun","required_level":1,"icon_key":"pocion_vigor"},
		{"id":"cofre_resonancia","type":TYPE_SURPRISE_CHEST,"category":CATEGORY_CHESTS,"name_key":"resonance_chest_name","description_key":"resonance_chest_desc","price":7500,"rarity":"epico","rarity_key":"rarity_epic","required_level":12,"icon_key":"cofre_resonancia"},
		{"id":"cofre_comun","type":TYPE_CHEST,"category":CATEGORY_CHESTS,"name_key":"common_chest_name","description_key":"common_chest_desc","price":500,"rarity":"comun","rarity_key":"rarity_common","required_level":1,"icon_key":"cofre_comun"},
		{"id":"cofre_poco_comun","type":TYPE_CHEST,"category":CATEGORY_CHESTS,"name_key":"uncommon_chest_name","description_key":"uncommon_chest_desc","price":1500,"rarity":"poco_comun","rarity_key":"rarity_uncommon","required_level":1,"icon_key":"cofre_poco_comun"},
		{"id":"cofre_raro","type":TYPE_CHEST,"category":CATEGORY_CHESTS,"name_key":"rare_chest_name","description_key":"rare_chest_desc","price":5000,"rarity":"raro","rarity_key":"rarity_rare","required_level":1,"icon_key":"cofre_raro"},
		{"id":"cofre_epico","type":TYPE_CHEST,"category":CATEGORY_CHESTS,"name_key":"epic_chest_name","description_key":"epic_chest_desc","price":15000,"rarity":"epico","rarity_key":"rarity_epic","required_level":EPIC_CHEST_UNLOCK_LEVEL,"icon_key":"cofre_epico"}
	]
	product_by_id.clear()
	for product: Dictionary in products:
		product_by_id[str(product.get("id", ""))] = product

func _recommended_product_ids() -> Array[String]:
	var level: int = _get_player_level()
	var result: Array[String] = ["pocion_menor", "pocion_vigor", "cofre_resonancia", "cofre_comun", "cofre_poco_comun", "cofre_raro"]
	if level >= EPIC_CHEST_UNLOCK_LEVEL:
		result.append("cofre_epico")
	return result

func _required_level(product: Dictionary) -> int:
	return maxi(1, int(product.get("required_level", 1)))

func _is_product_unlocked(product: Dictionary) -> bool:
	return _get_player_level() >= _required_level(product)

func _get_visible_products() -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	var recommended_ids: Array[String] = _recommended_product_ids()

	for product: Dictionary in products:
		var product_id: String = str(product.get("id", ""))
		var category: String = str(product.get("category", ""))

		if active_category == CATEGORY_RECOMMENDED:
			if recommended_ids.has(product_id):
				result.append(product)
		elif active_category == CATEGORY_ALL:
			result.append(product)
		elif category == active_category:
			result.append(product)

	return result

func _mount_top_button() -> void:
	if not is_instance_valid(main_interface_root):
		return

	var existing: Node = main_interface_root.find_child(
		"BotonTienda",
		true,
		false
	)

	if existing is Button:
		top_button = existing as Button
		top_button.tooltip_text = _text("open_shop")
		return

	top_button = Button.new()
	top_button.name = "BotonTienda"
	top_button.text = "◆"
	top_button.position = top_button_position
	top_button.size = top_button_size
	top_button.focus_mode = Control.FOCUS_NONE
	top_button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	top_button.tooltip_text = _text("open_shop")
	top_button.z_index = 4095

	if ResourceLoader.exists(MODULE_TOP_ICON_PATH):
		top_button.icon = load(MODULE_TOP_ICON_PATH) as Texture2D
		top_button.text = ""
		top_button.expand_icon = true
		top_button.add_theme_constant_override("icon_max_width", 22)

	top_button.add_theme_stylebox_override(
		"normal",
		_make_style(Color(0, 0, 0, 0), Color(0, 0, 0, 0), 0, 4)
	)
	top_button.add_theme_stylebox_override(
		"hover",
		_make_style(Color(0.16, 0.12, 0.02, 0.20), COLOR_GOLD, 1, 4)
	)
	top_button.add_theme_stylebox_override(
		"pressed",
		_make_style(Color(0.22, 0.18, 0.05, 0.28), COLOR_GOLD_BRIGHT, 1, 4)
	)
	top_button.pressed.connect(_on_top_button_pressed)
	main_interface_root.add_child(top_button)

func _on_top_button_pressed() -> void:
	if _main_blocks_shop_opening() and not shop_is_open:
		return
	toggle_shop()

func _sync_top_button_state() -> void:
	if not is_instance_valid(top_button):
		return
	top_button.tooltip_text = _text("open_shop")
	top_button.modulate = Color("#FFF0A0") if shop_is_open else Color.WHITE

func _build_shop_window() -> void:
	shop_window = Window.new()
	shop_window.name = "VentanaTiendaLyria"
	shop_window.title = _text("window_title")
	shop_window.size = shop_window_size
	shop_window.min_size = minimum_window_size
	shop_window.borderless = true
	shop_window.transparent_bg = true
	shop_window.always_on_top = true
	shop_window.visible = false
	shop_window.unresizable = false
	shop_window.close_requested.connect(close_shop)
	shop_window.size_changed.connect(_on_shop_window_size_changed)
	add_child(shop_window)

	scaled_root = Control.new()
	scaled_root.name = "EscalaTienda"
	scaled_root.position = Vector2.ZERO
	scaled_root.size = REFERENCE_SIZE
	scaled_root.mouse_filter = Control.MOUSE_FILTER_PASS
	scaled_root.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	shop_window.add_child(scaled_root)

	_build_background()
	_build_merchant()
	_build_header()
	_build_categories()
	_build_product_grid()
	_build_details()
	_build_footer()
	_build_drag_surface()

	_on_shop_window_size_changed()

	if is_instance_valid(game_ui) and game_ui.has_method("apply_font_to_tree"):
		game_ui.call("apply_font_to_tree", scaled_root)
	_force_shop_typography()

func _build_background() -> void:
	background_rect = TextureRect.new()
	background_rect.name = "FondoTienda"
	background_rect.position = Vector2.ZERO
	background_rect.size = REFERENCE_SIZE
	background_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	background_rect.stretch_mode = TextureRect.STRETCH_SCALE
	background_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	background_rect.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST

	var resolved_background: String = _resolve_resource_path(
		shop_background_path,
		SHOP_BACKGROUND_FALLBACKS
	)
	if not resolved_background.is_empty():
		background_rect.texture = load(resolved_background) as Texture2D
	else:
		push_warning("TiendaUI: no se encontró tienda_base.png.")

	scaled_root.add_child(background_rect)

func _build_merchant() -> void:
	merchant_rect = TextureRect.new()
	merchant_rect.name = "Lyria"
	merchant_rect.position = Vector2(972.0, 58.0)
	merchant_rect.size = Vector2(360.0, 465.0)
	merchant_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	merchant_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	merchant_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	merchant_rect.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	merchant_rect.z_index = 2

	var resolved_merchant: String = _resolve_resource_path(
		merchant_texture_path,
		MERCHANT_TEXTURE_FALLBACKS
	)
	if not resolved_merchant.is_empty():
		merchant_rect.texture = load(resolved_merchant) as Texture2D
	else:
		push_warning("TiendaUI: no se encontró elfa_tendera.png.")

	scaled_root.add_child(merchant_rect)

	if is_instance_valid(background_rect) and background_rect.texture != null:
		var counter_texture: AtlasTexture = AtlasTexture.new()
		counter_texture.atlas = background_rect.texture
		counter_texture.region = MERCHANT_COUNTER_REGION

		merchant_counter_overlay = TextureRect.new()
		merchant_counter_overlay.name = "FrontalMostrador"
		merchant_counter_overlay.position = MERCHANT_COUNTER_REGION.position
		merchant_counter_overlay.size = MERCHANT_COUNTER_REGION.size
		merchant_counter_overlay.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		merchant_counter_overlay.stretch_mode = TextureRect.STRETCH_SCALE
		merchant_counter_overlay.texture = counter_texture
		merchant_counter_overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
		merchant_counter_overlay.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		merchant_counter_overlay.z_index = 3
		scaled_root.add_child(merchant_counter_overlay)

	merchant_name_label = _create_label(
		scaled_root,
		"",
		Vector2(950.0, 446.0),
		Vector2(420.0, 38.0),
		23,
		HORIZONTAL_ALIGNMENT_CENTER,
		COLOR_GOLD_BRIGHT
	)
	merchant_name_label.z_index = 4
	merchant_name_label.add_theme_color_override("font_shadow_color", Color.BLACK)
	merchant_name_label.add_theme_constant_override("shadow_offset_x", 2)
	merchant_name_label.add_theme_constant_override("shadow_offset_y", 2)

	merchant_quote_label = _create_label(
		scaled_root,
		"",
		Vector2(972.0, 482.0),
		Vector2(376.0, 56.0),
		18,
		HORIZONTAL_ALIGNMENT_CENTER,
		COLOR_MUTED
	)
	merchant_quote_label.z_index = 4
	merchant_quote_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART

func _build_header() -> void:
	gold_label = _create_label(
		scaled_root,
		"",
		Vector2(48.0, 26.0),
		Vector2(238.0, 62.0),
		31,
		HORIZONTAL_ALIGNMENT_CENTER,
		COLOR_GOLD_BRIGHT
	)

	title_label = _create_label(
		scaled_root,
		"",
		Vector2(320.0, 18.0),
		Vector2(600.0, 75.0),
		40,
		HORIZONTAL_ALIGNMENT_CENTER,
		COLOR_GOLD_BRIGHT
	)

	close_button = _create_button(
		scaled_root,
		"×",
		Vector2(1370.0, 20.0),
		Vector2(54.0, 54.0),
		26
	)
	close_button.tooltip_text = _text("close")
	close_button.add_theme_stylebox_override(
		"normal",
		_make_style(Color(0.28, 0.035, 0.045, 0.96), Color("#CF5B61"), 2, 7)
	)
	close_button.add_theme_stylebox_override(
		"hover",
		_make_style(Color(0.50, 0.055, 0.065, 1.0), Color("#FF9A9E"), 2, 7)
	)
	close_button.pressed.connect(close_shop)

func _build_categories() -> void:
	var definitions: Array[Dictionary] = [
		{"id": CATEGORY_RECOMMENDED, "key": "recommended", "y": 116.0},
		{"id": CATEGORY_POTIONS, "key": "potions", "y": 207.0},
		{"id": CATEGORY_CHESTS, "key": "chests", "y": 298.0},
		{"id": CATEGORY_ALL, "key": "all", "y": 389.0}
	]

	for definition: Dictionary in definitions:
		var category_id: String = str(definition.get("id", ""))
		var button: Button = _create_button(
			scaled_root,
			"",
			Vector2(34.0, float(definition.get("y", 0.0))),
			Vector2(235.0, 76.0),
			23
		)
		button.name = "Categoria_" + category_id
		button.set_meta("category_id", category_id)
		button.pressed.connect(_on_category_pressed.bind(category_id))
		category_buttons[category_id] = button

func _build_product_grid() -> void:
	var slot_width: float = 280.0
	var slot_height: float = 140.0
	var start_x: float = 305.0
	var start_y: float = 130.0
	var gap_x: float = 20.0
	var gap_y: float = 20.0

	for index: int in range(10):
		var column: int = index % 2
		var row: int = index >> 1
		var card_position: Vector2 = Vector2(
			start_x + float(column) * (slot_width + gap_x),
			start_y + float(row) * (slot_height + gap_y)
		)

		var card: Button = _create_button(
			scaled_root,
			"",
			card_position,
			Vector2(slot_width, slot_height),
			16
		)
		card.name = "Producto_%02d" % index
		card.clip_contents = true
		card.add_theme_stylebox_override(
			"normal",
			_make_style(Color(0.005, 0.010, 0.014, 0.36), Color(0.30, 0.22, 0.12, 0.55), 1, 5)
		)
		card.add_theme_stylebox_override(
			"hover",
			_make_style(COLOR_PANEL_HOVER, COLOR_EMERALD, 2, 5)
		)
		card.add_theme_stylebox_override(
			"pressed",
			_make_style(Color(0.04, 0.15, 0.10, 0.96), COLOR_GOLD_BRIGHT, 2, 5)
		)
		card.add_theme_stylebox_override(
			"disabled",
			_make_style(Color(0.012, 0.014, 0.018, 0.86), Color(0.24, 0.24, 0.28, 0.80), 1, 5)
		)
		card.pressed.connect(_on_product_card_pressed.bind(index))

		var icon: TextureRect = TextureRect.new()
		icon.position = Vector2(12.0, 24.0)
		icon.size = Vector2(76.0, 76.0)
		icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
		icon.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		card.add_child(icon)

		var name_label: Label = _create_label(
			card,
			"",
			Vector2(94.0, 12.0),
			Vector2(174.0, 34.0),
			22,
			HORIZONTAL_ALIGNMENT_LEFT,
			COLOR_TEXT
		)

		var description_label: Label = _create_label(
			card,
			"",
			Vector2(94.0, 45.0),
			Vector2(174.0, 58.0),
			17,
			HORIZONTAL_ALIGNMENT_LEFT,
			COLOR_MUTED
		)
		description_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART

		var price_label: Label = _create_label(
			card,
			"",
			Vector2(94.0, 104.0),
			Vector2(174.0, 28.0),
			20,
			HORIZONTAL_ALIGNMENT_LEFT,
			COLOR_GOLD_BRIGHT
		)

		product_cards.append(card)
		product_card_icons.append(icon)
		product_card_names.append(name_label)
		product_card_descriptions.append(description_label)
		product_card_prices.append(price_label)

func _build_details() -> void:
	detail_icon = TextureRect.new()
	detail_icon.position = Vector2(960.0, 575.0)
	detail_icon.size = Vector2(130.0, 130.0)
	detail_icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	detail_icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	detail_icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
	detail_icon.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	scaled_root.add_child(detail_icon)

	detail_name_label = _create_label(
		scaled_root,
		"",
		Vector2(1090.0, 550.0),
		Vector2(275.0, 46.0),
		27,
		HORIZONTAL_ALIGNMENT_CENTER,
		COLOR_EMERALD
	)

	detail_rarity_label = _create_label(
		scaled_root,
		"",
		Vector2(1090.0, 596.0),
		Vector2(275.0, 30.0),
		19,
		HORIZONTAL_ALIGNMENT_CENTER,
		COLOR_GOLD
	)

	detail_description_label = _create_label(
		scaled_root,
		"",
		Vector2(1098.0, 635.0),
		Vector2(260.0, 115.0),
		19,
		HORIZONTAL_ALIGNMENT_LEFT,
		COLOR_TEXT
	)
	detail_description_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	detail_description_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER

	quantity_title_label = _create_label(
		scaled_root,
		"",
		Vector2(1040.0, 792.0),
		Vector2(250.0, 30.0),
		19,
		HORIZONTAL_ALIGNMENT_CENTER,
		COLOR_EMERALD
	)

	minus_button = _create_button(
		scaled_root,
		"◀",
		Vector2(1030.0, 828.0),
		Vector2(58.0, 48.0),
		18
	)
	minus_button.pressed.connect(_change_quantity.bind(-1))

	quantity_value_label = _create_label(
		scaled_root,
		"1",
		Vector2(1100.0, 828.0),
		Vector2(170.0, 48.0),
		25,
		HORIZONTAL_ALIGNMENT_CENTER,
		COLOR_TEXT
	)
	quantity_value_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	quantity_value_label.add_theme_stylebox_override(
		"normal",
		_make_style(Color(0.004, 0.008, 0.012, 0.94), Color(0.32, 0.28, 0.20, 0.8), 1, 4)
	)

	plus_button = _create_button(
		scaled_root,
		"▶",
		Vector2(1280.0, 828.0),
		Vector2(58.0, 48.0),
		18
	)
	plus_button.pressed.connect(_change_quantity.bind(1))

	total_label = _create_label(
		scaled_root,
		"",
		Vector2(985.0, 890.0),
		Vector2(380.0, 42.0),
		25,
		HORIZONTAL_ALIGNMENT_CENTER,
		COLOR_GOLD_BRIGHT
	)

	buy_button = _create_button(
		scaled_root,
		"",
		Vector2(990.0, 940.0),
		Vector2(370.0, 72.0),
		30
	)
	buy_button.add_theme_stylebox_override(
		"normal",
		_make_style(Color(0.14, 0.36, 0.05, 0.98), Color("#A7DC39"), 2, 5)
	)
	buy_button.add_theme_stylebox_override(
		"hover",
		_make_style(Color(0.22, 0.54, 0.08, 1.0), Color("#E4FF78"), 2, 5)
	)
	buy_button.add_theme_stylebox_override(
		"pressed",
		_make_style(Color(0.10, 0.28, 0.04, 1.0), Color.WHITE, 2, 5)
	)
	buy_button.pressed.connect(_on_buy_pressed)

	status_label = _create_label(
		scaled_root,
		"",
		Vector2(36.0, 908.0),
		Vector2(235.0, 104.0),
		18,
		HORIZONTAL_ALIGNMENT_CENTER,
		COLOR_MUTED
	)
	status_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	status_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER

func _build_footer() -> void:
	region_label = _create_label(
		scaled_root,
		"",
		Vector2(42.0, 1020.0),
		Vector2(350.0, 42.0),
		17,
		HORIZONTAL_ALIGNMENT_LEFT,
		COLOR_EMERALD
	)

	footer_label = _create_label(
		scaled_root,
		"",
		Vector2(395.0, 1020.0),
		Vector2(540.0, 42.0),
		18,
		HORIZONTAL_ALIGNMENT_CENTER,
		COLOR_GOLD
	)

func _build_drag_surface() -> void:
	drag_surface = Control.new()
	drag_surface.name = "ZonaArrastre"
	drag_surface.position = Vector2(285.0, 0.0)
	drag_surface.size = Vector2(1080.0, drag_header_height)
	drag_surface.mouse_filter = Control.MOUSE_FILTER_STOP
	drag_surface.gui_input.connect(_on_drag_surface_input)
	scaled_root.add_child(drag_surface)
	drag_surface.move_to_front()

	close_button.move_to_front()

func _on_shop_window_size_changed() -> void:
	if not is_instance_valid(shop_window) or not is_instance_valid(scaled_root):
		return

	var available: Vector2 = Vector2(shop_window.size)
	var scale_factor: float = minf(
		available.x / REFERENCE_SIZE.x,
		available.y / REFERENCE_SIZE.y
	)
	scale_factor = maxf(scale_factor, 0.35)

	scaled_root.scale = Vector2.ONE * scale_factor
	scaled_root.position = (
		available - REFERENCE_SIZE * scale_factor
	) * 0.5

func _on_drag_surface_input(event: InputEvent) -> void:
	if not allow_window_drag or not is_instance_valid(shop_window):
		return

	if event is InputEventMouseButton:
		var mouse_event: InputEventMouseButton = event as InputEventMouseButton
		if mouse_event.button_index == MOUSE_BUTTON_LEFT:
			if mouse_event.pressed:
				dragging_window = true
				drag_offset = (
					DisplayServer.mouse_get_position()
					- shop_window.position
				)
			else:
				dragging_window = false

	elif event is InputEventMouseMotion and dragging_window:
		shop_window.position = (
			DisplayServer.mouse_get_position() - drag_offset
		)

func _refresh_all() -> void:
	if not is_instance_valid(scaled_root):
		return

	if is_instance_valid(shop_window):
		shop_window.title = _text("window_title")

	if is_instance_valid(title_label):
		title_label.text = _text("title")
	if is_instance_valid(merchant_name_label):
		merchant_name_label.text = _text("merchant_name")
	if is_instance_valid(merchant_quote_label):
		merchant_quote_label.text = _text("merchant_quote")
	if is_instance_valid(quantity_title_label):
		quantity_title_label.text = _text("quantity")
	if is_instance_valid(buy_button):
		buy_button.text = _text("buy")
	if is_instance_valid(close_button):
		close_button.tooltip_text = _text("close")
	if is_instance_valid(footer_label):
		footer_label.text = _text("footer")

	for category_id: String in category_buttons.keys():
		var button_variant: Variant = category_buttons.get(category_id)
		if button_variant is Button:
			var button: Button = button_variant as Button
			button.text = _category_text(category_id)
			_style_category_button(button, category_id == active_category)

	_refresh_region_label()
	_refresh_gold_only()
	_refresh_product_grid()
	_refresh_selected_product()
	_sync_top_button_state()

	if is_instance_valid(game_ui) and game_ui.has_method("apply_font_to_tree"):
		game_ui.call("apply_font_to_tree", scaled_root)
	_force_shop_typography()

func _refresh_gold_only() -> void:
	if is_instance_valid(gold_label):
		gold_label.text = _text("gold") % _get_gold()

	if is_instance_valid(total_label):
		total_label.text = _text("total") % _get_total_price()

	if is_instance_valid(buy_button):
		var total_price: int = _get_total_price()
		var selected_product: Dictionary = _get_selected_product()
		buy_button.disabled = (
			selected_product_id.is_empty()
			or selected_product.is_empty()
			or not _is_product_unlocked(selected_product)
			or _get_gold() < total_price
			or total_price <= 0
		)

func _refresh_region_label() -> void:
	if not is_instance_valid(region_label):
		return
	region_label.text = _text("region") % _get_current_zone_name()

func _refresh_product_grid() -> void:
	var visible_products: Array[Dictionary] = _get_visible_products()

	for index: int in range(product_cards.size()):
		var card: Button = product_cards[index]
		if index >= visible_products.size():
			card.visible = false
			card.disabled = false
			card.set_meta("product_id", "")
			continue

		var product: Dictionary = visible_products[index]
		var product_id: String = str(product.get("id", ""))
		var product_unlocked: bool = _is_product_unlocked(product)
		var required_level: int = _required_level(product)

		card.visible = true
		card.disabled = not product_unlocked
		card.set_meta("product_id", product_id)

		var icon_key: String = str(product.get("icon_key", ""))
		product_card_icons[index].texture = _load_product_icon(icon_key)
		product_card_icons[index].modulate = (
			Color.WHITE if product_unlocked else Color(0.42, 0.45, 0.50, 0.82)
		)

		product_card_names[index].text = _text(str(product.get("name_key", "")))
		product_card_descriptions[index].text = (
			_text(str(product.get("description_key", "")))
			if product_unlocked
			else _text("unlock_level_desc") % required_level
		)
		product_card_prices[index].text = (
			"◆  %s" % _format_number(int(product.get("price", 0)))
			if product_unlocked
			else _text("unlock_level") % required_level
		)

		var rarity: String = str(product.get("rarity", "comun"))
		var accent: Color = BaseDatosObjetos.obtener_color_rareza(rarity)
		product_card_names[index].add_theme_color_override(
			"font_color",
			accent if product_unlocked else COLOR_MUTED
		)
		product_card_descriptions[index].add_theme_color_override(
			"font_color",
			COLOR_MUTED
		)
		product_card_prices[index].add_theme_color_override(
			"font_color",
			COLOR_GOLD_BRIGHT if product_unlocked else COLOR_DANGER
		)

		var selected: bool = product_unlocked and product_id == selected_product_id
		card.add_theme_stylebox_override(
			"normal",
			_make_style(
				Color(accent.r, accent.g, accent.b, 0.12 if selected else 0.035),
				accent if selected else Color(0.30, 0.22, 0.12, 0.55),
				2 if selected else 1,
				5
			)
		)

func _refresh_selected_product() -> void:
	var product: Dictionary = _get_selected_product()
	if product.is_empty():
		if is_instance_valid(detail_name_label): detail_name_label.text = _text("select_product")
		if is_instance_valid(detail_rarity_label): detail_rarity_label.text = ""
		if is_instance_valid(detail_description_label): detail_description_label.text = ""
		if is_instance_valid(detail_icon): detail_icon.texture = null
		return
	var rarity: String = str(product.get("rarity", "comun"))
	var rarity_color: Color = BaseDatosObjetos.obtener_color_rareza(rarity)
	var product_type: String = str(product.get("type", ""))
	var is_chest: bool = product_type == TYPE_CHEST or product_type == TYPE_SURPRISE_CHEST
	var is_surprise: bool = product_type == TYPE_SURPRISE_CHEST
	var product_unlocked: bool = _is_product_unlocked(product)
	var required_level: int = _required_level(product)
	detail_name_label.text = _text(str(product.get("name_key", "")))
	detail_name_label.add_theme_color_override("font_color", rarity_color if product_unlocked else COLOR_MUTED)
	detail_rarity_label.text = _product_rarity_text(product) if product_unlocked else _text("unlock_level") % required_level
	detail_rarity_label.add_theme_color_override("font_color", rarity_color if product_unlocked else COLOR_DANGER)
	detail_icon.texture = _load_product_icon(str(product.get("icon_key", "")))
	detail_icon.modulate = Color.WHITE if product_unlocked else Color(0.45, 0.48, 0.52, 0.86)
	var description: String = _text(str(product.get("description_key", "")))
	if not product_unlocked:
		description = _text("unlock_level_desc") % required_level
	elif is_surprise:
		description += "\n\n" + _text("resonance_note")
	elif is_chest:
		description += "\n\n" + _text("rank_chest_note")
		description += "\n" + _text("no_legendary_unique")
	detail_description_label.text = description
	if is_chest:
		purchase_quantity = 1
	minus_button.disabled = not product_unlocked or is_chest or purchase_quantity <= 1
	plus_button.disabled = not product_unlocked or is_chest or purchase_quantity >= 99
	quantity_value_label.text = str(purchase_quantity)
	total_label.text = _text("total") % _get_total_price()
	_refresh_gold_only()

func _style_category_button(button: Button, selected: bool) -> void:
	var accent: Color = COLOR_EMERALD if selected else COLOR_GOLD
	button.add_theme_color_override(
		"font_color",
		COLOR_EMERALD if selected else COLOR_TEXT
	)
	button.add_theme_stylebox_override(
		"normal",
		_make_style(
			Color(accent.r, accent.g, accent.b, 0.18 if selected else 0.03),
			accent if selected else Color(0.28, 0.20, 0.10, 0.65),
			2 if selected else 1,
			5
		)
	)
	button.add_theme_stylebox_override(
		"hover",
		_make_style(Color(0.03, 0.15, 0.10, 0.82), COLOR_EMERALD, 2, 5)
	)

func _category_text(category_id: String) -> String:
	match category_id:
		CATEGORY_RECOMMENDED:
			return _text("recommended")
		CATEGORY_POTIONS:
			return _text("potions")
		CATEGORY_CHESTS:
			return _text("chests")
		CATEGORY_ALL:
			return _text("all")
		_:
			return category_id

func _product_rarity_text(product: Dictionary) -> String:
	var rarity_key: String = str(product.get("rarity_key", ""))
	if not rarity_key.is_empty():
		return _text(rarity_key)
	return BaseDatosObjetos.obtener_nombre_rareza(
		str(product.get("rarity", "comun"))
	)

func _on_category_pressed(category_id: String) -> void:
	active_category = category_id
	var visible_products: Array[Dictionary] = _get_visible_products()
	if not visible_products.is_empty():
		selected_product_id = str(visible_products[0].get("id", ""))
	purchase_quantity = 1
	_refresh_all()

func _on_product_card_pressed(card_index: int) -> void:
	if card_index < 0 or card_index >= product_cards.size():
		return
	var product_id: String = str(
		product_cards[card_index].get_meta("product_id", "")
	)
	if product_id.is_empty():
		return
	selected_product_id = product_id
	purchase_quantity = 1
	_refresh_product_grid()
	_refresh_selected_product()

func _change_quantity(delta: int) -> void:
	var product: Dictionary = _get_selected_product()
	if product.is_empty():
		return
	var product_type: String = str(product.get("type", ""))
	if product_type == TYPE_CHEST or product_type == TYPE_SURPRISE_CHEST:
		purchase_quantity = 1
	else:
		purchase_quantity = clampi(purchase_quantity + delta, 1, 99)
	_refresh_selected_product()

func _on_buy_pressed() -> void:
	if surprise_animation_running:
		return
	var product: Dictionary = _get_selected_product()
	if product.is_empty():
		return
	if not _is_product_unlocked(product):
		var required_level: int = _required_level(product)
		_show_status(_text("unlock_level_desc") % required_level, COLOR_DANGER)
		purchase_failed.emit("level_locked")
		return
	_refresh_references()
	if not is_instance_valid(inventory_ui) or not inventory_ui.has_method("add_item"):
		_show_status(_text("missing_inventory"), COLOR_DANGER)
		purchase_failed.emit("missing_inventory")
		return
	var total_price: int = _get_total_price()
	if _get_gold() < total_price:
		_show_status(_text("not_enough_gold"), COLOR_DANGER)
		purchase_failed.emit("not_enough_gold")
		return
	var product_type: String = str(product.get("type", ""))
	if product_type == TYPE_POTION:
		_buy_potion(product, total_price)
	elif product_type == TYPE_CHEST:
		_buy_rank_chest(product, total_price)
	elif product_type == TYPE_SURPRISE_CHEST:
		_buy_surprise_chest(product, total_price)

func _buy_potion(product: Dictionary, total_price: int) -> void:
	var item_id: String = str(product.get("item_id", ""))
	var item_data: Dictionary = BaseDatosObjetos.completar_objeto_guardado(
		{
			"id": item_id,
			"quantity": purchase_quantity,
			"item_level": maxi(1, _get_player_level()),
			"source_zone": _get_current_zone_id()
		}
	)

	if item_data.is_empty():
		_show_status(_text("generation_failed"), COLOR_DANGER)
		purchase_failed.emit("generation_failed")
		return

	var added: bool = bool(inventory_ui.call("add_item", item_data))
	if not added:
		_show_status(_text("inventory_full"), COLOR_DANGER)
		purchase_failed.emit("inventory_full")
		return

	_spend_gold(total_price)
	var item_name: String = str(item_data.get("name", _text(str(product.get("name_key", "")))))
	_show_status(
		_text("purchase_success") % [item_name, total_price],
		COLOR_EMERALD
	)
	purchase_completed.emit(item_data, total_price)
	_refresh_all()

func _buy_rank_chest(product: Dictionary, total_price: int) -> void:
	var target_rarity: String = str(product.get("rarity", "comun"))

	if target_rarity == "legendario" or target_rarity == "unico":
		_show_status(_text("generation_failed"), COLOR_DANGER)
		purchase_failed.emit("blocked_rarity")
		return

	var generated_item: Dictionary = BaseDatosObjetos.generar_objeto_tienda(
		target_rarity,
		_get_player_level(),
		_get_character_id(),
		_get_current_zone_id()
	)

	if generated_item.is_empty():
		_show_status(_text("generation_failed"), COLOR_DANGER)
		purchase_failed.emit("generation_failed")
		return

	var generated_rarity: String = str(
		generated_item.get("rarity", generated_item.get("rareza", "comun"))
	)
	if generated_rarity != target_rarity:
		_show_status(_text("generation_failed"), COLOR_DANGER)
		purchase_failed.emit("wrong_rarity")
		return

	var added: bool = bool(inventory_ui.call("add_item", generated_item))
	if not added:
		_show_status(_text("inventory_full"), COLOR_DANGER)
		purchase_failed.emit("inventory_full")
		return

	_spend_gold(total_price)
	var reward_name: String = str(generated_item.get("name", "Objeto"))
	_show_status(_text("chest_success") % reward_name, _get_item_color(generated_item))
	purchase_completed.emit(generated_item, total_price)
	_register_chest_opened()
	_refresh_all()

func _buy_surprise_chest(product: Dictionary, total_price: int) -> void:
	if surprise_animation_running:
		return
	if inventory_ui.has_method("get_free_slot_count") and int(inventory_ui.call("get_free_slot_count")) <= 0:
		_show_status(_text("inventory_full"), COLOR_DANGER)
		purchase_failed.emit("inventory_full")
		return
	var selected_rarity: String = _choose_resonance_rarity()
	var generated_item: Dictionary = BaseDatosObjetos.generar_objeto_forzado(selected_rarity, _get_player_level(), _get_character_id(), _get_current_zone_id())
	if generated_item.is_empty():
		_show_status(_text("generation_failed"), COLOR_DANGER)
		purchase_failed.emit("generation_failed")
		return
	_spend_gold(total_price)
	surprise_animation_running = true
	surprise_pending_item = generated_item.duplicate(true)
	buy_button.disabled = true
	await _play_resonance_animation(selected_rarity, generated_item)
	if not is_instance_valid(inventory_ui):
		_refund_gold(total_price)
		surprise_animation_running = false
		return
	var added: bool = bool(inventory_ui.call("add_item", generated_item))
	if not added:
		_refund_gold(total_price)
		_show_status(_text("inventory_full"), COLOR_DANGER)
		purchase_failed.emit("inventory_full")
	else:
		var reward_name: String = str(generated_item.get("name", "Objeto"))
		_show_status(_text("chest_success") % reward_name, _get_item_color(generated_item))
		purchase_completed.emit(generated_item, total_price)
		_register_chest_opened()
	surprise_pending_item = {}
	surprise_animation_running = false
	buy_button.disabled = false
	_refresh_all()

func _register_chest_opened() -> void:
	if not is_instance_valid(main_controller) or not main_controller.has_method("get_mission_system"):
		return
	var missions: Node = main_controller.call("get_mission_system") as Node
	if is_instance_valid(missions) and missions.has_method("registrar_cofre"):
		missions.call("registrar_cofre", _get_current_zone_id())

func _choose_resonance_rarity() -> String:
	var roll: float = randf() * 100.0
	var cumulative: float = 0.0
	var table: Array[Dictionary] = [
		{"id":"comun","weight":42.0}, {"id":"poco_comun","weight":28.0},
		{"id":"raro","weight":17.0}, {"id":"epico","weight":8.0},
		{"id":"legendario","weight":3.5}, {"id":"mitico","weight":1.0},
		{"id":"ancestral","weight":0.45}, {"id":"unico","weight":0.05}
	]
	for entry: Dictionary in table:
		cumulative += float(entry.get("weight", 0.0))
		if roll <= cumulative:
			return str(entry.get("id", "comun"))
	return "comun"

func _play_resonance_animation(winner_rarity: String, item_data: Dictionary) -> void:
	_build_resonance_overlay()
	if not is_instance_valid(surprise_overlay) or not is_instance_valid(surprise_track):
		return
	surprise_overlay.visible = true
	surprise_overlay.move_to_front()
	if is_instance_valid(surprise_claim_button):
		surprise_claim_button.visible = false
	if is_instance_valid(surprise_result_label):
		surprise_result_label.text = _text("resonance_subtitle")
	if is_instance_valid(surprise_rarity_label):
		surprise_rarity_label.text = ""
	for child: Node in surprise_track.get_children():
		child.queue_free()
	var sequence: Array[String] = []
	var pool: Array[String] = ["comun","poco_comun","raro","epico","legendario","mitico","ancestral"]
	for index: int in range(31):
		sequence.append(pool[randi_range(0, pool.size() - 1)])
	var winner_index: int = 26
	sequence[winner_index] = winner_rarity
	var card_width: float = 150.0
	var gap: float = 12.0
	for index: int in range(sequence.size()):
		var rarity: String = sequence[index]
		var card: Panel = Panel.new()
		card.position = Vector2(float(index) * (card_width + gap), 0.0)
		card.size = Vector2(card_width, 142.0)
		var accent: Color = BaseDatosObjetos.obtener_color_rareza(rarity)
		card.add_theme_stylebox_override("panel", _make_style(Color(accent.r,accent.g,accent.b,0.14), accent, 2, 9))
		surprise_track.add_child(card)
		var symbol: Label = _create_label(card, "◆", Vector2(0, 18), Vector2(card_width, 60), 42, HORIZONTAL_ALIGNMENT_CENTER, accent)
		var rarity_label: Label = _create_label(card, BaseDatosObjetos.obtener_nombre_rareza(rarity), Vector2(6, 85), Vector2(card_width-12, 40), 17, HORIZONTAL_ALIGNMENT_CENTER, Color.WHITE)
		rarity_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	var viewport_width: float = 1000.0
	var marker_x: float = viewport_width * 0.5
	var target_x: float = marker_x - (float(winner_index) * (card_width + gap) + card_width * 0.5)
	surprise_track.position = Vector2(80.0, 9.0)
	var tween: Tween = create_tween()
	tween.set_trans(Tween.TRANS_QUINT)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(surprise_track, "position:x", target_x, 5.4)
	await tween.finished
	var winner_color: Color = BaseDatosObjetos.obtener_color_rareza(winner_rarity)
	if is_instance_valid(surprise_result_label):
		surprise_result_label.text = _text("resonance_result") + "\n" + str(item_data.get("name", "Objeto"))
		surprise_result_label.add_theme_color_override("font_color", winner_color)
	if is_instance_valid(surprise_rarity_label):
		surprise_rarity_label.text = BaseDatosObjetos.obtener_nombre_rareza(winner_rarity)
		surprise_rarity_label.add_theme_color_override("font_color", winner_color)
	if is_instance_valid(surprise_claim_button):
		surprise_claim_button.visible = true
		await surprise_claim_button.pressed
	if is_instance_valid(surprise_overlay):
		surprise_overlay.visible = false

func _build_resonance_overlay() -> void:
	if is_instance_valid(surprise_overlay):
		return
	surprise_overlay = Control.new()
	surprise_overlay.name = "ResonanciaFractura"
	surprise_overlay.position = Vector2.ZERO
	surprise_overlay.size = REFERENCE_SIZE
	surprise_overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	surprise_overlay.z_index = 500
	surprise_overlay.visible = false
	scaled_root.add_child(surprise_overlay)
	var shade: ColorRect = ColorRect.new()
	shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	shade.color = Color(0.002,0.004,0.010,0.96)
	shade.mouse_filter = Control.MOUSE_FILTER_STOP
	surprise_overlay.add_child(shade)
	var frame: Panel = Panel.new()
	frame.position = Vector2(170, 95)
	frame.size = Vector2(1108, 860)
	frame.add_theme_stylebox_override("panel", _make_style(Color(0.006,0.012,0.022,0.99), Color("#E7C45E"), 3, 16))
	surprise_overlay.add_child(frame)
	var title: Label = _create_label(frame, _text("resonance_title"), Vector2(30, 28), Vector2(1048, 60), 38, HORIZONTAL_ALIGNMENT_CENTER, COLOR_GOLD_BRIGHT)
	surprise_result_label = _create_label(frame, _text("resonance_subtitle"), Vector2(90, 100), Vector2(928, 94), 24, HORIZONTAL_ALIGNMENT_CENTER, COLOR_TEXT)
	surprise_result_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	var viewport: Panel = Panel.new()
	viewport.position = Vector2(54, 215)
	viewport.size = Vector2(1000, 160)
	viewport.clip_contents = true
	viewport.add_theme_stylebox_override("panel", _make_style(Color(0.001,0.006,0.012,0.98), Color("#4D6078"), 2, 10))
	frame.add_child(viewport)
	surprise_track = Control.new()
	surprise_track.position = Vector2(80, 9)
	surprise_track.size = Vector2(5200, 142)
	viewport.add_child(surprise_track)
	var marker: ColorRect = ColorRect.new()
	marker.position = Vector2(497, 0)
	marker.size = Vector2(6, 160)
	marker.color = Color("#FFE18A")
	marker.mouse_filter = Control.MOUSE_FILTER_IGNORE
	viewport.add_child(marker)
	var marker_top: Label = _create_label(viewport, "▼", Vector2(477,-2), Vector2(46,32), 24, HORIZONTAL_ALIGNMENT_CENTER, Color("#FFE18A"))
	marker_top.z_index = 5
	surprise_rarity_label = _create_label(frame, "", Vector2(170, 630), Vector2(768, 55), 32, HORIZONTAL_ALIGNMENT_CENTER, COLOR_GOLD_BRIGHT)
	surprise_claim_button = _create_button(frame, _text("resonance_close"), Vector2(354, 710), Vector2(400, 82), 30)
	surprise_claim_button.visible = false
	surprise_claim_button.add_theme_stylebox_override("normal", _make_style(Color(0.05,0.28,0.18,0.98), Color("#7EF2B8"), 3, 10))
func _get_selected_product() -> Dictionary:
	var product_variant: Variant = product_by_id.get(selected_product_id, {})
	if product_variant is Dictionary:
		return product_variant as Dictionary
	return {}

func _get_total_price() -> int:
	var product: Dictionary = _get_selected_product()
	if product.is_empty():
		return 0
	var price: int = maxi(0, int(product.get("price", 0)))
	var quantity: int = 1
	if str(product.get("type", "")) == TYPE_POTION:
		quantity = maxi(1, purchase_quantity)
	return price * quantity

func _get_gold() -> int:
	if is_instance_valid(main_controller):
		var value: Variant = main_controller.get("player_gold")
		if value is int or value is float:
			return maxi(0, int(value))

	var config: ConfigFile = ConfigFile.new()
	if config.load(SAVE_PATH) == OK:
		return maxi(0, int(config.get_value("jugador", "oro", 0)))
	return 0

func _spend_gold(amount: int) -> void:
	var cost: int = maxi(0, amount)
	var current_gold: int = _get_gold()
	var new_gold: int = maxi(0, current_gold - cost)
	if is_instance_valid(inventory_ui) and inventory_ui.has_method("add_gold"):
		inventory_ui.call("add_gold", -cost)
	if is_instance_valid(main_controller):
		main_controller.set("player_gold", new_gold)
		if main_controller.has_method("_update_player_interface_only"):
			main_controller.call("_update_player_interface_only")
		elif main_controller.has_method("_update_interface"):
			main_controller.call("_update_interface")
		if main_controller.has_method("_save_progress"):
			main_controller.call("_save_progress")
	var config: ConfigFile = ConfigFile.new()
	config.load(SAVE_PATH)
	config.set_value("jugador", "oro", new_gold)
	config.save(SAVE_PATH)
	_refresh_gold_only()

func _refund_gold(amount: int) -> void:
	var refund: int = maxi(0, amount)
	if refund <= 0:
		return
	var new_gold: int = _get_gold() + refund
	if is_instance_valid(inventory_ui) and inventory_ui.has_method("add_gold"):
		inventory_ui.call("add_gold", refund)
	if is_instance_valid(main_controller):
		main_controller.set("player_gold", new_gold)
		if main_controller.has_method("_save_progress"):
			main_controller.call("_save_progress")
	var config: ConfigFile = ConfigFile.new()
	config.load(SAVE_PATH)
	config.set_value("jugador", "oro", new_gold)
	config.save(SAVE_PATH)

func _get_player_level() -> int:
	if is_instance_valid(main_controller):
		return maxi(1, int(main_controller.get("player_level")))
	return 1

func _get_character_id() -> String:
	if is_instance_valid(inventory_ui) and inventory_ui.has_method("get_active_character_id"):
		return str(inventory_ui.call("get_active_character_id"))

	if is_instance_valid(main_controller):
		var value: Variant = main_controller.get("current_character_id")
		if value != null:
			return str(value)
	return "paladin_alba"

func _get_current_zone_id() -> String:
	if is_instance_valid(main_controller):
		var value: Variant = main_controller.get("current_zone_id")
		if value != null:
			return SistemaRegiones.normalizar_zona(str(value))
	return SistemaRegiones.ZONA_VALDORIA

func _get_current_zone_name() -> String:
	return SistemaRegiones.obtener_nombre(
		_get_current_zone_id(),
		current_language,
		false
	)

func toggle_shop() -> void:
	if shop_is_open:
		close_shop()
	else:
		open_shop()

func is_shop_open() -> bool:
	return shop_is_open

func open_shop() -> void:
	if not initialized or not is_instance_valid(shop_window):
		return
	if _main_blocks_shop_opening():
		return

	_refresh_references()
	_refresh_all()
	_position_window_near_game()
	shop_window.show()
	shop_window.move_to_foreground()
	shop_is_open = true
	_sync_top_button_state()
	shop_opened.emit()

func close_shop() -> void:
	if surprise_animation_running:
		return
	if is_instance_valid(shop_window):
		shop_window.hide()
	shop_is_open = false
	dragging_window = false
	_sync_top_button_state()
	shop_closed.emit()

func _position_window_near_game() -> void:
	if not is_instance_valid(shop_window):
		return

	var game_window: Window = get_window()
	var desired: Vector2i = (
		game_window.position
		+ Vector2i(
			int(round(float(game_window.size.x - shop_window.size.x) / 2.0)),
			-int(round(float(maxi(0, shop_window.size.y - game_window.size.y)) / 2.0))
		)
	)

	desired.x = maxi(0, desired.x)
	desired.y = maxi(0, desired.y)
	shop_window.position = desired

func _show_status(message: String, color: Color) -> void:
	if not is_instance_valid(status_label):
		return

	status_label.text = message
	status_label.add_theme_color_override("font_color", color)
	status_label.modulate = Color.WHITE

	if is_instance_valid(status_tween):
		status_tween.kill()

	status_tween = create_tween()
	status_tween.tween_interval(2.4)
	status_tween.tween_property(status_label, "modulate:a", 0.45, 0.8)
	status_tween.tween_callback(
		func() -> void:
			if is_instance_valid(status_label):
				status_label.text = _text("select_product")
				status_label.modulate = Color.WHITE
				status_label.add_theme_color_override("font_color", COLOR_MUTED)
	)

func _load_shop_fonts() -> void:
	shop_regular_font = _load_font_resource(SHOP_REGULAR_FONT_PATH)
	shop_bold_font = _load_font_resource(SHOP_BOLD_FONT_PATH)

	if shop_regular_font == null and is_instance_valid(game_ui):
		if game_ui.has_method("get_pixel_font"):
			var regular_variant: Variant = game_ui.call("get_pixel_font")
			if regular_variant is Font:
				shop_regular_font = regular_variant as Font

	if shop_bold_font == null and is_instance_valid(game_ui):
		if game_ui.has_method("get_bold_pixel_font"):
			var bold_variant: Variant = game_ui.call("get_bold_pixel_font")
			if bold_variant is Font:
				shop_bold_font = bold_variant as Font

	if shop_bold_font == null:
		shop_bold_font = shop_regular_font

func _load_font_resource(path: String) -> Font:
	if not ResourceLoader.exists(path):
		return null
	var loaded: Resource = load(path)
	if loaded is Font:
		return loaded as Font
	return null

func _force_shop_typography() -> void:
	if not is_instance_valid(scaled_root):
		return

	var pending: Array[Node] = [scaled_root]
	while not pending.is_empty():
		var current: Node = pending.pop_back()
		if current is Control:
			var control: Control = current as Control
			control.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
			if control is Label or control is Button:
				var role: String = str(control.get_meta("ui_font_role", "body"))
				var chosen: Font = (
					shop_bold_font
					if role == "title" or control is Button
					else shop_regular_font
				)
				if chosen != null:
					control.add_theme_font_override("font", chosen)
				control.add_theme_constant_override(
					"outline_size",
					3 if role == "title" else 2
				)
				control.add_theme_color_override(
					"font_outline_color",
					Color(0.0, 0.0, 0.0, 0.92)
				)

		for child: Node in current.get_children():
			pending.append(child)

func _create_label(
	parent: Node,
	text: String,
	label_position: Vector2,
	label_size: Vector2,
	font_size: int,
	alignment: HorizontalAlignment,
	color: Color
) -> Label:
	var label: Label = Label.new()
	label.text = text
	label.position = label_position
	label.size = label_size
	label.horizontal_alignment = alignment
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", color)
	if font_size >= 18:
		label.set_meta("ui_font_role", "title")
		if shop_bold_font != null:
			label.add_theme_font_override("font", shop_bold_font)
		label.add_theme_constant_override("outline_size", 3)
	else:
		label.set_meta("ui_font_role", "body")
		if shop_regular_font != null:
			label.add_theme_font_override("font", shop_regular_font)
		label.add_theme_constant_override("outline_size", 2)
	label.add_theme_color_override("font_outline_color", Color(0.0, 0.0, 0.0, 0.92))
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	parent.add_child(label)
	return label

func _create_button(
	parent: Node,
	text: String,
	button_position: Vector2,
	button_size: Vector2,
	font_size: int
) -> Button:
	var button: Button = Button.new()
	button.text = text
	button.position = button_position
	button.size = button_size
	button.focus_mode = Control.FOCUS_NONE
	button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	button.add_theme_font_size_override("font_size", font_size)
	if shop_bold_font != null:
		button.add_theme_font_override("font", shop_bold_font)
	button.set_meta("ui_font_role", "title")
	button.add_theme_constant_override("outline_size", 3)
	button.add_theme_color_override("font_outline_color", Color(0.0, 0.0, 0.0, 0.92))
	button.add_theme_color_override("font_color", COLOR_TEXT)
	button.add_theme_color_override("font_hover_color", Color.WHITE)
	button.add_theme_color_override("font_pressed_color", COLOR_GOLD_BRIGHT)
	button.add_theme_stylebox_override(
		"normal",
		_make_style(COLOR_PANEL, Color(0.28, 0.20, 0.10, 0.70), 1, 5)
	)
	button.add_theme_stylebox_override(
		"hover",
		_make_style(COLOR_PANEL_HOVER, COLOR_GOLD, 2, 5)
	)
	button.add_theme_stylebox_override(
		"pressed",
		_make_style(Color(0.04, 0.12, 0.08, 0.98), COLOR_GOLD_BRIGHT, 2, 5)
	)
	parent.add_child(button)
	return button

func _make_style(
	background: Color,
	border: Color,
	border_width: int,
	corner_radius: int
) -> StyleBoxFlat:
	var style: StyleBoxFlat = StyleBoxFlat.new()
	style.bg_color = background
	style.border_color = border
	style.set_border_width_all(border_width)
	style.corner_radius_top_left = corner_radius
	style.corner_radius_top_right = corner_radius
	style.corner_radius_bottom_left = corner_radius
	style.corner_radius_bottom_right = corner_radius
	style.content_margin_left = 8.0
	style.content_margin_right = 8.0
	style.content_margin_top = 5.0
	style.content_margin_bottom = 5.0
	return style

func _load_product_icon(icon_key: String) -> Texture2D:
	var configured_path: String = str(PRODUCT_ICON_PATHS.get(icon_key, ""))
	var filename: String = configured_path.get_file()
	var candidates: Array[String] = []

	if not configured_path.is_empty():
		candidates.append(configured_path)

	for root_path: String in SHOP_ICON_ROOTS:
		if not filename.is_empty():
			candidates.append(root_path.path_join(filename))

	for icon_path: String in candidates:
		if not ResourceLoader.exists(icon_path):
			continue
		var resource: Resource = load(icon_path)
		if resource is Texture2D:
			return resource as Texture2D

	return null

func _resolve_resource_path(
	preferred_path: String,
	fallbacks: Array[String]
) -> String:
	if not preferred_path.is_empty() and ResourceLoader.exists(preferred_path):
		return preferred_path

	for fallback_path: String in fallbacks:
		if ResourceLoader.exists(fallback_path):
			return fallback_path

	return ""

func _get_item_color(item_data: Dictionary) -> Color:
	var rarity: String = str(
		item_data.get("rarity", item_data.get("rareza", "comun"))
	)
	return BaseDatosObjetos.obtener_color_rareza(rarity)

func _format_number(value: int) -> String:
	var text: String = str(absi(value))
	var result: String = ""
	var counter: int = 0

	for index: int in range(text.length() - 1, -1, -1):
		if counter > 0 and counter % 3 == 0:
			result = "." + result
		result = text.substr(index, 1) + result
		counter += 1

	return ("-" if value < 0 else "") + result
