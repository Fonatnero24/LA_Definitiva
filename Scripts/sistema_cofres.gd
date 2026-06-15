extends Node
class_name SistemaCofres

signal cofre_aparecido
signal objeto_obtenido(item_data: Dictionary)
signal inventario_lleno(item_data: Dictionary)

@export_group("Tiempo")
@export_range(5.0, 3600.0, 1.0) var intervalo_cofre_segundos: float = 120.0
@export_range(0.0, 3600.0, 1.0) var retraso_primer_cofre_segundos: float = 120.0
@export_range(0.0, 300.0, 1.0) var duracion_cofre_segundos: float = 45.0
@export_range(1.0, 30.0, 1.0) var reintento_sin_enemigo_segundos: float = 4.0

@export_group("Integración")
@export var inventory_node_path: NodePath = NodePath("../InventarioUI")
@export var mostrar_mensaje_recompensa: bool = true
@export var imprimir_estado_en_salida: bool = true
@export_range(0.0, 100.0, 0.5) var probabilidad_recogida_automatica: float = 20.0
@export var sumar_suerte_a_recogida_automatica: bool = true

const CHEST_SIZE := Vector2(88.0, 42.0)
const TOAST_SIZE := Vector2(360.0, 80.0)

const TRANSLATIONS: Dictionary = {
	"es": {
		"chest": "COFRE",
		"open_chest": "Abrir cofre de recompensa",
		"inventory_missing": "NO SE ENCONTRÓ EL INVENTARIO",
		"inventory_method_missing": "INVENTARIO SIN add_item()",
		"inventory_full": "INVENTARIO LLENO",
		"level": "NIVEL",
		"common": "COMÚN",
		"uncommon": "POCO COMÚN",
		"rare": "RARO",
		"epic": "ÉPICO",
		"legendary": "LEGENDARIO",
		"mythic": "MÍTICO",
		"ancestral": "ANCESTRAL",
		"unique": "ÚNICO",
		"item": "Objeto",
		"region": "Territorio",
		"auto_collected": "RECOGIDO AUTOMÁTICAMENTE"
	},
	"en": {
		"chest": "CHEST",
		"open_chest": "Open reward chest",
		"inventory_missing": "INVENTORY NOT FOUND",
		"inventory_method_missing": "INVENTORY HAS NO add_item()",
		"inventory_full": "INVENTORY FULL",
		"level": "LEVEL",
		"common": "COMMON",
		"uncommon": "UNCOMMON",
		"rare": "RARE",
		"epic": "EPIC",
		"legendary": "LEGENDARY",
		"mythic": "MYTHIC",
		"ancestral": "ANCESTRAL",
		"unique": "UNIQUE",
		"item": "Item",
		"region": "Region",
		"auto_collected": "AUTO-COLLECTED"
	}
}

var main_controller: Node
var inventory_ui: Node
var interface_root: Control
var enemy_visual: Control

var spawn_timer: Timer
var lifetime_timer: Timer
var active_chest: Button
var chest_tween: Tween
var reward_toast: Panel
var reward_tween: Tween
var pending_item: Dictionary = {}
var initialized: bool = false
var current_language: String = "es"
var game_ui: Node
var reference_refresh_accumulator: float = 0.0

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	set_process(true)
	_connect_game_ui()
	_load_language()
	call_deferred("_initialize_system")

func _process(delta: float) -> void:
	if not initialized:
		return

	reference_refresh_accumulator += delta
	if reference_refresh_accumulator >= 0.50:
		reference_refresh_accumulator = 0.0
		_refresh_references()

	var can_show_rewards: bool = not _blocking_overlay_is_open()

	if is_instance_valid(active_chest):
		active_chest.visible = can_show_rewards

		if can_show_rewards:
			_update_chest_position()

	if is_instance_valid(reward_toast):
		reward_toast.visible = can_show_rewards

