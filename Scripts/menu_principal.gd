extends Control

const MAIN_SCENE_PATH: String = "res://escenas/main.tscn"
const FACTION_SCENE_PATH: String = "res://escenas/SeleccionFaccion.tscn"
const SAVE_PATH: String = "user://partida.cfg"
const SETTINGS_PATH: String = "user://opciones.cfg"
const RESET_FILES: Array[String] = [
	"user://partida.cfg",
	"user://inventario.cfg",
	"user://habilidades.cfg",
	"user://forja.cfg",
	"user://misiones.cfg",
	"user://mundos_superados.cfg",
	"user://seleccion.cfg"
]

var current_language: String = "es"
var game_ui: Node
var changing_scene: bool = false
var title_label: Label
var subtitle_label: Label
var continue_button: Button
var new_button: Button
var options_button: Button
var exit_button: Button
var options_panel: Panel
var language_button: Button

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	game_ui = get_node_or_null("/root/GameUI")
	_load_language()
	for child: Node in get_children():
		if child is CanvasItem:
			(child as CanvasItem).visible = false
	_build_interface()
	_refresh_texts()
	if is_instance_valid(game_ui) and game_ui.has_signal("language_changed"):
		var callback: Callable = Callable(self, "_on_language_changed")
		if not game_ui.is_connected("language_changed", callback):
			game_ui.connect("language_changed", callback)
	if is_instance_valid(game_ui) and game_ui.has_method("apply_font_to_tree"):
		game_ui.call_deferred("apply_font_to_tree", self)

func _load_language() -> void:
	if is_instance_valid(game_ui) and game_ui.has_method("get_language"):
		current_language = str(game_ui.call("get_language"))
	else:
		var config: ConfigFile = ConfigFile.new()
		if config.load(SETTINGS_PATH) == OK:
			current_language = str(config.get_value("general", "idioma", "es"))
	current_language = "en" if current_language.to_lower().begins_with("en") else "es"

func _build_interface() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var background: ColorRect = ColorRect.new()
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	background.color = Color("#050A10")
	add_child(background)

	var lower_tint: ColorRect = ColorRect.new()
	lower_tint.position = Vector2(0, size.y * 0.58)
	lower_tint.size = Vector2(size.x, size.y * 0.42)
	lower_tint.color = Color(0.015, 0.08, 0.065, 0.18)
	lower_tint.mouse_filter = Control.MOUSE_FILTER_IGNORE
	background.add_child(lower_tint)

	var frame: Panel = Panel.new()
	frame.set_anchors_preset(Control.PRESET_CENTER)
	frame.position = Vector2(-310, -235)
	frame.size = Vector2(620, 470)
	frame.add_theme_stylebox_override(
		"panel",
		_style(
			Color(0.006, 0.013, 0.021, 0.98),
			Color("#D5B254"),
			3,
			18,
			Color(0, 0, 0, 0.72),
			18
		)
	)
	add_child(frame)

	title_label = _label(
		frame, "", Vector2(35, 35), Vector2(550, 70), 38, Color("#FFE18A")
	)
	subtitle_label = _label(
		frame, "", Vector2(55, 102), Vector2(510, 50), 18, Color("#A9C8D8")
	)
	continue_button = _menu_button(frame, Vector2(135, 175), _on_continue_pressed)
	new_button = _menu_button(frame, Vector2(135, 235), _on_new_game_pressed)
	options_button = _menu_button(frame, Vector2(135, 295), _on_options_pressed)
	exit_button = _menu_button(frame, Vector2(135, 355), _on_exit_pressed, true)

	options_panel = Panel.new()
	options_panel.position = Vector2(70, 160)
	options_panel.size = Vector2(480, 250)
	options_panel.visible = false
	options_panel.add_theme_stylebox_override(
		"panel",
		_style(Color(0.008, 0.018, 0.028, 0.995), Color("#56DDB1"), 2, 12)
	)
	frame.add_child(options_panel)

	var options_title: Label = _label(
		options_panel,
		"OPCIONES",
		Vector2(20, 15),
		Vector2(440, 38),
		25,
		Color("#FFE18A")
	)
	options_title.name = "OptionsTitle"

	language_button = _menu_button(options_panel, Vector2(70, 75), _toggle_language)
	language_button.size = Vector2(340, 48)

	var back_button: Button = _menu_button(
		options_panel, Vector2(70, 145), _on_options_pressed
	)
	back_button.name = "OptionsBack"
	back_button.size = Vector2(340, 48)

