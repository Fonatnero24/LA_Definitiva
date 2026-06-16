extends Control
class_name ArbolHabilidadesUI

const MODULE_TOP_ICON_PATH: String = "res://Recursos/UI/IconosBarra/habilidades.svg"

signal skills_changed(effects: Dictionary)
signal character_tokens_changed(tokens: int)
signal potion_generated(item_data: Dictionary)
signal skill_tree_opened
signal skill_tree_closed

@export_group("Ventana")
@export var skill_window_size: Vector2i = Vector2i(1360, 1020)
@export var start_open: bool = false
@export var allow_window_drag: bool = true
@export_range(24.0, 100.0, 1.0) var drag_header_height: float = 58.0

@export_group("Botón superior")
@export var top_button_position: Vector2 = Vector2(208.0, 8.0)
@export var top_button_size: Vector2 = Vector2(20.0, 20.0)
@export var top_button_symbol: String = "✦"

@export_group("Recursos")
@export_file("*.png") var skill_tree_background_path: String = (
	"res://Recursos/UI/arbol_habilidades_cosmico_sin_texto.png"
)

@export_group("Pociones")
@export_range(60.0, 3600.0, 10.0) var potion_interval_seconds: float = 600.0
@export_range(1, 48, 1) var maximum_daily_potions: int = 24

const SKILL_SAVE_PATH: String = "user://habilidades.cfg"
const SETTINGS_PATH: String = "user://opciones.cfg"
const CHARACTER_SAVE_PATH: String = "user://partida.cfg"
const REFERENCE_SIZE: Vector2 = Vector2(1448.0, 1086.0)
const RESET_COST: int = 50
const STAR_COUNT: int = 112
const STAR_REGION: Rect2 = Rect2(300.0, 55.0, 855.0, 930.0)
const TREE_CENTER: Vector2 = Vector2(735.0, 540.0)
const TEXT_Z_INDEX: int = 30
const NODE_Z_INDEX: int = 20
const STAR_Z_INDEX: int = 4

var translations: Dictionary = {
	"es": {
		"window_title": "Árbol Astral de Habilidades",
		"open_tree": "Abrir árbol de habilidades [H]",
		"title": "ÁRBOL DE HABILIDADES",
		"subtitle": "Cada nivel concede 1 punto. Elige el camino de tu campeón.",
		"points": "PUNTOS DISPONIBLES: %d",
		"level": "NIVEL %d",
		"rank": "RANGO %d / %d",
		"cost": "Coste: %d punto(s)",
		"maxed": "DOMINADO",
		"requires_level": "Requiere nivel %d",
		"requires_skill": "Requiere %s rango %d",
		"not_enough": "No tienes suficientes puntos de habilidad.",
		"purchased": "Has mejorado: %s.",
		"characters": "FICHAS DE PERSONAJE: %d",
		"character_hint": "Usa las fichas en los huecos bloqueados del inventario.",
		"potion_counter": "POCIONES HOY: %d / %d",
		"potion_ready": "Alquimia ambulante ha creado una poción.",
		"close": "Cerrar",
		"branch_core": "NÚCLEO DEL CAMPEÓN",
		"branch_offense": "SENDERO DE GUERRA",
		"branch_defense": "BASTIÓN DEL GUARDIÁN",
		"branch_fortune": "FORTUNA DEL VIAJERO",
		"branch_alchemy": "ALQUIMIA DEL CAMINO",
		"branch_legacy": "CAMPEONES",
		"branch_progression": "PROGRESIÓN",
		"desc_offense": "Domina el campo de batalla.",
		"desc_defense": "Resiste y permanece en pie.",
		"desc_fortune": "La suerte favorece a los audaces.",
		"desc_alchemy": "Domina los secretos de la materia.",
		"desc_progression": "Crece más allá de tus límites.",
		"desc_legacy": "Desbloquea el verdadero legado.",
		"no_active_bonus": "Sin bonificación activa.",
		"spent_points": "%d PUNTOS INVERTIDOS",
		"top_level": "Nivel",
		"top_gold": "Oro",
		"top_phase": "Fase",
		"legend_offense": "Ofensiva",
		"legend_defense": "Defensa",
		"legend_fortune": "Fortuna",
		"legend_alchemy": "Alquimia",
		"legend_progression": "Progresión",
		"legend_champions": "Campeones",
		"tree_level": "NIVEL DEL ÁRBOL",
		"bonus_summary": "RESUMEN DE BONIFICACIONES",
		"reset_tree": "REINICIAR ÁRBOL",
		"reset_hint": "Devuelve todos los puntos invertidos.",
		"selected_current": "BONIFICACIÓN ACTUAL",
		"selected_next": "SIGUIENTE NIVEL",
		"unlock": "DESBLOQUEAR",
		"requires_points": "REQUIERE %d PUNTO(S)",
		"legend": "LEYENDA",
		"footer": "TU CAMINO. TU LEYENDA.",
		"lore": "El poder del campeón no reside solo en su fuerza, sino en las decisiones que lo forjan.\n\n— Crónicas de la Fractura",
		"reset_done": "Has reiniciado el árbol de habilidades.",
		"reset_gold": "Necesitas %d de oro para reiniciar el árbol."
	},
	"en": {
		"window_title": "Astral Skill Tree",
		"open_tree": "Open skill tree [H]",
		"title": "SKILL TREE",
		"subtitle": "Each level grants 1 point. Choose your champion's path.",
		"points": "AVAILABLE POINTS: %d",
		"level": "LEVEL %d",
		"rank": "RANK %d / %d",
		"cost": "Cost: %d point(s)",
		"maxed": "MASTERED",
		"requires_level": "Requires level %d",
		"requires_skill": "Requires %s rank %d",
		"not_enough": "You do not have enough skill points.",
		"purchased": "You improved: %s.",
		"characters": "CHARACTER TOKENS: %d",
		"character_hint": "Spend tokens on locked character slots in the inventory.",
		"potion_counter": "POTIONS TODAY: %d / %d",
		"potion_ready": "Wandering Alchemy created a potion.",
		"close": "Close",
		"branch_core": "CHAMPION CORE",
		"branch_offense": "PATH OF WAR",
		"branch_defense": "GUARDIAN BASTION",
		"branch_fortune": "TRAVELER'S FORTUNE",
		"branch_alchemy": "WAYSIDE ALCHEMY",
		"branch_legacy": "CHAMPIONS",
		"branch_progression": "PROGRESSION",
		"desc_offense": "Rule the battlefield.",
		"desc_defense": "Endure and remain standing.",
		"desc_fortune": "Luck favors the bold.",
		"desc_alchemy": "Master the secrets of matter.",
		"desc_progression": "Grow beyond your limits.",
		"desc_legacy": "Unlock the true legacy.",
		"no_active_bonus": "No active bonus.",
		"spent_points": "%d SPENT POINTS",
		"top_level": "Level",
		"top_gold": "Gold",
		"top_phase": "Stage",
		"legend_offense": "Offense",
		"legend_defense": "Defense",
		"legend_fortune": "Fortune",
		"legend_alchemy": "Alchemy",
		"legend_progression": "Progression",
		"legend_champions": "Champions",
		"tree_level": "TREE LEVEL",
		"bonus_summary": "BONUS SUMMARY",
		"reset_tree": "RESET TREE",
		"reset_hint": "Returns every invested skill point.",
		"selected_current": "CURRENT BONUS",
		"selected_next": "NEXT LEVEL",
		"unlock": "UNLOCK",
		"requires_points": "REQUIRES %d POINT(S)",
		"legend": "LEGEND",
		"footer": "YOUR PATH. YOUR LEGEND.",
		"lore": "A champion's power lies not only in strength, but in the choices that shape it.\n\n— Chronicles of the Fracture",
		"reset_done": "You reset the skill tree.",
		"reset_gold": "You need %d gold to reset the tree."
	}
}

var current_language: String = "es"
var game_ui: Node
var main_controller: Node
var main_interface_root: Control
var inventory_ui: Node
var top_button: Button

var skill_window: Window
var skill_window_open: bool = false
var window_dragging: bool = false
var window_drag_offset: Vector2i = Vector2i.ZERO
var window_manually_moved: bool = false

var window_root: Control
var design_root: Control
var background_rect: TextureRect
var tree_scroll: ScrollContainer
var tree_canvas: Control
var connection_layer: Control
var skill_buttons: Dictionary = {}
var skill_rank_labels: Dictionary = {}
var skill_name_labels: Dictionary = {}
var skill_name_panels: Dictionary = {}
var branch_title_labels: Dictionary = {}
var selected_skill_id: String = "core"
var top_area_label: Label
var top_stats_label: Label
var top_phase_label: Label
var tree_level_label: Label
var bonus_summary_label: Label
var selected_title_label: Label
var selected_rank_label: Label
var selected_description_label: Label
var selected_current_label: Label
var selected_next_label: Label
var selected_requirement_label: Label
var unlock_button: Button
var reset_button: Button
var legend_label: Label
var footer_label: Label
var skill_definitions: Array[Dictionary] = []
var skill_definitions_by_id: Dictionary = {}

var title_label: Label
var subtitle_label: Label
var points_label: Label
var level_label: Label
var character_tokens_label: Label
var character_hint_label: Label
var potion_counter_label: Label
var status_label: Label
var close_button: Button

var skill_ranks: Dictionary = {}
var extra_skill_points: int = 0
var character_tokens: int = 0
var potion_day_key: String = ""
var potions_today: int = 0
var last_potion_unix: int = 0
var current_effects: Dictionary = {}
var potion_check_accumulator: float = 0.0

var star_layer: Control
var twinkling_stars: Array[Dictionary] = []
var astral_time: float = 0.0
var star_rng: RandomNumberGenerator = RandomNumberGenerator.new()

func _ready() -> void:
	star_rng.randomize()
	process_mode = Node.PROCESS_MODE_ALWAYS
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	visible = true
	_build_skill_definitions()
	_connect_game_ui()
	_load_language()
	call_deferred("_initialize_skill_tree")