func _connect_game_ui() -> void:
	game_ui = get_node_or_null("/root/GameUI")

	if not is_instance_valid(game_ui):
		return

	if game_ui.has_signal("language_changed"):
		var callback: Callable = Callable(
			self,
			"_on_global_language_changed"
		)

		if not game_ui.is_connected("language_changed", callback):
			game_ui.connect("language_changed", callback)

func _on_global_language_changed(language_code: String) -> void:
	set_language(language_code)

func _load_language() -> void:
	if is_instance_valid(game_ui):
		if game_ui.has_method("get_language"):
			set_language(str(game_ui.call("get_language")))
			return

	var config: ConfigFile = ConfigFile.new()

	if config.load("user://opciones.cfg") == OK:
		set_language(
			str(
				config.get_value(
					"general",
					"idioma",
					"es"
				)
			)
		)

func set_language(language_code: String) -> void:
	var normalized: String = language_code.to_lower().strip_edges()

	if normalized != "es" and normalized != "en":
		normalized = "es"

	current_language = normalized

	if is_instance_valid(active_chest):
		active_chest.text = "◆  " + _text("chest")
		active_chest.tooltip_text = _build_chest_tooltip()

func _text(key: String) -> String:
	var spanish: Dictionary = TRANSLATIONS.get("es", {})
	var selected: Dictionary = TRANSLATIONS.get(
		current_language,
		spanish
	)
	return str(selected.get(key, spanish.get(key, key)))

func _blocking_overlay_is_open() -> bool:
	if not is_instance_valid(main_controller):
		return false

	if main_controller.has_method("is_modal_ui_open"):
		return bool(main_controller.call("is_modal_ui_open"))

	var options_value: Variant = main_controller.get("options_open")

	if options_value is bool and bool(options_value):
		return true

	var map_node: Node = main_controller.get_node_or_null(
		"MapaMundosUI"
	)

	if is_instance_valid(map_node):
		var map_value: Variant = map_node.get("map_open")
		if map_value is bool and bool(map_value):
			return true

	return false

func _get_localized_rarity_name(item_data: Dictionary) -> String:
	var rarity_id: String = str(
		item_data.get(
			"rarity",
			item_data.get("rareza", "comun")
		)
	).to_lower().strip_edges()

	var key_by_rarity: Dictionary = {
		"comun": "common",
		"poco_comun": "uncommon",
		"raro": "rare",
		"epico": "epic",
		"legendario": "legendary",
		"mitico": "mythic",
		"ancestral": "ancestral",
		"unico": "unique"
	}

	var translation_key: String = str(
		key_by_rarity.get(rarity_id, "common")
	)
	return _text(translation_key)

func _build_chest_tooltip() -> String:
	var region_name: String = SistemaRegiones.obtener_nombre(
		_get_current_zone_id(),
		current_language,
		true
	)
	return "%s · %s · %s: %s" % [
		_text("open_chest"),
		_get_localized_rarity_name(pending_item),
		_text("region"),
		region_name
	]

func _initialize_system() -> void:
	main_controller = get_parent()

	for _attempt in range(180):
		_refresh_references()
		if (
			is_instance_valid(interface_root)
			and is_instance_valid(enemy_visual)
			and is_instance_valid(inventory_ui)
		):
			break
		await get_tree().process_frame

	_create_timers()
	initialized = true

	if imprimir_estado_en_salida:
		print(
			"SistemaCofres listo | Main: ", is_instance_valid(main_controller),
			" | Interfaz: ", is_instance_valid(interface_root),
			" | Enemigo: ", is_instance_valid(enemy_visual),
			" | Inventario: ", is_instance_valid(inventory_ui)
		)

	var first_delay: float = retraso_primer_cofre_segundos
	if first_delay <= 0.0:
		first_delay = intervalo_cofre_segundos
	_schedule_next_chest(first_delay)

