extends Control
class_name ForjaUI

const MODULE_TOP_ICON_PATH: String = "res://Recursos/UI/IconosBarra/forja.svg"

signal forge_opened
signal forge_closed
signal item_inserted(slot_index: int, item_data: Dictionary)
signal item_removed(slot_index: int, item_data: Dictionary)
signal item_forged(item_data: Dictionary)

@export_group("Recursos")
@export_file("*.png") var forge_background_path: String = (
	"res://Recursos/UI/forja_pixel_transparente.png"
)

@export_group("Ventana")
@export var forge_window_size: Vector2i = Vector2i(820, 454)
@export var window_gap: int = 12
@export var open_inventory_together: bool = true
@export var start_open: bool = false

@export_group("Movimiento de ventana")
@export var permitir_mover_ventana: bool = true
@export_range(20.0, 100.0, 1.0) var altura_arrastre_ventana: float = 46.0

@export_group("Botón superior")
@export var top_button_position: Vector2 = Vector2(228.0, 8.0)
@export var top_button_size: Vector2 = Vector2(20.0, 20.0)
@export var top_button_symbol: String = "⚒"

@export_group("Forja")
@export_range(1, 10, 1) var required_items: int = 10
@export var allow_unique_as_material: bool = false

const REFERENCE_SIZE: Vector2 = Vector2(1666.0, 922.0)
const SAVE_PATH: String = "user://forja.cfg"
const SETTINGS_PATH: String = "user://opciones.cfg"
const CHARACTER_SAVE_PATH: String = "user://partida.cfg"
const SLOT_COUNT: int = 10

const SLOT_RECTS: Array[Rect2] = [
	Rect2(708.0, 404.0, 104.0, 104.0),
	Rect2(868.0, 404.0, 104.0, 104.0),
	Rect2(1028.0, 404.0, 104.0, 104.0),
	Rect2(1188.0, 404.0, 104.0, 104.0),
	Rect2(1348.0, 404.0, 104.0, 104.0),
	Rect2(708.0, 550.0, 104.0, 104.0),
	Rect2(868.0, 550.0, 104.0, 104.0),
	Rect2(1028.0, 550.0, 104.0, 104.0),
	Rect2(1188.0, 550.0, 104.0, 104.0),
	Rect2(1348.0, 550.0, 104.0, 104.0)
]

const RARITY_ORDER: Array[String] = [
	"comun",
	"poco_comun",
	"raro",
	"epico",
	"legendario",
	"mitico",
	"ancestral",
	"unico"
]

var translations: Dictionary = {
	"es": {
		"window_title": "Forja Ancestral",
		"open_forge": "Abrir forja [F]",
		"title": "FORJA ANCESTRAL",
		"description": "Coloca 10 objetos de la misma rareza. La forja los consumirá y creará un objeto aleatorio del siguiente grado.",
		"forge": "MEJORAR",
		"empty": "VACIAR",
		"close": "Cerrar",
		"slot_empty": "Hueco vacío\nArrastra aquí un objeto del inventario o pulsa para elegirlo.",
		"slot_remove": "Pulsa para devolver este objeto al inventario.",
		"selector_title": "ELIGE UN OBJETO",
		"selector_description": "Puedes usar cualquier objeto, pero los 10 deben tener la misma rareza.",
		"selector_empty": "No tienes objetos compatibles con la rareza actual.",
		"cancel": "CANCELAR",
		"missing_inventory": "No se encontró el nodo InventarioUI.",
		"need_items": "Necesitas %d objetos de la misma rareza.",
		"progress_empty": "%d / %d OBJETOS",
		"progress_recipe": "%d / %d · %s → %s",
		"ready": "La mejora está lista. El fuego espera tu decisión.",
		"inserted": "%s ha sido colocado en la forja.",
		"returned": "%s ha regresado al inventario.",
		"inventory_full": "El inventario está lleno. No se puede devolver el objeto.",
		"forge_failed": "La forja no pudo crear un objeto.",
		"output_full": "El inventario está lleno. La forja no consumirá los objetos.",
		"forged": "¡Has mejorado el botín y obtenido %s!",
		"same_rarity": "Todos los objetos deben ser de la misma rareza: %s.",
		"unique_protected": "Los objetos ÚNICOS son el grado máximo y no pueden mejorarse.",
		"max_rarity": "La rareza ANCESTRAL es el máximo grado que puede obtenerse mediante la forja.",
		"level": "Nivel %d",
		"effects": "Efectos",
		"click_select": "Pulsa para introducir este objeto.",
		"cleared": "Los objetos han vuelto al inventario.",
		"some_not_returned": "Algunos objetos no pudieron volver porque el inventario está lleno."
	},
	"en": {
		"window_title": "Ancestral Forge",
		"open_forge": "Open forge [F]",
		"title": "ANCESTRAL FORGE",
		"description": "Place 10 items of the same rarity. The forge consumes them and creates a random item of the next grade.",
		"forge": "UPGRADE",
		"empty": "EMPTY",
		"close": "Close",
		"slot_empty": "Empty slot\nDrag an inventory item here or click to choose one.",
		"slot_remove": "Click to return this item to the inventory.",
		"selector_title": "CHOOSE AN ITEM",
		"selector_description": "Any item can be used, but all 10 must share the same rarity.",
		"selector_empty": "You have no items matching the current rarity.",
		"cancel": "CANCEL",
		"missing_inventory": "InventarioUI node was not found.",
		"need_items": "You need %d items of the same rarity.",
		"progress_empty": "%d / %d ITEMS",
		"progress_recipe": "%d / %d · %s → %s",
		"ready": "The upgrade is ready. The fire awaits your choice.",
		"inserted": "%s was placed in the forge.",
		"returned": "%s returned to the inventory.",
		"inventory_full": "The inventory is full. The item cannot be returned.",
		"forge_failed": "The forge could not create an item.",
		"output_full": "The inventory is full. The forge will not consume the items.",
		"forged": "You upgraded the loot and obtained %s!",
		"same_rarity": "All items must have the same rarity: %s.",
		"unique_protected": "UNIQUE items are the maximum grade and cannot be upgraded.",
		"max_rarity": "ANCESTRAL is the highest grade obtainable through the forge.",
		"level": "Level %d",
		"effects": "Effects",
		"click_select": "Click to insert this item.",
		"cleared": "The items returned to the inventory.",
		"some_not_returned": "Some items could not return because the inventory is full."
	}
}

var current_language: String = "es"
var game_ui: Node
var forge_items: Array[Dictionary] = []
var forge_is_open: bool = false
var initialized: bool = false

var main_controller: Node
var main_interface_root: Control
var inventory_ui: Node
var top_button: Button

var forge_window: Window
var forge_window_dragging: bool = false
var forge_window_drag_offset: Vector2i = Vector2i.ZERO
var forge_window_manually_moved: bool = false
var overlay: Control
var menu_canvas: Control
var background_rect: TextureRect

var title_label: Label
var description_label: Label
var progress_label: Label
var status_label: Label
var forge_button: Button
var clear_button: Button
var close_button: Button
var slot_buttons: Array[Button] = []

var external_drag_preview: Panel
var external_drag_item: Dictionary = {}
var external_drag_inventory_index: int = -1
var external_drag_hover_slot: int = -1
var external_drag_signature: String = ""