func _process(delta: float) -> void:
	_sync_top_button_with_options()
	astral_time += delta
	if skill_window_open:
		_update_twinkling_stars()
		var selected_definition: Dictionary = skill_definitions_by_id.get(selected_skill_id, {})
		if not selected_definition.is_empty():
			_refresh_skill_button(selected_definition)
	potion_check_accumulator += delta
	if potion_check_accumulator >= 1.0:
		potion_check_accumulator = 0.0
		_process_potion_generator()
		if skill_window_open:
			_refresh_header_only()

func _initialize_skill_tree() -> void:
	main_controller = get_parent()
	for _attempt in range(180):
		_refresh_references()
		if is_instance_valid(main_interface_root):
			break
		await get_tree().process_frame

	_load_progress()
	_mount_top_button()
	_build_window()
	_refresh_all()
	_notify_main_effects()

	if start_open:
		open_skill_tree()

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
		var config := ConfigFile.new()
		if config.load(SETTINGS_PATH) == OK:
			current_language = str(
				config.get_value("general", "idioma", "es")
			).to_lower().strip_edges()

	if current_language != "es" and current_language != "en":
		current_language = "es"

func set_language(language_code: String) -> void:
	var normalized := language_code.to_lower().strip_edges()
	if normalized != "es" and normalized != "en":
		normalized = "es"
	current_language = normalized
	_refresh_all()

func _text(key: String) -> String:
	var spanish: Dictionary = translations.get("es", {})
	var selected: Dictionary = translations.get(current_language, spanish)
	return str(selected.get(key, spanish.get(key, key)))

func _main_options_are_open() -> bool:
	if not is_instance_valid(main_controller):
		return false

	if main_controller.has_method("is_modal_ui_open"):
		return bool(main_controller.call("is_modal_ui_open"))

	var value: Variant = main_controller.get("options_open")
	return value is bool and bool(value)

func _sync_top_button_with_options() -> void:

	if is_instance_valid(top_button):
		top_button.tooltip_text = _text("open_tree")

func _mount_top_button() -> void:
	if not is_instance_valid(main_interface_root):
		return

	var existing: Node = main_interface_root.find_child(
		"BotonHabilidades",
		true,
		false
	)

	if existing is Button:
		top_button = existing as Button
		top_button.tooltip_text = _text("open_tree")
		return

	top_button = Button.new()
	top_button.name = "BotonHabilidades"
	top_button.text = ""
	if ResourceLoader.exists("res://Recursos/UI/IconosBarra/habilidades.svg"):
		top_button.icon = load("res://Recursos/UI/IconosBarra/habilidades.svg") as Texture2D
	top_button.expand_icon = true
	top_button.icon_alignment = HORIZONTAL_ALIGNMENT_CENTER
	top_button.vertical_icon_alignment = VERTICAL_ALIGNMENT_CENTER
	top_button.add_theme_constant_override("icon_max_width", 10)
	top_button.position = top_button_position
	top_button.size = top_button_size
	top_button.focus_mode = Control.FOCUS_NONE
	top_button.tooltip_text = _text("open_tree")
	top_button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	top_button.pressed.connect(toggle_skill_tree)
	main_interface_root.add_child(top_button)

func _unhandled_input(event: InputEvent) -> void:
	if not (event is InputEventKey):
		return
	var key_event := event as InputEventKey
	if not key_event.pressed or key_event.echo:
		return
	if key_event.keycode == KEY_H and not _main_options_are_open():
		toggle_skill_tree()
		get_viewport().set_input_as_handled()
	elif key_event.keycode == KEY_ESCAPE and skill_window_open:
		close_skill_tree()
		get_viewport().set_input_as_handled()

func toggle_skill_tree() -> void:
	if skill_window_open:
		close_skill_tree()
	else:
		open_skill_tree()

func open_skill_tree() -> void:
	if _main_options_are_open():
		return
	_load_progress()
	_refresh_all()
	if is_instance_valid(skill_window):
		skill_window.size = skill_window_size
		_position_window()
		skill_window.show()
		skill_window.grab_focus()
		call_deferred("_fit_design_to_window")
	skill_window_open = true
	skill_tree_opened.emit()

func _center_tree_on_core() -> void:

	pass

func close_skill_tree() -> void:
	if is_instance_valid(skill_window):
		skill_window.hide()
	skill_window_open = false
	window_dragging = false
	skill_tree_closed.emit()

func _position_window(force_position: bool = false) -> void:
	if not is_instance_valid(skill_window):
		return
	if window_manually_moved and not force_position:
		return
	var screen_index := DisplayServer.window_get_current_screen()
	var usable := DisplayServer.screen_get_usable_rect(screen_index)
	var x := usable.position.x + int(float(usable.size.x - skill_window.size.x) / 2.0)
	var y := usable.position.y + int(float(usable.size.y - skill_window.size.y) / 2.0)
	skill_window.position = Vector2i(x, y)

func _on_window_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var mouse_event := event as InputEventMouseButton
		if mouse_event.button_index != MOUSE_BUTTON_LEFT:
			return
		if mouse_event.pressed:
			if allow_window_drag and mouse_event.position.y <= drag_header_height and mouse_event.position.x < float(skill_window.size.x - 62):
				window_dragging = true
				window_drag_offset = DisplayServer.mouse_get_position() - skill_window.position
		else:
			if window_dragging:
				window_dragging = false
				window_manually_moved = true
	elif event is InputEventMouseMotion and window_dragging:
		skill_window.position = DisplayServer.mouse_get_position() - window_drag_offset

func _build_window() -> void:
	skill_window = Window.new()
	skill_window.name = "VentanaArbolHabilidades"
	skill_window.title = _text("window_title")
	skill_window.size = skill_window_size
	skill_window.min_size = Vector2i(1100, 825)
	skill_window.borderless = true
	skill_window.unresizable = false
	skill_window.always_on_top = true
	skill_window.exclusive = false
	skill_window.transparent = true
	skill_window.transparent_bg = true
	skill_window.visible = false
	skill_window.force_native = true
	skill_window.close_requested.connect(close_skill_tree)
	skill_window.window_input.connect(_on_window_input)
	skill_window.size_changed.connect(_fit_design_to_window)
	add_child(skill_window)

	window_root = Control.new()
	window_root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	window_root.mouse_filter = Control.MOUSE_FILTER_PASS
	skill_window.add_child(window_root)

	design_root = Control.new()
	design_root.name = "DisenoAstral"
	design_root.size = REFERENCE_SIZE
	design_root.mouse_filter = Control.MOUSE_FILTER_PASS
	window_root.add_child(design_root)

	background_rect = TextureRect.new()
	background_rect.name = "FondoAstral"
	background_rect.position = Vector2.ZERO
	background_rect.size = REFERENCE_SIZE
	background_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	background_rect.stretch_mode = TextureRect.STRETCH_SCALE
	background_rect.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	background_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	background_rect.z_index = 0
	if ResourceLoader.exists(skill_tree_background_path):
		background_rect.texture = load(skill_tree_background_path) as Texture2D
	else:
		push_warning("No se encontró el fondo del árbol: " + skill_tree_background_path)
	design_root.add_child(background_rect)

	_create_astral_star_layer()
	_build_overlay_text()
	_build_skill_nodes()
	_fit_design_to_window()

func _create_astral_star_layer() -> void:
	if is_instance_valid(star_layer):
		star_layer.queue_free()

	star_layer = Control.new()
	star_layer.name = "EstrellasAstrales"
	star_layer.position = Vector2.ZERO
	star_layer.size = REFERENCE_SIZE
	star_layer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	star_layer.z_index = STAR_Z_INDEX
	design_root.add_child(star_layer)

	twinkling_stars.clear()
	for star_index in range(STAR_COUNT):
		var star_control := Control.new()
		var star_size: float = float(star_rng.randi_range(1, 3))
		star_control.position = Vector2(
			star_rng.randf_range(STAR_REGION.position.x, STAR_REGION.position.x + STAR_REGION.size.x),
			star_rng.randf_range(STAR_REGION.position.y, STAR_REGION.position.y + STAR_REGION.size.y)
		)
		star_control.size = Vector2(7.0, 7.0)
		star_control.pivot_offset = star_control.size * 0.5
		star_control.mouse_filter = Control.MOUSE_FILTER_IGNORE

		var vertical_ray := ColorRect.new()
		vertical_ray.position = Vector2(3.0, 3.0 - star_size)
		vertical_ray.size = Vector2(1.0, star_size * 2.0 + 1.0)
		vertical_ray.color = Color(0.78, 0.92, 1.0, 1.0)
		vertical_ray.mouse_filter = Control.MOUSE_FILTER_IGNORE
		star_control.add_child(vertical_ray)

		var horizontal_ray := ColorRect.new()
		horizontal_ray.position = Vector2(3.0 - star_size, 3.0)
		horizontal_ray.size = Vector2(star_size * 2.0 + 1.0, 1.0)
		horizontal_ray.color = Color(1.0, 0.91, 0.63, 1.0)
		horizontal_ray.mouse_filter = Control.MOUSE_FILTER_IGNORE
		star_control.add_child(horizontal_ray)

		star_layer.add_child(star_control)
		twinkling_stars.append({
			"node": star_control,
			"phase": star_rng.randf_range(0.0, TAU),
			"speed": star_rng.randf_range(0.65, 2.25),
			"minimum": star_rng.randf_range(0.05, 0.28),
			"maximum": star_rng.randf_range(0.45, 0.96),
			"scale": star_rng.randf_range(0.70, 1.35)
		})

func _update_twinkling_stars() -> void:
	for star_data in twinkling_stars:
		var star_node: Control = star_data.get("node") as Control
		if not is_instance_valid(star_node):
			continue

		var phase: float = float(star_data.get("phase", 0.0))
		var speed: float = float(star_data.get("speed", 1.0))
		var minimum_alpha: float = float(star_data.get("minimum", 0.1))
		var maximum_alpha: float = float(star_data.get("maximum", 0.8))
		var base_scale: float = float(star_data.get("scale", 1.0))
		var pulse: float = (sin(astral_time * speed + phase) + 1.0) * 0.5
		star_node.modulate.a = lerpf(minimum_alpha, maximum_alpha, pulse)
		var pulse_scale: float = base_scale * lerpf(0.82, 1.12, pulse)
		star_node.scale = Vector2.ONE * pulse_scale