func _refresh_references() -> void:
	if not is_instance_valid(main_controller):
		main_controller = get_parent()

	if is_instance_valid(main_controller):
		var root_candidate: Variant = main_controller.get("interface_root")
		if root_candidate is Control:
			interface_root = root_candidate as Control

		var enemy_candidate: Variant = main_controller.get("enemy_visual")
		if enemy_candidate is Control:
			enemy_visual = enemy_candidate as Control

	if not is_instance_valid(inventory_ui):
		if not inventory_node_path.is_empty():
			inventory_ui = get_node_or_null(inventory_node_path)

		if not is_instance_valid(inventory_ui) and is_instance_valid(main_controller):
			inventory_ui = main_controller.get_node_or_null("InventarioUI")

		if not is_instance_valid(inventory_ui):
			var current_scene: Node = get_tree().current_scene
			if current_scene != null:
				inventory_ui = current_scene.find_child("InventarioUI", true, false)
				if not is_instance_valid(inventory_ui):
					for candidate: Node in current_scene.find_children("*", "", true, false):
						if candidate.has_method("add_item") and candidate.has_method("open_inventory"):
							inventory_ui = candidate
							break

func _create_timers() -> void:
	if not is_instance_valid(spawn_timer):
		spawn_timer = Timer.new()
		spawn_timer.name = "TemporizadorCofres"
		spawn_timer.one_shot = true
		spawn_timer.process_callback = Timer.TIMER_PROCESS_IDLE
		spawn_timer.timeout.connect(_on_spawn_timer_timeout)
		add_child(spawn_timer)

	if not is_instance_valid(lifetime_timer):
		lifetime_timer = Timer.new()
		lifetime_timer.name = "DuracionCofre"
		lifetime_timer.one_shot = true
		lifetime_timer.process_callback = Timer.TIMER_PROCESS_IDLE
		lifetime_timer.timeout.connect(_on_chest_expired)
		add_child(lifetime_timer)

func _schedule_next_chest(delay_seconds: float) -> void:
	if not is_instance_valid(spawn_timer):
		return
	spawn_timer.start(maxf(0.05, delay_seconds))

func _on_spawn_timer_timeout() -> void:
	_refresh_references()

	if is_instance_valid(active_chest):
		_schedule_next_chest(intervalo_cofre_segundos)
		return

	if _can_spawn_chest():
		_spawn_chest()
		_schedule_next_chest(intervalo_cofre_segundos)
	else:
		_schedule_next_chest(reintento_sin_enemigo_segundos)

func _can_spawn_chest() -> bool:
	if is_instance_valid(active_chest):
		return false
	if not is_instance_valid(interface_root):
		return false
	if not is_instance_valid(enemy_visual):
		return false
	if not enemy_visual.visible:
		return false
	if _blocking_overlay_is_open():
		return false

	if is_instance_valid(main_controller):
		if bool(main_controller.get("world_completed")):
			return false
		if bool(main_controller.get("is_traveling")):
			return false
		if not bool(main_controller.get("combat_active")):
			return false
		if int(main_controller.get("enemy_hp")) <= 0:
			return false

	return true

func forzar_cofre() -> void:
	_refresh_references()
	if is_instance_valid(active_chest):
		return
	if _can_spawn_chest():
		_spawn_chest()

func reiniciar_temporizador() -> void:
	_remove_active_chest()
	_schedule_next_chest(intervalo_cofre_segundos)