var selector_panel: Panel
var selector_list: VBoxContainer
var selector_target_slot: int = -1

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	visible = true
	_prepare_forge_slots()
	_connect_game_ui()
	call_deferred("_initialize_forge")

func _initialize_forge() -> void:
	main_controller = get_parent()

	for _attempt in range(180):
		_refresh_references()
		if is_instance_valid(main_interface_root) and is_instance_valid(inventory_ui):
			break
		await get_tree().process_frame

	_load_language()
	_build_forge_window()
	_load_forge_state()
	_mount_top_button()
	_refresh_all()
	initialized = true

	if start_open:
		call_deferred("open_forge")

func _process(_delta: float) -> void:
	if not initialized:
		return

	if not is_instance_valid(top_button):
		_refresh_references()
		_mount_top_button()

	_sync_top_button_with_options()
	_update_external_drag_preview()

func _prepare_forge_slots() -> void:
	forge_items.clear()
	forge_items.resize(SLOT_COUNT)
	for index in range(SLOT_COUNT):
		forge_items[index] = {}

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

func _main_options_are_open() -> bool:
	if not is_instance_valid(main_controller):
		return false

	if main_controller.has_method("is_modal_ui_open"):
		return bool(main_controller.call("is_modal_ui_open"))

	var options_value: Variant = main_controller.get("options_open")
	return options_value is bool and bool(options_value)

func _sync_top_button_with_options() -> void:

	if is_instance_valid(top_button):
		top_button.tooltip_text = _text("open_forge")

func _connect_game_ui() -> void:
	game_ui = get_node_or_null("/root/GameUI")

	if not is_instance_valid(game_ui):
		return

	var callback: Callable = Callable(self, "_on_global_language_changed")
	if game_ui.has_signal("language_changed"):
		if not game_ui.is_connected("language_changed", callback):
			game_ui.connect("language_changed", callback)

func _on_global_language_changed(language_code: String) -> void:
	set_language(language_code)

func _load_language() -> void:
	if is_instance_valid(game_ui) and game_ui.has_method("get_language"):
		current_language = str(game_ui.call("get_language"))
	else:
		var config: ConfigFile = ConfigFile.new()
		if config.load(SETTINGS_PATH) == OK:
			current_language = str(
				config.get_value("general", "idioma", "es")
			).to_lower().strip_edges()

	if current_language != "es" and current_language != "en":
		current_language = "es"

func set_language(language_code: String) -> void:
	var normalized: String = language_code.to_lower().strip_edges()
	if normalized != "es" and normalized != "en":
		normalized = "es"
	current_language = normalized
	_refresh_language()

func _text(key: String) -> String:
	var spanish: Dictionary = translations.get("es", {})
	var selected: Dictionary = translations.get(current_language, spanish)
	return str(selected.get(key, spanish.get(key, key)))

func _refresh_language() -> void:
	if is_instance_valid(forge_window):
		forge_window.title = _text("window_title")
	if is_instance_valid(top_button):
		top_button.tooltip_text = _text("open_forge")
	if is_instance_valid(title_label):
		title_label.text = _text("title")
	if is_instance_valid(description_label):
		description_label.text = _text("description")
	if is_instance_valid(forge_button):
		forge_button.text = _text("forge")
	if is_instance_valid(clear_button):
		clear_button.text = _text("empty")
	if is_instance_valid(close_button):
		close_button.tooltip_text = _text("close")
	_refresh_all()

func _mount_top_button() -> void:
	if not is_instance_valid(main_interface_root):
		return

	var existing: Node = main_interface_root.find_child(
		"BotonForja",
		true,
		false
	)

	if existing is Button:
		top_button = existing as Button
		top_button.tooltip_text = _text("open_forge")
		return

	top_button = Button.new()
	top_button.name = "BotonForja"
	top_button.text = ""
	if ResourceLoader.exists("res://Recursos/UI/IconosBarra/forja.svg"):
		top_button.icon = load("res://Recursos/UI/IconosBarra/forja.svg") as Texture2D
	top_button.expand_icon = true
	top_button.icon_alignment = HORIZONTAL_ALIGNMENT_CENTER
	top_button.vertical_icon_alignment = VERTICAL_ALIGNMENT_CENTER
	top_button.add_theme_constant_override("icon_max_width", 10)
	top_button.position = top_button_position
	top_button.size = top_button_size
	top_button.focus_mode = Control.FOCUS_NONE
	top_button.tooltip_text = _text("open_forge")
	top_button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	top_button.pressed.connect(toggle_forge)
	main_interface_root.add_child(top_button)

func _unhandled_input(event: InputEvent) -> void:
	if not (event is InputEventKey):
		return

	var key_event: InputEventKey = event as InputEventKey
	if not key_event.pressed or key_event.echo:
		return

	if key_event.keycode == KEY_F:
		if not _main_options_are_open():
			toggle_forge()
			get_viewport().set_input_as_handled()
	elif key_event.keycode == KEY_ESCAPE and forge_is_open:
		if is_instance_valid(selector_panel):
			_close_selector()
		else:
			close_forge()
		get_viewport().set_input_as_handled()

func toggle_forge() -> void:
	if _main_options_are_open():
		return

	if forge_is_open:
		close_forge()
	else:
		open_forge()

func open_forge() -> void:
	if forge_is_open:
		return

	_refresh_references()
	_load_language()
	_refresh_language()

	if open_inventory_together and is_instance_valid(inventory_ui):
		if inventory_ui.has_method("open_inventory"):
			inventory_ui.call("open_inventory")
			await get_tree().process_frame

	forge_is_open = true
	visible = true

	if is_instance_valid(forge_window):
		forge_window.size = forge_window_size
		_position_forge_window()
		forge_window.show()

	call_deferred("_apply_native_transparency")
	_refresh_all()
	forge_opened.emit()

func close_forge() -> void:
	if not forge_is_open:
		return

	_clear_external_drag_preview()
	forge_is_open = false
	_close_selector()
	_save_forge_state()

	if is_instance_valid(forge_window):
		forge_window.hide()

	forge_closed.emit()

func is_forge_open() -> bool:
	return forge_is_open

func _position_forge_window(force_position: bool = false) -> void:
	if not is_instance_valid(forge_window):
		return
	if forge_window_manually_moved and not force_position:
		return

	var screen_index: int = DisplayServer.window_get_current_screen()
	var usable: Rect2i = DisplayServer.screen_get_usable_rect(screen_index)
	var target_position: Vector2i = get_window().position
	var reference_window: Window

	if is_instance_valid(inventory_ui):
		var inventory_window_variant: Variant = inventory_ui.get("inventory_window")
		if inventory_window_variant is Window:
			var possible_window: Window = inventory_window_variant as Window
			if possible_window.visible:
				reference_window = possible_window

	if is_instance_valid(reference_window):
		target_position = Vector2i(
			reference_window.position.x + reference_window.size.x + window_gap,
			reference_window.position.y
		)

		if target_position.x + forge_window.size.x > usable.position.x + usable.size.x:
			target_position.x = (
				reference_window.position.x
				- forge_window.size.x
				- window_gap
			)
	else:
		var game_window: Window = get_window()
		target_position = Vector2i(
			game_window.position.x + game_window.size.x + window_gap,
			game_window.position.y
		)

		if target_position.x + forge_window.size.x > usable.position.x + usable.size.x:
			target_position.x = game_window.position.x - forge_window.size.x - window_gap

	target_position.x = clampi(
		target_position.x,
		usable.position.x,
		usable.position.x + usable.size.x - forge_window.size.x
	)
	target_position.y = clampi(
		target_position.y,
		usable.position.y,
		usable.position.y + usable.size.y - forge_window.size.y
	)

	forge_window.position = target_position