func _fit_design_to_window() -> void:
	if not is_instance_valid(design_root) or not is_instance_valid(skill_window):
		return
	var viewport_size := Vector2(skill_window.size)
	var factor := minf(viewport_size.x / REFERENCE_SIZE.x, viewport_size.y / REFERENCE_SIZE.y)
	design_root.scale = Vector2.ONE * factor
	design_root.position = (viewport_size - REFERENCE_SIZE * factor) * 0.5

func _build_overlay_text() -> void:

	top_area_label = _create_label(design_root, "TASKBAR ADVENTURES", Vector2(40, 8), Vector2(230, 44), 17, HORIZONTAL_ALIGNMENT_LEFT, Color("#72F0C2"))
	top_area_label.add_theme_constant_override("outline_size", 2)
	top_stats_label = _create_label(design_root, "", Vector2(430, 8), Vector2(590, 44), 16, HORIZONTAL_ALIGNMENT_CENTER, Color("#F1E8DB"))
	top_phase_label = _create_label(design_root, "", Vector2(1108, 8), Vector2(180, 44), 15, HORIZONTAL_ALIGNMENT_RIGHT, Color("#DAB0FF"))

	close_button = Button.new()
	close_button.text = ""
	close_button.position = Vector2(1389, 8)
	close_button.size = Vector2(43, 43)
	close_button.flat = true
	close_button.z_index = 50
	close_button.focus_mode = Control.FOCUS_NONE
	close_button.tooltip_text = _text("close")
	close_button.pressed.connect(close_skill_tree)
	design_root.add_child(close_button)

	title_label = _create_label(design_root, _text("title"), Vector2(34, 72), Vector2(265, 38), 21, HORIZONTAL_ALIGNMENT_CENTER, Color("#F3CE72"))
	title_label.add_theme_constant_override("outline_size", 3)
	subtitle_label = _create_label(design_root, _text("subtitle"), Vector2(46, 111), Vector2(242, 48), 11, HORIZONTAL_ALIGNMENT_CENTER, Color("#E5E8ED"))
	subtitle_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART

	points_label = _create_label(design_root, "", Vector2(52, 184), Vector2(228, 52), 15, HORIZONTAL_ALIGNMENT_CENTER, Color("#78F0B6"))
	points_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	character_tokens_label = _create_label(design_root, "", Vector2(52, 237), Vector2(228, 20), 10, HORIZONTAL_ALIGNMENT_CENTER, Color("#DAB0FF"))
	tree_level_label = _create_label(design_root, "", Vector2(50, 267), Vector2(235, 48), 11, HORIZONTAL_ALIGNMENT_CENTER, Color("#F1D697"))
	potion_counter_label = _create_label(design_root, "", Vector2(52, 316), Vector2(228, 20), 10, HORIZONTAL_ALIGNMENT_CENTER, Color("#7FD8FF"))

	var bonus_title := _create_label(design_root, _text("bonus_summary"), Vector2(39, 382), Vector2(255, 32), 15, HORIZONTAL_ALIGNMENT_CENTER, Color("#EBCB7A"))
	bonus_title.add_theme_constant_override("outline_size", 2)
	bonus_summary_label = _create_label(design_root, "", Vector2(53, 422), Vector2(225, 174), 12, HORIZONTAL_ALIGNMENT_LEFT, Color("#E6E1D8"))
	bonus_summary_label.vertical_alignment = VERTICAL_ALIGNMENT_TOP
	bonus_summary_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	bonus_summary_label.add_theme_constant_override("line_spacing", 4)

	reset_button = Button.new()
	reset_button.position = Vector2(51, 642)
	reset_button.size = Vector2(235, 78)
	reset_button.focus_mode = Control.FOCUS_NONE
	reset_button.z_index = TEXT_Z_INDEX + 2
	reset_button.text = "%s\n%s\n◆ %d" % [_text("reset_tree"), _text("reset_hint"), RESET_COST]
	reset_button.add_theme_font_size_override("font_size", 12)
	reset_button.add_theme_color_override("font_color", Color("#EED59A"))
	reset_button.add_theme_stylebox_override("normal", _make_style(Color(0.01, 0.025, 0.035, 0.55), Color(0.72, 0.52, 0.20, 0.50), 1, 8))
	reset_button.add_theme_stylebox_override("hover", _make_style(Color(0.04, 0.08, 0.08, 0.80), Color("#E6C45D"), 2, 8))
	reset_button.pressed.connect(_reset_skill_tree)
	design_root.add_child(reset_button)

	var lore_label := _create_label(design_root, _text("lore"), Vector2(82, 806), Vector2(208, 146), 11, HORIZONTAL_ALIGNMENT_CENTER, Color("#D7D0C3"))
	lore_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	lore_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART

	_create_branch_hub("branch_offense", "desc_offense", Vector2(627, 245), Vector2(216, 80), Color("#FF9872"))
	_create_branch_hub("branch_defense", "desc_defense", Vector2(889, 385), Vector2(212, 80), Color("#8BC7FF"))
	_create_branch_hub("branch_fortune", "desc_fortune", Vector2(360, 385), Vector2(220, 80), Color("#8AEC9D"))
	_create_branch_hub("branch_alchemy", "desc_alchemy", Vector2(356, 652), Vector2(222, 80), Color("#E49BFF"))
	_create_branch_hub("branch_progression", "desc_progression", Vector2(891, 652), Vector2(222, 80), Color("#FFD26A"))
	_create_branch_hub("branch_legacy", "desc_legacy", Vector2(615, 800), Vector2(236, 82), Color("#7DECF0"))

	var core_title := _create_label(design_root, _text("branch_core"), Vector2(607, 580), Vector2(255, 48), 18, HORIZONTAL_ALIGNMENT_CENTER, Color("#F5D674"))
	core_title.add_theme_constant_override("outline_size", 3)

	selected_title_label = _create_label(design_root, "", Vector2(1182, 164), Vector2(222, 58), 16, HORIZONTAL_ALIGNMENT_CENTER, Color("#F3D47B"))
	selected_title_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	selected_rank_label = _create_label(design_root, "", Vector2(1188, 224), Vector2(210, 24), 11, HORIZONTAL_ALIGNMENT_CENTER, Color("#D5CADF"))
	selected_description_label = _create_label(design_root, "", Vector2(1188, 278), Vector2(210, 110), 11, HORIZONTAL_ALIGNMENT_CENTER, Color("#E1DDD4"))
	selected_description_label.vertical_alignment = VERTICAL_ALIGNMENT_TOP
	selected_description_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	selected_description_label.add_theme_constant_override("line_spacing", 3)
	selected_current_label = _create_label(design_root, "", Vector2(1188, 410), Vector2(210, 94), 11, HORIZONTAL_ALIGNMENT_LEFT, Color("#DDD6CA"))
	selected_current_label.vertical_alignment = VERTICAL_ALIGNMENT_TOP
	selected_current_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	selected_next_label = _create_label(design_root, "", Vector2(1188, 520), Vector2(210, 84), 11, HORIZONTAL_ALIGNMENT_LEFT, Color("#7EE7A3"))
	selected_next_label.vertical_alignment = VERTICAL_ALIGNMENT_TOP
	selected_next_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	selected_requirement_label = _create_label(design_root, "", Vector2(1188, 612), Vector2(210, 42), 11, HORIZONTAL_ALIGNMENT_CENTER, Color("#FF887A"))

	unlock_button = Button.new()
	unlock_button.position = Vector2(1188, 666)
	unlock_button.size = Vector2(210, 58)
	unlock_button.focus_mode = Control.FOCUS_NONE
	unlock_button.z_index = TEXT_Z_INDEX + 2
	unlock_button.add_theme_font_size_override("font_size", 15)
	unlock_button.add_theme_color_override("font_color", Color("#F5DF9C"))
	unlock_button.add_theme_stylebox_override("normal", _make_style(Color(0.01, 0.11, 0.07, 0.84), Color("#42D684"), 2, 8))
	unlock_button.add_theme_stylebox_override("hover", _make_style(Color(0.02, 0.22, 0.12, 0.95), Color("#88FFB7"), 3, 8))
	unlock_button.add_theme_stylebox_override("disabled", _make_style(Color(0.02, 0.03, 0.04, 0.78), Color("#4E4A42"), 1, 8))
	unlock_button.pressed.connect(_purchase_selected_skill)
	design_root.add_child(unlock_button)

	legend_label = _create_label(design_root, "", Vector2(1190, 804), Vector2(206, 156), 11, HORIZONTAL_ALIGNMENT_LEFT, Color("#D9D4CB"))
	legend_label.vertical_alignment = VERTICAL_ALIGNMENT_TOP
	legend_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART

	footer_label = _create_label(design_root, _text("footer"), Vector2(440, 1016), Vector2(570, 30), 14, HORIZONTAL_ALIGNMENT_CENTER, Color("#C9A953"))
	status_label = _create_label(design_root, "", Vector2(390, 1047), Vector2(670, 20), 11, HORIZONTAL_ALIGNMENT_CENTER, Color("#E6DED2"))

func _create_branch_hub(
	text_key: String,
	description_key: String,
	hub_position: Vector2,
	hub_size: Vector2,
	color: Color
) -> void:
	var backdrop := Panel.new()
	backdrop.position = hub_position + Vector2(5.0, 4.0)
	backdrop.size = hub_size - Vector2(10.0, 8.0)
	backdrop.mouse_filter = Control.MOUSE_FILTER_IGNORE
	backdrop.z_index = 16
	backdrop.add_theme_stylebox_override(
		"panel",
		_make_style(
			Color(0.005, 0.012, 0.022, 0.76),
			Color(color.r, color.g, color.b, 0.36),
			1,
			18,
			Color(color.r, color.g, color.b, 0.14),
			8
		)
	)
	design_root.add_child(backdrop)

	var label := _create_label(
		design_root,
		"%s\n%s" % [_text(text_key), _text(description_key)],
		hub_position,
		hub_size,
		13,
		HORIZONTAL_ALIGNMENT_CENTER,
		color
	)
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.add_theme_constant_override("outline_size", 3)
	label.z_index = TEXT_Z_INDEX
	branch_title_labels[text_key] = {
		"label": label,
		"description_key": description_key
	}