func _spawn_chest() -> void:
	pending_item = BaseDatosObjetos.generar_objeto_aleatorio(
		_get_player_level(),
		_get_enemy_rank(),
		_get_character_id(),
		_get_loot_luck_percent(),
		_get_current_zone_id()
	)

	if pending_item.is_empty():
		push_warning("El cofre no pudo generar ningún objeto.")
		return

	var rarity_color: Color = _get_item_color(pending_item)

	var normal_background: Color = _rarity_background(
		rarity_color,
		0.48
	)
	var hover_background: Color = _rarity_background(
		rarity_color,
		0.70
	)
	var pressed_background: Color = _rarity_background(
		rarity_color,
		0.34
	)

	active_chest = Button.new()
	active_chest.name = "CofreTemporizado"
	active_chest.text = "◆  " + _text("chest")
	active_chest.tooltip_text = _build_chest_tooltip()
	active_chest.size = CHEST_SIZE
	active_chest.focus_mode = Control.FOCUS_NONE
	active_chest.mouse_filter = Control.MOUSE_FILTER_STOP
	active_chest.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	active_chest.z_as_relative = false
	active_chest.z_index = 120
	active_chest.add_theme_font_size_override("font_size", 10)
	active_chest.add_theme_color_override("font_color", Color.WHITE)
	active_chest.add_theme_color_override("font_hover_color", Color.WHITE)
	active_chest.add_theme_color_override(
		"font_pressed_color",
		Color.WHITE
	)
	active_chest.add_theme_stylebox_override(
		"normal",
		_make_style(
			normal_background,
			rarity_color,
			2,
			8,
			Color(
				rarity_color.r,
				rarity_color.g,
				rarity_color.b,
				0.24
			),
			7
		)
	)
	active_chest.add_theme_stylebox_override(
		"hover",
		_make_style(
			hover_background,
			Color.WHITE,
			2,
			8,
			Color(
				rarity_color.r,
				rarity_color.g,
				rarity_color.b,
				0.42
			),
			10
		)
	)
	active_chest.add_theme_stylebox_override(
		"pressed",
		_make_style(
			pressed_background,
			Color.WHITE,
			2,
			8
		)
	)
	active_chest.pressed.connect(_on_chest_pressed)
	interface_root.add_child(active_chest)
	active_chest.set_meta("ui_font_role", "button")

	if is_instance_valid(game_ui) and game_ui.has_method("refresh_control"):
		game_ui.call("refresh_control", active_chest)

	_update_chest_position()
	_start_chest_animation()

	if duracion_cofre_segundos > 0.0:
		lifetime_timer.start(duracion_cofre_segundos)

	if imprimir_estado_en_salida:
		print(
			"Cofre aparecido: ",
			_get_localized_rarity_name(pending_item),
			" - ",
			str(pending_item.get("name", "Objeto"))
		)

	cofre_aparecido.emit()
	call_deferred("_try_auto_collect_chest")

func _try_auto_collect_chest() -> void:
	if not is_instance_valid(active_chest) or pending_item.is_empty():
		return
	await get_tree().create_timer(0.55).timeout
	if not is_instance_valid(active_chest) or pending_item.is_empty():
		return
	var chance: float = probabilidad_recogida_automatica
	if sumar_suerte_a_recogida_automatica:
		chance += _get_loot_luck_percent() * 0.20
	chance = clampf(chance, 0.0, 85.0)
	if randf() * 100.0 > chance:
		return
	if mostrar_mensaje_recompensa:
		_show_toast(_text("auto_collected"), Color("#7EF2B8"))
	_on_chest_pressed()

func _update_chest_position() -> void:
	if not is_instance_valid(active_chest):
		return
	if not is_instance_valid(enemy_visual):
		return
	if not is_instance_valid(interface_root):
		return

	var target_x: float = (
		enemy_visual.position.x
		+ enemy_visual.size.x * 0.5
		- CHEST_SIZE.x * 0.5
	)
	var target_y: float = enemy_visual.position.y - CHEST_SIZE.y - 8.0

	active_chest.position = Vector2(
		clampf(
			target_x,
			4.0,
			maxf(
				4.0,
				interface_root.size.x - CHEST_SIZE.x - 4.0
			)
		),
		maxf(36.0, target_y)
	).round()