func _apply_native_transparency() -> void:
	if not is_instance_valid(forge_window):
		return

	forge_window.transparent = true
	forge_window.transparent_bg = true

	if DisplayServer.is_window_transparency_available():
		DisplayServer.window_set_flag(
			DisplayServer.WINDOW_FLAG_TRANSPARENT,
			true,
			forge_window.get_window_id()
		)

func _on_forge_window_input(event: InputEvent) -> void:
	if event is InputEventKey:
		var key_event: InputEventKey = event as InputEventKey
		if not key_event.pressed or key_event.echo:
			return
		if key_event.keycode == KEY_ESCAPE or key_event.keycode == KEY_F:
			if is_instance_valid(selector_panel):
				_close_selector()
			else:
				close_forge()
		return

	if event is InputEventMouseButton:
		var mouse_event: InputEventMouseButton = event as InputEventMouseButton
		if mouse_event.button_index != MOUSE_BUTTON_LEFT:
			return

		if mouse_event.pressed:
			if _can_start_forge_window_drag(mouse_event.position):
				forge_window_dragging = true
				forge_window_drag_offset = (
					DisplayServer.mouse_get_position()
					- forge_window.position
				)
				return
		else:
			if forge_window_dragging:
				forge_window_dragging = false
				forge_window_manually_moved = true
				return

			if get_tree().root.has_meta("taskbar_inventory_drag_index"):
				var inventory_index: int = int(
					get_tree().root.get_meta("taskbar_inventory_drag_index", -1)
				)
				if inventory_index >= 0:
					insert_inventory_item_from_screen_position(
						inventory_index,
						DisplayServer.mouse_get_position()
					)
					if is_instance_valid(inventory_ui):
						if inventory_ui.has_method("cancel_external_drag"):
							inventory_ui.call("cancel_external_drag")
			return

	if event is InputEventMouseMotion and forge_window_dragging:
		forge_window.position = (
			DisplayServer.mouse_get_position()
			- forge_window_drag_offset
		)

func _can_start_forge_window_drag(window_position: Vector2) -> bool:
	if not permitir_mover_ventana:
		return false
	if not is_instance_valid(forge_window):
		return false
	if window_position.y < 0.0 or window_position.y > altura_arrastre_ventana:
		return false
	return window_position.x < float(forge_window.size.x - 58)

func _update_external_drag_preview() -> void:
	if not forge_is_open:
		_clear_external_drag_preview(true)
		return
	if not is_instance_valid(forge_window) or not forge_window.visible:
		_clear_external_drag_preview(true)
		return
	if not is_instance_valid(menu_canvas):
		_clear_external_drag_preview(true)
		return
	if not get_tree().root.has_meta("taskbar_inventory_drag_index"):
		_clear_external_drag_preview(true)
		return

	_refresh_references()
	if not is_instance_valid(inventory_ui):
		_clear_external_drag_preview(true)
		return

	var inventory_index: int = int(
		get_tree().root.get_meta("taskbar_inventory_drag_index", -1)
	)
	if inventory_index < 0:
		_clear_external_drag_preview(true)
		return

	var item_variant: Variant = inventory_ui.call(
		"get_inventory_item_at",
		inventory_index
	)
	if not (item_variant is Dictionary):
		_clear_external_drag_preview(true)
		return

	var dragged_item: Dictionary = item_variant
	if dragged_item.is_empty():
		_clear_external_drag_preview(true)
		return

	var global_mouse: Vector2i = DisplayServer.mouse_get_position()
	var forge_rect: Rect2i = Rect2i(forge_window.position, forge_window.size)
	if not forge_rect.has_point(global_mouse):
		_clear_external_drag_preview(true)
		return

	var item_signature: String = str(dragged_item.get("id", "")) + "|" + str(
		dragged_item.get("level", dragged_item.get("item_level", 1))
	) + "|" + str(dragged_item.get("quantity", 1))

	if (
		not is_instance_valid(external_drag_preview)
		or external_drag_signature != item_signature
		or external_drag_inventory_index != inventory_index
	):
		_build_external_drag_preview(dragged_item)

	external_drag_inventory_index = inventory_index
	external_drag_item = dragged_item.duplicate(true)
	external_drag_signature = item_signature

	var menu_position: Vector2 = _global_position_to_menu(global_mouse)
	var preview_size: Vector2 = external_drag_preview.size
	var half_size: Vector2 = preview_size * 0.5
	var clamped_center: Vector2 = Vector2(
		clampf(menu_position.x, half_size.x, REFERENCE_SIZE.x - half_size.x),
		clampf(menu_position.y, half_size.y, REFERENCE_SIZE.y - half_size.y)
	)
	external_drag_preview.position = clamped_center - half_size
	external_drag_preview.visible = true

	get_tree().root.set_meta("taskbar_forge_drag_preview_active", true)
	if inventory_ui.has_method("set_drag_preview_visible"):
		inventory_ui.call("set_drag_preview_visible", false)

	var new_hover_slot: int = _slot_index_at_global_position(global_mouse)
	if new_hover_slot >= 0 and not forge_items[new_hover_slot].is_empty():
		new_hover_slot = -1

	if new_hover_slot != external_drag_hover_slot:
		external_drag_hover_slot = new_hover_slot
		_refresh_slots()

func _global_position_to_menu(screen_position: Vector2i) -> Vector2:
	if not is_instance_valid(forge_window) or not is_instance_valid(menu_canvas):
		return Vector2.ZERO

	var window_local: Vector2 = Vector2(screen_position - forge_window.position)
	var scale_x: float = maxf(menu_canvas.scale.x, 0.0001)
	var scale_y: float = maxf(menu_canvas.scale.y, 0.0001)
	return Vector2(
		(window_local.x - menu_canvas.position.x) / scale_x,
		(window_local.y - menu_canvas.position.y) / scale_y
	)

func _build_external_drag_preview(item: Dictionary) -> void:
	if is_instance_valid(external_drag_preview):
		external_drag_preview.free()

	external_drag_preview = Panel.new()
	external_drag_preview.name = "VistaObjetoArrastradoForja"
	external_drag_preview.size = Vector2(82.0, 82.0)
	external_drag_preview.mouse_filter = Control.MOUSE_FILTER_IGNORE
	external_drag_preview.clip_contents = true
	external_drag_preview.z_as_relative = false
	external_drag_preview.z_index = 4090
	external_drag_preview.modulate = Color(1.0, 1.0, 1.0, 0.94)

	var rarity_color: Color = _rarity_color(item)
	external_drag_preview.add_theme_stylebox_override(
		"panel",
		_make_style(
			Color(rarity_color.r, rarity_color.g, rarity_color.b, 0.24),
			rarity_color,
			3,
			8,
			Color(rarity_color.r, rarity_color.g, rarity_color.b, 0.32),
			10
		)
	)
	menu_canvas.add_child(external_drag_preview)
	_create_item_visual(external_drag_preview, item, true)