func _menu_button(
	parent: Control,
	button_position: Vector2,
	callback: Callable,
	danger: bool = false
) -> Button:
	var button: Button = Button.new()
	button.position = button_position
	button.size = Vector2(350, 48)
	button.focus_mode = Control.FOCUS_NONE
	button.add_theme_font_size_override("font_size", 21)
	button.add_theme_constant_override("outline_size", 2)
	button.add_theme_color_override("font_outline_color", Color.BLACK)
	var accent: Color = Color("#D5B254") if not danger else Color("#C24C58")
	button.add_theme_stylebox_override(
		"normal",
		_style(Color(0.012, 0.026, 0.038, 0.98), accent, 2, 9)
	)
	button.add_theme_stylebox_override(
		"hover",
		_style(
			Color(0.025, 0.075, 0.065, 0.99), accent.lightened(0.20), 3, 9
		)
	)
	button.add_theme_stylebox_override(
		"pressed",
		_style(Color(0.01, 0.14, 0.10, 0.99), Color("#FFF0A0"), 3, 9)
	)
	button.pressed.connect(callback)
	parent.add_child(button)
	return button

func _refresh_texts() -> void:
	var spanish: bool = current_language == "es"
	title_label.text = "TASKBAR ADVENTURES RPG"
	subtitle_label.text = (
		"CRÓNICAS DE LA FRACTURA" if spanish else "CHRONICLES OF THE FRACTURE"
	)
	continue_button.text = "CONTINUAR AVENTURA" if spanish else "CONTINUE ADVENTURE"
	new_button.text = "NUEVA PARTIDA" if spanish else "NEW GAME"
	options_button.text = "OPCIONES" if spanish else "OPTIONS"
	exit_button.text = "SALIR" if spanish else "EXIT"
	continue_button.disabled = not _has_valid_saved_game()
	language_button.text = "IDIOMA · ESPAÑOL" if spanish else "LANGUAGE · ENGLISH"

	var options_title: Label = options_panel.get_node_or_null("OptionsTitle") as Label
	if is_instance_valid(options_title):
		options_title.text = "OPCIONES" if spanish else "OPTIONS"
	var back_button: Button = options_panel.get_node_or_null("OptionsBack") as Button
	if is_instance_valid(back_button):
		back_button.text = "VOLVER" if spanish else "BACK"

func _has_valid_saved_game() -> bool:
	if not FileAccess.file_exists(SAVE_PATH):
		return false
	var config: ConfigFile = ConfigFile.new()
	if config.load(SAVE_PATH) != OK:
		return false
	var character_id: String = str(
		config.get_value("jugador", "personaje", "")
	).strip_edges()
	return (
		not character_id.is_empty()
		or config.has_section_key("mapa", "zona_actual")
		or config.has_section_key("zonas", "fase_0_1")
		or config.has_section_key("zonas", "fase_0_2")
		or config.has_section_key("zonas", "fase_0_3")
	)

func _on_language_changed(language_code: String) -> void:
	current_language = "en" if language_code.to_lower().begins_with("en") else "es"
	_refresh_texts()

func _toggle_language() -> void:
	var next_language: String = "en" if current_language == "es" else "es"
	if is_instance_valid(game_ui) and game_ui.has_method("set_language"):
		game_ui.call("set_language", next_language)
	else:
		current_language = next_language
		_refresh_texts()

func _on_continue_pressed() -> void:
	_change_scene(MAIN_SCENE_PATH)

func _on_new_game_pressed() -> void:
	for file_path: String in RESET_FILES:
		if FileAccess.file_exists(file_path):
			DirAccess.remove_absolute(ProjectSettings.globalize_path(file_path))
	_change_scene(FACTION_SCENE_PATH)

func _on_options_pressed() -> void:
	options_panel.visible = not options_panel.visible
	continue_button.visible = not options_panel.visible
	new_button.visible = not options_panel.visible
	options_button.visible = not options_panel.visible
	exit_button.visible = not options_panel.visible

func _on_exit_pressed() -> void:
	get_tree().quit()

func _change_scene(scene_path: String) -> void:
	if changing_scene or not ResourceLoader.exists(scene_path):
		return
	changing_scene = true
	var change_error: Error = get_tree().change_scene_to_file(scene_path)
	if change_error != OK:
		changing_scene = false
		push_error("No se pudo abrir la escena: " + scene_path)

func _label(
	parent: Control,
	label_text: String,
	label_position: Vector2,
	label_dimensions: Vector2,
	font_size: int,
	color: Color
) -> Label:
	var label: Label = Label.new()
	label.position = label_position
	label.size = label_dimensions
	label.text = label_text
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", color)
	label.add_theme_constant_override("outline_size", 3)
	label.add_theme_color_override("font_outline_color", Color.BLACK)
	parent.add_child(label)
	return label

func _style(
	background: Color,
	border: Color,
	border_width: int,
	radius: int,
	shadow: Color = Color.TRANSPARENT,
	shadow_size: int = 0
) -> StyleBoxFlat:
	var style: StyleBoxFlat = StyleBoxFlat.new()
	style.bg_color = background
	style.border_color = border
	style.set_border_width_all(border_width)
	style.set_corner_radius_all(radius)
	style.shadow_color = shadow
	style.shadow_size = shadow_size
	return style
