extends Node

const MODULE_TOP_ICON_PATH: String = "res://Recursos/UI/IconosBarra/atlas.png"

const BASE_UI_SIZE: Vector2 = Vector2(900.0, 240.0)
const SETTINGS_PATH: String = "user://opciones.cfg"

const GOLD: Color = Color("#E5C363")
const GOLD_BRIGHT: Color = Color("#FFE69A")
const EMERALD: Color = Color("#4CE5B2")
const BLUE: Color = Color("#68BFFF")
const PURPLE: Color = Color("#C493FF")
const TEXT: Color = Color("#F6EDD9")
const MUTED: Color = Color("#B9B1A2")
const PANEL: Color = Color(0.006, 0.012, 0.020, 0.985)
const PANEL_SOFT: Color = Color(0.012, 0.026, 0.042, 0.98)

var map_open: bool = false
var current_language: String = "es"
var main_controller: Node
var game_ui: Node
var overlay: Control
var selected_zone: String = SistemaRegiones.ZONA_VALDORIA

var title_label: Label
var subtitle_label: Label
var world_label: Label
var difficulty_label: Label
var detail_title: Label
var detail_phase: Label
var detail_description: Label
var detail_reward: Label
var action_button: Button
var difficulty_buttons: Dictionary = {}
var zone_buttons: Dictionary = {}

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	main_controller = get_parent()
	game_ui = get_node_or_null("/root/GameUI")
	_load_language()
	if is_instance_valid(game_ui) and game_ui.has_signal("language_changed"):
		var callback: Callable = Callable(self, "set_language")
		if not game_ui.is_connected("language_changed", callback):
			game_ui.connect("language_changed", callback)
	call_deferred("_build_atlas")

func _load_language() -> void:
	if is_instance_valid(game_ui) and game_ui.has_method("get_language"):
		current_language = str(game_ui.call("get_language"))
	else:
		var config: ConfigFile = ConfigFile.new()
		if config.load(SETTINGS_PATH) == OK:
			current_language = str(config.get_value("general", "idioma", "es"))
	current_language = "en" if current_language.to_lower().begins_with("en") else "es"

func set_language(language_code: String) -> void:
	current_language = "en" if language_code.to_lower().begins_with("en") else "es"
	_refresh_content()

func toggle_map() -> void:
	if map_open:
		close_map()
	else:
		open_map()

func open_map() -> void:
	if not is_instance_valid(overlay):
		_build_atlas()
	map_open = true
	overlay.visible = true
	overlay.move_to_front()
	selected_zone = _current_zone()
	_refresh_content()

func close_map() -> void:
	map_open = false
	if is_instance_valid(overlay):
		overlay.visible = false

func is_map_open() -> bool:
	return map_open