func _clear_external_drag_preview(restore_inventory_preview: bool = true) -> void:
	var old_hover_slot: int = external_drag_hover_slot

	if restore_inventory_preview:
		if get_tree().root.has_meta("taskbar_forge_drag_preview_active"):
			get_tree().root.remove_meta("taskbar_forge_drag_preview_active")
		if is_instance_valid(inventory_ui) and inventory_ui.has_method("set_drag_preview_visible"):
			inventory_ui.call("set_drag_preview_visible", true)

	if is_instance_valid(external_drag_preview):
		external_drag_preview.free()
	external_drag_preview = null
	external_drag_item = {}
	external_drag_inventory_index = -1
	external_drag_hover_slot = -1
	external_drag_signature = ""

	if old_hover_slot >= 0 and initialized:
		_refresh_slots()

func _build_forge_window() -> void:
	ProjectSettings.set_setting(
		"display/window/per_pixel_transparency/allowed",
		true
	)

	var root_viewport: Viewport = get_viewport()
	if root_viewport != null:
		root_viewport.gui_embed_subwindows = false

	forge_window = Window.new()
	forge_window.name = "VentanaForja"
	forge_window.title = _text("window_title")
	forge_window.size = forge_window_size
	forge_window.min_size = forge_window_size
	forge_window.borderless = true
	forge_window.unresizable = true
	forge_window.always_on_top = true
	forge_window.exclusive = false
	forge_window.transparent = true
	forge_window.transparent_bg = true
	forge_window.visible = false
	forge_window.force_native = true
	forge_window.close_requested.connect(close_forge)
	forge_window.window_input.connect(_on_forge_window_input)
	forge_window.size_changed.connect(_fit_canvas)
	add_child(forge_window)

	overlay = Control.new()
	overlay.name = "ForjaSinSombreado"
	overlay.mouse_filter = Control.MOUSE_FILTER_PASS
	forge_window.add_child(overlay)
	overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

	menu_canvas = Control.new()
	menu_canvas.name = "ForjaCanvas"
	menu_canvas.size = REFERENCE_SIZE
	menu_canvas.mouse_filter = Control.MOUSE_FILTER_PASS
	overlay.add_child(menu_canvas)

	background_rect = TextureRect.new()
	background_rect.name = "FondoForja"
	background_rect.position = Vector2.ZERO
	background_rect.size = REFERENCE_SIZE
	background_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	background_rect.stretch_mode = TextureRect.STRETCH_SCALE
	background_rect.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	background_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	menu_canvas.add_child(background_rect)

	if ResourceLoader.exists(forge_background_path):
		background_rect.texture = load(forge_background_path) as Texture2D
	else:
		push_warning("No se encontró la imagen de la forja: " + forge_background_path)

	_build_header()
	_build_slots()
	_build_bottom_controls()
	_build_close_button()
	_fit_canvas()

func _fit_canvas() -> void:
	if not is_instance_valid(forge_window) or not is_instance_valid(menu_canvas):
		return

	var available: Vector2 = Vector2(forge_window.size)
	var scale_factor: float = min(
		available.x / REFERENCE_SIZE.x,
		available.y / REFERENCE_SIZE.y
	)
	var scaled_size: Vector2 = REFERENCE_SIZE * scale_factor

	menu_canvas.scale = Vector2.ONE * scale_factor
	menu_canvas.position = (available - scaled_size) * 0.5

func _build_header() -> void:
	title_label = _create_label(
		menu_canvas,
		_text("title"),
		Vector2(670.0, 170.0),
		Vector2(790.0, 42.0),
		28,
		HORIZONTAL_ALIGNMENT_CENTER,
		Color("#F3CE72")
	)
	title_label.add_theme_constant_override("outline_size", 3)
	title_label.add_theme_color_override(
		"font_outline_color",
		Color(0.02, 0.01, 0.0, 0.95)
	)

	description_label = _create_label(
		menu_canvas,
		_text("description"),
		Vector2(690.0, 211.0),
		Vector2(750.0, 45.0),
		15,
		HORIZONTAL_ALIGNMENT_CENTER,
		Color("#D8D0C2")
	)
	description_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART

func _build_slots() -> void:
	slot_buttons.clear()

	for index in range(SLOT_COUNT):
		var slot_rect: Rect2 = SLOT_RECTS[index]
		var slot_button: Button = Button.new()
		slot_button.name = "HuecoForja%d" % index
		slot_button.text = ""
		slot_button.position = slot_rect.position
		slot_button.size = slot_rect.size
		slot_button.focus_mode = Control.FOCUS_NONE
		slot_button.clip_contents = true
		slot_button.z_index = 20
		slot_button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		slot_button.pressed.connect(_on_slot_pressed.bind(index))
		menu_canvas.add_child(slot_button)
		slot_buttons.append(slot_button)

func _build_bottom_controls() -> void:
	progress_label = _create_label(
		menu_canvas,
		"",
		Vector2(690.0, 681.0),
		Vector2(750.0, 28.0),
		17,
		HORIZONTAL_ALIGNMENT_CENTER,
		Color("#F1D275")
	)

	status_label = _create_label(
		menu_canvas,
		"",
		Vector2(675.0, 710.0),
		Vector2(780.0, 42.0),
		14,
		HORIZONTAL_ALIGNMENT_CENTER,
		Color("#E9E0D2")
	)
	status_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART

	clear_button = _create_action_button(
		_text("empty"),
		Vector2(290.0, 803.0),
		Vector2(260.0, 43.0),
		Color("#1D2730"),
		Color("#C79A43")
	)
	clear_button.pressed.connect(_return_all_items)

	forge_button = _create_action_button(
		_text("forge"),
		Vector2(1108.0, 803.0),
		Vector2(260.0, 43.0),
		Color("#4A1F08"),
		Color("#FFB34D")
	)
	forge_button.pressed.connect(_forge_items)

func _build_close_button() -> void:
	close_button = Button.new()
	close_button.name = "CerrarForja"
	close_button.text = "×"
	close_button.position = Vector2(1510.0, 104.0)
	close_button.size = Vector2(42.0, 42.0)
	close_button.focus_mode = Control.FOCUS_NONE
	close_button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	close_button.tooltip_text = _text("close")
	close_button.add_theme_font_size_override("font_size", 24)
	close_button.add_theme_color_override("font_color", Color("#FFD46B"))
	close_button.add_theme_stylebox_override(
		"normal",
		_make_style(Color("#42100E"), Color("#E3AF42"), 2, 8)
	)
	close_button.add_theme_stylebox_override(
		"hover",
		_make_style(Color("#711B14"), Color("#FFE08B"), 2, 8)
	)
	close_button.pressed.connect(close_forge)
	menu_canvas.add_child(close_button)

func _on_slot_pressed(slot_index: int) -> void:
	if slot_index < 0 or slot_index >= forge_items.size():
		return

	var current_item: Dictionary = forge_items[slot_index]
	if current_item.is_empty():
		_open_item_selector(slot_index)
	else:
		_return_item_from_slot(slot_index)