func _build_skill_nodes() -> void:
	skill_buttons.clear()
	skill_rank_labels.clear()
	skill_name_labels.clear()
	skill_name_panels.clear()

	for definition in skill_definitions:
		var skill_id: String = str(definition.get("id", ""))
		var button := Button.new()
		button.name = "Skill_%s" % skill_id
		button.position = definition.get("position", Vector2.ZERO)
		button.size = definition.get("size", Vector2(58, 58))
		button.text = ""
		button.focus_mode = Control.FOCUS_NONE
		button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		button.z_index = NODE_Z_INDEX
		button.pressed.connect(_select_skill.bind(skill_id))
		design_root.add_child(button)
		skill_buttons[skill_id] = button

		var rank_badge := Label.new()
		rank_badge.position = Vector2(button.size.x - 27.0, button.size.y - 19.0)
		rank_badge.size = Vector2(27.0, 18.0)
		rank_badge.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		rank_badge.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		rank_badge.add_theme_font_size_override("font_size", 8)
		rank_badge.add_theme_color_override("font_color", Color.WHITE)
		rank_badge.add_theme_color_override("font_outline_color", Color(0, 0, 0, 1))
		rank_badge.add_theme_constant_override("outline_size", 1)
		rank_badge.add_theme_stylebox_override("normal", _make_style(Color(0, 0, 0, 0.82), Color(1, 1, 1, 0.22), 1, 7))
		rank_badge.mouse_filter = Control.MOUSE_FILTER_IGNORE
		rank_badge.z_index = NODE_Z_INDEX + 3
		button.add_child(rank_badge)
		skill_rank_labels[skill_id] = rank_badge

		if skill_id != "core" and button.size.x <= 60.0:
			_create_skill_caption(definition, button)

func _create_skill_caption(definition: Dictionary, button: Button) -> void:
	var skill_id: String = str(definition.get("id", ""))
	var center: Vector2 = button.position + button.size * 0.5
	var radial: Vector2 = (center - TREE_CENTER).normalized()
	if radial == Vector2.ZERO:
		radial = Vector2.DOWN

	var caption_size := Vector2(104.0, 34.0)
	var caption_center := center + radial * 43.0

	if center.y < 180.0:
		caption_center = center + Vector2(0.0, 47.0)
	elif center.y > 875.0:
		caption_center = center + Vector2(0.0, -47.0)

	var caption_position := caption_center - caption_size * 0.5
	caption_position.x = clampf(caption_position.x, 304.0, 1114.0 - caption_size.x)
	caption_position.y = clampf(caption_position.y, 58.0, 995.0 - caption_size.y)

	var branch: String = str(definition.get("branch", "core"))
	var accent: Color = _branch_color(branch)
	var panel := Panel.new()
	panel.position = caption_position
	panel.size = caption_size
	panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	panel.z_index = NODE_Z_INDEX + 1
	panel.add_theme_stylebox_override(
		"panel",
		_make_style(
			Color(0.005, 0.012, 0.022, 0.76),
			Color(accent.r, accent.g, accent.b, 0.28),
			1,
			7
		)
	)
	design_root.add_child(panel)
	skill_name_panels[skill_id] = panel

	var caption := _create_label(
		design_root,
		"",
		caption_position + Vector2(3.0, 1.0),
		caption_size - Vector2(6.0, 2.0),
		9,
		HORIZONTAL_ALIGNMENT_CENTER,
		Color("#F0E7D6")
	)
	caption.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	caption.add_theme_constant_override("line_spacing", -1)
	caption.add_theme_constant_override("outline_size", 2)
	caption.z_index = NODE_Z_INDEX + 2
	skill_name_labels[skill_id] = caption

func _draw_connections() -> void:

	pass