func _build_atlas() -> void:
	if is_instance_valid(overlay):
		return
	var parent_control: Control = null
	if is_instance_valid(main_controller):
		parent_control = main_controller.get("interface_root") as Control
	if not is_instance_valid(parent_control):
		return

	overlay = Control.new()
	overlay.name = "AtlasReinosRPG"
	overlay.position = Vector2.ZERO
	overlay.size = BASE_UI_SIZE
	overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	overlay.z_index = 500
	overlay.visible = false
	parent_control.add_child(overlay)

	var shade: ColorRect = ColorRect.new()
	shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	shade.color = Color(0.0, 0.0, 0.0, 0.93)
	shade.mouse_filter = Control.MOUSE_FILTER_STOP
	overlay.add_child(shade)

	var frame: Panel = Panel.new()
	frame.position = Vector2(10.0, 7.0)
	frame.size = Vector2(880.0, 226.0)
	frame.add_theme_stylebox_override("panel", _style(PANEL, GOLD, 2, 10, Color(0, 0, 0, 0.72), 10))
	overlay.add_child(frame)

	_create_corner_gem(frame, Vector2(6, 6))
	_create_corner_gem(frame, Vector2(858, 6))
	_create_corner_gem(frame, Vector2(6, 204))
	_create_corner_gem(frame, Vector2(858, 204))

	title_label = _label(frame, "", Vector2(185, 9), Vector2(510, 28), 22, HORIZONTAL_ALIGNMENT_CENTER, GOLD_BRIGHT)
	subtitle_label = _label(frame, "", Vector2(170, 35), Vector2(540, 20), 15, HORIZONTAL_ALIGNMENT_CENTER, MUTED)

	var close_button: Button = Button.new()
	close_button.position = Vector2(838, 10)
	close_button.size = Vector2(30, 30)
	close_button.text = "×"
	close_button.focus_mode = Control.FOCUS_NONE
	close_button.add_theme_font_size_override("font_size", 20)
	close_button.add_theme_color_override("font_color", Color("#FFD7D8"))
	close_button.add_theme_stylebox_override("normal", _style(Color(0.20, 0.02, 0.04, 0.92), Color("#AA3843"), 1, 7))
	close_button.add_theme_stylebox_override("hover", _style(Color(0.42, 0.04, 0.07, 0.96), Color("#FF8188"), 2, 7))
	close_button.pressed.connect(close_map)
	frame.add_child(close_button)

	world_label = _label(frame, "", Vector2(24, 60), Vector2(540, 22), 16, HORIZONTAL_ALIGNMENT_LEFT, GOLD)
	difficulty_label = _label(frame, "", Vector2(574, 60), Vector2(88, 22), 14, HORIZONTAL_ALIGNMENT_LEFT, GOLD)

	var route_panel: Panel = Panel.new()
	route_panel.position = Vector2(22, 84)
	route_panel.size = Vector2(548, 125)
	route_panel.add_theme_stylebox_override("panel", _style(PANEL_SOFT, Color("#245063"), 1, 8))
	frame.add_child(route_panel)

	var route_line: ColorRect = ColorRect.new()
	route_line.position = Vector2(82, 58)
	route_line.size = Vector2(378, 3)
	route_line.color = Color("#53697A")
	route_line.mouse_filter = Control.MOUSE_FILTER_IGNORE
	route_panel.add_child(route_line)

	_create_zone_button(route_panel, SistemaRegiones.ZONA_VALDORIA, Vector2(22, 27), EMERALD)
	_create_zone_button(route_panel, SistemaRegiones.ZONA_BRUMA, Vector2(210, 27), BLUE)
	_create_zone_button(route_panel, SistemaRegiones.ZONA_ELARIS, Vector2(398, 27), PURPLE)

	var detail_panel: Panel = Panel.new()
	detail_panel.position = Vector2(581, 84)
	detail_panel.size = Vector2(275, 125)
	detail_panel.add_theme_stylebox_override("panel", _style(PANEL_SOFT, EMERALD, 2, 8))
	frame.add_child(detail_panel)
	detail_panel.name = "PanelDetalle"

	detail_title = _label(detail_panel, "", Vector2(12, 8), Vector2(251, 25), 17, HORIZONTAL_ALIGNMENT_LEFT, GOLD_BRIGHT)
	detail_phase = _label(detail_panel, "", Vector2(12, 34), Vector2(251, 18), 14, HORIZONTAL_ALIGNMENT_LEFT, EMERALD)
	detail_description = _label(detail_panel, "", Vector2(12, 53), Vector2(251, 35), 14, HORIZONTAL_ALIGNMENT_LEFT, TEXT)
	detail_description.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	detail_description.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	detail_reward = _label(detail_panel, "", Vector2(12, 88), Vector2(251, 15), 12, HORIZONTAL_ALIGNMENT_CENTER, MUTED)

	action_button = Button.new()
	action_button.position = Vector2(12, 103)
	action_button.size = Vector2(251, 18)
	action_button.focus_mode = Control.FOCUS_NONE
	action_button.add_theme_font_size_override("font_size", 14)
	action_button.add_theme_color_override("font_color", Color.WHITE)
	action_button.add_theme_stylebox_override("normal", _style(Color(0.02, 0.25, 0.18, 0.95), EMERALD, 1, 5))
	action_button.add_theme_stylebox_override("hover", _style(Color(0.03, 0.38, 0.27, 0.98), Color("#8CFFD8"), 2, 5))
	action_button.pressed.connect(_on_action_pressed)
	detail_panel.add_child(action_button)

	_create_difficulty_buttons(frame)
	if is_instance_valid(game_ui) and game_ui.has_method("apply_font_to_tree"):
		game_ui.call_deferred("apply_font_to_tree", overlay)
	_refresh_content()