func _open_item_selector(slot_index: int) -> void:
	_refresh_references()
	_close_selector()
	selector_target_slot = slot_index

	selector_panel = Panel.new()
	selector_panel.name = "SelectorObjetos"
	selector_panel.position = Vector2(650.0, 270.0)
	selector_panel.size = Vector2(860.0, 440.0)
	selector_panel.z_index = 80
	selector_panel.mouse_filter = Control.MOUSE_FILTER_STOP
	selector_panel.add_theme_stylebox_override(
		"panel",
		_make_style(
			Color(0.012, 0.018, 0.026, 0.985),
			Color("#D2A34B"),
			3,
			16,
			Color(0.0, 0.0, 0.0, 0.62),
			16
		)
	)
	menu_canvas.add_child(selector_panel)

	var selector_title: Label = _create_label(
		selector_panel,
		_text("selector_title"),
		Vector2(32.0, 18.0),
		Vector2(690.0, 34.0),
		23,
		HORIZONTAL_ALIGNMENT_LEFT,
		Color("#F3CE72")
	)
	selector_title.add_theme_constant_override("outline_size", 2)

	_create_label(
		selector_panel,
		_text("selector_description"),
		Vector2(32.0, 54.0),
		Vector2(690.0, 25.0),
		13,
		HORIZONTAL_ALIGNMENT_LEFT,
		Color("#CFC7B8")
	)

	var selector_close: Button = _create_action_button_on_parent(
		selector_panel,
		_text("cancel"),
		Vector2(700.0, 22.0),
		Vector2(130.0, 40.0),
		Color("#291211"),
		Color("#C98D43")
	)
	selector_close.pressed.connect(_close_selector)

	var scroll: ScrollContainer = ScrollContainer.new()
	scroll.position = Vector2(26.0, 92.0)
	scroll.size = Vector2(808.0, 320.0)
	selector_panel.add_child(scroll)

	selector_list = VBoxContainer.new()
	selector_list.custom_minimum_size = Vector2(780.0, 0.0)
	selector_list.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	selector_list.add_theme_constant_override("separation", 7)
	scroll.add_child(selector_list)

	_populate_selector()

func _populate_selector() -> void:
	if not is_instance_valid(selector_list):
		return

	for child in selector_list.get_children():
		child.queue_free()

	if not is_instance_valid(inventory_ui):
		_create_label(
			selector_list,
			_text("missing_inventory"),
			Vector2.ZERO,
			Vector2(760.0, 48.0),
			16,
			HORIZONTAL_ALIGNMENT_CENTER,
			Color("#FF8F8F")
		)
		return

	var inventory_copy_variant: Variant = inventory_ui.call("get_inventory_copy")
	if not (inventory_copy_variant is Array):
		return

	var inventory_copy: Array = inventory_copy_variant
	var found_items: int = 0
	var required_rarity: String = _current_input_rarity()

	for inventory_index in range(inventory_copy.size()):
		var item_variant: Variant = inventory_copy[inventory_index]
		if not (item_variant is Dictionary):
			continue

		var item: Dictionary = item_variant
		if item.is_empty() or str(item.get("id", "")).is_empty():
			continue

		var rarity: String = _item_rarity(item)
		if rarity == "unico" and not allow_unique_as_material:
			continue
		if not required_rarity.is_empty() and rarity != required_rarity:
			continue

		found_items += 1
		var rarity_color: Color = _rarity_color(item)
		var row_button: Button = Button.new()
		row_button.text = _selector_row_text(item)
		row_button.custom_minimum_size = Vector2(772.0, 48.0)
		row_button.focus_mode = Control.FOCUS_NONE
		row_button.alignment = HORIZONTAL_ALIGNMENT_LEFT
		row_button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		row_button.tooltip_text = _item_tooltip(item) + "\n\n" + _text("click_select")
		row_button.add_theme_font_size_override("font_size", 14)
		row_button.add_theme_color_override("font_color", Color("#EFE6D8"))
		row_button.add_theme_color_override("font_hover_color", Color.WHITE)
		row_button.add_theme_stylebox_override(
			"normal",
			_make_style(Color("#101821"), rarity_color, 1, 7)
		)
		row_button.add_theme_stylebox_override(
			"hover",
			_make_style(Color("#1D2A34"), rarity_color, 2, 7)
		)
		row_button.pressed.connect(
			_on_selector_item_chosen.bind(inventory_index, selector_target_slot)
		)
		selector_list.add_child(row_button)

	if found_items == 0:
		var empty_label: Label = Label.new()
		empty_label.text = _text("selector_empty")
		empty_label.custom_minimum_size = Vector2(770.0, 80.0)
		empty_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		empty_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		empty_label.add_theme_font_size_override("font_size", 16)
		empty_label.add_theme_color_override("font_color", Color("#C7BEB0"))
		selector_list.add_child(empty_label)

func _on_selector_item_chosen(inventory_index: int, slot_index: int) -> void:
	if _insert_inventory_item(inventory_index, slot_index):
		_close_selector()

func insert_inventory_item_from_screen_position(
	inventory_index: int,
	global_mouse_position: Vector2i
) -> bool:
	if not forge_is_open:
		return false
	if not is_instance_valid(forge_window) or not forge_window.visible:
		return false

	var slot_index: int = _slot_index_at_global_position(global_mouse_position)
	if slot_index < 0:
		return false

	return _insert_inventory_item(inventory_index, slot_index)

func _slot_index_at_global_position(global_mouse_position: Vector2i) -> int:
	if not is_instance_valid(forge_window) or not is_instance_valid(menu_canvas):
		return -1

	var window_local: Vector2 = Vector2(global_mouse_position - forge_window.position)
	var scale_x: float = maxf(menu_canvas.scale.x, 0.0001)
	var scale_y: float = maxf(menu_canvas.scale.y, 0.0001)
	var menu_position: Vector2 = Vector2(
		(window_local.x - menu_canvas.position.x) / scale_x,
		(window_local.y - menu_canvas.position.y) / scale_y
	)

	for index in range(SLOT_RECTS.size()):
		if SLOT_RECTS[index].has_point(menu_position):
			return index

	return -1

func _insert_inventory_item(inventory_index: int, slot_index: int) -> bool:
	_refresh_references()
	if not is_instance_valid(inventory_ui):
		_set_status(_text("missing_inventory"), Color("#FF8F8F"))
		return false
	if slot_index < 0 or slot_index >= forge_items.size():
		return false
	if not forge_items[slot_index].is_empty():
		return false

	var preview_variant: Variant = inventory_ui.call("get_inventory_item_at", inventory_index)
	if not (preview_variant is Dictionary):
		return false
	var preview_item: Dictionary = preview_variant
	if preview_item.is_empty():
		return false

	var validation_message: String = _validate_input_item(preview_item)
	if not validation_message.is_empty():
		_set_status(validation_message, Color("#FF9D87"))
		return false

	var taken_variant: Variant
	if inventory_ui.has_method("take_one_item_at"):
		taken_variant = inventory_ui.call("take_one_item_at", inventory_index)
	else:
		taken_variant = inventory_ui.call("take_item_at", inventory_index)

	if not (taken_variant is Dictionary):
		return false
	var item: Dictionary = taken_variant
	if item.is_empty():
		return false

	forge_items[slot_index] = item.duplicate(true)
	_clear_external_drag_preview()
	_save_forge_state()
	_refresh_all()
	_set_status(
		_text("inserted") % _item_name(item),
		_rarity_color(item)
	)
	item_inserted.emit(slot_index, item)
	return true