func _build_skill_definitions() -> void:
	skill_definitions = [
		{"id":"core", "branch":"core", "position":Vector2(690, 485), "size":Vector2(90, 90), "max_rank":1, "base_cost":0, "cost_growth":0, "min_level":1, "auto_unlocked":true, "requires":[], "title_es":"Núcleo del campeón", "title_en":"Champion Core", "desc_es":"El corazón de tu leyenda. Abre todos los senderos.", "desc_en":"The heart of your legend. Opens every path."},

		{"id":"damage", "branch":"offense", "position":Vector2(694, 164), "size":Vector2(78, 78), "max_rank":5, "base_cost":1, "cost_growth":0, "min_level":1, "requires":[{"id":"core","rank":1}], "title_es":"Fuerza implacable", "title_en":"Relentless Strength", "desc_es":"+4% de daño por rango.", "desc_en":"+4% damage per rank."},
		{"id":"speed", "branch":"offense", "position":Vector2(610, 240), "size":Vector2(54, 54), "max_rank":5, "base_cost":1, "cost_growth":0, "min_level":4, "requires":[{"id":"damage","rank":1}], "title_es":"Ritmo de batalla", "title_en":"Battle Rhythm", "desc_es":"+5 de velocidad de ataque por rango.", "desc_en":"+5 attack speed per rank."},
		{"id":"crit", "branch":"offense", "position":Vector2(610, 108), "size":Vector2(54, 54), "max_rank":5, "base_cost":1, "cost_growth":0, "min_level":5, "requires":[{"id":"damage","rank":2}], "title_es":"Golpe preciso", "title_en":"Precise Strike", "desc_es":"+2% de probabilidad crítica por rango.", "desc_en":"+2% critical chance per rank."},
		{"id":"armor_break", "branch":"offense", "position":Vector2(770, 110), "size":Vector2(54, 54), "max_rank":4, "base_cost":2, "cost_growth":0, "min_level":9, "requires":[{"id":"damage","rank":3}], "title_es":"Filo penetrante", "title_en":"Piercing Edge", "desc_es":"+3% de daño adicional por rango.", "desc_en":"+3% additional damage per rank."},
		{"id":"lifesteal", "branch":"offense", "position":Vector2(834, 244), "size":Vector2(54, 54), "max_rank":3, "base_cost":2, "cost_growth":1, "min_level":14, "requires":[{"id":"speed","rank":3}], "title_es":"Sed de victoria", "title_en":"Thirst for Victory", "desc_es":"Curas un 1% del daño causado por rango.", "desc_en":"Heal 1% of damage dealt per rank."},
		{"id":"crit_damage", "branch":"offense", "position":Vector2(550, 73), "size":Vector2(54, 54), "max_rank":4, "base_cost":2, "cost_growth":1, "min_level":12, "requires":[{"id":"crit","rank":3}], "title_es":"Veredicto crítico", "title_en":"Critical Verdict", "desc_es":"+15% de daño crítico por rango.", "desc_en":"+15% critical damage per rank."},
		{"id":"execution", "branch":"offense", "position":Vector2(695, 64), "size":Vector2(58, 58), "max_rank":3, "base_cost":3, "cost_growth":1, "min_level":20, "requires":[{"id":"armor_break","rank":3}], "title_es":"Ejecución", "title_en":"Execution", "desc_es":"+10% de daño contra enemigos bajo 30% de vida por rango.", "desc_en":"+10% damage against enemies below 30% health per rank."},
		{"id":"war_mastery", "branch":"offense", "position":Vector2(886, 92), "size":Vector2(58, 58), "max_rank":1, "base_cost":6, "cost_growth":0, "min_level":32, "requires":[{"id":"crit_damage","rank":2},{"id":"execution","rank":2},{"id":"lifesteal","rank":2}], "title_es":"Avatar de la guerra", "title_en":"Avatar of War", "desc_es":"+12% daño, +5% crítico y +10 velocidad.", "desc_en":"+12% damage, +5% critical chance and +10 speed."},

		{"id":"vitality", "branch":"defense", "position":Vector2(965, 328), "size":Vector2(78, 78), "max_rank":5, "base_cost":1, "cost_growth":0, "min_level":1, "requires":[{"id":"core","rank":1}], "title_es":"Vitalidad", "title_en":"Vitality", "desc_es":"+5% de vida máxima por rango.", "desc_en":"+5% maximum health per rank."},
		{"id":"defense", "branch":"defense", "position":Vector2(920, 236), "size":Vector2(54, 54), "max_rank":5, "base_cost":1, "cost_growth":0, "min_level":4, "requires":[{"id":"vitality","rank":1}], "title_es":"Armadura templada", "title_en":"Tempered Armor", "desc_es":"+6 de defensa por rango.", "desc_en":"+6 defense per rank."},
		{"id":"resistance", "branch":"defense", "position":Vector2(985, 198), "size":Vector2(54, 54), "max_rank":4, "base_cost":2, "cost_growth":1, "min_level":10, "requires":[{"id":"vitality","rank":2}], "title_es":"Muralla del Guardián", "title_en":"Guardian Bulwark", "desc_es":"-3% de daño recibido por rango.", "desc_en":"-3% damage taken per rank."},
		{"id":"dodge", "branch":"defense", "position":Vector2(1045, 238), "size":Vector2(54, 54), "max_rank":4, "base_cost":2, "cost_growth":0, "min_level":12, "requires":[{"id":"defense","rank":2}], "title_es":"Paso del viento", "title_en":"Wind Step", "desc_es":"+1,5% de probabilidad de esquivar por rango.", "desc_en":"+1.5% dodge chance per rank."},
		{"id":"block", "branch":"defense", "position":Vector2(1090, 292), "size":Vector2(54, 54), "max_rank":4, "base_cost":2, "cost_growth":0, "min_level":14, "requires":[{"id":"defense","rank":3}], "title_es":"Guardia firme", "title_en":"Steadfast Guard", "desc_es":"+3% de probabilidad de bloquear la mitad del daño por rango.", "desc_en":"+3% chance to block half damage per rank."},
		{"id":"heal_kill", "branch":"defense", "position":Vector2(1107, 383), "size":Vector2(54, 54), "max_rank":5, "base_cost":2, "cost_growth":0, "min_level":16, "requires":[{"id":"resistance","rank":2}], "title_es":"Aliento del vencedor", "title_en":"Victor’s Breath", "desc_es":"Recuperas 6 de vida al vencer por rango.", "desc_en":"Recover 6 health on victory per rank."},
		{"id":"shield_kill", "branch":"defense", "position":Vector2(1065, 469), "size":Vector2(54, 54), "max_rank":5, "base_cost":2, "cost_growth":0, "min_level":20, "requires":[{"id":"dodge","rank":2},{"id":"block","rank":2}], "title_es":"Égida triunfal", "title_en":"Triumphant Aegis", "desc_es":"Obtienes 10 de escudo al vencer por rango.", "desc_en":"Gain 10 shield on victory per rank."},
		{"id":"last_stand", "branch":"defense", "position":Vector2(976, 493), "size":Vector2(54, 54), "max_rank":3, "base_cost":3, "cost_growth":1, "min_level":24, "requires":[{"id":"block","rank":3}], "title_es":"Último bastión", "title_en":"Last Bastion", "desc_es":"-5% de daño recibido bajo 35% de vida por rango.", "desc_en":"-5% damage taken below 35% health per rank."},
		{"id":"guardian_mastery", "branch":"defense", "position":Vector2(895, 422), "size":Vector2(58, 58), "max_rank":1, "base_cost":6, "cost_growth":0, "min_level":34, "requires":[{"id":"heal_kill","rank":3},{"id":"shield_kill","rank":3},{"id":"last_stand","rank":2}], "title_es":"Guardián eterno", "title_en":"Eternal Guardian", "desc_es":"+10% vida, +12 defensa y -5% de daño recibido.", "desc_en":"+10% health, +12 defense and -5% damage taken."},

		{"id":"fortune", "branch":"fortune", "position":Vector2(447, 328), "size":Vector2(78, 78), "max_rank":5, "base_cost":1, "cost_growth":0, "min_level":1, "requires":[{"id":"core","rank":1}], "title_es":"Fortuna del viajero", "title_en":"Traveler's Fortune", "desc_es":"+1% de oro y experiencia por rango.", "desc_en":"+1% gold and experience per rank."},
		{"id":"gold", "branch":"progression", "position":Vector2(962, 617), "size":Vector2(78, 78), "max_rank":5, "base_cost":1, "cost_growth":0, "min_level":5, "requires":[{"id":"fortune","rank":1}], "title_es":"Bolsillos bendecidos", "title_en":"Blessed Pockets", "desc_es":"+6% de oro obtenido por rango.", "desc_en":"+6% gold gained per rank."},
		{"id":"xp", "branch":"progression", "position":Vector2(1066, 590), "size":Vector2(54, 54), "max_rank":5, "base_cost":1, "cost_growth":0, "min_level":5, "requires":[{"id":"fortune","rank":1}], "title_es":"Memoria del combate", "title_en":"Battle Memory", "desc_es":"+6% de experiencia por rango.", "desc_en":"+6% experience per rank."},
		{"id":"loot", "branch":"fortune", "position":Vector2(532, 238), "size":Vector2(54, 54), "max_rank":5, "base_cost":2, "cost_growth":0, "min_level":10, "requires":[{"id":"fortune","rank":3}], "title_es":"Ojo del buscador", "title_en":"Seeker's Eye", "desc_es":"+4% de suerte de botín por rango.", "desc_en":"+4% loot luck per rank."},
		{"id":"treasure", "branch":"fortune", "position":Vector2(560, 315), "size":Vector2(54, 54), "max_rank":4, "base_cost":2, "cost_growth":1, "min_level":18, "requires":[{"id":"gold","rank":3},{"id":"loot","rank":2}], "title_es":"Cazador de tesoros", "title_en":"Treasure Hunter", "desc_es":"+4% oro y +3% suerte de botín por rango.", "desc_en":"+4% gold and +3% loot luck per rank."},
		{"id":"relic", "branch":"fortune", "position":Vector2(385, 425), "size":Vector2(54, 54), "max_rank":3, "base_cost":3, "cost_growth":1, "min_level":26, "requires":[{"id":"loot","rank":4},{"id":"xp","rank":3}], "title_es":"Rastro de reliquias", "title_en":"Relic Trail", "desc_es":"+6% suerte de botín y +3% EXP por rango.", "desc_en":"+6% loot luck and +3% XP per rank."},
		{"id":"fortune_mastery", "branch":"progression", "position":Vector2(1087, 735), "size":Vector2(58, 58), "max_rank":1, "base_cost":7, "cost_growth":0, "min_level":38, "requires":[{"id":"treasure","rank":3},{"id":"relic","rank":2}], "title_es":"Favor de la fortuna", "title_en":"Fortune's Favor", "desc_es":"+15% oro, +15% EXP y +12% suerte de botín.", "desc_en":"+15% gold, +15% XP and +12% loot luck."},

		{"id":"alchemy_root", "branch":"alchemy", "position":Vector2(420, 618), "size":Vector2(78, 78), "max_rank":5, "base_cost":1, "cost_growth":0, "min_level":3, "requires":[{"id":"core","rank":1}], "title_es":"Sabiduría alquímica", "title_en":"Alchemical Wisdom", "desc_es":"+5% de potencia de pociones por rango.", "desc_en":"+5% potion power per rank."},
		{"id":"potion", "branch":"alchemy", "position":Vector2(349, 559), "size":Vector2(54, 54), "max_rank":1, "base_cost":3, "cost_growth":0, "min_level":12, "requires":[{"id":"alchemy_root","rank":2}], "title_es":"Alquimia ambulante", "title_en":"Wandering Alchemy", "desc_es":"Crea 1 poción cada 10 min, máximo 24 al día.", "desc_en":"Creates 1 potion every 10 min, up to 24 daily."},
		{"id":"potion_power", "branch":"alchemy", "position":Vector2(296, 621), "size":Vector2(54, 54), "max_rank":5, "base_cost":2, "cost_growth":0, "min_level":14, "requires":[{"id":"alchemy_root","rank":3}], "title_es":"Esencia concentrada", "title_en":"Concentrated Essence", "desc_es":"+12% de curación de pociones por rango.", "desc_en":"+12% potion healing per rank."},
		{"id":"potion_flat", "branch":"alchemy", "position":Vector2(322, 722), "size":Vector2(54, 54), "max_rank":5, "base_cost":2, "cost_growth":0, "min_level":18, "requires":[{"id":"potion","rank":1}], "title_es":"Frasco abundante", "title_en":"Abundant Flask", "desc_es":"Las pociones curan 8 puntos adicionales por rango.", "desc_en":"Potions heal 8 additional points per rank."},
		{"id":"recovery", "branch":"alchemy", "position":Vector2(420, 797), "size":Vector2(54, 54), "max_rank":4, "base_cost":2, "cost_growth":1, "min_level":22, "requires":[{"id":"potion_flat","rank":2}], "title_es":"Recuperación del camino", "title_en":"Wayside Recovery", "desc_es":"Recuperas 4 de vida adicional al vencer por rango.", "desc_en":"Recover 4 additional health on victory per rank."},
		{"id":"alchemy_mastery", "branch":"alchemy", "position":Vector2(528, 739), "size":Vector2(58, 58), "max_rank":1, "base_cost":6, "cost_growth":0, "min_level":36, "requires":[{"id":"potion_power","rank":3},{"id":"potion_flat","rank":3},{"id":"recovery","rank":2}], "title_es":"Gran alquimista", "title_en":"Grand Alchemist", "desc_es":"+25% potencia de pociones y +20 de curación fija.", "desc_en":"+25% potion power and +20 flat healing."},

		{"id":"unlock_1", "branch":"legacy", "position":Vector2(690, 760), "size":Vector2(78, 78), "max_rank":1, "base_cost":4, "cost_growth":0, "min_level":10, "requires":[{"id":"core","rank":1}], "title_es":"Compañero de juramento", "title_en":"Oath Companion", "desc_es":"Obtienes 1 ficha para desbloquear el personaje que elijas.", "desc_en":"Gain 1 token to unlock a character of your choice."},
		{"id":"unlock_2", "branch":"legacy", "position":Vector2(620, 844), "size":Vector2(54, 54), "max_rank":1, "base_cost":6, "cost_growth":0, "min_level":25, "requires":[{"id":"unlock_1","rank":1}], "title_es":"Trinidad de campeones", "title_en":"Trinity of Champions", "desc_es":"Obtienes otra ficha y podrás utilizar los 3 personajes.", "desc_en":"Gain another token and use all 3 characters."},
		{"id":"shared_training", "branch":"legacy", "position":Vector2(790, 844), "size":Vector2(54, 54), "max_rank":5, "base_cost":2, "cost_growth":0, "min_level":15, "requires":[{"id":"unlock_1","rank":1}], "title_es":"Entrenamiento compartido", "title_en":"Shared Training", "desc_es":"+3% de experiencia por rango.", "desc_en":"+3% experience per rank."},
		{"id":"legacy_power", "branch":"legacy", "position":Vector2(575, 908), "size":Vector2(54, 54), "max_rank":4, "base_cost":3, "cost_growth":1, "min_level":28, "requires":[{"id":"unlock_2","rank":1},{"id":"shared_training","rank":2}], "title_es":"Vínculo de campeones", "title_en":"Champions' Bond", "desc_es":"+2% de vida y daño, y +2 defensa por rango.", "desc_en":"+2% health and damage, and +2 defense per rank."},
		{"id":"trinity_bonus", "branch":"legacy", "position":Vector2(692, 939), "size":Vector2(58, 58), "max_rank":1, "base_cost":6, "cost_growth":0, "min_level":35, "requires":[{"id":"legacy_power","rank":3}], "title_es":"Poder de la trinidad", "title_en":"Power of the Trinity", "desc_es":"+6% vida, +6% daño, +5% crítico y +8 defensa.", "desc_en":"+6% health, +6% damage, +5% critical chance and +8 defense."},
		{"id":"paladin_active", "branch":"defense", "position":Vector2(806, 365), "size":Vector2(58, 58), "max_rank":3, "base_cost":2, "cost_growth":2, "min_level":6, "requires":[{"id":"core","rank":1}], "title_es":"Artes activas del Paladín", "title_en":"Paladin Active Arts", "desc_es":"Cada rango desbloquea una habilidad activa de Luz para equipar en el inventario.", "desc_en":"Each rank unlocks one Light active skill to equip in the inventory."},
		{"id":"paladin_passive", "branch":"defense", "position":Vector2(872, 518), "size":Vector2(54, 54), "max_rank":3, "base_cost":2, "cost_growth":2, "min_level":8, "requires":[{"id":"paladin_active","rank":1}], "title_es":"Juramentos pasivos", "title_en":"Passive Oaths", "desc_es":"Desbloquea Luz, vampirismo y resistencia para el Paladín.", "desc_en":"Unlocks Light, vampirism and resistance passives for the Paladin."},
		{"id":"archer_active", "branch":"offense", "position":Vector2(610, 390), "size":Vector2(58, 58), "max_rank":3, "base_cost":2, "cost_growth":2, "min_level":10, "requires":[{"id":"unlock_1","rank":1}], "title_es":"Técnicas activas del Arquero", "title_en":"Archer Active Techniques", "desc_es":"Desbloquea Flecha Hemorrágica, Salva Tóxica y Lluvia de Tormenta.", "desc_en":"Unlocks Hemorrhaging Arrow, Toxic Volley and Storm Rain."},
		{"id":"archer_passive", "branch":"fortune", "position":Vector2(520, 518), "size":Vector2(54, 54), "max_rank":3, "base_cost":2, "cost_growth":2, "min_level":12, "requires":[{"id":"archer_active","rank":1}], "title_es":"Instintos pasivos", "title_en":"Passive Instincts", "desc_es":"Potencia sangrado, veneno y golpes de ejecución del Arquero.", "desc_en":"Empowers bleeding, poison and execution strikes for the Archer."},
		{"id":"arcanist_active", "branch":"alchemy", "position":Vector2(607, 592), "size":Vector2(58, 58), "max_rank":3, "base_cost":3, "cost_growth":2, "min_level":20, "requires":[{"id":"unlock_2","rank":1}], "title_es":"Conjuros activos del Arcanista", "title_en":"Arcanist Active Spells", "desc_es":"Desbloquea Orbe Vampírico, Nova Arcana y Colapso Estelar.", "desc_en":"Unlocks Vampiric Orb, Arcane Nova and Stellar Collapse."},
		{"id":"arcanist_passive", "branch":"progression", "position":Vector2(824, 592), "size":Vector2(54, 54), "max_rank":3, "base_cost":3, "cost_growth":2, "min_level":22, "requires":[{"id":"arcanist_active","rank":1}], "title_es":"Misterios pasivos", "title_en":"Passive Mysteries", "desc_es":"Desbloquea vampirismo arcano, eco místico y barrera astral.", "desc_en":"Unlocks arcane vampirism, mystic echo and astral barrier."},

		{"id":"mastery", "branch":"legacy", "position":Vector2(835, 905), "size":Vector2(58, 58), "max_rank":3, "base_cost":4, "cost_growth":1, "min_level":40, "requires":[{"id":"trinity_bonus","rank":1},{"id":"war_mastery","rank":1},{"id":"guardian_mastery","rank":1}], "title_es":"Maestría del juramento", "title_en":"Oath Mastery", "desc_es":"+3% vida, daño, oro y EXP; +3 defensa por rango.", "desc_en":"+3% health, damage, gold and XP; +3 defense per rank."}
	]

	skill_definitions_by_id.clear()
	for definition in skill_definitions:
		skill_definitions_by_id[str(definition.get("id", ""))] = definition