func _create_zone_button(parent: Control, zone_id: String, button_position: Vector2, accent: Color) -> void:
	var button: Button = Button.new()
	button.name = "Zona_" + zone_id.replace("-", "_")
	button.position = button_position
	button.size = Vector2(128, 66)
	button.focus_mode = Control.FOCUS_NONE
	button.add_theme_font_size_override("font_size", 14)
	button.add_theme_color_override("font_color", TEXT)
	button.add_theme_color_override("font_disabled_color", Color("#777B83"))
	button.add_theme_constant_override("outline_size", 2)
	button.add_theme_color_override("font_outline_color", Color.BLACK)
	button.add_theme_stylebox_override("normal", _style(Color(0.005, 0.012, 0.020, 0.98), Color(accent.r, accent.g, accent.b, 0.52), 1, 8))
	button.add_theme_stylebox_override("hover", _style(Color(accent.r * 0.10, accent.g * 0.10, accent.b * 0.10, 0.98), accent, 2, 8))
	button.add_theme_stylebox_override("pressed", _style(Color(accent.r * 0.16, accent.g * 0.16, accent.b * 0.16, 0.99), GOLD_BRIGHT, 2, 8))
	button.pressed.connect(_select_zone.bind(zone_id))
	parent.add_child(button)
	zone_buttons[zone_id] = button

func _create_difficulty_buttons(frame: Control) -> void:
	var modes: Array[String] = SistemaDificultad.ORDEN
	for index: int in range(modes.size()):
		var mode: String = modes[index]
		var button: Button = Button.new()
		button.position = Vector2(662 + index * 64, 59)
		button.size = Vector2(60, 22)
		button.focus_mode = Control.FOCUS_NONE
		button.add_theme_font_size_override("font_size", 12)
		button.pressed.connect(_on_difficulty_pressed.bind(mode))
		frame.add_child(button)
		difficulty_buttons[mode] = button

func _select_zone(zone_id: String) -> void:
	selected_zone = zone_id
	_refresh_content()

func _on_difficulty_pressed(mode: String) -> void:
	if is_instance_valid(main_controller) and main_controller.has_method("set_difficulty"):
		if bool(main_controller.call("set_difficulty", mode)):
			selected_zone = _current_zone()
			_refresh_content()

func _on_action_pressed() -> void:
	if not _zone_unlocked(selected_zone):
		return
	var zone_completed: bool = _zone_completed(selected_zone)
	if zone_completed and is_instance_valid(main_controller) and main_controller.has_method("replay_zone"):
		if bool(main_controller.call("replay_zone", selected_zone)):
			close_map()
		return
	if is_instance_valid(main_controller) and main_controller.has_method("select_zone"):
		if bool(main_controller.call("select_zone", selected_zone, false)):
			close_map()

func _refresh_content() -> void:
	if not is_instance_valid(overlay):
		return
	title_label.text = "ATLAS DE LOS REINOS" if current_language == "es" else "ATLAS OF THE REALMS"
	subtitle_label.text = "Rutas, secretos y dominios de la Fractura." if current_language == "es" else "Routes, secrets and domains of the Fracture."
	world_label.text = "MUNDO I · TIERRAS DE LA FRACTURA" if current_language == "es" else "WORLD I · LANDS OF THE FRACTURE"
	var current_mode: String = _current_difficulty()
	difficulty_label.text = "DIFICULTAD" if current_language == "es" else "DIFFICULTY"
	var unlocked_modes: Array[String] = _unlocked_difficulties()
	for mode: String in SistemaDificultad.ORDEN:
		var button: Button = difficulty_buttons.get(mode) as Button
		if not is_instance_valid(button):
			continue
		button.text = SistemaDificultad.obtener_nombre(mode, current_language)
		button.disabled = not unlocked_modes.has(mode)
		var selected: bool = mode == current_mode
		button.add_theme_color_override("font_color", GOLD_BRIGHT if selected else TEXT)
		button.add_theme_stylebox_override("normal", _style(Color(0.12, 0.08, 0.015, 0.98) if selected else Color(0.008, 0.015, 0.025, 0.96), GOLD if selected else Color("#475668"), 2 if selected else 1, 5))

	for zone_id: String in zone_buttons.keys():
		var zone_button: Button = zone_buttons[zone_id] as Button
		var is_zone_available: bool = _zone_unlocked(zone_id)
		var is_zone_cleared: bool = _zone_completed(zone_id)
		zone_button.disabled = not is_zone_available
		var zone_name: String = SistemaRegiones.obtener_nombre(zone_id, current_language, false).to_upper()
		var status: String = ("SUPERADA" if current_language == "es" else "CLEARED") if is_zone_cleared else (("FASE %d" if current_language == "es" else "STAGE %d") % _zone_phase(zone_id))
		if not is_zone_available:
			status = "BLOQUEADA" if current_language == "es" else "LOCKED"
		zone_button.text = ("◆ " if selected_zone == zone_id else "◇ ") + zone_id + "\n" + zone_name + "\n" + status

	var selected_zone_unlocked: bool = _zone_unlocked(selected_zone)
	var selected_zone_cleared: bool = _zone_completed(selected_zone)
	detail_title.text = SistemaRegiones.obtener_nombre(selected_zone, current_language, true).to_upper()
	detail_phase.text = ("ZONA SUPERADA" if current_language == "es" else "ZONE CLEARED") if selected_zone_cleared else (("FASE %d / %d" if current_language == "es" else "STAGE %d / %d") % [_zone_phase(selected_zone), SistemaRegiones.obtener_fases(selected_zone)])
	detail_description.text = SistemaRegiones.obtener_descripcion(selected_zone, current_language)
	detail_reward.text = ("100 fases · reliquias regionales · jefe secreto" if current_language == "es" else "100 stages · regional relics · secret boss")
	action_button.disabled = not selected_zone_unlocked
	if not selected_zone_unlocked:
		action_button.text = "BLOQUEADO" if current_language == "es" else "LOCKED"
	elif selected_zone_cleared:
		action_button.text = "REJUGAR ZONA" if current_language == "es" else "REPLAY ZONE"
	elif selected_zone == _current_zone():
		action_button.text = "CONTINUAR AVENTURA" if current_language == "es" else "CONTINUE ADVENTURE"
	else:
		action_button.text = "VIAJAR A LA ZONA" if current_language == "es" else "TRAVEL TO ZONE"