func _validate_input_item(item: Dictionary) -> String:
	var rarity: String = _item_rarity(item)
	if rarity == "unico" and not allow_unique_as_material:
		return _text("unique_protected")

	var current_rarity: String = _current_input_rarity()
	if not current_rarity.is_empty() and rarity != current_rarity:
		return _text("same_rarity") % BaseDatosObjetos.obtener_nombre_rareza(current_rarity)

	return ""

func _item_rarity(item: Dictionary) -> String:
	return str(item.get("rarity", item.get("rareza", "comun")))

func _current_input_rarity() -> String:
	for item in forge_items:
		if not item.is_empty():
			return _item_rarity(item)
	return ""

func _all_items_share_rarity() -> bool:
	var expected: String = ""
	for item in forge_items:
		if item.is_empty():
			continue
		var rarity: String = _item_rarity(item)
		if expected.is_empty():
			expected = rarity
		elif rarity != expected:
			return false
	return true

func _return_item_from_slot(slot_index: int) -> void:
	if not is_instance_valid(inventory_ui):
		_set_status(_text("missing_inventory"), Color("#FF8F8F"))
		return

	var item: Dictionary = forge_items[slot_index]
	if item.is_empty():
		return

	var returned: bool = bool(inventory_ui.call("add_item", item))
	if not returned:
		_set_status(_text("inventory_full"), Color("#FF8F8F"))
		return

	forge_items[slot_index] = {}
	_save_forge_state()
	_refresh_all()
	_set_status(
		_text("returned") % _item_name(item),
		Color("#A7E6B2")
	)
	item_removed.emit(slot_index, item)

func _close_selector() -> void:
	if is_instance_valid(selector_panel):
		selector_panel.queue_free()
	selector_panel = null
	selector_list = null
	selector_target_slot = -1

func _forge_items() -> void:
	var filled: int = _filled_slot_count()
	if filled < required_items:
		_set_status(
			_text("need_items") % required_items,
			Color("#FFB678")
		)
		return

	if not _all_items_share_rarity():
		_set_status(_text("same_rarity") % "?", Color("#FF9D87"))
		return

	if not is_instance_valid(inventory_ui):
		_set_status(_text("missing_inventory"), Color("#FF8F8F"))
		return

	var input_rarity: String = _current_input_rarity()
	var target_rarity: String = _next_forge_rarity(input_rarity)
	if target_rarity.is_empty():
		_set_status(_text("max_rarity"), Color("#FFCF77"))
		return

	var output_level: int = _calculate_output_level()
	var character_id: String = _load_character_id()
	var category_hint: String = _dominant_input_category()
	var equip_slot_hint: String = _common_input_equip_slot()
	var output_item: Dictionary = BaseDatosObjetos.generar_objeto_forjado(
		target_rarity,
		output_level,
		character_id,
		category_hint,
		equip_slot_hint,
		_load_current_zone_id()
	)

	if output_item.is_empty():
		_set_status(_text("forge_failed"), Color("#FF8F8F"))
		return

	var added: bool = bool(inventory_ui.call("add_item", output_item))
	if not added:
		_set_status(_text("output_full"), Color("#FF8F8F"))
		return

	for index in range(forge_items.size()):
		forge_items[index] = {}

	_save_forge_state()
	_refresh_all()
	_set_status(
		_text("forged") % _item_name(output_item),
		_rarity_color(output_item)
	)
	item_forged.emit(output_item)
	var current_scene: Node = get_tree().current_scene
	if is_instance_valid(current_scene):
		var mission_node: Node = current_scene.find_child(
			"SistemaMisiones",
			true,
			false
		)
		if is_instance_valid(mission_node):
			if mission_node.has_method("registrar_forja"):
				mission_node.call(
					"registrar_forja",
					1,
					str(output_item.get("rarity", output_item.get("rareza", "")))
				)

func _next_forge_rarity(input_rarity: String) -> String:
	var rarity_index: int = RARITY_ORDER.find(input_rarity)
	if rarity_index < 0:
		return "poco_comun"

	var ancestral_index: int = RARITY_ORDER.find("ancestral")
	if rarity_index >= ancestral_index:
		return ""
	return RARITY_ORDER[rarity_index + 1]

func _calculate_output_level() -> int:
	var total_level: int = 0
	var counted: int = 0

	for item in forge_items:
		if item.is_empty():
			continue
		total_level += int(item.get("item_level", 1))
		counted += 1

	var average_level: int = 1
	if counted > 0:
		average_level = maxi(1, int(round(float(total_level) / float(counted))))

	return maxi(
		_player_level(),
		average_level + 2 + int(floor(float(_player_level()) * 0.08))
	)

func _dominant_input_category() -> String:
	var counts: Dictionary = {}
	for item in forge_items:
		if item.is_empty():
			continue
		var category: String = str(item.get("category", ""))
		if category.is_empty():
			continue
		counts[category] = int(counts.get(category, 0)) + 1

	var best_category: String = ""
	var best_count: int = 0
	for category_variant in counts.keys():
		var category: String = str(category_variant)
		var count: int = int(counts[category])
		if count > best_count:
			best_category = category
			best_count = count
	return best_category

func _common_input_equip_slot() -> String:
	var expected: String = ""
	for item in forge_items:
		if item.is_empty():
			continue
		var slot_name: String = str(item.get("equip_slot", ""))
		if slot_name.is_empty():
			return ""
		if expected.is_empty():
			expected = slot_name
		elif slot_name != expected:
			return ""
	return expected

func _return_all_items() -> void:
	if not is_instance_valid(inventory_ui):
		_set_status(_text("missing_inventory"), Color("#FF8F8F"))
		return

	var failed: bool = false
	for index in range(forge_items.size()):
		var item: Dictionary = forge_items[index]
		if item.is_empty():
			continue
		var returned: bool = bool(inventory_ui.call("add_item", item))
		if returned:
			forge_items[index] = {}
		else:
			failed = true

	_save_forge_state()
	_refresh_all()

	if failed:
		_set_status(_text("some_not_returned"), Color("#FFB678"))
	else:
		_set_status(_text("cleared"), Color("#A7E6B2"))

func _set_status(message: String, color: Color = Color("#E9E0D2")) -> void:
	if not is_instance_valid(status_label):
		return

	status_label.text = message
	status_label.add_theme_color_override("font_color", color)

func _refresh_all() -> void:
	_refresh_slots()
	_refresh_bottom()