func _purchase_skill(skill_id: String) -> void:
	var definition: Dictionary = skill_definitions_by_id.get(skill_id, {})
	if definition.is_empty():
		return

	var current_rank := int(skill_ranks.get(skill_id, 0))
	var max_rank := int(definition.get("max_rank", 1))
	if current_rank >= max_rank:
		return

	var player_level := _get_player_level()
	var min_level := int(definition.get("min_level", 1))
	if player_level < min_level:
		_set_status(_text("requires_level") % min_level, Color("#FF9B86"))
		return

	var missing_requirement := _first_missing_requirement(definition)
	if not missing_requirement.is_empty():
		var required_definition: Dictionary = skill_definitions_by_id.get(str(missing_requirement.get("id", "")), {})
		_set_status(_text("requires_skill") % [_skill_title(required_definition), int(missing_requirement.get("rank", 1))], Color("#FF9B86"))
		return

	var cost := _next_rank_cost(definition, current_rank)
	if _get_available_points() < cost:
		_set_status(_text("not_enough"), Color("#FF9B86"))
		return

	skill_ranks[skill_id] = current_rank + 1
	if skill_id == "unlock_1" or skill_id == "unlock_2":
		character_tokens += 1
		character_tokens_changed.emit(character_tokens)

	current_effects = _calculate_effects()
	_save_progress()
	_refresh_all()
	_notify_main_effects()
	_notify_inventory_character_progress()
	_set_status(_text("purchased") % _skill_title(definition), Color("#7EF2B8"))

func _first_missing_requirement(definition: Dictionary) -> Dictionary:
	var requirements: Array = definition.get("requires", [])
	for requirement_variant in requirements:
		if not (requirement_variant is Dictionary):
			continue
		var requirement: Dictionary = requirement_variant
		var required_rank := int(requirement.get("rank", 1))
		if int(skill_ranks.get(str(requirement.get("id", "")), 0)) < required_rank:
			return requirement
	return {}

func _next_rank_cost(definition: Dictionary, current_rank: int) -> int:
	return maxi(0, int(definition.get("base_cost", 1)) + int(definition.get("cost_growth", 0)) * current_rank)

func _get_total_spent_points() -> int:
	var total := 0
	for definition in skill_definitions:
		var skill_id := str(definition.get("id", ""))
		var rank := int(skill_ranks.get(skill_id, 0))
		for previous_rank in range(rank):
			total += _next_rank_cost(definition, previous_rank)
	return total

func _get_total_points() -> int:
	return maxi(0, _get_player_level() + extra_skill_points)

func _get_available_points() -> int:
	return maxi(0, _get_total_points() - _get_total_spent_points())

func _get_player_level() -> int:
	if is_instance_valid(main_controller):
		var value: Variant = main_controller.get("player_level")
		if value is int or value is float:
			return maxi(1, int(value))
	var config := ConfigFile.new()
	if config.load(CHARACTER_SAVE_PATH) == OK:
		return maxi(1, int(config.get_value("jugador", "nivel", 1)))
	return 1

func _calculate_effects() -> Dictionary:
	var effects := {
		"damage_percent": 0.0,
		"health_percent": 0.0,
		"defense_flat": 0,
		"speed_flat": 0,
		"critical_chance": 0.0,
		"critical_damage_percent": 50.0,
		"damage_reduction_percent": 0.0,
		"gold_percent": 0.0,
		"xp_percent": 0.0,
		"loot_luck_percent": 0.0,
		"potion_generator": false,
		"potion_power_percent": 0.0,
		"potion_heal_flat": 0,
		"dodge_chance": 0.0,
		"block_chance": 0.0,
		"lifesteal_percent": 0.0,
		"execution_damage_percent": 0.0,
		"heal_on_kill": 0,
		"shield_on_kill": 0,
		"low_health_reduction_percent": 0.0
	}

	var mastery := int(skill_ranks.get("mastery", 0))
	var legacy_power := int(skill_ranks.get("legacy_power", 0))
	var trinity_bonus := int(skill_ranks.get("trinity_bonus", 0))
	var war_mastery := int(skill_ranks.get("war_mastery", 0))
	var guardian_mastery := int(skill_ranks.get("guardian_mastery", 0))
	var fortune_mastery := int(skill_ranks.get("fortune_mastery", 0))
	var alchemy_mastery := int(skill_ranks.get("alchemy_mastery", 0))

	effects["damage_percent"] = float(
		int(skill_ranks.get("damage", 0)) * 4
		+ int(skill_ranks.get("armor_break", 0)) * 3
		+ legacy_power * 2
		+ trinity_bonus * 6
		+ war_mastery * 12
		+ mastery * 3
	)
	effects["health_percent"] = float(
		int(skill_ranks.get("vitality", 0)) * 5
		+ legacy_power * 2
		+ trinity_bonus * 6
		+ guardian_mastery * 10
		+ mastery * 3
	)
	effects["defense_flat"] = (
		int(skill_ranks.get("defense", 0)) * 6
		+ legacy_power * 2
		+ trinity_bonus * 8
		+ guardian_mastery * 12
		+ mastery * 3
	)
	effects["speed_flat"] = int(skill_ranks.get("speed", 0)) * 5 + war_mastery * 10
	effects["critical_chance"] = float(int(skill_ranks.get("crit", 0)) * 2 + war_mastery * 5 + trinity_bonus * 5)
	effects["critical_damage_percent"] = 50.0 + float(int(skill_ranks.get("crit_damage", 0)) * 15)
	effects["damage_reduction_percent"] = float(int(skill_ranks.get("resistance", 0)) * 3 + guardian_mastery * 5)
	effects["dodge_chance"] = float(int(skill_ranks.get("dodge", 0))) * 1.5
	effects["block_chance"] = float(int(skill_ranks.get("block", 0)) * 3)
	effects["lifesteal_percent"] = float(int(skill_ranks.get("lifesteal", 0)))
	effects["execution_damage_percent"] = float(int(skill_ranks.get("execution", 0)) * 10)
	effects["heal_on_kill"] = int(skill_ranks.get("heal_kill", 0)) * 6 + int(skill_ranks.get("recovery", 0)) * 4
	effects["shield_on_kill"] = int(skill_ranks.get("shield_kill", 0)) * 10
	effects["low_health_reduction_percent"] = float(int(skill_ranks.get("last_stand", 0)) * 5)

	var fortune_rank := int(skill_ranks.get("fortune", 0))
	effects["gold_percent"] = float(
		fortune_rank
		+ int(skill_ranks.get("gold", 0)) * 6
		+ int(skill_ranks.get("treasure", 0)) * 4
		+ fortune_mastery * 15
		+ mastery * 3
	)
	effects["xp_percent"] = float(
		fortune_rank
		+ int(skill_ranks.get("xp", 0)) * 6
		+ int(skill_ranks.get("relic", 0)) * 3
		+ int(skill_ranks.get("shared_training", 0)) * 3
		+ fortune_mastery * 15
		+ mastery * 3
	)
	effects["loot_luck_percent"] = float(
		int(skill_ranks.get("loot", 0)) * 4
		+ int(skill_ranks.get("treasure", 0)) * 3
		+ int(skill_ranks.get("relic", 0)) * 6
		+ fortune_mastery * 12
	)
	effects["potion_generator"] = int(skill_ranks.get("potion", 0)) > 0
	effects["potion_power_percent"] = float(
		int(skill_ranks.get("alchemy_root", 0)) * 5
		+ int(skill_ranks.get("potion_power", 0)) * 12
		+ alchemy_mastery * 25
	)
	effects["potion_heal_flat"] = int(skill_ranks.get("potion_flat", 0)) * 8 + alchemy_mastery * 20
	return effects