func _start_chest_animation() -> void:
	if not is_instance_valid(active_chest):
		return

	if chest_tween != null and chest_tween.is_valid():
		chest_tween.kill()

	active_chest.pivot_offset = active_chest.size * 0.5
	active_chest.scale = Vector2(0.70, 0.70)

	chest_tween = create_tween()
	chest_tween.set_trans(Tween.TRANS_BACK)
	chest_tween.set_ease(Tween.EASE_OUT)
	chest_tween.tween_property(active_chest, "scale", Vector2.ONE, 0.30)
	chest_tween.set_trans(Tween.TRANS_SINE)
	chest_tween.set_ease(Tween.EASE_IN_OUT)
	chest_tween.set_loops()
	chest_tween.tween_property(active_chest, "scale", Vector2(1.055, 1.055), 0.62)
	chest_tween.tween_property(active_chest, "scale", Vector2.ONE, 0.62)

func _on_chest_pressed() -> void:
	if pending_item.is_empty():
		_remove_active_chest()
		return

	_refresh_references()

	if not is_instance_valid(inventory_ui):
		_show_toast(_text("inventory_missing"), Color("#FF7878"))
		return

	if not inventory_ui.has_method("add_item"):
		_show_toast(_text("inventory_method_missing"), Color("#FF7878"))
		return

	var obtained_item: Dictionary = pending_item.duplicate(true)
	var added: bool = bool(inventory_ui.call("add_item", obtained_item))

	if not added:
		inventario_lleno.emit(obtained_item)
		_show_toast(_text("inventory_full"), Color("#FF7878"))
		return

	objeto_obtenido.emit(obtained_item)
	if is_instance_valid(main_controller) and main_controller.has_method("get_mission_system"):
		var missions: Node = main_controller.call("get_mission_system") as Node
		if is_instance_valid(missions) and missions.has_method("registrar_cofre"):
			missions.call("registrar_cofre", _get_current_zone_id())

	if mostrar_mensaje_recompensa:
		var message: String = "%s · %s %d\n%s" % [
			str(
				obtained_item.get(
					"rarity_name",
					_text("common")
				)
			),
			_text("level"),
			int(obtained_item.get("item_level", 1)),
			str(obtained_item.get("name", _text("item")))
		]
		_show_toast(message, _get_item_color(obtained_item))

	_remove_active_chest()

func _on_chest_expired() -> void:
	_remove_active_chest()

func _remove_active_chest() -> void:
	if is_instance_valid(lifetime_timer):
		lifetime_timer.stop()

	if chest_tween != null and chest_tween.is_valid():
		chest_tween.kill()

	if is_instance_valid(active_chest):
		active_chest.queue_free()

	active_chest = null
	pending_item = {}

func _show_toast(message: String, accent: Color) -> void:
	if not is_instance_valid(interface_root):
		return

	if is_instance_valid(reward_toast):
		reward_toast.queue_free()

	reward_toast = Panel.new()
	reward_toast.name = "MensajeRecompensaCofre"
	reward_toast.size = TOAST_SIZE
	reward_toast.position = Vector2(
		(interface_root.size.x - TOAST_SIZE.x) * 0.5,
		43.0
	)
	reward_toast.mouse_filter = Control.MOUSE_FILTER_IGNORE
	reward_toast.z_as_relative = false
	reward_toast.z_index = 130
	reward_toast.modulate.a = 0.0
	reward_toast.add_theme_stylebox_override(
		"panel",
		_make_style(
			_rarity_background(accent, 0.24),
			accent,
			3,
			12,
			Color(accent.r, accent.g, accent.b, 0.30),
			12
		)
	)
	interface_root.add_child(reward_toast)
	var label := Label.new()
	label.text = message
	label.position = Vector2(12.0, 6.0)
	label.size = TOAST_SIZE - Vector2(24.0, 12.0)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size", 13)
	label.add_theme_color_override("font_color", Color("#FFF2D2"))
	label.add_theme_constant_override("outline_size", 2)
	label.add_theme_color_override("font_outline_color", Color(0.0, 0.0, 0.0, 0.92))
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	reward_toast.add_child(label)
	label.set_meta("ui_font_role", "heading")

	if is_instance_valid(game_ui) and game_ui.has_method("refresh_control"):
		game_ui.call("refresh_control", label)

	if reward_tween != null and reward_tween.is_valid():
		reward_tween.kill()

	reward_tween = create_tween()
	reward_tween.tween_property(reward_toast, "modulate:a", 1.0, 0.18)
	reward_tween.tween_interval(2.7)
	reward_tween.tween_property(reward_toast, "modulate:a", 0.0, 0.28)
	reward_tween.tween_callback(_remove_toast)