func _refresh_slots() -> void:
	for index in range(mini(slot_buttons.size(), forge_items.size())):
		var button: Button = slot_buttons[index]
		var item: Dictionary = forge_items[index]

		for child in button.get_children():
			button.remove_child(child)
			child.free()

		button.text = ""
		button.clip_contents = true
		button.visible = true
		button.disabled = false
		button.modulate = Color.WHITE
		button.self_modulate = Color.WHITE

		if item.is_empty():
			if index == external_drag_hover_slot and not external_drag_item.is_empty():
				var preview_color: Color = _rarity_color(external_drag_item)
				button.tooltip_text = _item_tooltip(external_drag_item)
				button.add_theme_stylebox_override(
					"normal",
					_make_style(
						Color(preview_color.r, preview_color.g, preview_color.b, 0.22),
						Color.WHITE,
						3,
						7,
						Color(preview_color.r, preview_color.g, preview_color.b, 0.38),
						9
					)
				)
				_create_item_visual(button, external_drag_item, true)
				for preview_child in button.get_children():
					if preview_child is CanvasItem:
						(preview_child as CanvasItem).modulate = Color(1.0, 1.0, 1.0, 0.72)
				continue

			button.tooltip_text = _text("slot_empty")
			button.add_theme_stylebox_override(
				"normal",
				_make_style(
					Color(0.0, 0.0, 0.0, 0.08),
					Color(0.20, 0.16, 0.09, 0.28),
					1,
					7
				)
			)
			button.add_theme_stylebox_override(
				"hover",
				_make_style(
					Color(0.15, 0.10, 0.03, 0.24),
					Color("#F0C45D"),
					2,
					7
				)
			)
			continue

		var rarity_color: Color = _rarity_color(item)
		button.tooltip_text = _item_tooltip(item) + "\n\n" + _text("slot_remove")
		button.add_theme_stylebox_override(
			"normal",
			_make_style(
				Color(rarity_color.r, rarity_color.g, rarity_color.b, 0.18),
				rarity_color,
				3,
				7,
				Color(rarity_color.r, rarity_color.g, rarity_color.b, 0.24),
				6
			)
		)
		button.add_theme_stylebox_override(
			"hover",
			_make_style(
				Color(rarity_color.r, rarity_color.g, rarity_color.b, 0.28),
				Color.WHITE,
				3,
				7,
				Color(rarity_color.r, rarity_color.g, rarity_color.b, 0.34),
				8
			)
		)
		_create_item_visual(button, item, true)

func _refresh_bottom() -> void:
	var filled: int = _filled_slot_count()
	var input_rarity: String = _current_input_rarity()
	var output_rarity: String = _next_forge_rarity(input_rarity)

	if is_instance_valid(progress_label):
		if input_rarity.is_empty():
			progress_label.text = _text("progress_empty") % [filled, required_items]
		else:
			var input_name: String = BaseDatosObjetos.obtener_nombre_rareza(input_rarity)
			var output_name: String = (
				BaseDatosObjetos.obtener_nombre_rareza(output_rarity)
				if not output_rarity.is_empty()
				else "MAX"
			)
			progress_label.text = _text("progress_recipe") % [
				filled,
				required_items,
				input_name,
				output_name
			]
			progress_label.add_theme_color_override(
				"font_color",
				BaseDatosObjetos.obtener_color_rareza(input_rarity)
			)

	if is_instance_valid(forge_button):
		forge_button.disabled = (
			filled < required_items
			or not _all_items_share_rarity()
			or output_rarity.is_empty()
		)

	if is_instance_valid(clear_button):
		clear_button.disabled = filled == 0

	if is_instance_valid(status_label) and status_label.text.is_empty():
		if filled >= required_items and not output_rarity.is_empty():
			status_label.text = _text("ready")
			status_label.add_theme_color_override("font_color", Color("#F2D47C"))
		elif output_rarity.is_empty() and not input_rarity.is_empty():
			status_label.text = _text("max_rarity")
			status_label.add_theme_color_override("font_color", Color("#FFCF77"))
		else:
			status_label.text = _text("need_items") % required_items
			status_label.add_theme_color_override("font_color", Color("#CFC7BA"))

func _create_item_visual(
	parent: Control,
	item: Dictionary,
	compact_mode: bool = true
) -> void:
	var rarity_color: Color = _rarity_color(item)
	parent.clip_contents = true

	var content: Control = Control.new()
	content.name = "ContenidoObjetoForja"
	content.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	content.mouse_filter = Control.MOUSE_FILTER_IGNORE
	content.clip_contents = true
	content.z_index = 50
	parent.add_child(content)

	var rarity_fill: ColorRect = ColorRect.new()
	rarity_fill.name = "FondoRareza"
	rarity_fill.position = Vector2(5.0, 5.0)
	rarity_fill.size = parent.size - Vector2(10.0, 10.0)
	rarity_fill.color = Color(
		rarity_color.r,
		rarity_color.g,
		rarity_color.b,
		0.15
	)
	rarity_fill.mouse_filter = Control.MOUSE_FILTER_IGNORE
	content.add_child(rarity_fill)

	var icon_path: String = str(item.get("icon_path", "")).strip_edges()
	if not icon_path.is_empty() and ResourceLoader.exists(icon_path):
		var icon: TextureRect = TextureRect.new()
		icon.name = "IconoObjetoForja"
		icon.position = Vector2(9.0, 8.0)
		icon.size = Vector2(parent.size.x - 18.0, parent.size.y - 18.0)
		icon.texture = load(icon_path) as Texture2D
		icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		icon.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
		icon.z_index = 2
		content.add_child(icon)
	else:
		var initials: Label = _create_label(
			content,
			_item_initials(item),
			Vector2(4.0, 4.0),
			Vector2(parent.size.x - 8.0, parent.size.y - 8.0),
			22 if compact_mode else 26,
			HORIZONTAL_ALIGNMENT_CENTER,
			rarity_color
		)
		initials.name = "InicialesObjetoForja"
		initials.clip_text = true
		initials.z_index = 3
		initials.add_theme_constant_override("outline_size", 3)
		initials.add_theme_color_override(
			"font_outline_color",
			Color(0.0, 0.0, 0.0, 0.98)
		)

	var level_label: Label = _create_label(
		content,
		str(int(item.get("item_level", 1))),
		Vector2(parent.size.x - 27.0, 4.0),
		Vector2(22.0, 15.0),
		8,
		HORIZONTAL_ALIGNMENT_RIGHT,
		Color("#FFF1BF")
	)
	level_label.name = "NivelObjetoForja"
	level_label.clip_text = true
	level_label.z_index = 5
	level_label.add_theme_constant_override("outline_size", 2)
	level_label.add_theme_color_override(
		"font_outline_color",
		Color(0.0, 0.0, 0.0, 0.98)
	)

	var quantity: int = int(item.get("quantity", 1))
	if quantity > 1:
		var quantity_label: Label = _create_label(
			content,
			"x%d" % quantity,
			Vector2(parent.size.x - 34.0, parent.size.y - 22.0),
			Vector2(29.0, 16.0),
			9,
			HORIZONTAL_ALIGNMENT_RIGHT,
			Color.WHITE
		)
		quantity_label.name = "CantidadObjetoForja"
		quantity_label.clip_text = true
		quantity_label.z_index = 6
		quantity_label.add_theme_constant_override("outline_size", 2)
		quantity_label.add_theme_color_override(
			"font_outline_color",
			Color(0.0, 0.0, 0.0, 0.98)
		)

	var rarity_line: ColorRect = ColorRect.new()
	rarity_line.name = "LineaRarezaForja"
	rarity_line.position = Vector2(8.0, parent.size.y - 6.0)
	rarity_line.size = Vector2(parent.size.x - 16.0, 3.0)
	rarity_line.color = rarity_color
	rarity_line.mouse_filter = Control.MOUSE_FILTER_IGNORE
	rarity_line.z_index = 7
	content.add_child(rarity_line)