func get_skill_ranks() -> Dictionary:
	return skill_ranks.duplicate(true)

func get_unlocked_equipable_skills(hero_id: String) -> Array[String]:
	return SistemaHabilidadesEquipables.habilidades_desbloqueadas(skill_ranks, hero_id)

func add_extra_skill_points(amount: int) -> void:
	if amount <= 0:
		return
	extra_skill_points += amount
	_save_progress()
	_refresh_all()

func get_extra_skill_points() -> int:
	return extra_skill_points

func get_skill_effects() -> Dictionary:
	return current_effects.duplicate(true)

func get_character_tokens() -> int:
	_reload_character_tokens_only()
	return character_tokens

func refresh_character_state() -> void:
	_reload_character_tokens_only()
	_refresh_header_only()

func notify_player_level_changed() -> void:
	_refresh_all()

func _notify_main_effects() -> void:
	skills_changed.emit(current_effects.duplicate(true))
	if is_instance_valid(main_controller):
		if main_controller.has_method("_refresh_skill_tree_effects"):
			main_controller.call_deferred("_refresh_skill_tree_effects")
		elif main_controller.has_method("_apply_inventory_equipment_effects"):
			main_controller.call_deferred("_apply_inventory_equipment_effects")

func _notify_inventory_character_progress() -> void:
	_refresh_references()
	if is_instance_valid(inventory_ui) and inventory_ui.has_method("refresh_character_roster_from_skills"):
		inventory_ui.call_deferred("refresh_character_roster_from_skills")

func _refresh_all() -> void:
	current_effects = _calculate_effects()
	_refresh_header_only()
	for definition in skill_definitions:
		_refresh_skill_button(definition)
	_refresh_selected_panel()
	_refresh_summary()
	_refresh_language()

func _refresh_header_only() -> void:
	var available := _get_available_points()
	var spent := _get_total_spent_points()
	var level := _get_player_level()
	if is_instance_valid(points_label):
		points_label.text = "%s\n%d" % [_text("points").split(":")[0], available]
	if is_instance_valid(level_label):
		level_label.text = _text("level") % level
	if is_instance_valid(tree_level_label):
		tree_level_label.text = "%s\n%d  •  %s" % [_text("tree_level"), level, _text("spent_points") % spent]
	if is_instance_valid(character_tokens_label):
		character_tokens_label.text = _text("characters") % character_tokens
	if is_instance_valid(potion_counter_label):
		potion_counter_label.text = _text("potion_counter") % [potions_today, maximum_daily_potions]
	if is_instance_valid(top_stats_label):
		top_stats_label.text = "%s %d  |  EXP %d/%d  |  %s %d" % [_text("top_level"), _main_number("player_level", level), _main_number("player_xp", 0), _main_number("player_xp_required", 0), _text("top_gold"), _main_number("player_gold", 0)]
	if is_instance_valid(top_phase_label):
		var zone_id: String = SistemaRegiones.ZONA_VALDORIA
		var phase_count: int = SistemaRegiones.obtener_fases(zone_id)
		if is_instance_valid(main_controller):
			if main_controller.has_method("get_current_zone_id"):
				zone_id = SistemaRegiones.normalizar_zona(
					str(main_controller.call("get_current_zone_id"))
				)
			phase_count = SistemaRegiones.obtener_fases(zone_id)
		top_phase_label.text = "%s %s · %d / %d" % [
			_text("top_phase"),
			zone_id,
			_main_number("current_phase", 1),
			phase_count
		]

func _main_number(property_name: String, fallback: int) -> int:
	if is_instance_valid(main_controller):
		var value: Variant = main_controller.get(property_name)
		if value is int or value is float:
			return int(value)
	return fallback

func _refresh_skill_button(definition: Dictionary) -> void:
	var skill_id := str(definition.get("id", ""))
	var button: Button = skill_buttons.get(skill_id) as Button
	if button == null:
		return

	var rank := int(skill_ranks.get(skill_id, 0))
	var max_rank := int(definition.get("max_rank", 1))
	var min_level := int(definition.get("min_level", 1))
	var cost := _next_rank_cost(definition, rank)
	var maxed := rank >= max_rank
	var requirements_met := _first_missing_requirement(definition).is_empty()
	var level_met := _get_player_level() >= min_level
	var affordable := _get_available_points() >= cost
	var selected := selected_skill_id == skill_id

	button.tooltip_text = "%s\n%s\n%s\n%s" % [_skill_title(definition), _text("rank") % [rank, max_rank], _skill_description(definition), _text("maxed") if maxed else _text("cost") % cost]
	button.disabled = false

	var branch := str(definition.get("branch", "core"))
	var accent := _branch_color(branch)
	var border := Color(accent.r, accent.g, accent.b, 0.10)
	var fill := Color(0, 0, 0, 0.02)
	var width := 1
	if maxed:
		border = Color("#FFF0A0")
		fill = Color(accent.r, accent.g, accent.b, 0.10)
		width = 3
	elif selected:
		var selection_pulse: float = 0.72 + 0.28 * ((sin(astral_time * 3.2) + 1.0) * 0.5)
		border = Color(1.0, 1.0, 1.0, selection_pulse)
		fill = Color(accent.r, accent.g, accent.b, 0.16)
		width = 3
	elif not requirements_met or not level_met:
		border = Color(0.25, 0.25, 0.27, 0.42)
		fill = Color(0, 0, 0, 0.18)
	elif not affordable:
		border = Color(0.55, 0.45, 0.25, 0.40)

	var radius := int(minf(button.size.x, button.size.y) * 0.5)
	button.add_theme_stylebox_override("normal", _make_style(fill, border, width, radius))
	button.add_theme_stylebox_override("hover", _make_style(Color(accent.r, accent.g, accent.b, 0.14), accent, 3, radius, Color(accent.r, accent.g, accent.b, 0.28), 10))
	button.add_theme_stylebox_override("pressed", _make_style(Color(accent.r, accent.g, accent.b, 0.20), Color("#FFF0A0"), 3, radius))

	var badge: Label = skill_rank_labels.get(skill_id) as Label
	if badge != null:
		badge.text = "%d/%d" % [rank, max_rank]
		badge.visible = rank > 0 or selected

	var caption: Label = skill_name_labels.get(skill_id) as Label
	if is_instance_valid(caption):
		caption.text = "%s\n%d/%d" % [_skill_title(definition), rank, max_rank]
		caption.add_theme_color_override(
			"font_color",
			Color("#FFF0A0") if maxed else Color("#F1E8DC")
		)
	var caption_panel: Panel = skill_name_panels.get(skill_id) as Panel
	if is_instance_valid(caption_panel):
		caption_panel.modulate.a = 1.0 if requirements_met and level_met else 0.56

func _select_skill(skill_id: String) -> void:
	if not skill_definitions_by_id.has(skill_id):
		return
	selected_skill_id = skill_id
	_refresh_all()

func _purchase_selected_skill() -> void:
	if selected_skill_id.is_empty():
		return
	_purchase_skill(selected_skill_id)

func _refresh_selected_panel() -> void:
	var definition: Dictionary = skill_definitions_by_id.get(selected_skill_id, {})
	if definition.is_empty():
		return
	var rank := int(skill_ranks.get(selected_skill_id, 0))
	var max_rank := int(definition.get("max_rank", 1))
	var cost := _next_rank_cost(definition, rank)
	var maxed := rank >= max_rank
	var missing := _first_missing_requirement(definition)
	var level_met := _get_player_level() >= int(definition.get("min_level", 1))

	selected_title_label.text = _skill_title(definition).to_upper()
	selected_rank_label.text = "(%s)" % (_text("rank") % [rank, max_rank])
	selected_description_label.text = _skill_description(definition)
	selected_current_label.text = "%s\n• %s" % [_text("selected_current"), _text("no_active_bonus") if rank <= 0 else "%s × %d" % [_skill_description(definition), rank]]
	selected_next_label.text = "%s\n• %s" % [_text("selected_next"), _text("maxed") if maxed else _skill_description(definition)]

	var requirement_text := ""
	if maxed:
		requirement_text = _text("maxed")
	elif not level_met:
		requirement_text = _text("requires_level") % int(definition.get("min_level", 1))
	elif not missing.is_empty():
		var parent_definition: Dictionary = skill_definitions_by_id.get(str(missing.get("id", "")), {})
		requirement_text = _text("requires_skill") % [_skill_title(parent_definition), int(missing.get("rank", 1))]
	else:
		requirement_text = _text("requires_points") % cost
	selected_requirement_label.text = requirement_text
	unlock_button.text = "%s   ◆ %d" % [_text("unlock"), cost]
	unlock_button.disabled = maxed or not level_met or not missing.is_empty() or _get_available_points() < cost or bool(definition.get("auto_unlocked", false))