func _remove_toast() -> void:
	if is_instance_valid(reward_toast):
		reward_toast.queue_free()
	reward_toast = null

func _get_loot_luck_percent() -> float:
	if is_instance_valid(main_controller):
		if main_controller.has_method("get_skill_bonus_effects"):
			var effects_variant: Variant = main_controller.call("get_skill_bonus_effects")
			if effects_variant is Dictionary:
				return maxf(0.0, float((effects_variant as Dictionary).get("loot_luck_percent", 0.0)))

	var current_scene := get_tree().current_scene
	if current_scene != null:
		var skill_tree := current_scene.find_child("ArbolHabilidadesUI", true, false)
		if skill_tree != null and skill_tree.has_method("get_skill_effects"):
			var effects_variant: Variant = skill_tree.call("get_skill_effects")
			if effects_variant is Dictionary:
				return maxf(0.0, float((effects_variant as Dictionary).get("loot_luck_percent", 0.0)))
	return 0.0

func _get_player_level() -> int:
	if is_instance_valid(main_controller):
		return maxi(1, int(main_controller.get("player_level")))
	return 1

func _get_enemy_rank() -> String:
	if is_instance_valid(main_controller):
		return str(main_controller.get("enemy_rank"))
	return "normal"

func _get_character_id() -> String:
	if is_instance_valid(inventory_ui):
		var character_candidate: Variant = inventory_ui.get("current_character_id")
		if character_candidate != null:
			var character_id: String = str(character_candidate).strip_edges()
			if not character_id.is_empty():
				return character_id

	var config: ConfigFile = ConfigFile.new()
	if config.load("user://partida.cfg") == OK:
		return str(
			config.get_value("jugador", "personaje", "")
		).strip_edges()

	return ""

func _get_current_zone_id() -> String:
	if is_instance_valid(main_controller):
		if main_controller.has_method("get_current_zone_id"):
			return SistemaRegiones.normalizar_zona(
				str(main_controller.call("get_current_zone_id"))
			)

	var config: ConfigFile = ConfigFile.new()
	if config.load("user://partida.cfg") == OK:
		return SistemaRegiones.leer_zona_actual(config)

	return SistemaRegiones.ZONA_VALDORIA

func _get_item_color(item_data: Dictionary) -> Color:
	var html_color: String = str(item_data.get("rarity_color", ""))
	if not html_color.is_empty():
		return Color(html_color)
	return BaseDatosObjetos.obtener_color_rareza(
		str(item_data.get("rarity", "comun"))
	)

func _rarity_background(
	rarity_color: Color,
	strength: float
) -> Color:
	var darkness: Color = Color(0.008, 0.012, 0.018, 0.99)
	var tinted: Color = darkness.lerp(
		Color(
			rarity_color.r,
			rarity_color.g,
			rarity_color.b,
			0.99
		),
		clampf(strength, 0.0, 0.82)
	)
	tinted.a = 0.99
	return tinted

func _make_style(
	background: Color,
	border: Color,
	border_width: int,
	radius: int,
	shadow_color: Color = Color(0.0, 0.0, 0.0, 0.0),
	shadow_size: int = 0
) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
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