func _filled_slot_count() -> int:
	var count: int = 0
	for item in forge_items:
		if not item.is_empty():
			count += 1
	return count

func _player_level() -> int:
	if is_instance_valid(main_controller):
		return maxi(1, int(main_controller.get("player_level")))
	return 1

func _load_current_zone_id() -> String:
	var current_scene: Node = get_tree().current_scene
	if is_instance_valid(current_scene):
		if current_scene.has_method("get_current_zone_id"):
			return SistemaRegiones.normalizar_zona(
				str(current_scene.call("get_current_zone_id"))
			)

	var config: ConfigFile = ConfigFile.new()
	if config.load(CHARACTER_SAVE_PATH) == OK:
		return SistemaRegiones.leer_zona_actual(config)

	return SistemaRegiones.ZONA_VALDORIA

func _load_character_id() -> String:
	var config: ConfigFile = ConfigFile.new()
	if config.load(CHARACTER_SAVE_PATH) == OK:
		return str(config.get_value("jugador", "personaje", "paladin_alba"))
	return "paladin_alba"

func _item_name(item: Dictionary) -> String:
	if is_instance_valid(inventory_ui) and inventory_ui.has_method("_item_display_name"):
		return str(inventory_ui.call("_item_display_name", item))
	return str(item.get("name", "Objeto"))

func _item_description(item: Dictionary) -> String:
	if is_instance_valid(inventory_ui) and inventory_ui.has_method("_item_display_description"):
		return str(inventory_ui.call("_item_display_description", item))
	return str(item.get("description", ""))

func _rarity_name(item: Dictionary) -> String:
	var rarity: String = str(item.get("rarity", item.get("rareza", "comun")))
	if is_instance_valid(inventory_ui) and inventory_ui.has_method("_get_rarity_display_name"):
		return str(inventory_ui.call("_get_rarity_display_name", rarity))
	return BaseDatosObjetos.obtener_nombre_rareza(rarity)

func _rarity_color(item: Dictionary) -> Color:
	var rarity: String = str(item.get("rarity", item.get("rareza", "comun")))
	return BaseDatosObjetos.obtener_color_rareza(rarity)

func _item_initials(item: Dictionary) -> String:
	var words: PackedStringArray = _item_name(item).strip_edges().split(" ", false)
	if words.is_empty():
		return "IT"
	if words.size() == 1:
		return words[0].substr(0, mini(2, words[0].length())).to_upper()
	return (words[0].substr(0, 1) + words[1].substr(0, 1)).to_upper()

func _selector_row_text(item: Dictionary) -> String:
	return "%s   ·   %s   ·   %s" % [
		_item_name(item),
		_rarity_name(item),
		_text("level") % int(item.get("item_level", 1))
	]

func _item_tooltip(item: Dictionary) -> String:
	var lines: Array[String] = []
	lines.append(_item_name(item))
	lines.append("%s · %s" % [
		_rarity_name(item),
		_text("level") % int(item.get("item_level", 1))
	])

	var description: String = _item_description(item)
	if not description.is_empty():
		lines.append("")
		lines.append(description)

	var stats_variant: Variant = item.get("stats", {})
	if stats_variant is Dictionary:
		var stats: Dictionary = stats_variant
		if not stats.is_empty():
			lines.append("")
			lines.append(_text("effects"))
			for stat_name in ["vida", "daño", "def", "vel", "magia"]:
				var value: int = int(stats.get(stat_name, 0))
				if value > 0:
					lines.append("+%d %s" % [value, stat_name.to_upper()])

	return "\n".join(lines)

func _save_forge_state() -> void:
	var config: ConfigFile = ConfigFile.new()
	config.set_value("forja", "items", forge_items)
	var save_error: Error = config.save(SAVE_PATH)
	if save_error != OK:
		push_warning("No se pudo guardar el estado de la forja.")

func _load_forge_state() -> void:
	var config: ConfigFile = ConfigFile.new()
	if config.load(SAVE_PATH) != OK:
		return

	var loaded_variant: Variant = config.get_value("forja", "items", [])
	if not (loaded_variant is Array):
		return

	var loaded: Array = loaded_variant
	for index in range(mini(loaded.size(), SLOT_COUNT)):
		var item_variant: Variant = loaded[index]
		if not (item_variant is Dictionary):
			continue
		var item: Dictionary = item_variant
		if str(item.get("id", "")).is_empty():
			continue
		forge_items[index] = item.duplicate(true)

func _create_action_button(
	button_text: String,
	button_position: Vector2,
	button_size: Vector2,
	background: Color,
	border: Color
) -> Button:
	return _create_action_button_on_parent(
		menu_canvas,
		button_text,
		button_position,
		button_size,
		background,
		border
	)

func _create_action_button_on_parent(
	parent: Control,
	button_text: String,
	button_position: Vector2,
	button_size: Vector2,
	background: Color,
	border: Color
) -> Button:
	var button: Button = Button.new()
	button.text = button_text
	button.position = button_position
	button.size = button_size
	button.focus_mode = Control.FOCUS_NONE
	button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	button.add_theme_font_size_override("font_size", 15)
	button.add_theme_color_override("font_color", Color("#F3E7CF"))
	button.add_theme_color_override("font_hover_color", Color.WHITE)
	button.add_theme_color_override("font_disabled_color", Color("#77736C"))
	button.add_theme_stylebox_override(
		"normal",
		_make_style(background, border, 2, 8)
	)
	button.add_theme_stylebox_override(
		"hover",
		_make_style(background.lightened(0.10), border.lightened(0.18), 2, 8)
	)
	button.add_theme_stylebox_override(
		"pressed",
		_make_style(background.darkened(0.10), Color.WHITE, 2, 8)
	)
	button.add_theme_stylebox_override(
		"disabled",
		_make_style(Color("#11161B"), Color("#4A453B"), 1, 8)
	)
	parent.add_child(button)
	return button

func _create_label(
	parent: Control,
	label_text: String,
	label_position: Vector2,
	label_size: Vector2,
	font_size: int,
	alignment: HorizontalAlignment,
	font_color: Color
) -> Label:
	var label: Label = Label.new()
	label.text = label_text
	label.position = label_position
	label.size = label_size
	label.horizontal_alignment = alignment
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", font_color)
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	parent.add_child(label)
	return label

func _make_style(
	background: Color,
	border: Color,
	border_width: int,
	radius: int,
	shadow_color: Color = Color(0.0, 0.0, 0.0, 0.0),
	shadow_size: int = 0
) -> StyleBoxFlat:
	var style: StyleBoxFlat = StyleBoxFlat.new()
	style.bg_color = background
	style.border_color = border
	style.set_border_width_all(border_width)
	style.corner_radius_top_left = radius
	style.corner_radius_top_right = radius
	style.corner_radius_bottom_left = radius
	style.corner_radius_bottom_right = radius
	style.shadow_color = shadow_color
	style.shadow_size = shadow_size
	return style