func _refresh_summary() -> void:
	if not is_instance_valid(bonus_summary_label):
		return
	var effects := current_effects
	if current_language == "en":
		bonus_summary_label.text = (
			"ATK  Attack damage       +%.0f%%\n" % float(effects.get("damage_percent", 0.0))
			+ "DEF  Defense               +%d\n" % int(effects.get("defense_flat", 0))
			+ "HP   Maximum health  +%.0f%%\n" % float(effects.get("health_percent", 0.0))
			+ "GLD  Gold found          +%.0f%%\n" % float(effects.get("gold_percent", 0.0))
			+ "EXP  Experience          +%.0f%%\n" % float(effects.get("xp_percent", 0.0))
			+ "CRT  Critical chance   +%.1f%%\n" % float(effects.get("critical_chance", 0.0))
			+ "SPD  Attack speed       +%d" % int(effects.get("speed_flat", 0))
		)
	else:
		bonus_summary_label.text = (
			"ATQ  Daño de ataque       +%.0f%%\n" % float(effects.get("damage_percent", 0.0))
			+ "DEF  Defensa                  +%d\n" % int(effects.get("defense_flat", 0))
			+ "VID  Vida máxima          +%.0f%%\n" % float(effects.get("health_percent", 0.0))
			+ "ORO  Oro encontrado     +%.0f%%\n" % float(effects.get("gold_percent", 0.0))
			+ "EXP  EXP obtenida          +%.0f%%\n" % float(effects.get("xp_percent", 0.0))
			+ "CRT  Prob. crítico           +%.1f%%\n" % float(effects.get("critical_chance", 0.0))
			+ "VEL  Vel. de ataque       +%d" % int(effects.get("speed_flat", 0))
		)
	if is_instance_valid(legend_label):
		legend_label.text = "%s\n\n◆ %s\n◆ %s\n◆ %s\n◆ %s\n◆ %s\n◆ %s" % [
			_text("legend"), _text("legend_offense"), _text("legend_defense"),
			_text("legend_fortune"), _text("legend_alchemy"),
			_text("legend_progression"), _text("legend_champions")
		]

func _reset_skill_tree() -> void:
	if _get_total_spent_points() <= 0:
		return
	var gold := _main_number("player_gold", 0)
	if gold < RESET_COST:
		_set_status(_text("reset_gold") % RESET_COST, Color("#FF8F82"))
		return
	if is_instance_valid(main_controller):
		main_controller.set("player_gold", gold - RESET_COST)
		if main_controller.has_method("_save_progress"):
			main_controller.call("_save_progress")
	for definition in skill_definitions:
		var skill_id := str(definition.get("id", ""))
		skill_ranks[skill_id] = 1 if skill_id == "core" else 0
	character_tokens = 0
	current_effects = _calculate_effects()
	_save_progress()
	_refresh_all()
	_notify_main_effects()
	_notify_inventory_character_progress()
	_set_status(_text("reset_done"), Color("#7EF2B8"))

func _skill_title(definition: Dictionary) -> String:
	return str(definition.get("title_en" if current_language == "en" else "title_es", definition.get("id", "")))

func _skill_description(definition: Dictionary) -> String:
	return str(definition.get("desc_en" if current_language == "en" else "desc_es", ""))

func _branch_color(branch: String) -> Color:
	match branch:
		"core": return Color("#F5D674")
		"offense": return Color("#E96D55")
		"defense": return Color("#63AFFF")
		"fortune": return Color("#66E27D")
		"alchemy": return Color("#D278F0")
		"progression": return Color("#F5B82E")
		"legacy": return Color("#55DCE2")
		_: return Color("#D3A83C")

func _refresh_language() -> void:
	if is_instance_valid(skill_window):
		skill_window.title = _text("window_title")
	if is_instance_valid(top_button):
		top_button.tooltip_text = _text("open_tree")
	if is_instance_valid(title_label):
		title_label.text = _text("title")
	if is_instance_valid(subtitle_label):
		subtitle_label.text = _text("subtitle")
	if is_instance_valid(close_button):
		close_button.tooltip_text = _text("close")
	if is_instance_valid(footer_label):
		footer_label.text = _text("footer")
	for text_key in branch_title_labels.keys():
		var entry: Dictionary = branch_title_labels[text_key]
		var branch_label: Label = entry.get("label") as Label
		var description_key: String = str(entry.get("description_key", ""))
		if is_instance_valid(branch_label):
			branch_label.text = "%s\n%s" % [_text(str(text_key)), _text(description_key)]
	for definition in skill_definitions:
		var skill_id: String = str(definition.get("id", ""))
		var caption: Label = skill_name_labels.get(skill_id) as Label
		if is_instance_valid(caption):
			var rank: int = int(skill_ranks.get(skill_id, 0))
			var max_rank: int = int(definition.get("max_rank", 1))
			caption.text = "%s\n%d/%d" % [_skill_title(definition), rank, max_rank]

func _set_status(message: String, color: Color = Color("#D8D0C3")) -> void:
	if not is_instance_valid(status_label):
		return
	status_label.text = message
	status_label.add_theme_color_override("font_color", color)

func _process_potion_generator() -> void:
	current_effects = _calculate_effects()
	if not bool(current_effects.get("potion_generator", false)):
		return

	_refresh_daily_potion_counter()
	if potions_today >= maximum_daily_potions:
		return

	var now := int(Time.get_unix_time_from_system())
	if last_potion_unix <= 0:
		last_potion_unix = now
		_save_progress()
		return

	var elapsed := now - last_potion_unix
	if elapsed < int(potion_interval_seconds):
		return

	_refresh_references()
	if not is_instance_valid(inventory_ui) or not inventory_ui.has_method("add_item"):
		return

	var due_count := mini(int(floor(float(elapsed) / maxf(potion_interval_seconds, 1.0))), maximum_daily_potions - potions_today)
	for _index in range(due_count):
		var potion := _create_generated_potion()
		var added := bool(inventory_ui.call("add_item", potion))
		if not added:
			break
		potions_today += 1
		last_potion_unix += int(potion_interval_seconds)
		potion_generated.emit(potion.duplicate(true))
		_set_status(_text("potion_ready"), Color("#78D8FF"))

	_save_progress()
	_refresh_header_only()

func _create_generated_potion() -> Dictionary:
	return {
		"id": "pocion_vigor",
		"name": "Poción de Vigor",
		"name_en": "Vigor Potion",
		"description": "Devuelve fuerzas al viajero.",
		"description_en": "Restores strength to the traveler.",
		"rarity": "poco_comun",
		"rareza": "poco_comun",
		"category": "objetos",
		"equip_slot": "",
		"stackable": true,
		"consumable": true,
		"quantity": 1,
		"item_level": maxi(1, _get_player_level()),
		"effect": {"heal": 45},
		"stats": {},
		"icon_path": ""
	}

func _refresh_daily_potion_counter() -> void:
	var date := Time.get_date_dict_from_system()
	var new_key := "%04d-%02d-%02d" % [int(date.get("year", 0)), int(date.get("month", 0)), int(date.get("day", 0))]
	if potion_day_key != new_key:
		potion_day_key = new_key
		potions_today = 0
		last_potion_unix = int(Time.get_unix_time_from_system())
		_save_progress()

func _load_progress() -> void:
	skill_ranks.clear()
	for definition in skill_definitions:
		skill_ranks[str(definition.get("id", ""))] = 0

	var config := ConfigFile.new()
	if config.load(SKILL_SAVE_PATH) == OK:
		var ranks_variant: Variant = config.get_value("habilidades", "rangos", {})
		if ranks_variant is Dictionary:
			var loaded_ranks: Dictionary = ranks_variant
			for skill_id in loaded_ranks.keys():
				if skill_definitions_by_id.has(str(skill_id)):
					skill_ranks[str(skill_id)] = maxi(0, int(loaded_ranks[skill_id]))
		extra_skill_points = maxi(0, int(config.get_value("habilidades", "puntos_extra", 0)))
		character_tokens = maxi(0, int(config.get_value("personajes", "fichas", 0)))
		potion_day_key = str(config.get_value("pociones", "dia", ""))
		potions_today = maxi(0, int(config.get_value("pociones", "cantidad_hoy", 0)))
		last_potion_unix = maxi(0, int(config.get_value("pociones", "ultimo_unix", 0)))

	if skill_ranks.has("core"):
		skill_ranks["core"] = 1

	current_effects = _calculate_effects()
	_refresh_daily_potion_counter()

func _reload_character_tokens_only() -> void:
	var config := ConfigFile.new()
	if config.load(SKILL_SAVE_PATH) == OK:
		character_tokens = maxi(0, int(config.get_value("personajes", "fichas", character_tokens)))

func _save_progress() -> void:
	var config := ConfigFile.new()
	config.load(SKILL_SAVE_PATH)
	config.set_value("habilidades", "rangos", skill_ranks)
	config.set_value("habilidades", "puntos_extra", extra_skill_points)
	config.set_value("habilidades", "efectos", current_effects)
	config.set_value("personajes", "fichas", character_tokens)
	config.set_value("pociones", "dia", potion_day_key)
	config.set_value("pociones", "cantidad_hoy", potions_today)
	config.set_value("pociones", "ultimo_unix", last_potion_unix)
	var error := config.save(SKILL_SAVE_PATH)
	if error != OK:
		push_warning("No se pudo guardar el árbol de habilidades.")

func _make_style(
	background_color: Color,
	border_color: Color,
	border_width: int,
	radius: int,
	shadow_color: Color = Color(0, 0, 0, 0),
	shadow_size: int = 0
) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = background_color
	style.border_color = border_color
	style.set_border_width_all(border_width)
	style.corner_radius_top_left = radius
	style.corner_radius_top_right = radius
	style.corner_radius_bottom_left = radius
	style.corner_radius_bottom_right = radius
	style.shadow_color = shadow_color
	style.shadow_size = shadow_size
	return style

func _create_label(
	parent: Control,
	label_text: String,
	label_position: Vector2,
	label_size: Vector2,
	font_size: int,
	alignment: HorizontalAlignment,
	font_color: Color
) -> Label:
	var label := Label.new()
	label.text = label_text
	label.position = label_position
	label.size = label_size
	label.horizontal_alignment = alignment
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", font_color)
	label.add_theme_color_override("font_outline_color", Color(0.0, 0.0, 0.0, 0.94))
	label.add_theme_constant_override("outline_size", 2)
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	label.z_index = TEXT_Z_INDEX
	parent.add_child(label)
	return label