func _current_zone() -> String:
	return str(main_controller.call("get_current_zone_id")) if is_instance_valid(main_controller) and main_controller.has_method("get_current_zone_id") else SistemaRegiones.ZONA_VALDORIA

func _current_difficulty() -> String:
	return str(main_controller.call("get_current_difficulty")) if is_instance_valid(main_controller) and main_controller.has_method("get_current_difficulty") else SistemaDificultad.NORMAL

func _unlocked_difficulties() -> Array[String]:
	if is_instance_valid(main_controller) and main_controller.has_method("get_unlocked_difficulties"):
		var raw: Variant = main_controller.call("get_unlocked_difficulties")
		if raw is Array:
			var result: Array[String] = []
			for entry: Variant in raw:
				result.append(str(entry))
			return result
	return [SistemaDificultad.NORMAL]

func _zone_phase(zone_id: String) -> int:
	return int(main_controller.call("get_zone_phase", zone_id)) if is_instance_valid(main_controller) and main_controller.has_method("get_zone_phase") else 1

func _zone_completed(zone_id: String) -> bool:
	return bool(main_controller.call("is_zone_completed", zone_id)) if is_instance_valid(main_controller) and main_controller.has_method("is_zone_completed") else false

func _zone_unlocked(zone_id: String) -> bool:
	return bool(main_controller.call("is_zone_unlocked", zone_id)) if is_instance_valid(main_controller) and main_controller.has_method("is_zone_unlocked") else zone_id == SistemaRegiones.ZONA_VALDORIA

func _create_corner_gem(parent: Control, gem_position: Vector2) -> void:
	var gem: Label = _label(parent, "◆", gem_position, Vector2(16, 16), 16, HORIZONTAL_ALIGNMENT_CENTER, GOLD_BRIGHT)
	gem.vertical_alignment = VERTICAL_ALIGNMENT_CENTER

func _label(parent: Control, text: String, label_position: Vector2, label_size: Vector2, font_size: int, alignment: HorizontalAlignment, color: Color) -> Label:
	var label: Label = Label.new()
	label.position = label_position
	label.size = label_size
	label.text = text
	label.horizontal_alignment = alignment
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", color)
	label.add_theme_constant_override("outline_size", 2)
	label.add_theme_color_override("font_outline_color", Color(0, 0, 0, 0.96))
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	parent.add_child(label)
	return label

func _style(background: Color, border: Color, border_width: int, radius: int, shadow: Color = Color.TRANSPARENT, shadow_size: int = 0) -> StyleBoxFlat:
	var style: StyleBoxFlat = StyleBoxFlat.new()
	style.bg_color = background
	style.border_color = border
	style.set_border_width_all(border_width)
	style.set_corner_radius_all(radius)
	style.shadow_color = shadow
	style.shadow_size = shadow_size
	style.content_margin_left = 6
	style.content_margin_right = 6
	style.content_margin_top = 3
	style.content_margin_bottom = 3
	return style
