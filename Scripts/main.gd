extends Control

const BASE_UI_SIZE: Vector2 = Vector2(900.0, 240.0)
const TOP_BAR_HEIGHT: float = 32.0
const TOP_ACTION_BUTTON_SIZE: Vector2 = Vector2(24.0, 24.0)
const TOP_ACTION_BUTTON_Y: float = 4.0
const TOP_ACTION_BUTTON_GAP: float = 2.0

const TOP_LEFT_BUTTON_START_X: float = 204.0
const TOP_RIGHT_BUTTON_START_X: float = 846.0
const TOP_ACTION_DOCK_PADDING: float = 1.0
const TOP_ACTION_DOCK_HEIGHT: float = 26.0

const TOP_BUTTON_ICON_PATHS: Dictionary = {
	"BotonHabilidades": "res://Recursos/UI/IconosBarra/habilidades.png",
	"BotonForja": "res://Recursos/UI/IconosBarra/forja.png",
	"BotonInventario": "res://Recursos/UI/IconosBarra/inventario.png",
	"BotonMapaMundos": "res://Recursos/UI/IconosBarra/atlas.png",
	"BotonTienda": "res://Recursos/UI/Tienda/IconosBarra/tienda.png",
	"BotonOpciones": "res://Recursos/UI/IconosBarra/opciones.png",
	"BotonCerrar": "res://Recursos/UI/IconosBarra/cerrar.png"
}

const TOP_BUTTON_ICON_WIDTHS: Dictionary = {
	"BotonHabilidades": 30,
	"BotonForja": 30,
	"BotonInventario": 30,
	"BotonMapaMundos": 30,
	"BotonTienda": 30,
	"BotonOpciones": 30,
	"BotonCerrar": 30
}

const SETTINGS_PATH: String = "user://opciones.cfg"
const SAVE_PATH: String = "user://partida.cfg"
const SKILL_SAVE_PATH: String = "user://habilidades.cfg"

const WORLD_NAME_KEY: String = "world_name"
const ZONE_VALDORIA: String = SistemaRegiones.ZONA_VALDORIA
const ZONE_BRUMA: String = SistemaRegiones.ZONA_BRUMA
const ZONE_ELARIS: String = SistemaRegiones.ZONA_ELARIS

const PHASES_PER_ZONE: int = 100
const LEGACY_WORLD_COMPLETION_PHASE: int = 24
const ZONE_TRANSITION_DELAY: float = 2.2
const WORLD_SCROLL_SPEED: float = 14.0
const TRAVEL_DURATION: float = 2.8
const FIRST_TRAVEL_DURATION: float = 2.2
const ENEMY_ENTRY_DURATION: float = 0.48

const PLAYER_BASE_POSITION: Vector2 = Vector2(145.0, 108.0)
const ENEMY_BASE_POSITION: Vector2 = Vector2(655.0, 108.0)

const PARTY_VISUAL_AREA: Rect2 = Rect2(34.0, 96.0, 390.0, 106.0)
const ENEMY_VISUAL_AREA: Rect2 = Rect2(536.0, 96.0, 330.0, 106.0)
const COMBAT_CARD_GAP: float = 12.0
const HERO_CARD_SIZE: Vector2 = Vector2(94.0, 94.0)
const HERO_FRONTLINE_X: float = 316.0
const HERO_MIDLINE_X: float = 194.0
const HERO_BACKLINE_X: float = 72.0

const HERO_COMBAT_TEXTURE_PATHS: Dictionary = {
	"paladin_alba": "res://Recursos/Personajes/Paladin/Seleccion/Idle/Paladin1.png",
	"arquero_bosque": "res://Recursos/Personajes/Arquero/Seleccion/Idle/Arquero1.png",
	"arcanista_estelar": "res://Recursos/Personajes/Arcanista/Seleccion/Idle/Arcanista1.png"
}

const HERO_ROSTER_IDS: Array[String] = [
	"paladin_alba",
	"arquero_bosque",
	"arcanista_estelar"
]
const HERO_BASE_XP_REQUIRED: int = 30
const HERO_XP_GROWTH: float = 1.35
const MIN_ATTACK_INTERVAL: float = 0.34
const MAX_ATTACK_INTERVAL: float = 2.60

const BACKGROUND_DISPLAY_HEIGHT_VALDORIA: float = 580.0
const BACKGROUND_DISPLAY_HEIGHT_BRUMA: float = 610.0
const BACKGROUND_DISPLAY_HEIGHT_ELARIS: float = 610.0

const BACKGROUND_BOTTOM_ADJUST_VALDORIA: float = 0.0
const BACKGROUND_BOTTOM_ADJUST_BRUMA: float = 0.0
const BACKGROUND_BOTTOM_ADJUST_ELARIS: float = 0.0

const BACKGROUND_MARGIN_FILL_OPACITY: float = 0.34

const WINDOW_SIZES: Array[Vector2i] = [
	Vector2i(675, 180),
	Vector2i(900, 240),
	Vector2i(1125, 300)
]

const WINDOW_SIZE_KEYS: Array[String] = [
	"size_small",
	"size_medium",
	"size_large"
]

const LANGUAGE_CODES: Array[String] = [
	"es",
	"en"
]

const LANGUAGE_NAMES: Array[String] = [
	"Español",
	"English"
]

const TRANSLATIONS: Dictionary = {
	"es": {
		"world_name": "Mundo I",
		"stage_phase_format": "%s · Fase %d / %d",
		"zone_0_1_completed": "0-1 · RUTA DE VALDORIA SUPERADA",
		"zone_0_2_completed": "0-2 · PASO DE LA BRUMA SUPERADO",
		"zone_0_3_completed": "0-3 · RUINAS DE ELARIS SUPERADAS",
		"zone_0_1_completed_message": "La Ruta de Valdoria queda atrás. La niebla revela un paso secreto...",
		"zone_0_2_completed_message": "Has conquistado el Paso de la Bruma. Las Ruinas de Elaris despiertan...",
		"zone_0_3_completed_message": "Las Ruinas de Elaris han callado. La Fractura recuerda tu nombre.",
		"transition_to_bruma": "La senda verde se apaga tras tus pasos. Entrando en 0-2 · Paso de la Bruma...",
		"transition_to_elaris": "La niebla se abre como una herida. Entrando en 0-3 · Ruinas de Elaris...",
		"size_small": "Pequeño",
		"size_medium": "Mediano",
		"size_large": "Grande",
		"options": "OPCIONES",
		"options_tooltip": "Opciones",
		"inventory_tooltip": "Abrir inventario [I]",
		"shop_tooltip": "Abrir tienda de Lyria [T]",
		"close": "Cerrar",
		"close_options": "Cerrar opciones",
		"background_visibility": "Visibilidad del fondo",
		"window_size": "Tamaño",
		"master_volume": "Volumen general",
		"language": "Idioma",
		"always_on_top": "Mantener siempre visible",
		"lock_movement": "Bloquear movimiento",
		"autosave": "Los cambios se guardan automáticamente",
		"hero_name": "Héroe aventurero",
		"hero_panel": "HÉROE",
		"enemy": "Enemigo",
		"enemy_panel": "ENEMIGO",
		"preparing_combat": "Preparando el combate...",
		"phase_format": "Fase %d / %d",
		"player_info_format": "Nivel %d | Oro %d",
		"travel_first": "El héroe se adentra en Valdoria...",
		"travel_first_valdoria": "El héroe inicia 0-1 · Ruta de Valdoria...",
		"travel_first_bruma": "La niebla se cierra alrededor del héroe en 0-2 · Paso de la Bruma...",
		"travel_first_elaris": "Las piedras de Elaris despiertan bajo tus pasos...",
		"travel_next": "Avanzando hacia la siguiente amenaza...",
		"travel_next_bruma": "Atravesando ruinas, cuevas y estatuas olvidadas...",
		"travel_next_elaris": "Avanzando entre runas, veneno y ecos de un reino muerto...",
		"status_poison": "VENENO",
		"status_bleed": "SANGRADO",
		"status_burn": "ARDIENDO",
		"status_curse": "MALDICIÓN",
		"status_stun": "ATURDIDO",
		"status_armor_break": "ARMADURA ROTA",
		"status_light_mark": "MARCA DE LUZ",
		"rank_elite": "Élite",
		"rank_boss": "Jefe",
		"enemy_appears": "%s aparece en el camino.",
		"enemy_blocks": "%s bloquea tu camino.",
		"player_hits": "Golpeas a %s por %d de daño.",
		"enemy_hits": "%s te golpea por %d de daño.",
		"enemy_defeated": "%s derrotado. +%d oro · +%d EXP",
		"world_completed_phase": "VALDORIA SUPERADA",
		"world_completed_message": "Ruta de Valdoria completada. El siguiente destino ya aparece en el atlas.",
		"guardian_defeated": "Guardián de la zona derrotado",
		"player_defeated": "Has caído, pero tu aventura todavía no ha terminado...",
		"player_returns": "Regresas al combate con toda tu vida.",
		"level_up": "¡Nivel %d! Tu poder continúa creciendo.",
		"unique_shield_ready": "%s activa su pasiva: +%d de escudo.",
		"enemy_guardian": "Guardián de Valdoria",
		"enemy_ruins_lord": "Señor de las Ruinas",
		"enemy_ancestral_bear": "Oso Ancestral",
		"enemy_luminous_slime": "Slime luminoso",
		"enemy_road_bandit": "Bandido del camino",
		"enemy_valdoria_wolf": "Lobo de Valdoria",
		"enemy_meadow_spider": "Araña del prado",
		"enemy_ruins_raider": "Saqueador de ruinas",
		"enemy_mist_boar": "Jabalí de la bruma",
		"enemy_wandering_archer": "Arquero errante",
		"enemy_mist_wraith": "Espectro de la Bruma",
		"enemy_ash_hound": "Sabueso de Ceniza",
		"enemy_veiled_knight": "Caballero Velado",
		"enemy_cave_stalker": "Acechador de la Cueva",
		"enemy_ruined_sentinel": "Centinela Derruido",
		"enemy_fog_marauder": "Merodeador del Velo",
		"enemy_stone_spider": "Araña de Piedra",
		"enemy_fallen_paladin": "Paladín Derruido",
		"enemy_mist_giant": "Gigante de la Niebla",
		"enemy_lord_of_veil": "Señor del Velo",
		"rank_secret": "JEFE SECRETO",
		"wave_format": "OLEADA %d / %d",
		"difficulty_format": "%s · %s",
		"legendary_reward": "¡El jefe secreto deja un cofre LEGENDARIO!",
		"party_skill": "%s activa %s y causa %d de daño."
	},
	"en": {
		"world_name": "World I",
		"stage_phase_format": "%s · Stage %d / %d",
		"zone_0_1_completed": "0-1 · VALDORIA ROUTE CLEARED",
		"zone_0_2_completed": "0-2 · MIST PASS CLEARED",
		"zone_0_3_completed": "0-3 · ELARIS RUINS CLEARED",
		"zone_0_1_completed_message": "The Valdoria Route lies behind you. The mist reveals a secret pass...",
		"zone_0_2_completed_message": "You conquered the Mist Pass. The Ruins of Elaris awaken...",
		"zone_0_3_completed_message": "The Ruins of Elaris have fallen silent. The Fracture remembers your name.",
		"transition_to_bruma": "The green road fades behind you. Entering 0-2 · Mist Pass...",
		"transition_to_elaris": "The mist opens like a wound. Entering 0-3 · Ruins of Elaris...",
		"size_small": "Small",
		"size_medium": "Medium",
		"size_large": "Large",
		"options": "OPTIONS",
		"options_tooltip": "Options",
		"inventory_tooltip": "Open inventory [I]",
		"shop_tooltip": "Open Lyria's shop [T]",
		"close": "Close",
		"close_options": "Close options",
		"background_visibility": "Background visibility",
		"window_size": "Size",
		"master_volume": "Master volume",
		"language": "Language",
		"always_on_top": "Keep always on top",
		"lock_movement": "Lock window movement",
		"autosave": "Changes are saved automatically",
		"hero_name": "Adventurer Hero",
		"hero_panel": "HERO",
		"enemy": "Enemy",
		"enemy_panel": "ENEMY",
		"preparing_combat": "Preparing for battle...",
		"phase_format": "Stage %d / %d",
		"player_info_format": "Level %d | Gold %d",
		"travel_first": "The hero ventures into Valdoria...",
		"travel_first_valdoria": "The hero begins 0-1 · Valdoria Route...",
		"travel_first_bruma": "The mist closes around the hero in 0-2 · Mist Pass...",
		"travel_first_elaris": "The stones of Elaris awaken beneath your steps...",
		"travel_next": "Advancing toward the next threat...",
		"travel_next_bruma": "Crossing ruins, caves and forgotten statues...",
		"travel_next_elaris": "Advancing through runes, venom and echoes of a dead kingdom...",
		"status_poison": "POISON",
		"status_bleed": "BLEED",
		"status_burn": "BURNING",
		"status_curse": "CURSE",
		"status_stun": "STUNNED",
		"status_armor_break": "ARMOR BROKEN",
		"status_light_mark": "LIGHT MARK",
		"rank_elite": "Elite",
		"rank_boss": "Boss",
		"enemy_appears": "%s appears on the road.",
		"enemy_blocks": "%s blocks your path.",
		"player_hits": "You hit %s for %d damage.",
		"enemy_hits": "%s hits you for %d damage.",
		"enemy_defeated": "%s defeated. +%d gold · +%d EXP",
		"world_completed_phase": "VALDORIA CLEARED",
		"world_completed_message": "Valdoria route cleared. Your next destination is now marked on the atlas.",
		"guardian_defeated": "Zone guardian defeated",
		"player_defeated": "You have fallen, but your adventure is not over yet...",
		"player_returns": "You return to battle at full health.",
		"level_up": "Level %d! Your power continues to grow.",
		"unique_shield_ready": "%s activates its passive: +%d shield.",
		"enemy_guardian": "Guardian of Valdoria",
		"enemy_ruins_lord": "Lord of the Ruins",
		"enemy_ancestral_bear": "Ancestral Bear",
		"enemy_luminous_slime": "Luminous Slime",
		"enemy_road_bandit": "Road Bandit",
		"enemy_valdoria_wolf": "Valdoria Wolf",
		"enemy_meadow_spider": "Meadow Spider",
		"enemy_ruins_raider": "Ruins Raider",
		"enemy_mist_boar": "Mist Boar",
		"enemy_wandering_archer": "Wandering Archer",
		"enemy_mist_wraith": "Mist Wraith",
		"enemy_ash_hound": "Ash Hound",
		"enemy_veiled_knight": "Veiled Knight",
		"enemy_cave_stalker": "Cave Stalker",
		"enemy_ruined_sentinel": "Ruined Sentinel",
		"enemy_fog_marauder": "Veil Marauder",
		"enemy_stone_spider": "Stone Spider",
		"enemy_fallen_paladin": "Fallen Paladin",
		"enemy_mist_giant": "Mist Giant",
		"enemy_lord_of_veil": "Lord of the Veil",
		"rank_secret": "SECRET BOSS",
		"wave_format": "WAVE %d / %d",
		"difficulty_format": "%s · %s",
		"legendary_reward": "The secret boss drops a LEGENDARY chest!",
		"party_skill": "%s casts %s and deals %d damage."
	}
}

var window_size_index: int = 0
var current_window_size: Vector2i = Vector2i(675, 180)

var background_opacity: float = 0.82
var master_volume: float = 0.75
var always_on_top: bool = true
var movement_locked: bool = false
var options_open: bool = false
var inventory_opened_state: bool = false
var current_language: String = "es"
var game_ui: Node

var current_zone_id: String = ZONE_VALDORIA
var current_phase: int = 1
var world_completed: bool = false
var world_2_unlocked: bool = false
var zone_progress: Dictionary = {
	ZONE_VALDORIA: {"phase": 1, "completed": false, "unlocked": true},
	ZONE_BRUMA: {"phase": 1, "completed": false, "unlocked": false}
}

var current_difficulty: String = SistemaDificultad.NORMAL
var unlocked_difficulties: Array[String] = [SistemaDificultad.NORMAL]
var difficulty_progress: Dictionary = SistemaDificultad.crear_progreso_completo()
var mission_system: SistemaMisiones

var player_level: int = 1

var player_base_max_hp: int = 100
var player_base_damage: int = 10

var player_max_hp: int = 100
var player_hp: int = 100
var player_damage: int = 10
var player_defense: int = 0
var player_speed: int = 0
var player_magic: int = 0

var equipment_bonus_stats: Dictionary = {
	"vida": 0,
	"daño": 0,
	"def": 0,
	"vel": 0,
	"magia": 0
}

var skill_bonus_effects: Dictionary = {
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

var player_shield: int = 0
var player_max_shield: int = 0
var active_unique_passive_signature: String = ""
var unique_passive_timers: Dictionary = {}

var player_xp: int = 0
var player_xp_required: int = 30
var player_gold: int = 0

var hero_progress: Dictionary = {}
var hero_combat_states: Dictionary = {}

var enemy_name: String = ""
var enemy_name_key: String = ""
var enemy_rank: String = "normal"

var enemy_max_hp: int = 1
var enemy_hp: int = 1
var enemy_damage: int = 1
var enemy_gold_reward: int = 1
var enemy_xp_reward: int = 1
var current_enemy_data: Dictionary = {}
var current_enemy_wave: Array[Dictionary] = []
var current_enemy_wave_index: int = 0
var wave_gold_reward: int = 0
var wave_xp_reward: int = 0
var combat_rng: RandomNumberGenerator = RandomNumberGenerator.new()

var combat_active: bool = false
var is_traveling: bool = false
var walking_tween: Tween

var current_message_key: String = "preparing_combat"
var current_message_values: Array = []

var interface_root: Control

var background_rect: ColorRect
var battlefield_tint: ColorRect
var top_bar_rect: ColorRect
var ground_tint: ColorRect
var ground_line_rect: ColorRect

var world_background_container: Control
var world_background_fill: TextureRect
var world_background_a: TextureRect

var world_background_b: TextureRect
var background_tile_width: float = 0.0
var current_background_display_height: float = BACKGROUND_DISPLAY_HEIGHT_VALDORIA
var current_background_y_offset: float = 0.0
var current_background_scroll_speed: float = WORLD_SCROLL_SPEED
var background_loop_enabled: bool = false
var background_min_x: float = 0.0

var world_name_label: Label
var information_label: Label
var experience_bar: Control
var experience_value_label: Label
var phase_label: Label
var combat_log_label: Label

var player_visual: Panel
var enemy_visual: Panel

var player_hp_bar: ProgressBar
var enemy_hp_bar: ProgressBar

var player_hp_label: Label
var player_shield_bar: ProgressBar
var player_shield_label: Label
var enemy_hp_label: Label

var player_name_label: Label
var enemy_name_label: Label

var skill_button: Button
var skill_button_press_locked: bool = false
var forge_button: Button
var inventory_button: Button
var map_button: Button
var shop_button: Button
var gear_button: Button
var close_button: Button
var left_actions_backplate: Panel
var right_actions_backplate: Panel
var inventory_ui: Node
var skill_tree_ui: Node
var player_text_label: Label
var enemy_text_label: Label
var versus_label: Label
var party_strip: Control
var wave_status_label: Label
var difficulty_status_label: Label
var enemy_queue_strip: Control

var party_visual_cards: Dictionary = {}
var enemy_visual_cards: Array[Panel] = []
var enemy_visual_labels: Array[Label] = []
var enemy_visual_hp_bars: Array[Control] = []
var enemy_visual_hp_labels: Array[Label] = []
var enemy_visual_status_labels: Array[Label] = []
var party_visual_hp_bars: Dictionary = {}
var party_visual_shield_bars: Dictionary = {}
var party_visual_hp_labels: Dictionary = {}
var party_visual_status_labels: Dictionary = {}
var player_visual_home_position: Vector2 = PLAYER_BASE_POSITION
var enemy_visual_home_position: Vector2 = ENEMY_BASE_POSITION
var combat_card_tweens: Dictionary = {}

var symbol_font: Font

var options_overlay: ColorRect
var options_panel: Panel

var opacity_slider: HSlider
var opacity_value_label: Label

var volume_slider: HSlider
var volume_value_label: Label

var size_selector: OptionButton
var language_selector: OptionButton

var options_title_label: Label
var opacity_option_label: Label
var size_option_label: Label
var volume_option_label: Label
var language_option_label: Label
var save_information_label: Label
var options_close_button: Button

var always_on_top_check: CheckButton
var movement_lock_check: CheckButton

var player_attack_timer: Timer
var enemy_attack_timer: Timer
var combat_start_watchdog: float = 0.0
var combat_resolution_locked: bool = false
var party_attack_timers: Dictionary = {}
var enemy_attack_timers: Dictionary = {}
var party_skill_ready_at: Dictionary = {}
var active_skill_ready_at_ms: int = 0
var equipped_skill_ready_at: Dictionary = {}
var player_statuses: Dictionary = {}
var status_turn_counter: int = 0

var dragging_window: bool = false
var drag_offset: Vector2i = Vector2i.ZERO

func _ready() -> void:
	randomize()
	combat_rng.randomize()
	_connect_game_ui()
	_create_symbol_font()
	_load_settings()
	_load_progress()

	_hide_placeholder_nodes()
	_configure_window()
	_create_interface()
	_ensure_shop_module()
	_connect_inventory_ui()
	_connect_skill_tree_ui()
	_ensure_advanced_systems()
	_apply_interface_scale()
	_apply_visual_settings()
	_apply_audio_settings()
	_create_combat_timers()
	_refresh_party_system()
	call_deferred("_compact_top_action_buttons")
	call_deferred("_stabilize_top_bar")
	call_deferred("_apply_inventory_equipment_effects")
	_refresh_language()

	if world_completed:
		_show_world_completed_state()
	else:
		_begin_travel_to_enemy(true)

func _ensure_advanced_systems() -> void:
	mission_system = get_node_or_null("SistemaMisiones") as SistemaMisiones
	if not is_instance_valid(mission_system):
		mission_system = SistemaMisiones.new()
		mission_system.name = "SistemaMisiones"
		add_child(mission_system)
	mission_system.setup(self, inventory_ui)
	mission_system.set_language(current_language)
	if is_instance_valid(inventory_ui) and inventory_ui.has_method("_resolve_mission_system"):
		inventory_ui.call_deferred("_resolve_mission_system")

func get_mission_system() -> Node:
	return mission_system

func get_current_difficulty() -> String:
	return current_difficulty

func get_unlocked_difficulties() -> Array[String]:
	return unlocked_difficulties.duplicate()

func set_difficulty(mode: String) -> bool:
	var normalized: String = SistemaDificultad.normalizar(mode)
	if not unlocked_difficulties.has(normalized):
		return false
	combat_active = false
	is_traveling = false
	if is_instance_valid(player_attack_timer):
		player_attack_timer.stop()
	if is_instance_valid(enemy_attack_timer):
		enemy_attack_timer.stop()
	_stop_party_timers()
	_stop_enemy_timers()
	_store_current_zone_state()
	difficulty_progress[current_difficulty] = zone_progress.duplicate(true)
	current_difficulty = normalized
	var stored: Variant = difficulty_progress.get(current_difficulty, SistemaDificultad.crear_progreso_zonas())
	zone_progress = (stored as Dictionary).duplicate(true) if stored is Dictionary else SistemaDificultad.crear_progreso_zonas()
	current_zone_id = ZONE_VALDORIA
	current_phase = get_zone_phase(current_zone_id)
	world_completed = is_zone_completed(current_zone_id)
	current_enemy_wave.clear()
	current_enemy_wave_index = 0
	_restore_party_for_new_run()
	_save_progress()
	_load_current_zone_background()
	_refresh_language()
	_update_advanced_status()
	if not world_completed:
		_begin_travel_to_enemy(true)
	return true

func _process(delta: float) -> void:

	if not is_traveling and not combat_active and _alive_enemy_count() > 0:
		combat_start_watchdog += delta
		if combat_start_watchdog >= 1.25:
			combat_start_watchdog = 0.0
			if _sync_primary_enemy_from_wave():
				combat_active = true
				_start_party_timers()
				_start_enemy_timers()
	else:
		combat_start_watchdog = 0.0

	if not is_traveling:
		return

	if background_tile_width <= 0.0:
		return

	if not is_instance_valid(world_background_a):
		return

	var movement: float = current_background_scroll_speed * delta

	world_background_a.position.x = maxf(
		background_min_x,
		world_background_a.position.x - movement
	)
	world_background_a.position.y = current_background_y_offset

func _connect_game_ui() -> void:
	game_ui = get_node_or_null("/root/GameUI")

	if not is_instance_valid(game_ui):
		return

	var language_callable: Callable = Callable(
		self,
		"_on_global_language_changed"
	)

	if game_ui.has_signal("language_changed"):
		if not game_ui.is_connected(
			"language_changed",
			language_callable
		):
			game_ui.connect(
				"language_changed",
				language_callable
			)

func _on_global_language_changed(language_code: String) -> void:
	var normalized: String = language_code.to_lower().strip_edges()

	if not LANGUAGE_CODES.has(normalized):
		normalized = "es"

	current_language = normalized
	_refresh_language()
	_sync_inventory_language()

func is_modal_ui_open() -> bool:
	if options_open:
		return true

	var map_node: Node = get_node_or_null("MapaMundosUI")

	if is_instance_valid(map_node):
		var map_state: Variant = map_node.get("map_open")
		if map_state is bool and bool(map_state):
			return true

	return false

func close_world_map() -> void:
	var map_node: Node = get_node_or_null("MapaMundosUI")

	if is_instance_valid(map_node):
		if map_node.has_method("close_map"):
			map_node.call("close_map")
		elif map_node.has_method("_close_map"):
			map_node.call("_close_map")

func _text(key: String) -> String:
	var spanish_table: Dictionary = TRANSLATIONS["es"]
	var language_table: Dictionary = TRANSLATIONS.get(
		current_language,
		spanish_table
	)

	if language_table.has(key):
		return str(language_table[key])

	if spanish_table.has(key):
		return str(spanish_table[key])

	return key

func _format_text(key: String, values: Array = []) -> String:
	var translated_text: String = _text(key)

	if values.is_empty():
		return translated_text

	return translated_text % values

func _get_language_index() -> int:
	var index: int = LANGUAGE_CODES.find(current_language)

	if index < 0:
		return 0

	return index

func _set_combat_message(key: String, values: Array = []) -> void:
	current_message_key = key
	current_message_values = values.duplicate()
	_refresh_combat_message()

	_update_advanced_status(false)

func _refresh_combat_message() -> void:
	if not is_instance_valid(combat_log_label):
		return

	match current_message_key:
		"enemy_appears", "enemy_blocks":
			combat_log_label.text = _format_text(
				current_message_key,
				[enemy_name]
			)
		"player_hits", "enemy_hits":
			var damage: int = 0

			if not current_message_values.is_empty():
				damage = int(current_message_values[0])

			combat_log_label.text = _format_text(
				current_message_key,
				[enemy_name, damage]
			)
		"enemy_defeated":
			var gold_reward: int = 0
			var xp_reward: int = 0

			if current_message_values.size() >= 2:
				gold_reward = int(current_message_values[0])
				xp_reward = int(current_message_values[1])

			combat_log_label.text = _format_text(
				current_message_key,
				[enemy_name, gold_reward, xp_reward]
			)
		_:
			combat_log_label.text = _format_text(
				current_message_key,
				current_message_values
			)

func _get_ranked_enemy_name(uppercase: bool = false) -> String:
	var display_name: String = enemy_name
	if enemy_rank == "elite":
		display_name = _text("rank_elite") + " · " + enemy_name
	elif enemy_rank == "boss":
		display_name = _text("rank_boss") + " · " + enemy_name
	elif enemy_rank == "secret_boss":
		display_name = _text("rank_secret") + " · " + enemy_name
	return display_name.to_upper() if uppercase else display_name

func _update_enemy_visual_text() -> void:
	if not is_instance_valid(enemy_text_label):
		return

	var display_name: String = _text("enemy_panel")
	if not enemy_name_key.is_empty():
		display_name = _get_ranked_enemy_name(false)

	enemy_text_label.text = _compact_combatant_name(display_name, 12)
	enemy_text_label.tooltip_text = display_name

func _populate_size_selector() -> void:
	if not is_instance_valid(size_selector):
		return

	size_selector.clear()

	for size_key in WINDOW_SIZE_KEYS:
		size_selector.add_item(_text(size_key))

	size_selector.select(window_size_index)

func _refresh_language() -> void:
	if enemy_name_key == "__dynamic__" and not current_enemy_data.is_empty():
		enemy_name = SistemaCombateAvanzado.nombre_enemigo(current_enemy_data, current_language)
	elif not enemy_name_key.is_empty():
		enemy_name = _text(enemy_name_key)

	if is_instance_valid(world_name_label):
		world_name_label.text = get_current_zone_name(true).to_upper()

	if is_instance_valid(inventory_button):
		inventory_button.tooltip_text = _text("inventory_tooltip")

	if is_instance_valid(shop_button):
		shop_button.tooltip_text = _text("shop_tooltip")

	if is_instance_valid(gear_button):
		gear_button.tooltip_text = _text("options_tooltip")

	if is_instance_valid(close_button):
		close_button.tooltip_text = _text("close")

	if is_instance_valid(player_name_label):
		var active_id: String = _get_active_hero_id()
		var active_profile: Dictionary = SistemaCombateAvanzado.perfil_heroe(
			active_id,
			player_level,
			_get_hero_equipment_stats(active_id)
		)
		player_name_label.text = str(
			active_profile.get(
				"name_en" if current_language == "en" else "name_es",
				_text("hero_name")
			)
		)

	if is_instance_valid(player_text_label):
		player_text_label.text = _hero_short_name(_get_active_hero_id())

	if is_instance_valid(options_title_label):
		options_title_label.text = _text("options")

	if is_instance_valid(options_close_button):
		options_close_button.tooltip_text = _text("close_options")

	if is_instance_valid(opacity_option_label):
		opacity_option_label.text = _text("background_visibility")

	if is_instance_valid(size_option_label):
		size_option_label.text = _text("window_size")

	if is_instance_valid(volume_option_label):
		volume_option_label.text = _text("master_volume")

	if is_instance_valid(language_option_label):
		language_option_label.text = _text("language")

	if is_instance_valid(always_on_top_check):
		always_on_top_check.text = _text("always_on_top")

	if is_instance_valid(movement_lock_check):
		movement_lock_check.text = _text("lock_movement")

	if is_instance_valid(save_information_label):
		save_information_label.text = _text("autosave")

	if is_instance_valid(language_selector):
		language_selector.select(_get_language_index())

	_populate_size_selector()
	_update_enemy_visual_text()

	if world_completed:
		if is_instance_valid(phase_label):
			phase_label.text = _get_zone_completed_title()

		if is_instance_valid(enemy_name_label):
			enemy_name_label.text = _text("guardian_defeated")

		_update_player_interface_only()
	else:
		_update_interface()

	_refresh_combat_message()
	if is_instance_valid(mission_system):
		mission_system.set_language(current_language)
	_refresh_party_visuals()
	_update_advanced_status()

	if is_instance_valid(game_ui) and game_ui.has_method("apply_font_to_tree"):
		game_ui.call_deferred("apply_font_to_tree", interface_root)

func _create_symbol_font() -> void:

	if is_instance_valid(game_ui) and game_ui.has_method("get_symbol_font"):
		var global_symbol_font: Variant = game_ui.call("get_symbol_font")
		if global_symbol_font is Font:
			symbol_font = global_symbol_font as Font
			return

	var fallback: SystemFont = SystemFont.new()
	fallback.font_names = PackedStringArray([
		"Segoe UI Symbol",
		"Segoe UI Emoji",
		"Noto Sans Symbols 2",
		"Noto Sans Symbols",
		"sans-serif"
	])
	fallback.allow_system_fallback = true
	fallback.multichannel_signed_distance_field = true
	fallback.msdf_pixel_range = 16
	fallback.msdf_size = 64
	fallback.generate_mipmaps = true
	fallback.subpixel_positioning = TextServer.SUBPIXEL_POSITIONING_DISABLED
	symbol_font = fallback

func _hide_placeholder_nodes() -> void:

	var system_names: Array[StringName] = [
		&"InventarioUI",
		&"SistemaCofres",
		&"ForjaUI",
		&"ArbolHabilidadesUI",
		&"MapaMundosUI",
		&"TiendaUI",
		&"tienda"
	]

	for child: Node in get_children():
		var is_system: bool = system_names.has(child.name)
		is_system = is_system or child.has_method("toggle_inventory")
		is_system = is_system or child.has_method("toggle_forge")
		is_system = is_system or child.has_method("toggle_skill_tree")
		is_system = is_system or child.has_method("toggle_map")
		is_system = is_system or child.has_method("toggle_shop")

		if is_system:
			if child is CanvasItem:
				(child as CanvasItem).visible = true
			continue

		if child is CanvasItem:
			(child as CanvasItem).visible = false

func _load_settings() -> void:
	var config: ConfigFile = ConfigFile.new()
	var load_error: Error = config.load(SETTINGS_PATH)

	if load_error == OK:
		window_size_index = int(
			config.get_value("ventana", "tamaño", 0)
		)

		background_opacity = float(
			config.get_value("visual", "opacidad", 0.82)
		)

		master_volume = float(
			config.get_value("audio", "volumen", 0.75)
		)

		always_on_top = bool(
			config.get_value(
				"ventana",
				"siempre_visible",
				true
			)
		)

		movement_locked = bool(
			config.get_value(
				"ventana",
				"movimiento_bloqueado",
				false
			)
		)

		current_language = str(
			config.get_value("general", "idioma", "es")
		).to_lower().strip_edges()

	window_size_index = clampi(
		window_size_index,
		0,
		WINDOW_SIZES.size() - 1
	)
	background_opacity = clampf(background_opacity, 0.10, 1.0)
	master_volume = clampf(master_volume, 0.0, 1.0)

	if is_instance_valid(game_ui):
		if game_ui.has_method("get_language"):
			current_language = str(
				game_ui.call("get_language")
			).to_lower().strip_edges()

	if not LANGUAGE_CODES.has(current_language):
		current_language = "es"

func _save_settings() -> void:
	var config: ConfigFile = ConfigFile.new()
	config.load(SETTINGS_PATH)

	config.set_value("ventana", "tamaño", window_size_index)
	config.set_value("ventana", "siempre_visible", always_on_top)
	config.set_value("ventana", "movimiento_bloqueado", movement_locked)

	config.set_value("visual", "opacidad", background_opacity)
	config.set_value("audio", "volumen", master_volume)
	config.set_value("general", "idioma", current_language)

	var save_error: Error = config.save(SETTINGS_PATH)

	if save_error != OK:
		push_warning("No se pudieron guardar las opciones.")

func _load_progress() -> void:
	var config: ConfigFile = ConfigFile.new()
	var load_error: Error = config.load(SAVE_PATH)
	var migrated_normal: Dictionary = SistemaDificultad.crear_progreso_zonas()

	if load_error == OK:
		var legacy_phase: int = int(config.get_value("mundo_1", "fase", 1))
		var legacy_completed: bool = bool(config.get_value("mundo_1", "completado", false))
		for zone_id: String in SistemaRegiones.ORDEN_ZONAS:
			var fallback_phase: int = legacy_phase if zone_id == ZONE_VALDORIA else 1
			var zone_phase: int = SistemaRegiones.leer_fase(config, zone_id, fallback_phase)
			var zone_completed: bool = SistemaRegiones.leer_completada(config, zone_id)
			if zone_id == ZONE_VALDORIA and not config.has_section_key("zonas", SistemaRegiones.clave_fase(zone_id)) and legacy_completed and legacy_phase == LEGACY_WORLD_COMPLETION_PHASE:
				zone_phase = LEGACY_WORLD_COMPLETION_PHASE + 1
				zone_completed = false
			var previous_zone: String = SistemaRegiones.obtener_zona_anterior(zone_id)
			var unlocked: bool = zone_id == ZONE_VALDORIA or SistemaRegiones.esta_desbloqueada(config, zone_id)
			if not previous_zone.is_empty():
				unlocked = unlocked or bool((migrated_normal.get(previous_zone, {}) as Dictionary).get("completed", false))
			migrated_normal[zone_id] = {"phase":zone_phase, "completed":zone_completed, "unlocked":unlocked}

		current_difficulty = SistemaDificultad.cargar_modo(config)
		unlocked_difficulties = SistemaDificultad.cargar_desbloqueados(config)
		difficulty_progress = SistemaDificultad.cargar_progreso(config, migrated_normal)
		if not unlocked_difficulties.has(current_difficulty):
			current_difficulty = SistemaDificultad.NORMAL
		var active_progress: Variant = difficulty_progress.get(current_difficulty, migrated_normal)
		zone_progress = (active_progress as Dictionary).duplicate(true) if active_progress is Dictionary else migrated_normal.duplicate(true)
		for zone_id: String in SistemaRegiones.ORDEN_ZONAS:
			if not zone_progress.has(zone_id):
				zone_progress[zone_id] = migrated_normal.get(zone_id, {"phase":1,"completed":false,"unlocked":zone_id == ZONE_VALDORIA})

		current_zone_id = SistemaRegiones.leer_zona_actual(config)
		if not is_zone_unlocked(current_zone_id):
			current_zone_id = ZONE_VALDORIA
		current_phase = get_zone_phase(current_zone_id)
		world_completed = is_zone_completed(current_zone_id)
		world_2_unlocked = bool(config.get_value("mundos", "mundo_2_desbloqueado", is_zone_completed(ZONE_ELARIS)))
		player_level = maxi(1, int(config.get_value("jugador", "nivel", 1)))
		var legacy_max_hp: int = int(config.get_value("jugador", "vida_maxima", 100))
		var legacy_damage: int = int(config.get_value("jugador", "daño", 10))
		player_base_max_hp = int(config.get_value("jugador", "vida_maxima_base", legacy_max_hp))
		player_base_damage = int(config.get_value("jugador", "daño_base", legacy_damage))
		player_max_hp = player_base_max_hp
		player_damage = player_base_damage
		player_hp = clampi(int(config.get_value("jugador", "vida", player_max_hp)), 1, player_max_hp)
		player_xp = maxi(0, int(config.get_value("jugador", "experiencia", 0)))
		player_xp_required = maxi(1, int(config.get_value("jugador", "experiencia_necesaria", 30)))
		player_gold = maxi(0, int(config.get_value("jugador", "oro", 0)))
		_load_individual_hero_progress(config)
		return

	current_difficulty = SistemaDificultad.NORMAL
	unlocked_difficulties = [SistemaDificultad.NORMAL]
	difficulty_progress = SistemaDificultad.crear_progreso_completo()
	zone_progress = SistemaDificultad.crear_progreso_zonas()
	current_zone_id = ZONE_VALDORIA
	current_phase = 1
	world_completed = false
	world_2_unlocked = false
	hero_progress = {}
	for hero_id: String in HERO_ROSTER_IDS:
		hero_progress[hero_id] = _make_default_hero_progress(hero_id)

func _save_progress() -> void:
	_store_current_zone_state()
	difficulty_progress[current_difficulty] = zone_progress.duplicate(true)
	var config: ConfigFile = ConfigFile.new()
	config.load(SAVE_PATH)
	SistemaRegiones.escribir_zona_actual(config, current_zone_id)
	for zone_id: String in SistemaRegiones.ORDEN_ZONAS:
		var data: Dictionary = _get_zone_progress_data(zone_id)
		SistemaRegiones.escribir_estado_zona(config, zone_id, int(data.get("phase", 1)), bool(data.get("completed", false)), bool(data.get("unlocked", zone_id == ZONE_VALDORIA)))
	SistemaDificultad.guardar_progreso(config, difficulty_progress, current_difficulty, unlocked_difficulties)
	config.set_value("mundos", "mundo_2_desbloqueado", world_2_unlocked)
	config.set_value("jugador", "nivel", player_level)
	config.set_value("jugador", "vida_maxima_base", player_base_max_hp)
	config.set_value("jugador", "daño_base", player_base_damage)
	config.set_value("jugador", "vida_maxima", player_max_hp)
	config.set_value("jugador", "vida", player_hp)
	config.set_value("jugador", "daño", player_damage)
	config.set_value("jugador", "defensa", player_defense)
	config.set_value("jugador", "velocidad", player_speed)
	config.set_value("jugador", "magia", player_magic)
	config.set_value("jugador", "experiencia", player_xp)
	config.set_value("jugador", "experiencia_necesaria", player_xp_required)
	config.set_value("jugador", "oro", player_gold)
	_sync_progress_from_combat_states()
	config.set_value("heroes", "progreso_individual", hero_progress)
	var save_error: Error = config.save(SAVE_PATH)
	if save_error != OK:
		push_warning("No se pudo guardar el progreso.")

func _get_zone_progress_data(zone_id: String) -> Dictionary:
	var normalized: String = SistemaRegiones.normalizar_zona(zone_id)
	var data_variant: Variant = zone_progress.get(normalized, {})
	if data_variant is Dictionary:
		return (data_variant as Dictionary).duplicate(true)
	return {"phase": 1, "completed": false, "unlocked": normalized == ZONE_VALDORIA}

func _store_current_zone_state() -> void:
	var data: Dictionary = _get_zone_progress_data(current_zone_id)
	data["phase"] = clampi(current_phase, 1, _get_current_zone_phase_count())
	data["completed"] = world_completed
	data["unlocked"] = true
	zone_progress[current_zone_id] = data

func get_current_zone_id() -> String:
	return current_zone_id

func get_current_zone_name(include_code: bool = true) -> String:
	return SistemaRegiones.obtener_nombre(current_zone_id, current_language, include_code)

func get_zone_phase(zone_id: String) -> int:
	var normalized: String = SistemaRegiones.normalizar_zona(zone_id)
	return clampi(
		int(_get_zone_progress_data(normalized).get("phase", 1)),
		1,
		SistemaRegiones.obtener_fases(normalized)
	)

func is_zone_completed(zone_id: String) -> bool:
	return bool(_get_zone_progress_data(zone_id).get("completed", false))

func is_zone_unlocked(zone_id: String) -> bool:
	var normalized: String = SistemaRegiones.normalizar_zona(zone_id)
	if normalized == ZONE_VALDORIA:
		return true
	return bool(_get_zone_progress_data(normalized).get("unlocked", false))

func get_zone_unique_chance(zone_id: String = "") -> float:
	var selected_zone: String = current_zone_id if zone_id.is_empty() else zone_id
	return SistemaRegiones.obtener_probabilidad_unico(selected_zone)

func _get_current_zone_phase_count() -> int:
	return SistemaRegiones.obtener_fases(current_zone_id)

func _build_stage_phase_text() -> String:
	return _format_text(
		"stage_phase_format",
		[current_zone_id, current_phase, _get_current_zone_phase_count()]
	)

func _get_zone_completed_title() -> String:
	match current_zone_id:
		ZONE_BRUMA:
			return _text("zone_0_2_completed")
		ZONE_ELARIS:
			return _text("zone_0_3_completed")
		_:
			return _text("zone_0_1_completed")

func _get_zone_completed_message_key() -> String:
	match current_zone_id:
		ZONE_BRUMA:
			return "zone_0_2_completed_message"
		ZONE_ELARIS:
			return "zone_0_3_completed_message"
		_:
			return "zone_0_1_completed_message"

func _get_travel_message_key(first_encounter: bool) -> String:
	match current_zone_id:
		ZONE_BRUMA:
			return "travel_first_bruma" if first_encounter else "travel_next_bruma"
		ZONE_ELARIS:
			return "travel_first_elaris" if first_encounter else "travel_next_elaris"
		_:
			return "travel_first_valdoria" if first_encounter else "travel_next"

func select_zone(zone_id: String, reset_completed_zone: bool = false) -> bool:
	var normalized: String = SistemaRegiones.normalizar_zona(zone_id)
	if not is_zone_unlocked(normalized):
		return false
	combat_active = false
	is_traveling = false
	if is_instance_valid(player_attack_timer):
		player_attack_timer.stop()
	if is_instance_valid(enemy_attack_timer):
		enemy_attack_timer.stop()
	_stop_party_timers()
	_stop_enemy_timers()
	_stop_walking_animation()
	_store_current_zone_state()
	var target_data: Dictionary = _get_zone_progress_data(normalized)
	if reset_completed_zone:
		target_data["phase"] = 1
		target_data["completed"] = false
		target_data["unlocked"] = true
	zone_progress[normalized] = target_data
	difficulty_progress[current_difficulty] = zone_progress.duplicate(true)
	current_zone_id = normalized
	current_phase = clampi(int(target_data.get("phase", 1)), 1, SistemaRegiones.obtener_fases(normalized))
	world_completed = bool(target_data.get("completed", false))
	current_enemy_wave.clear()
	current_enemy_wave_index = 0
	enemy_name = ""
	enemy_name_key = ""
	enemy_rank = "normal"
	if is_instance_valid(enemy_queue_strip):
		enemy_queue_strip.visible = true
	_load_current_zone_background()
	_apply_visual_settings()
	_save_progress()
	_refresh_language()
	_update_advanced_status()
	if world_completed:
		_show_world_completed_state()
	else:
		call_deferred("_begin_travel_to_enemy", true)
	return true

func replay_zone(zone_id: String) -> bool:
	return select_zone(zone_id, true)

func _configure_window() -> void:
	current_window_size = WINDOW_SIZES[window_size_index]

	var game_window: Window = get_window()
	game_window.transparent_bg = true

	if DisplayServer.is_window_transparency_available():
		DisplayServer.window_set_flag(
			DisplayServer.WINDOW_FLAG_TRANSPARENT,
			true
		)

	DisplayServer.window_set_flag(
		DisplayServer.WINDOW_FLAG_BORDERLESS,
		true
	)

	DisplayServer.window_set_flag(
		DisplayServer.WINDOW_FLAG_RESIZE_DISABLED,
		true
	)

	DisplayServer.window_set_flag(
		DisplayServer.WINDOW_FLAG_ALWAYS_ON_TOP,
		always_on_top
	)

	DisplayServer.window_set_mode(
		DisplayServer.WINDOW_MODE_WINDOWED
	)

	DisplayServer.window_set_size(current_window_size)

	_reposition_window_at_bottom()

func _reposition_window_at_bottom() -> void:
	var current_screen: int = DisplayServer.window_get_current_screen()
	var usable_rect: Rect2i = DisplayServer.screen_get_usable_rect(current_screen)

	var position_x: int = (
		usable_rect.position.x
		+ int(
			(
				float(usable_rect.size.x)
				- float(current_window_size.x)
			) / 2.0
		)
	)

	var position_y: int = (
		usable_rect.position.y
		+ usable_rect.size.y
		- current_window_size.y
	)

	DisplayServer.window_set_position(
		Vector2i(position_x, position_y)
	)

func _input(event: InputEvent) -> void:

	if options_open:
		dragging_window = false
		return

	if movement_locked:
		dragging_window = false
		return

	if event is InputEventMouseButton:
		var mouse_event: InputEventMouseButton = event as InputEventMouseButton

		var top_button_names: Array[String] = [
			"BotonHabilidades",
			"BotonForja",
			"BotonInventario",
			"BotonMapaMundos",
			"BotonTienda",
			"BotonOpciones",
			"BotonCerrar"
		]

		for button_name in top_button_names:
			var top_candidate: Node = interface_root.find_child(
				button_name,
				true,
				false
			) if is_instance_valid(interface_root) else null

			if (
				top_candidate is Button
				and (top_candidate as Button).get_global_rect().has_point(
					mouse_event.position
				)
			):
				dragging_window = false
				return

		if mouse_event.button_index == MOUSE_BUTTON_LEFT:
			if mouse_event.pressed:
				var ui_scale: float = 1.0

				if is_instance_valid(interface_root):
					ui_scale = interface_root.scale.x

				var top_limit: float = TOP_BAR_HEIGHT * ui_scale
				var buttons_start: float = (TOP_RIGHT_BUTTON_START_X - 8.0) * ui_scale

				if (
					mouse_event.position.y <= top_limit
					and mouse_event.position.x <= buttons_start
				):
					dragging_window = true
					drag_offset = Vector2i(
						int(mouse_event.position.x),
						int(mouse_event.position.y)
					)
			else:
				dragging_window = false

	if event is InputEventMouseMotion and dragging_window:
		var mouse_position: Vector2i = DisplayServer.mouse_get_position()

		DisplayServer.window_set_position(
			mouse_position - drag_offset
		)

func _create_interface() -> void:
	interface_root = Control.new()
	interface_root.name = "InterfaceRoot"
	interface_root.position = Vector2.ZERO
	interface_root.size = BASE_UI_SIZE
	interface_root.mouse_filter = Control.MOUSE_FILTER_IGNORE
	interface_root.visible = true

	add_child(interface_root)

	_create_background()
	_create_world_background()
	_create_battlefield_tint()
	_create_top_bar()
	_create_ground()
	_create_player_interface()
	_create_enemy_interface()
	_create_combat_information()
	_create_advanced_combat_status()
	_create_options_menu()

	if is_instance_valid(game_ui) and game_ui.has_method("apply_font_to_tree"):
		game_ui.call_deferred("apply_font_to_tree", interface_root)

func _create_background() -> void:
	background_rect = ColorRect.new()
	background_rect.position = Vector2.ZERO
	background_rect.size = BASE_UI_SIZE
	background_rect.color = Color(0.01, 0.02, 0.025, 0.20)
	background_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE

	interface_root.add_child(background_rect)

func _create_world_background() -> void:
	world_background_container = Control.new()

	world_background_container.position = Vector2(0.0, TOP_BAR_HEIGHT)
	world_background_container.size = Vector2(
		BASE_UI_SIZE.x,
		BASE_UI_SIZE.y - TOP_BAR_HEIGHT
	)
	world_background_container.clip_contents = true
	world_background_container.mouse_filter = Control.MOUSE_FILTER_IGNORE

	interface_root.add_child(world_background_container)
	_load_current_zone_background()

func _load_current_zone_background() -> void:
	if not is_instance_valid(world_background_container):
		return

	for child in world_background_container.get_children():
		child.free()

	world_background_fill = null
	world_background_a = null
	world_background_b = null
	background_tile_width = 0.0

	var background_path: String = SistemaRegiones.obtener_ruta_fondo(current_zone_id)
	if not ResourceLoader.exists(background_path):
		push_error("No se encontró el fondo de %s: %s" % [current_zone_id, background_path])
		return

	var world_texture: Texture2D = load(background_path) as Texture2D
	if world_texture == null:
		push_error("No se pudo cargar el fondo: " + background_path)
		return

	var texture_size: Vector2 = world_texture.get_size()
	if texture_size.y <= 0.0:
		push_error("La textura del mundo tiene una altura inválida.")
		return

	var texture_aspect: float = texture_size.x / texture_size.y
	var requested_height: float = _get_background_display_height(current_zone_id)

	current_background_display_height = maxf(requested_height, 1.0)
	background_tile_width = current_background_display_height * texture_aspect
	current_background_y_offset = _calculate_background_y_offset(current_zone_id)

	world_background_fill = _create_background_fill_texture(world_texture)

	background_loop_enabled = false
	var available_width: float = world_background_container.size.x
	var centered_x: float = (available_width - background_tile_width) * 0.5

	if background_tile_width > available_width:
		background_min_x = available_width - background_tile_width
	else:
		background_min_x = centered_x

	current_background_scroll_speed = _calculate_background_scroll_speed()

	var phase_progress: float = clampf(
		float(maxi(current_phase - 1, 0))
		/ float(maxi(PHASES_PER_ZONE - 1, 1)),
		0.0,
		1.0
	)
	var initial_x: float = centered_x

	if background_tile_width > available_width:
		initial_x = lerpf(
			0.0,
			background_min_x,
			phase_progress
		)

	world_background_a = _create_background_texture(
		world_texture,
		Vector2(initial_x, current_background_y_offset)
	)

func _get_background_display_height(zone_id: String) -> float:
	var normalized: String = SistemaRegiones.normalizar_zona(zone_id)
	if normalized == ZONE_BRUMA:
		return BACKGROUND_DISPLAY_HEIGHT_BRUMA
	if normalized == ZONE_ELARIS:
		return BACKGROUND_DISPLAY_HEIGHT_ELARIS
	return BACKGROUND_DISPLAY_HEIGHT_VALDORIA

func _calculate_background_scroll_speed() -> float:
	if not is_instance_valid(world_background_container):
		return 0.0

	if background_tile_width <= world_background_container.size.x:
		return 0.0

	var unique_scroll_distance: float = absf(background_min_x)
	if unique_scroll_distance <= 0.0:
		return 0.0

	var total_travel_time: float = (
		FIRST_TRAVEL_DURATION
		+ float(maxi(PHASES_PER_ZONE - 1, 0)) * TRAVEL_DURATION
	)

	return unique_scroll_distance / maxf(total_travel_time, 0.01)

func _get_background_bottom_adjust(zone_id: String) -> float:
	var normalized: String = SistemaRegiones.normalizar_zona(zone_id)
	if normalized == ZONE_BRUMA:
		return BACKGROUND_BOTTOM_ADJUST_BRUMA
	if normalized == ZONE_ELARIS:
		return BACKGROUND_BOTTOM_ADJUST_ELARIS
	return BACKGROUND_BOTTOM_ADJUST_VALDORIA

func _calculate_background_y_offset(zone_id: String) -> float:

	return (
		world_background_container.size.y
		- current_background_display_height
		+ _get_background_bottom_adjust(zone_id)
	)

func _create_background_fill_texture(texture: Texture2D) -> TextureRect:
	var fill_rect: TextureRect = TextureRect.new()

	fill_rect.texture = texture
	fill_rect.position = Vector2.ZERO
	fill_rect.size = world_background_container.size
	fill_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	fill_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	fill_rect.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
	fill_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	fill_rect.modulate = Color(
		0.72,
		0.76,
		0.82,
		BACKGROUND_MARGIN_FILL_OPACITY * background_opacity
	)

	world_background_container.add_child(fill_rect)
	return fill_rect

func _create_background_texture(
	texture: Texture2D,
	texture_position: Vector2
) -> TextureRect:
	var texture_rect: TextureRect = TextureRect.new()

	texture_rect.texture = texture
	texture_rect.position = texture_position

	texture_rect.size = Vector2(
		background_tile_width,
		current_background_display_height
	)

	texture_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	texture_rect.stretch_mode = TextureRect.STRETCH_SCALE
	texture_rect.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	texture_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE

	world_background_container.add_child(texture_rect)

	return texture_rect

func _create_battlefield_tint() -> void:
	battlefield_tint = ColorRect.new()

	battlefield_tint.position = Vector2(
		0.0,
		TOP_BAR_HEIGHT
	)

	battlefield_tint.size = Vector2(
		BASE_UI_SIZE.x,
		BASE_UI_SIZE.y - TOP_BAR_HEIGHT
	)

	battlefield_tint.mouse_filter = Control.MOUSE_FILTER_IGNORE

	interface_root.add_child(battlefield_tint)

func _create_top_bar() -> void:
	top_bar_rect = ColorRect.new()
	top_bar_rect.position = Vector2.ZERO
	top_bar_rect.size = Vector2(BASE_UI_SIZE.x, TOP_BAR_HEIGHT)
	top_bar_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	interface_root.add_child(top_bar_rect)

	world_name_label = _create_label(
		interface_root,
		_text("world_name").to_upper(),
		Vector2(12.0, 0.0),
		Vector2(188.0, TOP_BAR_HEIGHT),
		12,
		HORIZONTAL_ALIGNMENT_LEFT
	)
	world_name_label.add_theme_color_override(
		"font_color",
		Color("#69F5C3")
	)

	_create_top_button_backplates()
	_create_module_action_buttons()
	_create_inventory_button()

	information_label = _create_label(
		interface_root,
		"",
		Vector2(334.0, 0.0),
		Vector2(254.0, 16.0),
		10,
		HORIZONTAL_ALIGNMENT_CENTER
	)
	information_label.z_index = 21

	experience_value_label = _create_label(
		interface_root,
		"EXP",
		Vector2(338.0, 16.0),
		Vector2(28.0, 14.0),
		8,
		HORIZONTAL_ALIGNMENT_LEFT,
		Color("#DCEBFF")
	)
	experience_value_label.z_index = 22
	experience_value_label.add_theme_constant_override("outline_size", 2)
	experience_bar = _create_compact_pill_bar(
		interface_root,
		Vector2(366.0, 18.0),
		Vector2(220.0, 10.0),
		Color("#58AFFF")
	)
	experience_bar.name = "BarraExperienciaSuperior"
	experience_bar.z_index = 21

	phase_label = _create_label(
		interface_root,
		"",
		Vector2(596.0, 0.0),
		Vector2(228.0, TOP_BAR_HEIGHT),
		12,
		HORIZONTAL_ALIGNMENT_RIGHT
	)

	_create_window_buttons()
	_compact_top_action_buttons()

func _create_top_button_backplates() -> void:
	left_actions_backplate = Panel.new()
	left_actions_backplate.name = "MarcoAccionesIzquierda"
	left_actions_backplate.position = Vector2(
		TOP_LEFT_BUTTON_START_X - TOP_ACTION_DOCK_PADDING,
		TOP_ACTION_BUTTON_Y - TOP_ACTION_DOCK_PADDING
	)
	left_actions_backplate.size = Vector2(
		TOP_ACTION_DOCK_PADDING * 2.0
		+ TOP_ACTION_BUTTON_SIZE.x * 5.0
		+ TOP_ACTION_BUTTON_GAP * 4.0,
		TOP_ACTION_DOCK_HEIGHT
	)
	left_actions_backplate.mouse_filter = Control.MOUSE_FILTER_IGNORE
	left_actions_backplate.z_index = 20
	left_actions_backplate.add_theme_stylebox_override(
		"panel",
		_make_top_backplate_style()
	)
	interface_root.add_child(left_actions_backplate)

	right_actions_backplate = Panel.new()
	right_actions_backplate.name = "MarcoAccionesDerecha"
	right_actions_backplate.position = Vector2(
		TOP_RIGHT_BUTTON_START_X - TOP_ACTION_DOCK_PADDING,
		TOP_ACTION_BUTTON_Y - TOP_ACTION_DOCK_PADDING
	)
	right_actions_backplate.size = Vector2(
		TOP_ACTION_DOCK_PADDING * 2.0
		+ TOP_ACTION_BUTTON_SIZE.x * 2.0
		+ TOP_ACTION_BUTTON_GAP,
		TOP_ACTION_DOCK_HEIGHT
	)
	right_actions_backplate.mouse_filter = Control.MOUSE_FILTER_IGNORE
	right_actions_backplate.z_index = 20
	right_actions_backplate.add_theme_stylebox_override(
		"panel",
		_make_top_backplate_style()
	)
	interface_root.add_child(right_actions_backplate)

func _make_top_backplate_style() -> StyleBoxFlat:
	var style: StyleBoxFlat = StyleBoxFlat.new()
	style.bg_color = Color(0.004, 0.009, 0.015, 0.72)
	style.border_color = Color(0.32, 0.48, 0.52, 0.28)
	style.set_border_width_all(1)
	style.corner_radius_top_left = 4
	style.corner_radius_top_right = 4
	style.corner_radius_bottom_left = 4
	style.corner_radius_bottom_right = 4
	return style

func _create_module_action_buttons() -> void:
	skill_button = _get_or_create_top_button("BotonHabilidades")
	forge_button = _get_or_create_top_button("BotonForja")
	map_button = _get_or_create_top_button("BotonMapaMundos")
	shop_button = _get_or_create_top_button("BotonTienda")

	skill_button.tooltip_text = (
		"Abrir árbol de habilidades [H]"
		if current_language == "es"
		else "Open skill tree [H]"
	)
	forge_button.tooltip_text = (
		"Abrir forja [F]"
		if current_language == "es"
		else "Open forge [F]"
	)
	map_button.tooltip_text = (
		"Abrir atlas de los mundos [M]"
		if current_language == "es"
		else "Open world atlas [M]"
	)
	shop_button.tooltip_text = _text("shop_tooltip")

	_make_skill_button_single_owner(skill_button)
	_connect_button_once(
		skill_button,
		Callable(self, "_on_skill_button_pressed")
	)
	_connect_button_once(
		forge_button,
		Callable(self, "_on_forge_button_pressed")
	)
	_connect_button_once(
		map_button,
		Callable(self, "_on_map_button_pressed")
	)
	_connect_button_once(
		shop_button,
		Callable(self, "_on_shop_button_pressed")
	)

func _create_inventory_button() -> void:
	inventory_button = _get_or_create_top_button("BotonInventario")
	inventory_button.tooltip_text = _text("inventory_tooltip")
	_connect_button_once(
		inventory_button,
		Callable(self, "_toggle_inventory")
	)

func _get_or_create_top_button(button_name: String) -> Button:
	var existing: Node = interface_root.find_child(
		button_name,
		true,
		false
	)

	var button: Button
	if existing is Button:
		button = existing as Button
		if button.get_parent() != interface_root:
			button.reparent(interface_root, false)
	else:
		button = Button.new()
		button.name = button_name
		interface_root.add_child(button)

	button.set_meta("taskbar_top_button", true)
	button.focus_mode = Control.FOCUS_NONE
	button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	button.mouse_filter = Control.MOUSE_FILTER_STOP
	_remove_duplicate_top_buttons(button_name, button)
	if button_name == "BotonHabilidades":
		_make_skill_button_single_owner(button)
	return button

func _remove_duplicate_top_buttons(
	button_name: String,
	button_to_keep: Button
) -> void:
	if not is_instance_valid(interface_root):
		return

	var matches: Array[Node] = interface_root.find_children(
		button_name,
		"Button",
		true,
		false
	)

	for candidate: Node in matches:
		if candidate == button_to_keep:
			continue
		if candidate.get_parent() != null:
			candidate.get_parent().remove_child(candidate)
		candidate.queue_free()

func _connect_button_once(button: Button, callback: Callable) -> void:
	if not is_instance_valid(button):
		return
	if not button.pressed.is_connected(callback):
		button.pressed.connect(callback)


func _make_skill_button_single_owner(button: Button) -> void:
	if not is_instance_valid(button):
		return

	var main_callback: Callable = Callable(self, "_on_skill_button_pressed")
	var connections: Array = button.pressed.get_connections()

	for connection_variant: Variant in connections:
		if not (connection_variant is Dictionary):
			continue

		var connection: Dictionary = connection_variant as Dictionary
		var callback_variant: Variant = connection.get("callable")
		if not (callback_variant is Callable):
			continue

		var callback: Callable = callback_variant as Callable
		if callback == main_callback:
			continue
		if button.pressed.is_connected(callback):
			button.pressed.disconnect(callback)


func _on_skill_button_pressed() -> void:
	if options_open or skill_button_press_locked:
		return

	var module: Node = get_node_or_null("ArbolHabilidadesUI")
	if not is_instance_valid(module):
		module = find_child("ArbolHabilidadesUI", true, false)
	if not is_instance_valid(module):
		push_error("No se encontró el nodo ArbolHabilidadesUI.")
		return

	skill_button_press_locked = true

	var tree_is_open: bool = false
	if module.has_method("is_skill_tree_open"):
		tree_is_open = bool(module.call("is_skill_tree_open"))

	if tree_is_open:
		if module.has_method("close_skill_tree"):
			module.call("close_skill_tree")
	elif module.has_method("open_skill_tree"):
		module.call("open_skill_tree")
	elif module.has_method("toggle_skill_tree"):
		module.call("toggle_skill_tree")
	else:
		push_error(
			"ArbolHabilidadesUI no contiene open_skill_tree(), "
			+ "close_skill_tree() ni toggle_skill_tree()."
		)

	call_deferred("_unlock_skill_button_press")


func _unlock_skill_button_press() -> void:
	skill_button_press_locked = false

func _on_forge_button_pressed() -> void:
	if options_open:
		return
	var module: Node = get_node_or_null("ForjaUI")
	if not is_instance_valid(module):
		module = find_child("ForjaUI", true, false)
	if is_instance_valid(module) and module.has_method("toggle_forge"):
		module.call("toggle_forge")

func _on_map_button_pressed() -> void:
	if options_open:
		return

	var shop_module: Node = _find_shop_module()
	if is_instance_valid(shop_module) and shop_module.has_method("close_shop"):
		shop_module.call("close_shop")

	var module: Node = get_node_or_null("MapaMundosUI")
	if not is_instance_valid(module):
		module = find_child("MapaMundosUI", true, false)
	if is_instance_valid(module) and module.has_method("toggle_map"):
		module.call("toggle_map")

func _on_shop_button_pressed() -> void:
	if options_open:
		return

	close_world_map()
	var module: Node = _find_shop_module()
	if is_instance_valid(module) and module.has_method("toggle_shop"):
		module.call("toggle_shop")

func _find_shop_module() -> Node:
	var official: Node = get_node_or_null("TiendaUI")
	if is_instance_valid(official) and official.has_method("toggle_shop"):
		return official

	var legacy: Node = get_node_or_null("tienda")
	if is_instance_valid(legacy) and legacy.has_method("toggle_shop"):
		return legacy

	for child: Node in get_children():
		if child.has_method("toggle_shop") and child.has_method("open_shop"):
			return child

	return null

func _ensure_shop_module() -> void:
	var existing: Node = _find_shop_module()
	if is_instance_valid(existing):

		if existing.name != &"TiendaUI" and get_node_or_null("TiendaUI") == null:
			existing.name = &"TiendaUI"
		return

	const SHOP_SCRIPT_PATH: String = "res://Scripts/tienda_ui.gd"
	if not ResourceLoader.exists(SHOP_SCRIPT_PATH):
		push_warning("No se encontró el módulo de tienda: " + SHOP_SCRIPT_PATH)
		return

	var script_resource: Resource = load(SHOP_SCRIPT_PATH)
	if not (script_resource is Script):
		push_warning("El recurso de tienda no es un Script válido.")
		return

	var shop_module: Node = (script_resource as Script).new()
	shop_module.name = &"TiendaUI"
	add_child(shop_module)

func _stabilize_top_bar() -> void:

	for _frame: int in range(16):
		await get_tree().process_frame
		_compact_top_action_buttons()

func _ensure_left_top_buttons() -> void:
	if not is_instance_valid(interface_root):
		return

	skill_button = _get_or_create_top_button("BotonHabilidades")
	forge_button = _get_or_create_top_button("BotonForja")
	inventory_button = _get_or_create_top_button("BotonInventario")
	map_button = _get_or_create_top_button("BotonMapaMundos")
	shop_button = _get_or_create_top_button("BotonTienda")

	skill_button.tooltip_text = (
		"Abrir árbol de habilidades [H]"
		if current_language == "es"
		else "Open skill tree [H]"
	)
	forge_button.tooltip_text = (
		"Abrir forja [F]"
		if current_language == "es"
		else "Open forge [F]"
	)
	inventory_button.tooltip_text = _text("inventory_tooltip")
	map_button.tooltip_text = (
		"Abrir atlas de los mundos [M]"
		if current_language == "es"
		else "Open world atlas [M]"
	)
	shop_button.tooltip_text = _text("shop_tooltip")

	_make_skill_button_single_owner(skill_button)
	_connect_button_once(
		skill_button,
		Callable(self, "_on_skill_button_pressed")
	)
	_connect_button_once(
		forge_button,
		Callable(self, "_on_forge_button_pressed")
	)
	_connect_button_once(
		inventory_button,
		Callable(self, "_toggle_inventory")
	)
	_connect_button_once(
		map_button,
		Callable(self, "_on_map_button_pressed")
	)
	_connect_button_once(
		shop_button,
		Callable(self, "_on_shop_button_pressed")
	)

func _compact_top_action_buttons() -> void:
	if not is_instance_valid(interface_root):
		return

	_ensure_left_top_buttons()

	var managed_buttons: Dictionary = {
		"BotonHabilidades": skill_button,
		"BotonForja": forge_button,
		"BotonInventario": inventory_button,
		"BotonMapaMundos": map_button,
		"BotonTienda": shop_button,
		"BotonOpciones": gear_button,
		"BotonCerrar": close_button
	}
	for managed_name: String in managed_buttons.keys():
		var managed_button: Variant = managed_buttons.get(managed_name)
		if managed_button is Button:
			_remove_duplicate_top_buttons(
				managed_name,
				managed_button as Button
			)

	var left_layout: Array[Dictionary] = [
		{
			"button": skill_button,
			"name": "BotonHabilidades",
			"position": Vector2(
				TOP_LEFT_BUTTON_START_X,
				TOP_ACTION_BUTTON_Y
			)
		},
		{
			"button": forge_button,
			"name": "BotonForja",
			"position": Vector2(
				TOP_LEFT_BUTTON_START_X
				+ TOP_ACTION_BUTTON_SIZE.x
				+ TOP_ACTION_BUTTON_GAP,
				TOP_ACTION_BUTTON_Y
			)
		},
		{
			"button": inventory_button,
			"name": "BotonInventario",
			"position": Vector2(
				TOP_LEFT_BUTTON_START_X
				+ (TOP_ACTION_BUTTON_SIZE.x + TOP_ACTION_BUTTON_GAP) * 2.0,
				TOP_ACTION_BUTTON_Y
			)
		},
		{
			"button": map_button,
			"name": "BotonMapaMundos",
			"position": Vector2(
				TOP_LEFT_BUTTON_START_X
				+ (TOP_ACTION_BUTTON_SIZE.x + TOP_ACTION_BUTTON_GAP) * 3.0,
				TOP_ACTION_BUTTON_Y
			)
		},
		{
			"button": shop_button,
			"name": "BotonTienda",
			"position": Vector2(
				TOP_LEFT_BUTTON_START_X
				+ (TOP_ACTION_BUTTON_SIZE.x + TOP_ACTION_BUTTON_GAP) * 4.0,
				TOP_ACTION_BUTTON_Y
			)
		}
	]

	for entry: Dictionary in left_layout:
		var button_value: Variant = entry.get("button")
		if not (button_value is Button):
			var found: Node = interface_root.find_child(
				str(entry.get("name", "")),
				true,
				false
			)
			if found is Button:
				button_value = found
		if button_value is Button:
			_style_uniform_top_button(
				button_value as Button,
				entry.get("position", Vector2.ZERO),
				false
			)

	var right_layout: Array[Dictionary] = [
		{
			"button": gear_button,
			"position": Vector2(
				TOP_RIGHT_BUTTON_START_X,
				TOP_ACTION_BUTTON_Y
			),
			"danger": false
		},
		{
			"button": close_button,
			"position": Vector2(
				TOP_RIGHT_BUTTON_START_X
				+ TOP_ACTION_BUTTON_SIZE.x
				+ TOP_ACTION_BUTTON_GAP,
				TOP_ACTION_BUTTON_Y
			),
			"danger": true
		}
	]

	for entry: Dictionary in right_layout:
		var button_value: Variant = entry.get("button")
		if button_value is Button:
			_style_uniform_top_button(
				button_value as Button,
				entry.get("position", Vector2.ZERO),
				bool(entry.get("danger", false))
			)

	if is_instance_valid(left_actions_backplate):
		left_actions_backplate.move_to_front()
	if is_instance_valid(right_actions_backplate):
		right_actions_backplate.move_to_front()

	for entry: Dictionary in left_layout:
		var button_value: Variant = entry.get("button")
		if button_value is Button:
			(button_value as Button).move_to_front()

	if is_instance_valid(gear_button):
		gear_button.move_to_front()
	if is_instance_valid(close_button):
		close_button.move_to_front()

func _style_uniform_top_button(
	button: Button,
	button_position: Vector2,
	danger_style: bool
) -> void:

	for child: Node in button.get_children():
		button.remove_child(child)
		child.queue_free()

	var button_name: String = str(button.name)
	var palette: Dictionary = _get_top_button_palette(
		button_name,
		danger_style
	)

	button.text = ""
	button.icon = _get_top_button_icon(button_name)
	button.expand_icon = true
	button.icon_alignment = HORIZONTAL_ALIGNMENT_CENTER
	button.vertical_icon_alignment = VERTICAL_ALIGNMENT_CENTER
	button.alignment = HORIZONTAL_ALIGNMENT_CENTER
	button.set_anchors_preset(Control.PRESET_TOP_LEFT)
	button.anchor_left = 0.0
	button.anchor_top = 0.0
	button.anchor_right = 0.0
	button.anchor_bottom = 0.0
	button.position = button_position.round()
	button.custom_minimum_size = TOP_ACTION_BUTTON_SIZE
	button.size = TOP_ACTION_BUTTON_SIZE
	button.scale = Vector2.ONE
	button.rotation = 0.0
	button.pivot_offset = TOP_ACTION_BUTTON_SIZE / 2.0
	button.focus_mode = Control.FOCUS_NONE
	button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	button.mouse_filter = Control.MOUSE_FILTER_STOP
	button.clip_text = true
	button.flat = false
	button.z_index = 30
	button.visible = true
	button.disabled = false
	button.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST

	button.add_theme_constant_override("h_separation", 0)
	button.add_theme_constant_override(
		"icon_max_width",
		_get_top_button_icon_width(button_name)
	)
	button.add_theme_color_override(
		"icon_normal_color",
		Color.WHITE
	)
	button.add_theme_color_override(
		"icon_hover_color",
		Color.WHITE
	)
	button.add_theme_color_override(
		"icon_focus_color",
		Color.WHITE
	)
	button.add_theme_color_override(
		"icon_pressed_color",
		Color.WHITE
	)
	button.add_theme_color_override(
		"icon_hover_pressed_color",
		Color.WHITE
	)
	button.add_theme_color_override(
		"icon_disabled_color",
		Color(1.0, 1.0, 1.0, 0.35)
	)
	button.add_theme_stylebox_override(
		"normal",
		_make_top_button_style(
			palette.get("background", Color.BLACK),
			palette.get("border", Color.WHITE)
		)
	)
	button.add_theme_stylebox_override(
		"hover",
		_make_top_button_style(
			palette.get("hover_background", Color.BLACK),
			palette.get("hover_border", Color.WHITE)
		)
	)
	button.add_theme_stylebox_override(
		"pressed",
		_make_top_button_style(
			palette.get("pressed_background", Color.BLACK),
			palette.get("pressed_border", Color.WHITE)
		)
	)
	button.add_theme_stylebox_override(
		"focus",
		StyleBoxEmpty.new()
	)

	button.set_deferred("size", TOP_ACTION_BUTTON_SIZE)
	button.set_deferred(
		"custom_minimum_size",
		TOP_ACTION_BUTTON_SIZE
	)
	button.set_deferred(
		"texture_filter",
		CanvasItem.TEXTURE_FILTER_NEAREST
	)

func _get_top_button_icon(button_name: String) -> Texture2D:
	var configured_path: String = str(
		TOP_BUTTON_ICON_PATHS.get(button_name, "")
	)

	if configured_path.is_empty():
		return null

	var base_path: String = configured_path.get_basename()
	var candidates: Array[String] = [
		configured_path,
		base_path + ".png",
		base_path + ".svg",
		base_path + ".webp"
	]

	if button_name == "BotonTienda":
		candidates.push_front(
			"res://Recursos/UI/Tienda/IconosBarra/tienda.png"
		)
		candidates.append("res://Recursos/UI/IconosBarra/tienda.png")

	for icon_path: String in candidates:
		if not ResourceLoader.exists(icon_path):
			continue

		var icon_resource: Resource = load(icon_path)
		if icon_resource is Texture2D:
			return icon_resource as Texture2D

	return null

func _get_top_button_icon_width(button_name: String) -> int:
	return int(TOP_BUTTON_ICON_WIDTHS.get(button_name, 10))

func _get_top_button_symbol(button_name: String) -> String:
	match button_name:
		"BotonHabilidades":
			return "✦"
		"BotonForja":
			return "⚒"
		"BotonInventario":
			return "▦"
		"BotonMapaMundos":
			return "◈"
		"BotonTienda":
			return "◆"
		"BotonOpciones":
			return "⚙"
		"BotonCerrar":
			return "×"
		_:
			return "?"

func _get_top_button_font_size(button_name: String) -> int:
	match button_name:
		"BotonHabilidades":
			return 10
		"BotonForja":
			return 10
		"BotonInventario":
			return 10
		"BotonMapaMundos":
			return 10
		"BotonTienda":
			return 10
		"BotonCerrar":
			return 12
		"BotonOpciones":
			return 10
		_:
			return 10

func _get_top_button_palette(
	button_name: String,
	danger_style: bool
) -> Dictionary:
	if danger_style or button_name == "BotonCerrar":
		return {
			"background": Color(0.0, 0.0, 0.0, 0.0),
			"border": Color(0.0, 0.0, 0.0, 0.0),
			"hover_background": Color(0.40, 0.05, 0.08, 0.18),
			"hover_border": Color(0.92, 0.25, 0.32, 0.70),
			"pressed_background": Color(0.35, 0.03, 0.06, 0.26),
			"pressed_border": Color(1.0, 0.55, 0.60, 0.82),
			"font": Color.WHITE
		}

	if button_name == "BotonOpciones":
		return {
			"background": Color(0.0, 0.0, 0.0, 0.0),
			"border": Color(0.0, 0.0, 0.0, 0.0),
			"hover_background": Color(0.02, 0.28, 0.22, 0.16),
			"hover_border": Color(0.22, 0.92, 0.76, 0.70),
			"pressed_background": Color(0.02, 0.22, 0.18, 0.24),
			"pressed_border": Color(0.70, 1.0, 0.92, 0.82),
			"font": Color.WHITE
		}

	return {
		"background": Color(0.0, 0.0, 0.0, 0.0),
		"border": Color(0.0, 0.0, 0.0, 0.0),
		"hover_background": Color(0.16, 0.12, 0.02, 0.14),
		"hover_border": Color(0.98, 0.84, 0.42, 0.70),
		"pressed_background": Color(0.22, 0.18, 0.05, 0.22),
		"pressed_border": Color(1.0, 0.93, 0.62, 0.84),
		"font": Color.WHITE
	}

func _make_top_button_style(
	background_color: Color,
	border_color: Color
) -> StyleBoxFlat:
	var style: StyleBoxFlat = StyleBoxFlat.new()
	style.bg_color = background_color
	style.border_color = border_color
	style.set_border_width_all(1)
	style.corner_radius_top_left = 3
	style.corner_radius_top_right = 3
	style.corner_radius_bottom_left = 3
	style.corner_radius_bottom_right = 3
	style.content_margin_left = 0.0
	style.content_margin_right = 0.0
	style.content_margin_top = 0.0
	style.content_margin_bottom = 0.0
	return style

func _connect_inventory_ui() -> void:
	inventory_ui = get_node_or_null("InventarioUI")

	if not is_instance_valid(inventory_ui):
		inventory_ui = find_child("InventarioUI", true, false)

	if not is_instance_valid(inventory_ui):
		push_warning("Main.gd no encontró el nodo InventarioUI.")
		return

	var opened_callable: Callable = Callable(self, "_on_inventory_opened")
	var closed_callable: Callable = Callable(self, "_on_inventory_closed")

	if inventory_ui.has_signal("inventory_opened"):
		if not inventory_ui.is_connected("inventory_opened", opened_callable):
			inventory_ui.connect("inventory_opened", opened_callable)

	if inventory_ui.has_signal("inventory_closed"):
		if not inventory_ui.is_connected("inventory_closed", closed_callable):
			inventory_ui.connect("inventory_closed", closed_callable)

	var changed_callable: Callable = Callable(self, "_on_inventory_changed")
	if inventory_ui.has_signal("inventory_changed"):
		if not inventory_ui.is_connected("inventory_changed", changed_callable):
			inventory_ui.connect("inventory_changed", changed_callable)

	var used_callable: Callable = Callable(self, "_on_inventory_item_used")
	if inventory_ui.has_signal("item_used"):
		if not inventory_ui.is_connected("item_used", used_callable):
			inventory_ui.connect("item_used", used_callable)

	if inventory_ui.has_method("set_base_stats"):
		inventory_ui.call(
			"set_base_stats",
			{
				"vida": player_base_max_hp,
				"daño": player_base_damage,
				"def": 0,
				"vel": 0,
				"magia": 0
			}
		)

	call_deferred("_apply_inventory_equipment_effects")

func _connect_skill_tree_ui() -> void:
	skill_tree_ui = get_node_or_null("ArbolHabilidadesUI")
	if not is_instance_valid(skill_tree_ui):
		skill_tree_ui = find_child("ArbolHabilidadesUI", true, false)

	if is_instance_valid(skill_tree_ui):
		var changed_callable := Callable(self, "_on_skills_changed")
		if skill_tree_ui.has_signal("skills_changed"):
			if not skill_tree_ui.is_connected("skills_changed", changed_callable):
				skill_tree_ui.connect("skills_changed", changed_callable)

	_refresh_skill_tree_effects()

func _on_skills_changed(effects: Dictionary) -> void:
	skill_bonus_effects = effects.duplicate(true)
	_apply_inventory_equipment_effects()

func _refresh_skill_tree_effects() -> void:
	var effects_variant: Variant = {}
	if is_instance_valid(skill_tree_ui) and skill_tree_ui.has_method("get_skill_effects"):
		effects_variant = skill_tree_ui.call("get_skill_effects")
	else:
		var config := ConfigFile.new()
		if config.load(SKILL_SAVE_PATH) == OK:
			effects_variant = config.get_value("habilidades", "efectos", {})

	if effects_variant is Dictionary:
		var loaded: Dictionary = effects_variant
		for key in skill_bonus_effects.keys():
			if loaded.has(key):
				skill_bonus_effects[key] = loaded[key]

	call_deferred("_apply_inventory_equipment_effects")

func get_skill_bonus_effects() -> Dictionary:
	return skill_bonus_effects.duplicate(true)

func _on_inventory_item_used(item_id: String) -> void:
	var completed_item: Dictionary = BaseDatosObjetos.completar_objeto_guardado({"id": item_id})
	var effect_variant: Variant = completed_item.get("effect", {})
	if not (effect_variant is Dictionary):
		return
	var effect: Dictionary = effect_variant
	var heal_amount: int = maxi(0, int(effect.get("heal", 0)))
	if heal_amount <= 0:
		return
	var potion_multiplier: float = 1.0 + float(skill_bonus_effects.get("potion_power_percent", 0.0)) / 100.0
	heal_amount = maxi(1, int(round(float(heal_amount) * potion_multiplier)))
	heal_amount += maxi(0, int(skill_bonus_effects.get("potion_heal_flat", 0)))
	var hero_id: String = _get_active_hero_id()
	var state: Dictionary = _get_hero_state(hero_id)
	state["hp"] = mini(int(state.get("max_hp", 1)), int(state.get("hp", 0)) + heal_amount)
	hero_combat_states[hero_id] = state
	_sync_active_player_aliases_from_state()
	_update_player_interface_only()
	_save_progress()

func _toggle_inventory() -> void:
	if options_open:
		return

	if not is_instance_valid(inventory_ui):
		_connect_inventory_ui()

	if not is_instance_valid(inventory_ui):
		push_warning("No se puede abrir el inventario: falta InventarioUI.")
		return

	if inventory_ui.has_method("toggle_inventory"):
		inventory_ui.call("toggle_inventory")

func _on_inventory_opened() -> void:
	inventory_opened_state = true
	dragging_window = false

	if is_instance_valid(inventory_button):
		inventory_button.modulate = Color("#FFF0A0")

func _on_inventory_closed() -> void:
	inventory_opened_state = false

	if is_instance_valid(inventory_button):
		inventory_button.modulate = Color.WHITE

func _on_inventory_changed() -> void:
	call_deferred("_apply_inventory_equipment_effects")

func _apply_inventory_equipment_effects(
	preserve_missing_health: bool = true
) -> void:
	if not is_instance_valid(inventory_ui):
		return

	_rebuild_hero_combat_states(preserve_missing_health)
	_sync_active_player_aliases_from_state()

	var passives_variant: Variant = []
	if inventory_ui.has_method("get_active_unique_passives"):
		passives_variant = inventory_ui.call("get_active_unique_passives")
	var passives: Array[Dictionary] = []
	if passives_variant is Array:
		for passive_variant: Variant in passives_variant:
			if passive_variant is Dictionary:
				passives.append((passive_variant as Dictionary).duplicate(true))
	_configure_unique_passives(passives)

	_update_player_interface_only()
	_refresh_party_system(false)
	_save_progress()

func _update_attack_speed_from_equipment() -> void:
	_refresh_party_attack_intervals()

func _configure_unique_passives(passives: Array[Dictionary]) -> void:
	var new_signature: String = _build_unique_passive_signature(passives)
	if new_signature == active_unique_passive_signature:
		return
	active_unique_passive_signature = new_signature
	_clear_unique_passive_timers()
	var hero_id: String = _get_active_hero_id()
	var state: Dictionary = _get_hero_state(hero_id)
	state["shield"] = 0
	state["max_shield"] = 0
	for passive: Dictionary in passives:
		if str(passive.get("type", "")) != "periodic_shield":
			continue
		var shield_amount: int = maxi(1, int(passive.get("shield", 1)))
		var cooldown: float = maxf(5.0, float(passive.get("cooldown", 50.0)))
		state["max_shield"] = int(state.get("max_shield", 0)) + shield_amount
		var passive_timer: Timer = Timer.new()
		passive_timer.name = "PasivaUnica_%s" % str(passive.get("item_id", "objeto"))
		passive_timer.wait_time = cooldown
		passive_timer.one_shot = false
		passive_timer.process_callback = Timer.TIMER_PROCESS_IDLE
		passive_timer.timeout.connect(_on_periodic_shield_passive.bind(passive.duplicate(true), hero_id))
		add_child(passive_timer)
		unique_passive_timers[str(passive.get("item_id", passive_timer.name))] = passive_timer
		passive_timer.start()
	state["shield"] = mini(int(state.get("shield", 0)), int(state.get("max_shield", 0)))
	hero_combat_states[hero_id] = state
	_sync_active_player_aliases_from_state()
	_update_player_interface_only()

func _clear_unique_passive_timers() -> void:
	for timer_variant in unique_passive_timers.values():
		if timer_variant is Timer:
			var passive_timer: Timer = timer_variant
			passive_timer.stop()
			passive_timer.queue_free()
	unique_passive_timers.clear()

func _build_unique_passive_signature(passives: Array[Dictionary]) -> String:
	var entries: Array[String] = []
	for passive in passives:
		entries.append(
			"%s|%s|%d|%.2f" % [
				str(passive.get("item_id", "")),
				str(passive.get("type", "")),
				int(passive.get("shield", 0)),
				float(passive.get("cooldown", 0.0))
			]
		)
	entries.sort()
	return ";".join(entries)

func _on_periodic_shield_passive(passive: Dictionary, hero_id: String = "") -> void:
	if hero_id.is_empty():
		hero_id = _get_active_hero_id()
	var state: Dictionary = _get_hero_state(hero_id)
	if int(state.get("max_shield", 0)) <= 0:
		return
	var shield_amount: int = maxi(1, int(passive.get("shield", 1)))
	var previous_shield: int = int(state.get("shield", 0))
	state["shield"] = mini(int(state.get("max_shield", 0)), previous_shield + shield_amount)
	var gained: int = int(state["shield"]) - previous_shield
	if gained <= 0:
		return
	hero_combat_states[hero_id] = state
	var passive_name: String = str(passive.get("name", "Pasiva única"))
	if is_instance_valid(combat_log_label):
		combat_log_label.text = _format_text("unique_shield_ready", [passive_name, gained])
	_show_damage(gained, _hero_card_position(hero_id) + Vector2(0.0, -34.0), Color("#53B8FF"))
	_sync_active_player_aliases_from_state()
	_update_player_interface_only()

func _create_window_buttons() -> void:

	gear_button = _get_or_create_top_button("BotonOpciones")
	gear_button.tooltip_text = _text("options_tooltip")
	_connect_button_once(
		gear_button,
		Callable(self, "_toggle_options")
	)

	close_button = _get_or_create_top_button("BotonCerrar")
	close_button.tooltip_text = _text("close")
	_connect_button_once(
		close_button,
		Callable(self, "_close_game")
	)

func _create_ground() -> void:
	ground_tint = ColorRect.new()
	ground_tint.position = Vector2(0, 198)
	ground_tint.size = Vector2(BASE_UI_SIZE.x, 42)
	ground_tint.mouse_filter = Control.MOUSE_FILTER_IGNORE

	interface_root.add_child(ground_tint)

	ground_line_rect = ColorRect.new()
	ground_line_rect.position = Vector2(0, 197)
	ground_line_rect.size = Vector2(BASE_UI_SIZE.x, 2)
	ground_line_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE

	interface_root.add_child(ground_line_rect)

func _create_player_interface() -> void:
	# La vida se dibuja dentro de la tarjeta del héroe. Estos nodos invisibles
	# conservan compatibilidad con el resto del controlador.
	player_name_label = _create_label(interface_root, "", Vector2.ZERO, Vector2.ONE, 1, HORIZONTAL_ALIGNMENT_CENTER)
	player_name_label.visible = false
	player_hp_bar = _create_health_bar(Vector2.ZERO, Vector2.ONE, Color("#19C98A"))
	player_hp_bar.visible = false
	player_hp_label = _create_label(interface_root, "", Vector2.ZERO, Vector2.ONE, 1, HORIZONTAL_ALIGNMENT_CENTER)
	player_hp_label.visible = false
	player_shield_bar = _create_health_bar(Vector2.ZERO, Vector2.ONE, Color("#3BA9FF"))
	player_shield_bar.visible = false
	player_shield_label = _create_label(interface_root, "", Vector2.ZERO, Vector2.ONE, 1, HORIZONTAL_ALIGNMENT_CENTER)
	player_shield_label.visible = false
	player_visual = null
	player_text_label = null

func _create_enemy_interface() -> void:
	# Cada enemigo tiene su propia barra compacta encima de su retrato.
	enemy_name_label = _create_label(interface_root, "", Vector2.ZERO, Vector2.ONE, 1, HORIZONTAL_ALIGNMENT_CENTER)
	enemy_name_label.visible = false
	enemy_hp_bar = _create_health_bar(Vector2.ZERO, Vector2.ONE, Color("#D94B4B"))
	enemy_hp_bar.visible = false
	enemy_hp_label = _create_label(interface_root, "", Vector2.ZERO, Vector2.ONE, 1, HORIZONTAL_ALIGNMENT_CENTER)
	enemy_hp_label.visible = false
	enemy_visual = null
	enemy_text_label = null

func _create_combat_information() -> void:
	combat_log_label = _create_label(
		interface_root,
		_text("preparing_combat"),
		Vector2(120, 204),
		Vector2(660, 28),
		13,
		HORIZONTAL_ALIGNMENT_CENTER
	)
	combat_log_label.vertical_alignment = VERTICAL_ALIGNMENT_TOP
	combat_log_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	combat_log_label.add_theme_color_override(
		"font_color",
		Color("#F6F1E4")
	)
	combat_log_label.add_theme_constant_override("outline_size", 2)
	combat_log_label.add_theme_color_override("font_outline_color", Color(0, 0, 0, 0.92))

	versus_label = _create_label(
		interface_root,
		"VS",
		Vector2(414, 174),
		Vector2(72, 26),
		21,
		HORIZONTAL_ALIGNMENT_CENTER
	)

	versus_label.add_theme_color_override(
		"font_color",
		Color("#F5B942")
	)

func _create_advanced_combat_status() -> void:
	difficulty_status_label = _create_label(
		interface_root,
		"",
		Vector2(312.0, 28.0),
		Vector2(276.0, 18.0),
		12,
		HORIZONTAL_ALIGNMENT_CENTER,
		Color("#FFE28A")
	)

	wave_status_label = _create_label(
		interface_root,
		"",
		Vector2(336.0, 44.0),
		Vector2(228.0, 18.0),
		12,
		HORIZONTAL_ALIGNMENT_CENTER,
		Color("#BBD7F2")
	)

	party_strip = Control.new()
	party_strip.name = "GrupoHeroesVisual"
	party_strip.position = Vector2.ZERO
	party_strip.size = BASE_UI_SIZE
	party_strip.mouse_filter = Control.MOUSE_FILTER_IGNORE
	party_strip.z_index = 12
	interface_root.add_child(party_strip)

	enemy_queue_strip = Control.new()
	enemy_queue_strip.name = "OleadaEnemigosVisual"
	enemy_queue_strip.position = Vector2.ZERO
	enemy_queue_strip.size = BASE_UI_SIZE
	enemy_queue_strip.mouse_filter = Control.MOUSE_FILTER_IGNORE
	enemy_queue_strip.z_index = 12
	interface_root.add_child(enemy_queue_strip)

	_refresh_party_visuals()
	_update_advanced_status()

func _update_advanced_status(rebuild_visuals: bool = true) -> void:
	if is_instance_valid(difficulty_status_label):
		difficulty_status_label.text = "%s · %s" % [
			get_current_zone_name(false).to_upper(),
			SistemaDificultad.obtener_nombre(
				current_difficulty,
				current_language
			)
		]

	if is_instance_valid(wave_status_label):
		var total: int = maxi(1, current_enemy_wave.size())
		var alive: int = _alive_enemy_count()
		wave_status_label.text = (
			_text("wave_format")
			% [alive, total]
		) if not current_enemy_wave.is_empty() else ""

	if rebuild_visuals:
		_refresh_enemy_queue_visuals()

func _refresh_enemy_queue_visuals() -> void:
	if not is_instance_valid(enemy_queue_strip):
		return
	_clear_combat_visual_container(enemy_queue_strip)
	enemy_visual_cards.clear()
	enemy_visual_labels.clear()
	enemy_visual_hp_bars.clear()
	enemy_visual_hp_labels.clear()
	enemy_visual_status_labels.clear()
	enemy_visual = null
	enemy_text_label = null
	if current_enemy_wave.is_empty():
		return
	var layouts: Array[Rect2] = _calculate_combat_card_layout(ENEMY_VISUAL_AREA, current_enemy_wave.size(), false)
	var primary_index: int = _get_primary_enemy_index()
	for index: int in range(current_enemy_wave.size()):
		var enemy_data: Dictionary = current_enemy_wave[index]
		var current_hp_value: int = int(enemy_data.get("current_hp", int(enemy_data.get("hp", 0))))
		var state: String = "future"
		if current_hp_value <= 0:
			state = "defeated"
		elif index == primary_index:
			state = "active"
		var full_name: String = SistemaCombateAvanzado.nombre_enemigo(enemy_data, current_language)
		var accent: Color = _enemy_card_accent(enemy_data, state)
		var card_data: Dictionary = _create_combatant_card(enemy_queue_strip, layouts[index], _enemy_fallback_symbol(enemy_data), accent, _get_enemy_combat_texture_path(enemy_data), state, false)
		var card: Panel = card_data.get("card") as Panel
		if card == null:
			continue
		card.tooltip_text = full_name
		enemy_visual_cards.append(card)
		enemy_visual_labels.append(card_data.get("label") as Label)
		enemy_visual_hp_bars.append(card_data.get("hp_bar") as Control)
		enemy_visual_hp_labels.append(card_data.get("hp_label") as Label)
		enemy_visual_status_labels.append(card_data.get("status_label") as Label)
	_select_primary_enemy_visual(primary_index)
	_update_enemy_card_states()

func _refresh_party_visuals() -> void:
	if not is_instance_valid(party_strip):
		return
	var restart_walking: bool = is_traveling and walking_tween != null
	if walking_tween != null:
		_stop_walking_animation()
	_clear_combat_visual_container(party_strip)
	party_visual_cards.clear()
	party_visual_hp_bars.clear()
	party_visual_shield_bars.clear()
	party_visual_hp_labels.clear()
	party_visual_status_labels.clear()
	player_visual = null
	player_text_label = null

	var active_id: String = _get_active_hero_id()
	var hero_ids: Array[String] = _get_party_hero_ids()
	for hero_id: String in hero_ids:
		var level: int = get_hero_level(hero_id)
		var profile: Dictionary = SistemaCombateAvanzado.perfil_heroe(hero_id, level, _get_hero_equipment_stats(hero_id))
		var accent: Color = profile.get("accent", Color("#69F5C3"))
		var is_active: bool = hero_id == active_id
		var formation_rect: Rect2 = _hero_formation_rect(hero_id)
		var card_data: Dictionary = _create_combatant_card(
			party_strip,
			formation_rect,
			"",
			accent,
			_get_hero_combat_texture_path(hero_id),
			"active" if is_active else "ally",
			true
		)
		var card: Panel = card_data.get("card") as Panel
		if card == null:
			continue
		var full_name: String = str(profile.get("name_en" if current_language == "en" else "name_es", hero_id))
		card.tooltip_text = "%s · %s %d" % [full_name, "Level" if current_language == "en" else "Nivel", level]
		party_visual_cards[hero_id] = card
		party_visual_hp_bars[hero_id] = card_data.get("hp_bar")
		party_visual_shield_bars[hero_id] = card_data.get("shield_bar")
		party_visual_hp_labels[hero_id] = card_data.get("hp_label")
		party_visual_status_labels[hero_id] = card_data.get("status_label")
		if is_active:
			player_visual = card
			player_text_label = card_data.get("label") as Label
			player_visual_home_position = _combat_card_home_position(card)
	if is_instance_valid(player_visual):
		player_visual.pivot_offset = player_visual.size / 2.0
	_update_compact_health_bars()
	if restart_walking and is_instance_valid(player_visual):
		_start_walking_animation()

func _clear_combat_visual_container(container: Control) -> void:
	if not is_instance_valid(container):
		return
	for child: Node in container.get_children():
		if not is_instance_valid(child):
			continue
		if child is Control:
			_stop_combat_card_motion(child as Control, false)
		container.remove_child(child)
		child.queue_free()
func _hero_formation_rect(hero_id: String) -> Rect2:
	var x: float
	match hero_id:
		"paladin_alba":
			x = HERO_FRONTLINE_X
		"arquero_bosque":
			x = HERO_MIDLINE_X
		"arcanista_estelar":
			x = HERO_BACKLINE_X
		_:
			x = HERO_BACKLINE_X
	var y: float = PARTY_VISUAL_AREA.position.y + (PARTY_VISUAL_AREA.size.y - HERO_CARD_SIZE.y) * 0.5 + 7.0
	return Rect2(Vector2(x, y), HERO_CARD_SIZE)

func _calculate_combat_card_layout(
	area: Rect2,
	count: int,
	for_heroes: bool
) -> Array[Rect2]:
	var result: Array[Rect2] = []
	if count <= 0:
		return result

	# Los héroes conservan siempre el mismo tamaño. La formación se alinea
	# hacia los enemigos para que el Paladín ocupe la primera línea.
	var card_size: Vector2 = Vector2(88.0, 88.0)
	var gap: float = 18.0
	if not for_heroes:
		match count:
			1, 2, 3:
				card_size = Vector2(88.0, 88.0)
				gap = 18.0
			4:
				card_size = Vector2(72.0, 82.0)
				gap = 10.0
			5:
				card_size = Vector2(60.0, 76.0)
				gap = 7.0
			_:
				card_size = Vector2(88.0, 88.0)
				gap = 18.0

	var total_width: float = card_size.x * float(count) + gap * float(maxi(0, count - 1))
	var y: float = area.position.y + (area.size.y - card_size.y) * 0.5 + 7.0
	var start_x: float
	if for_heroes:
		# Alineación a la derecha: el hueco más cercano a los enemigos es
		# siempre el del Paladín.
		start_x = area.position.x + area.size.x - total_width
	else:
		start_x = area.position.x + (area.size.x - total_width) * 0.5

	for index: int in range(count):
		result.append(Rect2(Vector2(start_x + float(index) * (card_size.x + gap), y), card_size))
	return result
func _create_combatant_card(
	parent: Control,
	rect: Rect2,
	short_text: String,
	accent: Color,
	texture_path: String,
	state: String,
	is_hero: bool
) -> Dictionary:
	var card: Panel = Panel.new()
	card.position = rect.position
	card.size = rect.size
	card.set_meta("home_position", rect.position)
	card.mouse_filter = Control.MOUSE_FILTER_IGNORE
	card.clip_contents = false
	card.pivot_offset = card.size / 2.0
	var background_color: Color = Color(0.025, 0.16, 0.12, 0.62) if is_hero else Color(0.22, 0.035, 0.045, 0.62)
	var border_color: Color = accent
	var border_width: int = 1
	if state == "active":
		border_width = 2
		background_color = background_color.lightened(0.035)
	elif state == "defeated":
		background_color = Color(0.015, 0.035, 0.030, 0.48)
		border_color = Color("#4DAE83")
		card.modulate = Color(0.52, 0.62, 0.58, 0.72)
	elif state == "future":
		background_color = background_color.darkened(0.16)
		card.modulate = Color(0.80, 0.80, 0.84, 0.90)
	elif state == "ally":
		background_color = background_color.darkened(0.06)
	card.add_theme_stylebox_override("panel", _make_combat_card_style(background_color, border_color, border_width, 9, Color(accent.r, accent.g, accent.b, 0.12), 3))
	parent.add_child(card)

	var hp_bar_width: float = clampf(card.size.x * 0.92, 60.0, 94.0)
	var hp_bar_height: float = 11.0 if is_hero else 10.0
	var hp_bar: Panel = _create_compact_pill_bar(card, Vector2((card.size.x - hp_bar_width) * 0.5, -13.0), Vector2(hp_bar_width, hp_bar_height), Color("#20D99A") if is_hero else Color("#E95764"))
	hp_bar.name = "VidaCompacta"
	var hp_label: Label = _create_label(card, "", Vector2(0.0, -28.0), Vector2(card.size.x, 13.0), 9 if card.size.x >= 70.0 else 8, HORIZONTAL_ALIGNMENT_CENTER, Color.WHITE)
	hp_label.name = "VidaTextoCompacta"
	hp_label.add_theme_constant_override("outline_size", 2)

	var shield_bar: Control = null
	var portrait_top: float = 4.0
	if is_hero:
		shield_bar = _create_compact_pill_bar(card, Vector2((card.size.x - hp_bar_width) * 0.5, -1.0), Vector2(hp_bar_width, 3.0), Color("#43AFFF"))
		shield_bar.name = "EscudoCompacto"
		shield_bar.visible = false
		portrait_top = 5.0

	var portrait: TextureRect = TextureRect.new()
	portrait.name = "Retrato"
	portrait.position = Vector2(1.0, portrait_top)
	portrait.size = Vector2(card.size.x - 2.0, card.size.y - portrait_top)
	portrait.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	portrait.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	portrait.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	portrait.mouse_filter = Control.MOUSE_FILTER_IGNORE
	portrait.modulate = Color(1.0, 1.0, 1.0, 0.98)
	card.add_child(portrait)
	var has_texture: bool = not texture_path.is_empty() and ResourceLoader.exists(texture_path)
	if has_texture:
		portrait.texture = load(texture_path) as Texture2D

	var label: Label = _create_label(card, "" if has_texture else short_text, Vector2(3.0, 12.0), Vector2(card.size.x - 6.0, card.size.y - 15.0), _combat_card_font_size(card.size.x), HORIZONTAL_ALIGNMENT_CENTER, Color("#F6EFE2"))
	label.name = "CombatantText"
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.add_theme_constant_override("outline_size", 3)
	var status_label: Label = _create_label(card, "", Vector2(1.0, card.size.y - 11.0), Vector2(card.size.x - 2.0, 10.0), 7 if card.size.x >= 70.0 else 6, HORIZONTAL_ALIGNMENT_CENTER, Color("#FFF0A0"))
	status_label.name = "EstadosCompactos"
	status_label.add_theme_constant_override("outline_size", 2)
	return {"card":card, "label":label, "hp_bar":hp_bar, "shield_bar":shield_bar, "hp_label":hp_label, "status_label":status_label}
func _create_compact_pill_bar(parent: Control, bar_position: Vector2, bar_size: Vector2, fill_color: Color) -> Panel:
	var bar: Panel = Panel.new()
	bar.position = bar_position
	bar.size = bar_size
	bar.custom_minimum_size = Vector2.ZERO
	bar.mouse_filter = Control.MOUSE_FILTER_IGNORE
	bar.clip_contents = true
	bar.add_theme_stylebox_override("panel", _make_combat_card_style(Color(0.012, 0.016, 0.022, 0.96), Color(0.0, 0.0, 0.0, 0.95), 1, 99, Color.TRANSPARENT, 0))
	parent.add_child(bar)
	var fill: Panel = Panel.new()
	fill.name = "Relleno"
	fill.position = Vector2.ZERO
	fill.size = bar_size
	fill.custom_minimum_size = Vector2.ZERO
	fill.mouse_filter = Control.MOUSE_FILTER_IGNORE
	fill.add_theme_stylebox_override("panel", _make_combat_card_style(fill_color, Color.TRANSPARENT, 0, 99, Color.TRANSPARENT, 0))
	bar.add_child(fill)
	bar.set_meta("fill_node", fill)
	return bar

func _set_compact_pill_value(bar: Control, value: float, maximum: float) -> void:
	if not is_instance_valid(bar):
		return
	var ratio: float = clampf(value / maxf(1.0, maximum), 0.0, 1.0)
	var fill_variant: Variant = bar.get_meta("fill_node", null)
	if fill_variant is Control:
		var fill: Control = fill_variant as Control
		fill.visible = ratio > 0.0
		fill.position = Vector2.ZERO
		fill.size = Vector2(bar.size.x * ratio, bar.size.y)

func _combat_card_home_position(card: Control) -> Vector2:
	if is_instance_valid(card) and card.has_meta("home_position"):
		var stored: Variant = card.get_meta("home_position")
		if stored is Vector2:
			return stored as Vector2
	return card.position if is_instance_valid(card) else Vector2.ZERO

func _stop_combat_card_motion(card: Control, restore_position: bool = true) -> void:
	if not is_instance_valid(card):
		return
	var key: int = card.get_instance_id()
	var tween_variant: Variant = combat_card_tweens.get(key)
	if tween_variant is Tween:
		var running: Tween = tween_variant as Tween
		if running.is_valid():
			running.kill()
	combat_card_tweens.erase(key)
	if restore_position:
		card.position = _combat_card_home_position(card)

func _animate_combat_card_lunge(card: Control, offset: Vector2, outward_time: float = 0.10, return_time: float = 0.14) -> void:
	if not is_instance_valid(card):
		return
	_stop_combat_card_motion(card, true)
	var home: Vector2 = _combat_card_home_position(card)
	var tween: Tween = create_tween().bind_node(card)
	combat_card_tweens[card.get_instance_id()] = tween
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(card, "position", home + offset, outward_time)
	tween.tween_property(card, "position", home, return_time)

func _make_combat_card_style(
	background_color: Color,
	border_color: Color,
	border_width: int,
	corner_radius: int,
	shadow_color: Color,
	shadow_size: int
) -> StyleBoxFlat:
	var style: StyleBoxFlat = StyleBoxFlat.new()
	style.bg_color = background_color
	style.border_color = border_color
	style.set_border_width_all(border_width)
	style.set_corner_radius_all(corner_radius)
	style.shadow_color = shadow_color
	style.shadow_size = shadow_size
	style.content_margin_left = 0.0
	style.content_margin_right = 0.0
	style.content_margin_top = 0.0
	style.content_margin_bottom = 0.0
	return style

func _combat_card_font_size(card_width: float) -> int:
	if card_width >= 95.0:
		return 15
	if card_width >= 75.0:
		return 13
	if card_width >= 62.0:
		return 11
	return 9

func _compact_combatant_name(value: String, maximum_length: int) -> String:
	var clean: String = value.strip_edges()
	if clean.length() <= maximum_length:
		return clean.to_upper()

	var words: PackedStringArray = clean.split(" ", false)
	var initials: String = ""

	for word: String in words:
		if word.is_empty():
			continue
		initials += word.substr(0, 1).to_upper()
		if initials.length() >= 3:
			break

	if not initials.is_empty():
		return initials

	return clean.substr(
		0,
		mini(maximum_length, clean.length())
	).to_upper()

func _hero_short_name(hero_id: String) -> String:
	match hero_id:
		"arquero_bosque":
			return "ARQ"
		"arcanista_estelar":
			return "ARC"
		_:
			return "PAL"

func _get_hero_combat_texture_path(hero_id: String) -> String:
	return str(HERO_COMBAT_TEXTURE_PATHS.get(hero_id, ""))

func _get_enemy_combat_texture_path(enemy_data: Dictionary) -> String:
	var explicit_path: String = str(enemy_data.get("texture_path", ""))
	if not explicit_path.is_empty() and ResourceLoader.exists(explicit_path):
		return explicit_path

	var enemy_id: String = str(enemy_data.get("id", ""))
	if enemy_id.is_empty():
		return ""

	var generated_path: String = "res://Recursos/Enemigos/%s.png" % enemy_id
	return generated_path if ResourceLoader.exists(generated_path) else ""

func _enemy_fallback_symbol(enemy_data: Dictionary) -> String:
	var enemy_id: String = str(enemy_data.get("id", "")).to_lower()
	var rank: String = str(enemy_data.get("rank", "normal"))
	if rank in ["boss", "secret_boss"]:
		return "☠"
	if enemy_id.contains("arana") or enemy_id.contains("spider"):
		return "✹"
	if enemy_id.contains("golem") or enemy_id.contains("centinela") or enemy_id.contains("guardian"):
		return "◆"
	return "⚔"

func _enemy_card_accent(enemy_data: Dictionary, state: String) -> Color:
	if state == "defeated":
		return Color("#65DDA7")

	match str(enemy_data.get("rank", "normal")):
		"secret_boss":
			return Color("#FFCC62")
		"boss":
			return Color("#FF7A6D")
		"elite":
			return Color("#D78BFF")
		_:
			return Color("#E75C68")

func _create_options_menu() -> void:
	options_overlay = ColorRect.new()
	options_overlay.position = Vector2.ZERO
	options_overlay.size = BASE_UI_SIZE
	options_overlay.color = Color(0.0, 0.0, 0.0, 0.72)
	options_overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	options_overlay.visible = false
	options_overlay.z_as_relative = false
	options_overlay.z_index = 2000

	interface_root.add_child(options_overlay)

	options_panel = Panel.new()
	options_panel.position = Vector2(180, 5)
	options_panel.size = Vector2(540, 230)

	options_overlay.add_child(options_panel)

	var panel_style: StyleBoxFlat = StyleBoxFlat.new()

	panel_style.bg_color = Color(0.025, 0.07, 0.055, 0.98)
	panel_style.border_width_left = 2
	panel_style.border_width_top = 2
	panel_style.border_width_right = 2
	panel_style.border_width_bottom = 2
	panel_style.border_color = Color("#19C98A")
	panel_style.corner_radius_top_left = 12
	panel_style.corner_radius_top_right = 12
	panel_style.corner_radius_bottom_left = 12
	panel_style.corner_radius_bottom_right = 12

	options_panel.add_theme_stylebox_override(
		"panel",
		panel_style
	)

	options_title_label = _create_label(
		options_panel,
		_text("options"),
		Vector2(20, 2),
		Vector2(500, 32),
		20,
		HORIZONTAL_ALIGNMENT_CENTER
	)

	options_title_label.add_theme_color_override(
		"font_color",
		Color("#69F5C3")
	)

	options_close_button = _create_icon_button(
		options_panel,
		"×",
		Vector2(497, 3),
		Vector2(32, 32),
		22,
		true,
		0.0
	)

	options_close_button.tooltip_text = _text("close_options")
	options_close_button.pressed.connect(_close_options)

	_create_opacity_option()
	_create_size_option()
	_create_volume_option()
	_create_language_option()
	_create_window_checks()

func _create_opacity_option() -> void:
	opacity_option_label = _create_label(
		options_panel,
		_text("background_visibility"),
		Vector2(24, 39),
		Vector2(165, 24),
		14,
		HORIZONTAL_ALIGNMENT_LEFT
	)

	opacity_slider = HSlider.new()
	opacity_slider.position = Vector2(190, 39)
	opacity_slider.size = Vector2(235, 24)
	opacity_slider.min_value = 10.0
	opacity_slider.max_value = 100.0
	opacity_slider.step = 1.0
	opacity_slider.value = background_opacity * 100.0

	options_panel.add_child(opacity_slider)

	opacity_value_label = _create_label(
		options_panel,
		"%d%%" % int(opacity_slider.value),
		Vector2(435, 39),
		Vector2(65, 24),
		14,
		HORIZONTAL_ALIGNMENT_CENTER
	)

	opacity_slider.value_changed.connect(_on_opacity_changed)

func _create_size_option() -> void:
	size_option_label = _create_label(
		options_panel,
		_text("window_size"),
		Vector2(24, 69),
		Vector2(165, 26),
		14,
		HORIZONTAL_ALIGNMENT_LEFT
	)

	size_selector = OptionButton.new()
	size_selector.position = Vector2(190, 69)
	size_selector.size = Vector2(235, 26)

	options_panel.add_child(size_selector)
	_populate_size_selector()

	size_selector.item_selected.connect(_on_size_selected)

func _create_volume_option() -> void:
	volume_option_label = _create_label(
		options_panel,
		_text("master_volume"),
		Vector2(24, 99),
		Vector2(165, 24),
		14,
		HORIZONTAL_ALIGNMENT_LEFT
	)

	volume_slider = HSlider.new()
	volume_slider.position = Vector2(190, 99)
	volume_slider.size = Vector2(235, 24)
	volume_slider.min_value = 0.0
	volume_slider.max_value = 100.0
	volume_slider.step = 1.0
	volume_slider.value = master_volume * 100.0

	options_panel.add_child(volume_slider)

	volume_value_label = _create_label(
		options_panel,
		"%d%%" % int(volume_slider.value),
		Vector2(435, 99),
		Vector2(65, 24),
		14,
		HORIZONTAL_ALIGNMENT_CENTER
	)

	volume_slider.value_changed.connect(_on_volume_changed)

func _create_language_option() -> void:
	language_option_label = _create_label(
		options_panel,
		_text("language"),
		Vector2(24, 129),
		Vector2(165, 26),
		14,
		HORIZONTAL_ALIGNMENT_LEFT
	)

	language_selector = OptionButton.new()
	language_selector.position = Vector2(190, 129)
	language_selector.size = Vector2(235, 26)

	for language_name in LANGUAGE_NAMES:
		language_selector.add_item(language_name)

	language_selector.select(_get_language_index())
	options_panel.add_child(language_selector)

	language_selector.item_selected.connect(_on_language_selected)

func _create_window_checks() -> void:
	always_on_top_check = CheckButton.new()
	always_on_top_check.text = _text("always_on_top")
	always_on_top_check.position = Vector2(24, 161)
	always_on_top_check.size = Vector2(245, 26)
	always_on_top_check.button_pressed = always_on_top

	options_panel.add_child(always_on_top_check)

	always_on_top_check.toggled.connect(
		_on_always_on_top_toggled
	)

	movement_lock_check = CheckButton.new()
	movement_lock_check.text = _text("lock_movement")
	movement_lock_check.position = Vector2(280, 161)
	movement_lock_check.size = Vector2(240, 26)
	movement_lock_check.button_pressed = movement_locked

	options_panel.add_child(movement_lock_check)

	movement_lock_check.toggled.connect(
		_on_movement_lock_toggled
	)

	save_information_label = _create_label(
		options_panel,
		_text("autosave"),
		Vector2(20, 197),
		Vector2(500, 20),
		12,
		HORIZONTAL_ALIGNMENT_CENTER
	)

	save_information_label.add_theme_color_override(
		"font_color",
		Color("#8FB6A8")
	)

func _toggle_options() -> void:

	options_open = not options_open
	dragging_window = false

	if options_open:
		close_world_map()
		options_overlay.visible = true
		options_overlay.move_to_front()
	else:
		options_overlay.visible = false
		_save_settings()

func _close_options() -> void:
	options_open = false
	options_overlay.visible = false
	_save_settings()

func _on_opacity_changed(value: float) -> void:
	background_opacity = value / 100.0
	opacity_value_label.text = "%d%%" % int(value)

	_apply_visual_settings()
	_save_settings()

func _on_volume_changed(value: float) -> void:
	master_volume = value / 100.0
	volume_value_label.text = "%d%%" % int(value)

	_apply_audio_settings()
	_save_settings()

func _on_size_selected(index: int) -> void:
	_set_window_size(index)

func _on_language_selected(index: int) -> void:
	if index < 0 or index >= LANGUAGE_CODES.size():
		return

	current_language = LANGUAGE_CODES[index]

	if is_instance_valid(game_ui):
		if game_ui.has_method("set_language"):
			game_ui.call("set_language", current_language)
		else:
			_refresh_language()
			_sync_inventory_language()
	else:
		TranslationServer.set_locale(current_language)
		_refresh_language()
		_sync_inventory_language()

	_save_settings()

func _sync_inventory_language() -> void:
	var localized_nodes: Array[String] = [
		"InventarioUI",
		"ArbolHabilidadesUI",
		"ForjaUI",
		"MapaMundosUI",
		"SistemaCofres"
	]

	for node_name: String in localized_nodes:
		var localized_node: Node = get_node_or_null(node_name)

		if is_instance_valid(localized_node):
			if localized_node.has_method("set_language"):
				localized_node.call(
					"set_language",
					current_language
				)

func _on_always_on_top_toggled(enabled: bool) -> void:
	always_on_top = enabled

	DisplayServer.window_set_flag(
		DisplayServer.WINDOW_FLAG_ALWAYS_ON_TOP,
		always_on_top
	)

	_save_settings()

func _on_movement_lock_toggled(enabled: bool) -> void:
	movement_locked = enabled
	dragging_window = false
	_save_settings()

func _apply_visual_settings() -> void:
	if is_instance_valid(world_background_fill):
		world_background_fill.modulate = Color(
			0.72,
			0.76,
			0.82,
			BACKGROUND_MARGIN_FILL_OPACITY * background_opacity
		)

	if is_instance_valid(world_background_a):
		world_background_a.modulate = Color(1.0, 1.0, 1.0, background_opacity)
	if is_instance_valid(world_background_b):
		world_background_b.modulate = Color(1.0, 1.0, 1.0, background_opacity)

	var is_bruma: bool = current_zone_id == ZONE_BRUMA

	if is_instance_valid(battlefield_tint):
		battlefield_tint.color = (
			Color(0.035, 0.045, 0.070, 0.17)
			if is_bruma
			else Color(0.015, 0.025, 0.035, 0.12)
		)

	if is_instance_valid(top_bar_rect):
		top_bar_rect.color = (
			Color(0.020, 0.026, 0.045, 0.96)
			if is_bruma
			else Color(0.015, 0.025, 0.04, 0.95)
		)

	if is_instance_valid(ground_tint):
		ground_tint.color = (
			Color(0.04, 0.05, 0.075, 0.10)
			if is_bruma
			else Color(0.02, 0.055, 0.035, 0.07)
		)

	if is_instance_valid(ground_line_rect):
		ground_line_rect.color = (
			Color(0.38, 0.62, 0.90, 0.50)
			if is_bruma
			else Color(0.10, 0.80, 0.55, 0.45)
		)

func _apply_audio_settings() -> void:
	var master_bus: int = AudioServer.get_bus_index("Master")

	if master_bus < 0:
		return

	if master_volume <= 0.001:
		AudioServer.set_bus_mute(master_bus, true)
	else:
		AudioServer.set_bus_mute(master_bus, false)

		AudioServer.set_bus_volume_db(
			master_bus,
			linear_to_db(master_volume)
		)

func _set_window_size(index: int) -> void:
	if index < 0:
		return

	if index >= WINDOW_SIZES.size():
		return

	window_size_index = index
	current_window_size = WINDOW_SIZES[window_size_index]

	DisplayServer.window_set_size(current_window_size)

	_apply_interface_scale()
	_reposition_window_at_bottom()

	if is_instance_valid(size_selector):
		size_selector.select(window_size_index)

	_save_settings()

func _apply_interface_scale() -> void:
	if not is_instance_valid(interface_root):
		return

	var horizontal_scale: float = (
		float(current_window_size.x)
		/ BASE_UI_SIZE.x
	)

	var vertical_scale: float = (
		float(current_window_size.y)
		/ BASE_UI_SIZE.y
	)

	var final_scale: float = minf(
		horizontal_scale,
		vertical_scale
	)

	interface_root.scale = Vector2(
		final_scale,
		final_scale
	)
	interface_root.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST

	var scaled_interface_size: Vector2 = (
		BASE_UI_SIZE * final_scale
	)

	var window_size_vector: Vector2 = Vector2(
		float(current_window_size.x),
		float(current_window_size.y)
	)

	interface_root.position = (
		(
			window_size_vector
			- scaled_interface_size
		) / 2.0
	).round()

	if is_instance_valid(game_ui):
		if game_ui.has_method("apply_font_to_tree"):
			game_ui.call("apply_font_to_tree", interface_root)

func _create_combat_timers() -> void:
	# Se conservan estos temporizadores por compatibilidad con el proyecto,
	# pero el combate real usa un temporizador independiente por entidad.
	player_attack_timer = Timer.new()
	player_attack_timer.one_shot = true
	player_attack_timer.wait_time = 9999.0
	add_child(player_attack_timer)
	enemy_attack_timer = Timer.new()
	enemy_attack_timer.one_shot = true
	enemy_attack_timer.wait_time = 9999.0
	add_child(enemy_attack_timer)
	_rebuild_hero_combat_states(false)
	_refresh_party_system(false)

func _get_active_hero_id() -> String:
	if is_instance_valid(inventory_ui) and inventory_ui.has_method("get_active_character_id"):
		return str(inventory_ui.call("get_active_character_id"))
	return "paladin_alba"

func _get_party_hero_ids() -> Array[String]:
	var unlocked: Dictionary = {}
	if is_instance_valid(inventory_ui) and inventory_ui.has_method("get_unlocked_character_ids"):
		var raw: Variant = inventory_ui.call("get_unlocked_character_ids")
		if raw is Array:
			for entry: Variant in raw:
				var hero_id: String = str(entry)
				if HERO_ROSTER_IDS.has(hero_id):
					unlocked[hero_id] = true

	# Respaldo persistente al cambiar de dificultad o zona.
	var skill_config: ConfigFile = ConfigFile.new()
	if skill_config.load(SKILL_SAVE_PATH) == OK:
		var saved_unlocked: Variant = skill_config.get_value("personajes", "desbloqueados", [])
		if saved_unlocked is Array:
			for entry: Variant in saved_unlocked:
				var saved_hero_id: String = str(entry)
				if HERO_ROSTER_IDS.has(saved_hero_id):
					unlocked[saved_hero_id] = true

	var active_id: String = _get_active_hero_id()
	if HERO_ROSTER_IDS.has(active_id):
		unlocked[active_id] = true
	if unlocked.is_empty():
		unlocked["paladin_alba"] = true

	# Orden fijo del grupo: Paladín, Arquero, Arcanista. En pantalla este
	# orden se coloca de derecha a izquierda, dejando al Paladín delante.
	var result: Array[String] = []
	for hero_id: String in HERO_ROSTER_IDS:
		if unlocked.has(hero_id):
			result.append(hero_id)
	return result

func _get_hero_equipment_stats(hero_id: String) -> Dictionary:
	if is_instance_valid(inventory_ui) and inventory_ui.has_method("get_equipment_bonus_stats_for_character"):
		var raw: Variant = inventory_ui.call("get_equipment_bonus_stats_for_character", hero_id)
		if raw is Dictionary:
			return (raw as Dictionary).duplicate(true)
	return equipment_bonus_stats.duplicate(true) if hero_id == _get_active_hero_id() else {"vida":0,"daño":0,"def":0,"vel":0,"magia":0}

func _refresh_party_system(rebuild_states: bool = true) -> void:
	var was_running: bool = combat_active
	_stop_party_timers()
	for raw_timer: Variant in party_attack_timers.values():
		if raw_timer is Timer:
			(raw_timer as Timer).queue_free()
	party_attack_timers.clear()

	if rebuild_states:
		_rebuild_hero_combat_states(true)
	for hero_id: String in _get_party_hero_ids():
		_ensure_hero_progress(hero_id)
		_ensure_hero_combat_state(hero_id)
		if not party_skill_ready_at.has(hero_id):
			party_skill_ready_at[hero_id] = 0
		var timer: Timer = Timer.new()
		timer.name = "AtaqueHeroe_%s" % hero_id
		timer.one_shot = false
		timer.wait_time = _hero_attack_interval(hero_id)
		timer.timeout.connect(_on_companion_attack.bind(hero_id))
		add_child(timer)
		party_attack_timers[hero_id] = timer

	_refresh_party_visuals()
	if was_running:
		_start_party_timers()

func _start_party_timers() -> void:
	var order: int = 0
	for hero_id: String in _get_party_hero_ids():
		var timer_variant: Variant = party_attack_timers.get(hero_id)
		if not (timer_variant is Timer):
			continue
		var timer: Timer = timer_variant as Timer
		var state: Dictionary = _get_hero_state(hero_id)
		if int(state.get("hp", 0)) <= 0:
			timer.stop()
			continue
		timer.wait_time = _hero_attack_interval(hero_id)
		# Desfase inicial para que nunca golpeen todos a la vez.
		timer.start(timer.wait_time + float(order) * 0.17)
		order += 1

func _stop_party_timers() -> void:
	for raw_timer: Variant in party_attack_timers.values():
		if raw_timer is Timer:
			(raw_timer as Timer).stop()

func _on_companion_attack(hero_id: String) -> void:
	_on_hero_attack(hero_id)

func _is_hero_skill_unlocked(hero_id: String) -> bool:
	if is_instance_valid(skill_tree_ui) and skill_tree_ui.has_method("is_combat_skill_unlocked"):
		return bool(skill_tree_ui.call("is_combat_skill_unlocked", hero_id))
	var required_level: int = 5
	if hero_id == "arquero_bosque":
		required_level = 8
	elif hero_id == "arcanista_estelar":
		required_level = 12
	return get_hero_level(hero_id) >= required_level

func _make_default_hero_progress(hero_id: String) -> Dictionary:
	return {
		"hero_id": hero_id,
		"level": 1,
		"xp": 0,
		"xp_required": HERO_BASE_XP_REQUIRED,
		"hp": -1,
		"shield": 0
	}

func _load_individual_hero_progress(config: ConfigFile) -> void:
	hero_progress = {}
	var saved_variant: Variant = config.get_value("heroes", "progreso_individual", {})
	var saved: Dictionary = {}
	if saved_variant is Dictionary:
		saved = (saved_variant as Dictionary).duplicate(true)
	var legacy_active_id: String = str(config.get_value("jugador", "personaje", "paladin_alba"))
	if not HERO_ROSTER_IDS.has(legacy_active_id):
		legacy_active_id = "paladin_alba"
	for hero_id: String in HERO_ROSTER_IDS:
		var data: Dictionary = _make_default_hero_progress(hero_id)
		var raw: Variant = saved.get(hero_id, {})
		if raw is Dictionary and not (raw as Dictionary).is_empty():
			data.merge((raw as Dictionary).duplicate(true), true)
		elif hero_id == legacy_active_id:
			data["level"] = player_level
			data["xp"] = player_xp
			data["xp_required"] = player_xp_required
			data["hp"] = player_hp
		data["level"] = maxi(1, int(data.get("level", 1)))
		data["xp"] = maxi(0, int(data.get("xp", 0)))
		data["xp_required"] = maxi(1, int(data.get("xp_required", HERO_BASE_XP_REQUIRED)))
		hero_progress[hero_id] = data

func _ensure_hero_progress(hero_id: String) -> Dictionary:
	if not hero_progress.has(hero_id) or not (hero_progress[hero_id] is Dictionary):
		hero_progress[hero_id] = _make_default_hero_progress(hero_id)
	return hero_progress[hero_id] as Dictionary

func get_hero_level(hero_id: String) -> int:
	return maxi(1, int(_ensure_hero_progress(hero_id).get("level", 1)))

func get_hero_progress(hero_id: String) -> Dictionary:
	return _ensure_hero_progress(hero_id).duplicate(true)

func _hero_formation_priority(hero_id: String) -> int:
	var profile: Dictionary = SistemaCombateAvanzado.perfil_heroe(hero_id, get_hero_level(hero_id), _get_hero_equipment_stats(hero_id))
	return int(profile.get("formation_priority", 50))

func _rebuild_hero_combat_states(preserve_missing_health: bool = true) -> void:
	var ids: Array[String] = HERO_ROSTER_IDS.duplicate()
	for hero_id: String in ids:
		_ensure_hero_progress(hero_id)
		var old_state: Dictionary = {}
		var old_variant: Variant = hero_combat_states.get(hero_id, {})
		if old_variant is Dictionary:
			old_state = (old_variant as Dictionary).duplicate(true)
		var level: int = get_hero_level(hero_id)
		var equipment: Dictionary = _get_hero_equipment_stats(hero_id)
		var profile: Dictionary = SistemaCombateAvanzado.perfil_heroe(hero_id, level, equipment)
		var health_multiplier: float = 1.0 + float(skill_bonus_effects.get("health_percent", 0.0)) / 100.0
		var damage_multiplier: float = 1.0 + float(skill_bonus_effects.get("damage_percent", 0.0)) / 100.0
		var max_hp_value: int = maxi(1, int(round(float(profile.get("max_hp", 100)) * health_multiplier)))
		var previous_max: int = maxi(1, int(old_state.get("max_hp", max_hp_value)))
		var saved_hp: int = int(_ensure_hero_progress(hero_id).get("hp", -1))
		var previous_hp: int = int(old_state.get("hp", saved_hp if saved_hp >= 0 else max_hp_value))
		var hp_value: int = max_hp_value
		if preserve_missing_health:
			var missing: int = maxi(0, previous_max - previous_hp)
			hp_value = clampi(max_hp_value - missing, 0, max_hp_value)
		var previous_statuses: Dictionary = {}
		var previous_statuses_variant: Variant = old_state.get("statuses", {})
		if previous_statuses_variant is Dictionary:
			previous_statuses = (previous_statuses_variant as Dictionary).duplicate(true)
		var state: Dictionary = {
			"hero_id": hero_id,
			"level": level,
			"max_hp": max_hp_value,
			"hp": hp_value,
			"damage": maxi(1, int(round(float(profile.get("damage", 1)) * damage_multiplier))),
			"defense": maxi(0, int(profile.get("defense", 0)) + int(skill_bonus_effects.get("defense_flat", 0))),
			"speed": maxi(0, int(profile.get("speed", 0)) + int(skill_bonus_effects.get("speed_flat", 0))),
			"magic": maxi(0, int(profile.get("magic", 0))),
			"attack_range": str(profile.get("attack_range", "melee")),
			"formation_priority": int(profile.get("formation_priority", 50)),
			"base_interval": float(profile.get("interval", 1.25)),
			"shield": maxi(0, int(old_state.get("shield", _ensure_hero_progress(hero_id).get("shield", 0)))),
			"max_shield": maxi(0, int(old_state.get("max_shield", 0))),
			"statuses": previous_statuses
		}
		state["shield"] = mini(int(state["shield"]), maxi(int(state["max_shield"]), int(state["shield"])))
		hero_combat_states[hero_id] = state
	_sync_active_player_aliases_from_state()

func _ensure_hero_combat_state(hero_id: String) -> Dictionary:
	if not hero_combat_states.has(hero_id) or not (hero_combat_states[hero_id] is Dictionary):
		_rebuild_hero_combat_states(true)
	return hero_combat_states.get(hero_id, {}) as Dictionary

func _get_hero_state(hero_id: String) -> Dictionary:
	return _ensure_hero_combat_state(hero_id)

func get_hero_combat_stats(hero_id: String) -> Dictionary:
	var state: Dictionary = _get_hero_state(hero_id)
	var progress: Dictionary = _ensure_hero_progress(hero_id)
	return {
		"vida": int(state.get("max_hp", 1)),
		"daño": int(state.get("damage", 1)),
		"def": int(state.get("defense", 0)),
		"vel": int(state.get("speed", 0)),
		"magia": int(state.get("magic", 0)),
		"level": int(progress.get("level", 1)),
		"xp": int(progress.get("xp", 0)),
		"xp_required": int(progress.get("xp_required", HERO_BASE_XP_REQUIRED))
	}

func _sync_active_player_aliases_from_state() -> void:
	var active_id: String = _get_active_hero_id()
	var state: Dictionary = {}
	if hero_combat_states.has(active_id) and hero_combat_states[active_id] is Dictionary:
		state = hero_combat_states[active_id] as Dictionary
	var progress: Dictionary = _ensure_hero_progress(active_id)
	if state.is_empty():
		return
	player_level = int(progress.get("level", 1))
	player_xp = int(progress.get("xp", 0))
	player_xp_required = int(progress.get("xp_required", HERO_BASE_XP_REQUIRED))
	player_max_hp = int(state.get("max_hp", 1))
	player_hp = int(state.get("hp", player_max_hp))
	player_damage = int(state.get("damage", 1))
	player_defense = int(state.get("defense", 0))
	player_speed = int(state.get("speed", 0))
	player_magic = int(state.get("magic", 0))
	player_shield = int(state.get("shield", 0))
	player_max_shield = int(state.get("max_shield", 0))
	player_statuses = {}
	var active_statuses_variant: Variant = state.get("statuses", {})
	if active_statuses_variant is Dictionary:
		player_statuses = (active_statuses_variant as Dictionary).duplicate(true)
	equipment_bonus_stats = _get_hero_equipment_stats(active_id)

func _sync_progress_from_combat_states() -> void:
	for hero_id: String in HERO_ROSTER_IDS:
		var progress: Dictionary = _ensure_hero_progress(hero_id)
		var state_variant: Variant = hero_combat_states.get(hero_id, {})
		if state_variant is Dictionary and not (state_variant as Dictionary).is_empty():
			var state: Dictionary = state_variant as Dictionary
			progress["hp"] = int(state.get("hp", -1))
			progress["shield"] = int(state.get("shield", 0))
		hero_progress[hero_id] = progress

func _restore_party_for_new_run() -> void:
	combat_active = false
	_stop_party_timers()
	_stop_enemy_timers()
	# Al entrar en una zona nueva o cambiar de dificultad, todo el grupo
	# comienza listo. Esto evita que un héroe derrotado siga guardado a 0 HP
	# y aparezca como una tarjeta vacía o desaparecida.
	_rebuild_hero_combat_states(false)
	for hero_id: String in _get_party_hero_ids():
		var state: Dictionary = _get_hero_state(hero_id)
		var full_hp: int = maxi(1, int(state.get("max_hp", 1)))
		state["hp"] = full_hp
		state["shield"] = 0
		state["max_shield"] = 0
		state["statuses"] = {}
		hero_combat_states[hero_id] = state

		var progress: Dictionary = _ensure_hero_progress(hero_id)
		progress["hp"] = full_hp
		progress["shield"] = 0
		hero_progress[hero_id] = progress

	_sync_active_player_aliases_from_state()
	_refresh_party_system(false)
	_update_compact_health_bars()

func _hero_attack_interval(hero_id: String) -> float:
	var state: Dictionary = _get_hero_state(hero_id)
	var base_interval: float = float(state.get("base_interval", 1.25))
	var speed: float = float(state.get("speed", 0))
	return clampf(base_interval / (1.0 + speed / 100.0), MIN_ATTACK_INTERVAL, MAX_ATTACK_INTERVAL)

func _refresh_party_attack_intervals() -> void:
	for hero_id: String in party_attack_timers.keys():
		var timer_variant: Variant = party_attack_timers.get(hero_id)
		if timer_variant is Timer:
			(timer_variant as Timer).wait_time = _hero_attack_interval(hero_id)

func _alive_hero_ids() -> Array[String]:
	var result: Array[String] = []
	for hero_id: String in _get_party_hero_ids():
		if int(_get_hero_state(hero_id).get("hp", 0)) > 0:
			result.append(hero_id)
	return result

func _all_heroes_defeated() -> bool:
	return _alive_hero_ids().is_empty()

func _select_enemy_target_for_hero(hero_id: String, alive_indices: Array[int]) -> int:
	if alive_indices.is_empty():
		return -1
	var attack_range: String = str(_get_hero_state(hero_id).get("attack_range", "melee"))
	return alive_indices[alive_indices.size() - 1] if attack_range == "ranged" else alive_indices[0]

func _select_hero_target_for_enemy(enemy_data: Dictionary) -> String:
	var alive: Array[String] = _alive_hero_ids()
	if alive.is_empty():
		return ""
	var attack_range: String = str(enemy_data.get("attack_range", "melee"))
	return alive[alive.size() - 1] if attack_range == "ranged" else alive[0]

func _refresh_enemy_attack_timers() -> void:
	_stop_enemy_timers()
	for raw_timer: Variant in enemy_attack_timers.values():
		if raw_timer is Timer:
			(raw_timer as Timer).queue_free()
	enemy_attack_timers.clear()
	for enemy_index: int in range(current_enemy_wave.size()):
		var enemy_data: Dictionary = current_enemy_wave[enemy_index]
		var timer: Timer = Timer.new()
		timer.name = "AtaqueEnemigo_%d" % enemy_index
		timer.one_shot = false
		var base_interval: float = float(enemy_data.get("interval", 1.65))
		var speed: float = float(enemy_data.get("speed", 0))
		timer.wait_time = clampf(base_interval / (1.0 + speed / 100.0), 0.48, 3.00)
		timer.timeout.connect(_on_enemy_entity_attack.bind(enemy_index))
		add_child(timer)
		enemy_attack_timers[enemy_index] = timer

func _start_enemy_timers() -> void:
	var order: int = 0
	for enemy_index: int in range(current_enemy_wave.size()):
		var timer_variant: Variant = enemy_attack_timers.get(enemy_index)
		if not (timer_variant is Timer):
			continue
		var enemy_data: Dictionary = current_enemy_wave[enemy_index]
		if int(enemy_data.get("current_hp", 0)) <= 0:
			(timer_variant as Timer).stop()
			continue
		var timer: Timer = timer_variant as Timer
		timer.start(timer.wait_time + 0.31 + float(order) * 0.19)
		order += 1

func _stop_enemy_timers() -> void:
	for raw_timer: Variant in enemy_attack_timers.values():
		if raw_timer is Timer:
			(raw_timer as Timer).stop()

func _stop_enemy_timer(enemy_index: int) -> void:
	var timer_variant: Variant = enemy_attack_timers.get(enemy_index)
	if timer_variant is Timer:
		(timer_variant as Timer).stop()

func _on_hero_attack(hero_id: String) -> void:
	if not combat_active or combat_resolution_locked:
		return
	var state: Dictionary = _get_hero_state(hero_id)
	if int(state.get("hp", 0)) <= 0:
		var timer_variant: Variant = party_attack_timers.get(hero_id)
		if timer_variant is Timer:
			(timer_variant as Timer).stop()
		return

	_tick_hero_statuses(hero_id)
	state = _get_hero_state(hero_id)
	if int(state.get("hp", 0)) <= 0:
		_update_interface()
		if _all_heroes_defeated():
			_player_defeated()
		return
	if _consume_hero_stun(hero_id):
		if is_instance_valid(combat_log_label):
			combat_log_label.text = (
				"%s está aturdido." % _hero_display_name(hero_id)
				if current_language == "es"
				else "%s is stunned." % _hero_display_name(hero_id)
			)
		_update_interface()
		return

	_tick_enemy_statuses()
	var alive_indices: Array[int] = _alive_enemy_indices()
	if alive_indices.is_empty():
		_resolve_party_attack_cycle()
		return
	var attack_data: Dictionary = _hero_attack_data(hero_id)
	var damage: int = maxi(1, int(attack_data.get("damage", 1)))
	var accent: Color = attack_data.get("accent", Color.WHITE)
	var critical: bool = bool(attack_data.get("critical", false))
	var area_attack: bool = bool(attack_data.get("area", false))
	_animate_party_member_attack(hero_id)
	var hit_count: int = 0
	if area_attack:
		for enemy_index: int in alive_indices.duplicate():
			_damage_wave_enemy(enemy_index, damage, accent, critical, attack_data)
			hit_count += 1
	else:
		var target_index: int = _select_enemy_target_for_hero(hero_id, alive_indices)
		if target_index >= 0:
			_damage_wave_enemy(target_index, damage, accent, critical, attack_data)
			hit_count = 1

	state = _get_hero_state(hero_id)
	var heal_amount: int = int(round(float(damage * hit_count) * float(attack_data.get("lifesteal_percent", 0.0)) / 100.0))
	heal_amount += int(round(float(state.get("max_hp", 1)) * float(attack_data.get("heal_percent", 0.0)) / 100.0))
	if heal_amount > 0:
		state["hp"] = mini(int(state.get("max_hp", 1)), int(state.get("hp", 0)) + heal_amount)
		_show_damage(heal_amount, _hero_card_position(hero_id) + Vector2(0, -30), Color("#75F0A6"))
	var shield_amount: int = int(attack_data.get("shield", 0))
	if shield_amount > 0:
		state["max_shield"] = maxi(int(state.get("max_shield", 0)), shield_amount)
		state["shield"] = mini(int(state["max_shield"]), int(state.get("shield", 0)) + shield_amount)
	hero_combat_states[hero_id] = state

	var shown_name: String = str(attack_data.get("skill_name", ""))
	if not shown_name.is_empty():
		var hero_card_variant: Variant = party_visual_cards.get(hero_id)
		if hero_card_variant is Control:
			var cast_effect_id: String = str(attack_data.get("status", ""))
			if cast_effect_id.is_empty():
				cast_effect_id = str(attack_data.get("skill", "skill"))
			_play_status_effect(hero_card_variant as Control, cast_effect_id, true)
		if is_instance_valid(mission_system) and mission_system.has_method("registrar_habilidad_usada"):
			mission_system.call("registrar_habilidad_usada")
	if is_instance_valid(combat_log_label):
		combat_log_label.text = shown_name if not shown_name.is_empty() else "%s golpea por %d" % [_hero_display_name(hero_id), damage]
	_sync_active_player_aliases_from_state()
	_resolve_party_attack_cycle()

func _on_enemy_entity_attack(enemy_index: int) -> void:
	if not combat_active or combat_resolution_locked:
		return
	if enemy_index < 0 or enemy_index >= current_enemy_wave.size():
		return
	var enemy_data: Dictionary = current_enemy_wave[enemy_index]
	if int(enemy_data.get("current_hp", 0)) <= 0:
		_stop_enemy_timer(enemy_index)
		return
	var target_hero_id: String = _select_hero_target_for_enemy(enemy_data)
	if target_hero_id.is_empty():
		_player_defeated()
		return
	var target_state: Dictionary = _get_hero_state(target_hero_id)
	var target_passive: Dictionary = _get_equipped_passive_totals(target_hero_id)
	var dodge_chance: float = clampf(float(skill_bonus_effects.get("dodge_chance", 0.0)) + float(target_passive.get("dodge_chance", 0.0)), 0.0, 55.0)
	_animate_enemy_entity_attack(enemy_index)
	if randf() * 100.0 < dodge_chance:
		if is_instance_valid(combat_log_label):
			combat_log_label.text = (
				"%s esquiva el ataque." % _hero_display_name(target_hero_id)
				if current_language == "es"
				else "%s dodges the attack." % _hero_display_name(target_hero_id)
			)
		_show_damage(0, _hero_card_position(target_hero_id) + Vector2(0, -20), Color("#7FDBFF"))
		return

	var enemy_base_damage: int = maxi(1, int(enemy_data.get("damage", 1)))
	var damage: int = randi_range(maxi(1, enemy_base_damage - 2), enemy_base_damage + 2)
	var used_ability: Dictionary = _roll_enemy_ability(enemy_data)
	var ability_message: String = ""
	if not used_ability.is_empty():
		_apply_enemy_ability(enemy_index, used_ability, target_hero_id)
		ability_message = SistemaCombateAvanzado.nombre_habilidad_enemiga(used_ability, current_language)
		target_state = _get_hero_state(target_hero_id)

	var statuses: Dictionary = {}
	var target_statuses_variant: Variant = target_state.get("statuses", {})
	if target_statuses_variant is Dictionary:
		statuses = target_statuses_variant as Dictionary
	var effective_defense: int = maxi(0, int(target_state.get("defense", 0)) - _hero_status_power(target_hero_id, "armor_break"))
	var mitigated_damage: int = maxi(1, int(round(float(damage) * 100.0 / (100.0 + float(effective_defense)))))
	var block_chance: float = clampf(float(skill_bonus_effects.get("block_chance", 0.0)) + float(target_passive.get("block_chance", 0.0)), 0.0, 70.0)
	if randf() * 100.0 < block_chance:
		mitigated_damage = maxi(1, int(round(float(mitigated_damage) * 0.5)))
	var reduction_percent: float = clampf(float(skill_bonus_effects.get("damage_reduction_percent", 0.0)) + float(target_passive.get("damage_reduction_percent", 0.0)), 0.0, 80.0)
	if int(target_state.get("max_hp", 1)) > 0 and float(target_state.get("hp", 0)) / float(target_state.get("max_hp", 1)) <= 0.35:
		reduction_percent += float(skill_bonus_effects.get("low_health_reduction_percent", 0.0))
	if statuses.has("curse"):
		reduction_percent -= float((statuses["curse"] as Dictionary).get("power", 0))
	reduction_percent = clampf(reduction_percent, -60.0, 85.0)
	mitigated_damage = maxi(1, int(round(float(mitigated_damage) * (1.0 - reduction_percent / 100.0))))

	var absorbed_by_shield: int = mini(int(target_state.get("shield", 0)), mitigated_damage)
	if absorbed_by_shield > 0:
		target_state["shield"] = int(target_state.get("shield", 0)) - absorbed_by_shield
		_show_damage(absorbed_by_shield, _hero_card_position(target_hero_id) + Vector2(0, -35), Color("#53B8FF"))
	var health_damage: int = maxi(0, mitigated_damage - absorbed_by_shield)
	target_state["hp"] = maxi(0, int(target_state.get("hp", 0)) - health_damage)
	hero_combat_states[target_hero_id] = target_state
	if not ability_message.is_empty():
		combat_log_label.text = "%s → %s · -%d" % [ability_message, _hero_display_name(target_hero_id), health_damage]
	else:
		combat_log_label.text = "%s golpea a %s por %d" % [SistemaCombateAvanzado.nombre_enemigo(enemy_data, current_language), _hero_display_name(target_hero_id), health_damage]
	if health_damage > 0:
		var target_card: Control = party_visual_cards.get(target_hero_id) as Control
		_show_damage(health_damage, _hero_card_position(target_hero_id) + Vector2(0, -20), Color("#FF7676"))
		if is_instance_valid(target_card):
			_flash_character(target_card, Color("#FF8B8B"))
	if int(target_state.get("hp", 0)) <= 0:
		var hero_timer: Variant = party_attack_timers.get(target_hero_id)
		if hero_timer is Timer:
			(hero_timer as Timer).stop()
	_sync_active_player_aliases_from_state()
	_update_interface()
	if _all_heroes_defeated():
		_player_defeated()

func _hero_display_name(hero_id: String) -> String:
	var profile: Dictionary = SistemaCombateAvanzado.perfil_heroe(hero_id, get_hero_level(hero_id), _get_hero_equipment_stats(hero_id))
	return str(profile.get("name_en" if current_language == "en" else "name_es", hero_id))

func _hero_card_position(hero_id: String) -> Vector2:
	var card_variant: Variant = party_visual_cards.get(hero_id)
	if card_variant is Control:
		return (card_variant as Control).position
	return PLAYER_BASE_POSITION

func _animate_enemy_entity_attack(enemy_index: int) -> void:
	if enemy_index < 0 or enemy_index >= enemy_visual_cards.size() or enemy_index >= current_enemy_wave.size():
		return
	var card: Panel = enemy_visual_cards[enemy_index]
	if is_instance_valid(card):
		var offset_x: float = -20.0 if str(current_enemy_wave[enemy_index].get("attack_range", "melee")) == "melee" else -7.0
		_animate_combat_card_lunge(card, Vector2(offset_x, -1.0))

func _tick_hero_statuses(hero_id: String) -> void:
	var state: Dictionary = _get_hero_state(hero_id)
	var statuses: Dictionary = {}
	var statuses_variant: Variant = state.get("statuses", {})
	if statuses_variant is Dictionary:
		statuses = (statuses_variant as Dictionary).duplicate(true)
	var updated: Dictionary = {}
	for status_id: Variant in statuses.keys():
		var data: Dictionary = statuses[status_id]
		var turns: int = int(data.get("turns", 0))
		var power: int = int(data.get("power", 0))
		if str(status_id) == "stun":
			updated[str(status_id)] = data
			continue
		if str(status_id) in ["poison", "bleed", "burn"] and power > 0:
			state["hp"] = maxi(0, int(state.get("hp", 0)) - power)
			_show_damage(power, _hero_card_position(hero_id) + Vector2(0, -26), _status_color(str(status_id)))
		turns -= 1
		if turns > 0:
			data["turns"] = turns
			updated[str(status_id)] = data
	state["statuses"] = updated
	hero_combat_states[hero_id] = state

func _consume_hero_stun(hero_id: String) -> bool:
	var state: Dictionary = _get_hero_state(hero_id)
	var statuses: Dictionary = {}
	var statuses_variant: Variant = state.get("statuses", {})
	if statuses_variant is Dictionary:
		statuses = (statuses_variant as Dictionary).duplicate(true)
	if not statuses.has("stun"):
		return false
	var data: Dictionary = statuses["stun"]
	var turns: int = int(data.get("turns", 1)) - 1
	if turns <= 0:
		statuses.erase("stun")
	else:
		data["turns"] = turns
		statuses["stun"] = data
	state["statuses"] = statuses
	hero_combat_states[hero_id] = state
	return true

func _hero_status_power(hero_id: String, status_id: String) -> int:
	var state: Dictionary = _get_hero_state(hero_id)
	var statuses: Dictionary = {}
	var statuses_variant: Variant = state.get("statuses", {})
	if statuses_variant is Dictionary:
		statuses = (statuses_variant as Dictionary).duplicate(true)
	if not statuses.has(status_id):
		return 0
	return int((statuses[status_id] as Dictionary).get("power", 0))

func _grant_party_xp(amount: int) -> void:
	var gained: int = maxi(0, amount)
	if gained <= 0:
		return
	var leveled_any: bool = false
	for hero_id: String in _get_party_hero_ids():
		var progress: Dictionary = _ensure_hero_progress(hero_id)
		progress["xp"] = int(progress.get("xp", 0)) + gained
		while int(progress.get("xp", 0)) >= int(progress.get("xp_required", HERO_BASE_XP_REQUIRED)):
			progress["xp"] = int(progress.get("xp", 0)) - int(progress.get("xp_required", HERO_BASE_XP_REQUIRED))
			progress["level"] = int(progress.get("level", 1)) + 1
			progress["xp_required"] = maxi(1, int(round(float(progress.get("xp_required", HERO_BASE_XP_REQUIRED)) * HERO_XP_GROWTH)))
			leveled_any = true
			if hero_id == _get_active_hero_id():
				_set_combat_message("level_up", [int(progress["level"])])
		hero_progress[hero_id] = progress
	if leveled_any:
		_rebuild_hero_combat_states(true)
		_refresh_party_attack_intervals()
		if is_instance_valid(skill_tree_ui) and skill_tree_ui.has_method("notify_player_level_changed"):
			skill_tree_ui.call_deferred("notify_player_level_changed")
	_sync_active_player_aliases_from_state()
	if is_instance_valid(inventory_ui) and inventory_ui.has_method("refresh_character_progression_ui"):
		inventory_ui.call_deferred("refresh_character_progression_ui")

func _get_enemy_for_phase(phase: int) -> Dictionary:
	if current_zone_id == ZONE_BRUMA:
		return _get_bruma_enemy_for_phase(phase)
	return _get_valdoria_enemy_for_phase(phase)

func _get_valdoria_enemy_for_phase(phase: int) -> Dictionary:
	if phase == _get_current_zone_phase_count():
		return {
			"name_key": "enemy_guardian",
			"rank": "boss",
			"hp": 1100,
			"damage": 42,
			"gold": 350,
			"xp": 420
		}

	if phase in [10, 20, 30, 40]:
		var milestone: int = int(floor(float(phase) / 10.0))
		var elite_name_key: String = "enemy_ancestral_bear"
		if milestone % 2 == 0:
			elite_name_key = "enemy_ruins_lord"

		return {
			"name_key": elite_name_key,
			"rank": "elite",
			"hp": 150 + phase * 10 + milestone * 35,
			"damage": 8 + int(floor(float(phase) * 0.55)),
			"gold": 25 + phase * 3,
			"xp": 30 + phase * 3
		}

	var normal_enemies: Array[Dictionary] = [
		{"name_key":"enemy_luminous_slime","hp":28,"damage":3,"gold":5,"xp":8},
		{"name_key":"enemy_road_bandit","hp":38,"damage":4,"gold":7,"xp":10},
		{"name_key":"enemy_valdoria_wolf","hp":43,"damage":5,"gold":8,"xp":11},
		{"name_key":"enemy_meadow_spider","hp":35,"damage":6,"gold":8,"xp":12},
		{"name_key":"enemy_ruins_raider","hp":49,"damage":6,"gold":10,"xp":13},
		{"name_key":"enemy_mist_boar","hp":58,"damage":7,"gold":11,"xp":14},
		{"name_key":"enemy_wandering_archer","hp":45,"damage":8,"gold":12,"xp":15}
	]

	return _scale_normal_enemy(normal_enemies, phase, 6, 8, 0)

func _get_bruma_enemy_for_phase(phase: int) -> Dictionary:
	if phase == _get_current_zone_phase_count():
		return {
			"name_key": "enemy_lord_of_veil",
			"rank": "boss",
			"hp": 2450,
			"damage": 68,
			"gold": 720,
			"xp": 850
		}

	if phase in [10, 20, 30, 40]:
		var milestone: int = int(floor(float(phase) / 10.0))
		var elite_name_key: String = (
			"enemy_fallen_paladin"
			if milestone % 2 == 1
			else "enemy_mist_giant"
		)
		return {
			"name_key": elite_name_key,
			"rank": "elite",
			"hp": 520 + phase * 17 + milestone * 80,
			"damage": 24 + int(floor(float(phase) * 0.72)),
			"gold": 70 + phase * 5,
			"xp": 82 + phase * 6
		}

	var bruma_enemies: Array[Dictionary] = [
		{"name_key":"enemy_mist_wraith","hp":120,"damage":14,"gold":24,"xp":28},
		{"name_key":"enemy_ash_hound","hp":145,"damage":16,"gold":27,"xp":31},
		{"name_key":"enemy_veiled_knight","hp":175,"damage":18,"gold":31,"xp":36},
		{"name_key":"enemy_cave_stalker","hp":132,"damage":21,"gold":32,"xp":38},
		{"name_key":"enemy_ruined_sentinel","hp":205,"damage":19,"gold":35,"xp":42},
		{"name_key":"enemy_fog_marauder","hp":164,"damage":23,"gold":38,"xp":45},
		{"name_key":"enemy_stone_spider","hp":150,"damage":25,"gold":40,"xp":48}
	]

	return _scale_normal_enemy(bruma_enemies, phase, 10, 7, 45)

func _scale_normal_enemy(
	enemies: Array[Dictionary],
	phase: int,
	hp_per_phase: int,
	tier_interval: int,
	base_hp_bonus: int
) -> Dictionary:
	var selected_index: int = (phase - 1) % enemies.size()
	var enemy_data: Dictionary = enemies[selected_index].duplicate(true)
	var tier: int = int(floor(float(phase - 1) / float(maxi(1, tier_interval))))

	enemy_data["rank"] = "normal"
	enemy_data["hp"] = int(enemy_data["hp"]) + base_hp_bonus + phase * hp_per_phase + tier * 28
	enemy_data["damage"] = int(enemy_data["damage"]) + tier * 4 + int(floor(float(phase) / 5.0))
	enemy_data["gold"] = int(enemy_data["gold"]) + phase * 2 + tier * 6
	enemy_data["xp"] = int(enemy_data["xp"]) + phase * 2 + tier * 7
	return enemy_data

func _begin_travel_to_enemy(first_encounter: bool = false) -> void:
	if world_completed:
		_show_world_completed_state()
		return

	combat_active = false
	is_traveling = true
	dragging_window = false

	if is_instance_valid(player_attack_timer):
		player_attack_timer.stop()

	if is_instance_valid(enemy_attack_timer):
		enemy_attack_timer.stop()
	_stop_party_timers()
	_stop_enemy_timers()

	_hide_enemy_interface()
	_start_walking_animation()

	phase_label.text = _build_stage_phase_text()
	_update_advanced_status()

	_set_combat_message(_get_travel_message_key(first_encounter))

	var travel_time: float = TRAVEL_DURATION

	if first_encounter:
		travel_time = FIRST_TRAVEL_DURATION

	await get_tree().create_timer(travel_time).timeout

	if not is_inside_tree():
		return

	if world_completed:
		_show_world_completed_state()
		return

	_stop_walking_animation()
	_spawn_phase_enemy()

func _hide_enemy_interface() -> void:
	if is_instance_valid(enemy_queue_strip):
		enemy_queue_strip.visible = false

	if is_instance_valid(enemy_name_label):
		enemy_name_label.visible = false

	if is_instance_valid(enemy_hp_bar):
		enemy_hp_bar.visible = false

	if is_instance_valid(enemy_hp_label):
		enemy_hp_label.visible = false

func _show_enemy_interface() -> void:
	if is_instance_valid(enemy_queue_strip):
		enemy_queue_strip.visible = true

	if is_instance_valid(enemy_visual):
		enemy_visual.visible = true

	# Los widgets globales quedan ocultos: la información vive en cada tarjeta.
	if is_instance_valid(enemy_name_label):
		enemy_name_label.visible = false
	if is_instance_valid(enemy_hp_bar):
		enemy_hp_bar.visible = false
	if is_instance_valid(enemy_hp_label):
		enemy_hp_label.visible = false

func _alive_enemy_indices() -> Array[int]:
	var result: Array[int] = []
	for index: int in range(current_enemy_wave.size()):
		var enemy_data: Dictionary = current_enemy_wave[index]
		if int(enemy_data.get("current_hp", int(enemy_data.get("hp", 0)))) > 0:
			result.append(index)
	return result

func _alive_enemy_count() -> int:
	return _alive_enemy_indices().size()

func _get_primary_enemy_index() -> int:
	var alive_indices: Array[int] = _alive_enemy_indices()
	return -1 if alive_indices.is_empty() else alive_indices[0]

func _sync_primary_enemy_from_wave() -> bool:
	var primary_index: int = _get_primary_enemy_index()
	if primary_index < 0 or primary_index >= current_enemy_wave.size():
		return false
	current_enemy_wave_index = primary_index
	current_enemy_data = current_enemy_wave[primary_index].duplicate(true)
	enemy_name_key = "__dynamic__"
	enemy_name = SistemaCombateAvanzado.nombre_enemigo(current_enemy_data, current_language)
	enemy_rank = str(current_enemy_data.get("rank", "normal"))
	enemy_max_hp = maxi(1, int(current_enemy_data.get("current_max_hp", current_enemy_data.get("hp", 1))))
	enemy_hp = clampi(int(current_enemy_data.get("current_hp", enemy_max_hp)), 0, enemy_max_hp)
	enemy_damage = maxi(1, int(current_enemy_data.get("damage", 1)))
	enemy_gold_reward = maxi(1, int(current_enemy_data.get("gold", 1)))
	enemy_xp_reward = maxi(1, int(current_enemy_data.get("xp", 1)))
	return true

func _write_primary_enemy_state() -> void:
	if current_enemy_wave_index < 0 or current_enemy_wave_index >= current_enemy_wave.size():
		return
	current_enemy_wave[current_enemy_wave_index]["current_hp"] = enemy_hp
	current_enemy_wave[current_enemy_wave_index]["current_max_hp"] = enemy_max_hp

func _select_primary_enemy_visual(primary_index: int) -> void:
	enemy_visual = null
	enemy_text_label = null
	if primary_index < 0:
		return
	if primary_index >= enemy_visual_cards.size():
		return

	var selected_card: Panel = enemy_visual_cards[primary_index]
	if not is_instance_valid(selected_card):
		return

	enemy_visual = selected_card
	enemy_visual_home_position = _combat_card_home_position(selected_card)
	if primary_index < enemy_visual_labels.size():
		var selected_label: Label = enemy_visual_labels[primary_index]
		if is_instance_valid(selected_label):
			enemy_text_label = selected_label

func _update_enemy_card_states() -> void:
	var primary_index: int = _get_primary_enemy_index()
	for index: int in range(enemy_visual_cards.size()):
		var card: Panel = enemy_visual_cards[index]
		if not is_instance_valid(card) or index >= current_enemy_wave.size():
			continue
		var enemy_data: Dictionary = current_enemy_wave[index]
		var current_hp_value: int = int(enemy_data.get("current_hp", int(enemy_data.get("hp", 0))))
		var maximum_hp_value: int = maxi(1, int(enemy_data.get("current_max_hp", enemy_data.get("hp", 1))))
		var state: String = "future"
		if current_hp_value <= 0:
			state = "defeated"
		elif index == primary_index:
			state = "active"
		var accent: Color = _enemy_card_accent(enemy_data, state)
		var background: Color = Color(0.22, 0.035, 0.045, 0.94)
		var border_width: int = 2
		card.scale = Vector2.ONE
		card.modulate = Color.WHITE
		var motion_value: Variant = combat_card_tweens.get(card.get_instance_id())
		if not (motion_value is Tween) or not (motion_value as Tween).is_valid():
			card.position = _combat_card_home_position(card)
		match state:
			"active":
				background = background.lightened(0.055)
				border_width = 3
			"defeated":
				background = Color(0.015, 0.035, 0.030, 0.78)
				card.modulate = Color(0.44, 0.55, 0.50, 0.62)
			_:
				background = background.darkened(0.12)
				card.modulate = Color(0.88, 0.88, 0.92, 0.94)
		card.add_theme_stylebox_override("panel", _make_combat_card_style(background, accent, border_width, 10, Color(accent.r, accent.g, accent.b, 0.20), 5))
		if index < enemy_visual_hp_bars.size() and is_instance_valid(enemy_visual_hp_bars[index]):
			_set_compact_pill_value(enemy_visual_hp_bars[index], current_hp_value, maximum_hp_value)
		if index < enemy_visual_hp_labels.size() and is_instance_valid(enemy_visual_hp_labels[index]):
			enemy_visual_hp_labels[index].text = "%d/%d" % [current_hp_value, maximum_hp_value]
		if index < enemy_visual_status_labels.size() and is_instance_valid(enemy_visual_status_labels[index]):
			enemy_visual_status_labels[index].text = _status_symbols(enemy_data.get("statuses", {}))
	_select_primary_enemy_visual(primary_index)

func _animate_party_member_attack(hero_id: String) -> void:
	var raw_card: Variant = party_visual_cards.get(hero_id)
	if raw_card is Control:
		var offset_x: float = 22.0 if str(_get_hero_state(hero_id).get("attack_range", "melee")) == "melee" else 7.0
		_animate_combat_card_lunge(raw_card as Control, Vector2(offset_x, -1.0))
func _hero_attack_data(hero_id: String) -> Dictionary:
	var equipment_stats: Dictionary = _get_hero_equipment_stats(hero_id)
	var level: int = get_hero_level(hero_id)
	var profile: Dictionary = SistemaCombateAvanzado.perfil_heroe(hero_id, level, equipment_stats)
	var state: Dictionary = _get_hero_state(hero_id)
	var base_damage: int = maxi(1, int(state.get("damage", profile.get("damage", 1))))
	var passive: Dictionary = _get_equipped_passive_totals(hero_id)
	base_damage = maxi(1, int(round(float(base_damage) * (1.0 + float(passive.get("holy_damage_percent", 0.0)) / 100.0))))
	var damage: int = randi_range(maxi(1, base_damage - 2), base_damage + 3)
	var critical_chance: float = float(skill_bonus_effects.get("critical_chance", 0.0)) + float(passive.get("critical_chance", 0.0))
	var critical: bool = randf() * 100.0 < critical_chance
	if critical:
		damage = maxi(1, int(round(float(damage) * (1.0 + float(skill_bonus_effects.get("critical_damage_percent", 50.0)) / 100.0))))

	var result: Dictionary = {
		"hero_id":hero_id,
		"damage":damage, "critical":critical, "area":false, "skill":"", "skill_name":"",
		"accent":profile.get("accent", Color.WHITE),
		"name":str(profile.get("name_en" if current_language == "en" else "name_es", hero_id)),
		"status":"", "status_chance":0.0, "status_power":0, "status_turns":0,
		"lifesteal_percent":float(passive.get("lifesteal_percent", 0.0)), "shield":0, "heal_percent":0.0,
		"attack_range":str(state.get("attack_range", "melee"))
	}
	var loadout: Dictionary = _get_equipped_skill_loadout(hero_id)
	var active_skills: Array = loadout.get("active", [])
	var now_ms: int = Time.get_ticks_msec()
	for raw_id: Variant in active_skills:
		var skill_id: String = str(raw_id)
		if skill_id.is_empty():
			continue
		var skill: Dictionary = SistemaHabilidadesEquipables.obtener_habilidad(skill_id)
		if skill.is_empty():
			continue
		var ready_at: int = int(equipped_skill_ready_at.get("%s:%s" % [hero_id, skill_id], 0))
		if now_ms < ready_at:
			continue
		var cooldown_reduction: float = clampf(float(passive.get("cooldown_reduction_percent", 0.0)), 0.0, 60.0)
		var cooldown: float = float(skill.get("cooldown", 10.0)) * (1.0 - cooldown_reduction / 100.0)
		equipped_skill_ready_at["%s:%s" % [hero_id, skill_id]] = now_ms + int(cooldown * 1000.0)
		damage = maxi(1, int(round(float(damage) * float(skill.get("multiplier", 1.0)))))
		result["damage"] = damage
		result["area"] = bool(skill.get("area", false))
		result["skill"] = skill_id
		result["skill_name"] = SistemaHabilidadesEquipables.obtener_nombre(skill_id, current_language)
		result["accent"] = Color(str(skill.get("accent", "#FFFFFF")))
		result["status"] = str(skill.get("status", ""))
		result["status_chance"] = float(skill.get("status_chance", 0.0))
		result["status_power"] = int(skill.get("status_power", 0))
		result["status_turns"] = int(skill.get("status_turns", 0))
		result["lifesteal_percent"] = float(result.get("lifesteal_percent", 0.0)) + float(skill.get("lifesteal_percent", 0.0))
		result["shield"] = int(skill.get("shield", 0)) + int(passive.get("shield_on_skill", 0))
		result["heal_percent"] = float(skill.get("heal_percent", 0.0))
		break
	return result

func _damage_wave_enemy(
	enemy_index: int,
	damage: int,
	accent: Color,
	critical: bool,
	attack_data: Dictionary = {}
) -> void:
	if enemy_index < 0 or enemy_index >= current_enemy_wave.size():
		return
	var enemy_data: Dictionary = current_enemy_wave[enemy_index]
	var previous_hp: int = int(enemy_data.get("current_hp", int(enemy_data.get("hp", 1))))
	if previous_hp <= 0:
		return
	var statuses: Dictionary = enemy_data.get("statuses", {})
	var final_damage: int = maxi(1, damage)
	if statuses.has("light_mark"):
		final_damage = maxi(1, int(round(float(final_damage) * (1.0 + float((statuses["light_mark"] as Dictionary).get("power", 15)) / 100.0))))
	if previous_hp <= int(float(enemy_data.get("current_max_hp", enemy_data.get("hp", 1))) * 0.30):
		var attacking_hero_id: String = str(attack_data.get("hero_id", _get_active_hero_id()))
		final_damage = maxi(1, int(round(float(final_damage) * (1.0 + float(_get_equipped_passive_totals(attacking_hero_id).get("execution_percent", 0.0)) / 100.0))))
	var final_hp: int = maxi(0, previous_hp - final_damage)
	current_enemy_wave[enemy_index]["current_hp"] = final_hp
	current_enemy_wave[enemy_index]["last_attacker"] = str(attack_data.get("hero_id", ""))
	if final_hp <= 0:
		_stop_enemy_timer(enemy_index)
	_apply_attack_status(enemy_index, attack_data)
	if enemy_index < enemy_visual_cards.size():
		var target_card: Panel = enemy_visual_cards[enemy_index]
		if is_instance_valid(target_card):
			_show_damage(final_damage, target_card.position + Vector2(randi_range(-8, 8), -18), Color("#FFF08A") if critical else accent)
			_flash_character(target_card, accent)

func _grant_enemy_defeat_rewards(enemy_index: int) -> bool:
	if enemy_index < 0 or enemy_index >= current_enemy_wave.size():
		return false
	var enemy_data: Dictionary = current_enemy_wave[enemy_index]
	if int(enemy_data.get("current_hp", 1)) > 0:
		return false
	if bool(enemy_data.get("reward_granted", false)):
		return false

	current_enemy_wave[enemy_index]["reward_granted"] = true
	var gold_value: int = maxi(1, int(enemy_data.get("gold", 1)))
	var xp_value: int = maxi(1, int(enemy_data.get("xp", 1)))
	var final_gold: int = maxi(
		1,
		int(
			round(
				float(gold_value)
				* (
					1.0
					+ float(skill_bonus_effects.get("gold_percent", 0.0))
					/ 100.0
				)
			)
		)
	)
	var final_xp: int = maxi(
		1,
		int(
			round(
				float(xp_value)
				* (
					1.0
					+ float(skill_bonus_effects.get("xp_percent", 0.0))
					/ 100.0
				)
			)
		)
	)
	wave_gold_reward += final_gold
	wave_xp_reward += final_xp

	if is_instance_valid(mission_system):
		mission_system.registrar_muerte(
			enemy_data,
			current_zone_id,
			current_difficulty
		)

	var heal_on_kill: int = maxi(
		0,
		int(skill_bonus_effects.get("heal_on_kill", 0))
	)
	var killer_id: String = str(enemy_data.get("last_attacker", _get_active_hero_id()))
	var killer_state: Dictionary = _get_hero_state(killer_id)
	if heal_on_kill > 0:
		killer_state["hp"] = mini(int(killer_state.get("max_hp", 1)), int(killer_state.get("hp", 0)) + heal_on_kill)

	var shield_on_kill: int = maxi(
		0,
		int(skill_bonus_effects.get("shield_on_kill", 0))
	)
	if shield_on_kill > 0:
		killer_state["max_shield"] = maxi(int(killer_state.get("max_shield", 0)), shield_on_kill)
		killer_state["shield"] = mini(int(killer_state["max_shield"]), int(killer_state.get("shield", 0)) + shield_on_kill)
	hero_combat_states[killer_id] = killer_state

	if bool(enemy_data.get("secret_boss", false)):
		_grant_guaranteed_legendary_reward()
	return true

func _resolve_party_attack_cycle() -> void:
	var defeated_any: bool = false
	for enemy_index: int in range(current_enemy_wave.size()):
		if _grant_enemy_defeat_rewards(enemy_index):
			defeated_any = true

	if _alive_enemy_count() <= 0:
		combat_active = false
		combat_resolution_locked = true
		_stop_party_timers()
		_stop_enemy_timers()
		_update_enemy_card_states()
		call_deferred("_finish_wave_after_party_attack")
		return

	_sync_primary_enemy_from_wave()
	_update_enemy_card_states()
	_update_enemy_visual_text()
	_update_advanced_status(false)
	_update_interface()
	if defeated_any:
		_set_combat_message("enemy_blocks")

func _finish_wave_after_party_attack() -> void:
	await get_tree().create_timer(0.30).timeout
	if not is_inside_tree():
		return
	if _alive_enemy_count() > 0:
		combat_resolution_locked = false
		combat_active = true
		return
	combat_resolution_locked = false
	_finish_enemy_wave()

func _spawn_phase_enemy() -> void:
	combat_resolution_locked = false
	if world_completed:
		_show_world_completed_state()
		return
	is_traveling = false
	_stop_walking_animation()
	current_enemy_wave = SistemaCombateAvanzado.crear_oleada(current_zone_id, current_phase, current_difficulty, combat_rng)
	for index: int in range(current_enemy_wave.size()):
		var wave_enemy: Dictionary = current_enemy_wave[index].duplicate(true)
		var max_hp_value: int = maxi(1, int(wave_enemy.get("hp", 1)))
		wave_enemy["current_max_hp"] = max_hp_value
		wave_enemy["current_hp"] = max_hp_value
		wave_enemy["statuses"] = {}
		current_enemy_wave[index] = wave_enemy
	current_enemy_wave_index = 0
	wave_gold_reward = 0
	wave_xp_reward = 0
	for hero_id: String in _get_party_hero_ids():
		var state: Dictionary = _get_hero_state(hero_id)
		state["statuses"] = {}
		hero_combat_states[hero_id] = state
	_refresh_enemy_attack_timers()
	_spawn_current_wave_enemy()

func _spawn_current_wave_enemy() -> void:
	if _alive_enemy_count() <= 0:
		_finish_enemy_wave()
		return
	if not _sync_primary_enemy_from_wave():
		_finish_enemy_wave()
		return

	_refresh_enemy_queue_visuals()
	if not is_instance_valid(enemy_visual):
		push_error("No se pudo crear la tarjeta visual del enemigo activo.")
		_finish_enemy_wave()
		return

	var entrance_target: Control = enemy_visual
	if not is_instance_valid(entrance_target):
		_finish_enemy_wave()
		return
	_stop_combat_card_motion(entrance_target, true)
	entrance_target.scale = Vector2(0.94, 0.94)
	entrance_target.position = enemy_visual_home_position + Vector2(0.0, -14.0)
	entrance_target.modulate = Color(1.0, 1.0, 1.0, 0.0)
	_update_enemy_visual_text()
	_show_enemy_interface()
	_update_interface()
	_update_advanced_status(false)
	_set_combat_message("enemy_appears")
	var entrance_tween: Tween = create_tween().bind_node(entrance_target)
	entrance_tween.set_trans(Tween.TRANS_BACK)
	entrance_tween.set_ease(Tween.EASE_OUT)
	entrance_tween.parallel().tween_property(entrance_target, "position", enemy_visual_home_position, ENEMY_ENTRY_DURATION)
	entrance_tween.parallel().tween_property(entrance_target, "scale", Vector2.ONE, ENEMY_ENTRY_DURATION)
	entrance_tween.parallel().tween_property(entrance_target, "modulate:a", 1.0, ENEMY_ENTRY_DURATION * 0.75)
	await entrance_tween.finished
	if not is_inside_tree():
		return

	if not is_instance_valid(enemy_visual):
		_refresh_enemy_queue_visuals()
	if not _sync_primary_enemy_from_wave():
		_finish_enemy_wave()
		return
	_update_enemy_visual_text()
	_set_combat_message("enemy_blocks")
	combat_active = true
	_start_party_timers()
	_start_enemy_timers()

func _on_player_attack() -> void:
	_on_hero_attack(_get_active_hero_id())

func _apply_active_hero_skill(base_damage: int) -> int:
	var hero_id: String = _get_active_hero_id()
	if not _is_hero_skill_unlocked(hero_id):
		return base_damage
	var now_ms: int = Time.get_ticks_msec()
	if now_ms < active_skill_ready_at_ms:
		return base_damage
	var level: int = get_hero_level(hero_id)
	var profile: Dictionary = SistemaCombateAvanzado.perfil_heroe(hero_id, level, _get_hero_equipment_stats(hero_id))
	active_skill_ready_at_ms = now_ms + int(float(profile.get("skill_cooldown", 10.0)) * 1000.0)
	match str(profile.get("skill", "")):
		"triple_shot":
			return base_damage * 3
		"arcane_rain":
			return int(round(float(base_damage) * 2.4 + float(_get_hero_state(hero_id).get("magic", 0))))
		"holy_aegis":
			var state: Dictionary = _get_hero_state(hero_id)
			var shield_value: int = 40 + level * 4
			state["max_shield"] = maxi(int(state.get("max_shield", 0)), shield_value)
			state["shield"] = mini(int(state["max_shield"]), int(state.get("shield", 0)) + shield_value)
			hero_combat_states[hero_id] = state
	return base_damage

func _on_enemy_attack() -> void:
	var primary_index: int = _get_primary_enemy_index()
	if primary_index >= 0:
		_on_enemy_entity_attack(primary_index)

func _defeat_enemy() -> void:

	if current_enemy_wave_index >= 0:
		if current_enemy_wave_index < current_enemy_wave.size():
			current_enemy_wave[current_enemy_wave_index]["current_hp"] = 0
	_resolve_party_attack_cycle()

func _finish_enemy_wave() -> void:
	_stop_party_timers()
	_stop_enemy_timers()
	combat_resolution_locked = false
	player_gold += wave_gold_reward
	_grant_party_xp(wave_xp_reward)
	if is_instance_valid(mission_system):
		mission_system.registrar_oro(wave_gold_reward)
	_set_combat_message("enemy_defeated", [wave_gold_reward, wave_xp_reward])
	if current_phase >= _get_current_zone_phase_count():
		await _complete_current_zone()
		return
	current_phase += 1
	if is_instance_valid(mission_system):
		mission_system.registrar_fase(current_zone_id, current_phase)
	_save_progress()
	_update_interface()
	await get_tree().create_timer(0.70).timeout
	if is_inside_tree():
		_begin_travel_to_enemy(false)

func _grant_guaranteed_legendary_reward() -> void:
	if not is_instance_valid(inventory_ui) or not inventory_ui.has_method("add_item"):
		return
	var reward: Dictionary = BaseDatosObjetos.generar_objeto_forzado("legendario", player_level, _get_active_hero_id(), current_zone_id)
	if reward.is_empty():
		return
	if bool(inventory_ui.call("add_item", reward)):
		if is_instance_valid(mission_system):
			mission_system.registrar_cofre(current_zone_id)
		combat_log_label.text = _text("legendary_reward")

func _grant_zone_completion_reward() -> void:
	if not is_instance_valid(inventory_ui) or not inventory_ui.has_method("add_item"):
		return
	var rarity: String = "legendario" if SistemaDificultad.normalizar(current_difficulty) == SistemaDificultad.INFERNO else "epico"
	var reward: Dictionary = BaseDatosObjetos.generar_objeto_forzado(rarity, player_level, _get_active_hero_id(), current_zone_id)
	if reward.is_empty():
		return
	if bool(inventory_ui.call("add_item", reward)):
		if is_instance_valid(mission_system):
			mission_system.registrar_cofre(current_zone_id)
		combat_log_label.text = ("Has obtenido un cofre garantizado de final de zona." if current_language == "es" else "You received a guaranteed zone-clear chest.")

func _complete_current_zone() -> void:
	world_completed = true
	_store_current_zone_state()
	var completed_data: Dictionary = _get_zone_progress_data(current_zone_id)
	completed_data["phase"] = _get_current_zone_phase_count()
	completed_data["completed"] = true
	completed_data["unlocked"] = true
	zone_progress[current_zone_id] = completed_data
	if is_instance_valid(mission_system):
		mission_system.registrar_zona_completada(current_zone_id, current_difficulty)
	_grant_zone_completion_reward()
	_restore_party_for_new_run()

	var next_zone: String = SistemaRegiones.obtener_siguiente_zona(current_zone_id)
	if not next_zone.is_empty():
		var next_data: Dictionary = _get_zone_progress_data(next_zone)
		next_data["unlocked"] = true
		zone_progress[next_zone] = next_data
	_save_progress()
	await get_tree().create_timer(0.75).timeout
	if not is_inside_tree():
		return
	if not next_zone.is_empty():
		phase_label.text = _get_zone_completed_title()
		_set_combat_message("transition_to_elaris" if next_zone == ZONE_ELARIS else "transition_to_bruma")
		if is_instance_valid(enemy_name_label):
			enemy_name_label.text = _text("guardian_defeated")
		await get_tree().create_timer(ZONE_TRANSITION_DELAY).timeout
		if is_inside_tree():
			_enter_zone(next_zone)
		return

	world_2_unlocked = true
	var next_difficulty: String = SistemaDificultad.siguiente_modo(current_difficulty)
	if not next_difficulty.is_empty() and not unlocked_difficulties.has(next_difficulty):
		unlocked_difficulties.append(next_difficulty)
	_save_progress()
	_show_world_completed_state()

func _enter_zone(zone_id: String) -> void:
	var normalized: String = SistemaRegiones.normalizar_zona(zone_id)
	if not is_zone_unlocked(normalized):
		return

	current_zone_id = normalized
	var target_data: Dictionary = _get_zone_progress_data(normalized)
	current_phase = clampi(
		int(target_data.get("phase", 1)),
		1,
		SistemaRegiones.obtener_fases(normalized)
	)
	world_completed = bool(target_data.get("completed", false))
	enemy_name = ""
	enemy_name_key = ""
	enemy_rank = "normal"
	_restore_party_for_new_run()
	_load_current_zone_background()
	_apply_visual_settings()
	_save_progress()
	_refresh_language()

	if world_completed:
		_show_world_completed_state()
	else:
		_begin_travel_to_enemy(true)

func _show_world_completed_state() -> void:
	combat_active = false
	is_traveling = false
	_stop_walking_animation()

	if is_instance_valid(player_attack_timer):
		player_attack_timer.stop()
	if is_instance_valid(enemy_attack_timer):
		enemy_attack_timer.stop()
	_stop_party_timers()
	_stop_enemy_timers()
	if is_instance_valid(enemy_queue_strip):
		enemy_queue_strip.visible = false
	elif is_instance_valid(enemy_visual):
		enemy_visual.visible = false

	phase_label.text = _get_zone_completed_title()
	_set_combat_message(_get_zone_completed_message_key())
	if is_instance_valid(enemy_name_label):
		enemy_name_label.text = _text("guardian_defeated")
	if is_instance_valid(enemy_hp_bar):
		enemy_hp_bar.max_value = 1
		enemy_hp_bar.value = 0
	if is_instance_valid(enemy_hp_label):
		enemy_hp_label.text = "0 / 0"
	_update_player_interface_only()

func _player_defeated() -> void:
	if not combat_active:
		return
	combat_active = false
	_stop_party_timers()
	_stop_enemy_timers()
	_set_combat_message("player_defeated")

	for hero_id: String in _get_party_hero_ids():
		var card_variant: Variant = party_visual_cards.get(hero_id)
		if card_variant is Control:
			var card: Control = card_variant as Control
			var tween: Tween = create_tween().bind_node(card)
			tween.tween_property(card, "scale", Vector2(0.25, 0.25), 0.35)

	await get_tree().create_timer(1.7).timeout
	if not is_inside_tree():
		return

	for hero_id: String in _get_party_hero_ids():
		var state: Dictionary = _get_hero_state(hero_id)
		state["hp"] = int(state.get("max_hp", 1))
		state["shield"] = 0
		state["statuses"] = {}
		hero_combat_states[hero_id] = state
	for index: int in range(current_enemy_wave.size()):
		var wave_enemy: Dictionary = current_enemy_wave[index]
		if int(wave_enemy.get("current_hp", 0)) > 0:
			current_enemy_wave[index]["current_hp"] = int(wave_enemy.get("current_max_hp", wave_enemy.get("hp", 1)))
	_sync_primary_enemy_from_wave()

	for card_variant: Variant in party_visual_cards.values():
		if card_variant is Control:
			var card: Control = card_variant as Control
			card.scale = Vector2.ONE
			card.modulate = Color.WHITE
	for enemy_card: Panel in enemy_visual_cards:
		if is_instance_valid(enemy_card):
			enemy_card.scale = Vector2.ONE
			enemy_card.modulate = Color.WHITE

	_set_combat_message("player_returns")
	_sync_active_player_aliases_from_state()
	_save_progress()
	_update_interface()
	await get_tree().create_timer(0.8).timeout
	if not is_inside_tree():
		return
	combat_active = true
	_start_party_timers()
	_start_enemy_timers()

func _check_level_up() -> void:
	# La experiencia se procesa de manera individual en _grant_party_xp().
	_sync_active_player_aliases_from_state()

func _update_interface() -> void:
	_update_player_interface_only()
	if is_instance_valid(enemy_hp_bar):
		enemy_hp_bar.max_value = enemy_max_hp
		enemy_hp_bar.value = enemy_hp
	if is_instance_valid(enemy_hp_label):
		enemy_hp_label.text = "%d / %d" % [enemy_hp, enemy_max_hp]
	if is_instance_valid(phase_label):
		phase_label.text = _build_stage_phase_text()
	_update_enemy_card_states()
	_update_compact_health_bars()

func _update_player_interface_only() -> void:
	_sync_active_player_aliases_from_state()
	if is_instance_valid(player_hp_bar):
		player_hp_bar.max_value = player_max_hp
		player_hp_bar.value = player_hp
	if is_instance_valid(player_hp_label):
		player_hp_label.text = "%d / %d" % [player_hp, player_max_hp]
	if is_instance_valid(information_label):
		information_label.text = (
			"Nivel %d  |  Oro %d" % [player_level, player_gold]
			if current_language == "es"
			else "Level %d  |  Gold %d" % [player_level, player_gold]
		)
	if is_instance_valid(experience_value_label):
		experience_value_label.text = "EXP"
	if is_instance_valid(experience_bar):
		_set_compact_pill_value(experience_bar, player_xp, player_xp_required)
		var xp_percent: int = int(round(100.0 * float(player_xp) / float(maxi(1, player_xp_required))))
		experience_bar.tooltip_text = "EXP %d / %d · %d%%" % [player_xp, player_xp_required, xp_percent]
	_update_compact_health_bars()

func _get_equipped_skill_loadout(hero_id: String) -> Dictionary:
	if is_instance_valid(inventory_ui) and inventory_ui.has_method("get_equipped_skills_for_character"):
		var value: Variant = inventory_ui.call("get_equipped_skills_for_character", hero_id)
		if value is Dictionary:
			return (value as Dictionary).duplicate(true)
	return SistemaHabilidadesEquipables.crear_carga_vacia()

func _get_equipped_passive_totals(hero_id: String) -> Dictionary:
	var totals: Dictionary = {}
	var loadout: Dictionary = _get_equipped_skill_loadout(hero_id)
	for passive: Dictionary in SistemaHabilidadesEquipables.obtener_pasivas(loadout):
		for key: Variant in passive.keys():
			if key in ["class", "type", "tier", "unlock_node", "name_es", "name_en", "desc_es", "desc_en", "symbol", "accent"]:
				continue
			var value: Variant = passive[key]
			if value is int or value is float:
				totals[str(key)] = float(totals.get(str(key), 0.0)) + float(value)
	return totals

func _apply_attack_status(enemy_index: int, attack_data: Dictionary) -> void:
	var status_id: String = str(attack_data.get("status", ""))
	if status_id.is_empty() or enemy_index < 0 or enemy_index >= current_enemy_wave.size():
		return
	if randf() * 100.0 > float(attack_data.get("status_chance", 0.0)):
		return
	var power: int = maxi(1, int(attack_data.get("status_power", 1)))
	var turns: int = maxi(1, int(attack_data.get("status_turns", 1)))
	var hero_id: String = str(attack_data.get("hero_id", _get_active_hero_id()))
	var passive: Dictionary = _get_equipped_passive_totals(hero_id)
	if status_id == "bleed":
		power = maxi(1, int(round(float(power) * (1.0 + float(passive.get("bleed_bonus_percent", 0.0)) / 100.0))))
		turns += int(passive.get("bleed_extra_turns", 0))
	elif status_id == "poison":
		power = maxi(1, int(round(float(power) * (1.0 + float(passive.get("poison_bonus_percent", 0.0)) / 100.0))))
	var statuses: Dictionary = current_enemy_wave[enemy_index].get("statuses", {})
	statuses[status_id] = {"power":power, "turns":turns}
	current_enemy_wave[enemy_index]["statuses"] = statuses
	if enemy_index < enemy_visual_cards.size():
		var target_card: Panel = enemy_visual_cards[enemy_index]
		if is_instance_valid(target_card):
			_play_status_effect(target_card, status_id, false)
	if is_instance_valid(mission_system) and mission_system.has_method("registrar_estado_aplicado"):
		mission_system.call("registrar_estado_aplicado", status_id)

func _tick_enemy_statuses() -> void:
	for enemy_index: int in range(current_enemy_wave.size()):
		var enemy_data: Dictionary = current_enemy_wave[enemy_index]
		if int(enemy_data.get("current_hp", 0)) <= 0:
			continue
		var statuses: Dictionary = enemy_data.get("statuses", {})
		var updated: Dictionary = {}
		for status_id: Variant in statuses.keys():
			var data: Dictionary = statuses[status_id]
			var turns: int = int(data.get("turns", 0))
			var power: int = int(data.get("power", 0))
			if str(status_id) in ["poison", "bleed", "burn"] and power > 0:
				var hp: int = maxi(0, int(enemy_data.get("current_hp", 0)) - power)
				current_enemy_wave[enemy_index]["current_hp"] = hp
				if enemy_index < enemy_visual_cards.size() and is_instance_valid(enemy_visual_cards[enemy_index]):
					_show_damage(power, enemy_visual_cards[enemy_index].position + Vector2(0, -12), _status_color(str(status_id)))
			turns -= 1
			if turns > 0 and int(current_enemy_wave[enemy_index].get("current_hp", 0)) > 0:
				data["turns"] = turns
				updated[str(status_id)] = data
		current_enemy_wave[enemy_index]["statuses"] = updated
	_update_enemy_card_states()

func _roll_enemy_ability(enemy_data: Dictionary) -> Dictionary:
	var raw: Variant = enemy_data.get("abilities", [])
	if not (raw is Array):
		return {}
	var difficulty_data: Dictionary = SistemaDificultad.obtener_datos(current_difficulty)
	var ability_multiplier: float = float(
		enemy_data.get(
			"ability_chance_multiplier",
			difficulty_data.get("ability_chance", 1.0)
		)
	)
	for ability_raw: Variant in raw:
		if not (ability_raw is Dictionary):
			continue
		var ability: Dictionary = ability_raw
		var final_chance: float = clampf(
			float(ability.get("chance", 0.0)) * ability_multiplier,
			0.0,
			85.0
		)
		if randf() * 100.0 <= final_chance:
			return ability.duplicate(true)
	return {}

func _apply_enemy_ability(enemy_index: int, ability: Dictionary, target_hero_id: String = "") -> void:
	if target_hero_id.is_empty():
		target_hero_id = _get_active_hero_id()
	var status_id: String = str(ability.get("type", ""))
	var power: int = maxi(1, int(ability.get("power", 1)))
	var turns: int = maxi(1, int(ability.get("turns", 1)))
	if status_id == "lifedrain":
		var heal: int = power
		if enemy_index >= 0 and enemy_index < current_enemy_wave.size():
			var maximum: int = maxi(1, int(current_enemy_wave[enemy_index].get("current_max_hp", 1)))
			current_enemy_wave[enemy_index]["current_hp"] = mini(maximum, int(current_enemy_wave[enemy_index].get("current_hp", 0)) + heal)
			if enemy_index < enemy_visual_cards.size():
				var drain_target: Panel = enemy_visual_cards[enemy_index]
				if is_instance_valid(drain_target):
					_play_status_effect(drain_target, "lifedrain", true)
		return
	var passive: Dictionary = _get_equipped_passive_totals(target_hero_id)
	if status_id in ["poison", "bleed"]:
		power = maxi(1, int(round(float(power) * (1.0 - float(passive.get("dot_resistance_percent", 0.0)) / 100.0))))
	elif status_id == "curse":
		power = maxi(1, int(round(float(power) * (1.0 - float(passive.get("curse_resistance_percent", 0.0)) / 100.0))))
	var state: Dictionary = _get_hero_state(target_hero_id)
	var statuses: Dictionary = {}
	var statuses_variant: Variant = state.get("statuses", {})
	if statuses_variant is Dictionary:
		statuses = (statuses_variant as Dictionary).duplicate(true)
	statuses[status_id] = {"power":power, "turns":turns}
	state["statuses"] = statuses
	hero_combat_states[target_hero_id] = state
	var card_variant: Variant = party_visual_cards.get(target_hero_id)
	if card_variant is Control:
		_play_status_effect(card_variant as Control, status_id, false)

func _tick_player_statuses() -> void:
	_tick_hero_statuses(_get_active_hero_id())

func _consume_player_stun() -> bool:
	return _consume_hero_stun(_get_active_hero_id())

func _player_status_power(status_id: String) -> int:
	return _hero_status_power(_get_active_hero_id(), status_id)

func _status_symbols(statuses_raw: Variant) -> String:
	if not (statuses_raw is Dictionary):
		return ""
	var statuses: Dictionary = statuses_raw
	var symbols: Array[String] = []
	for status_id: Variant in statuses.keys():
		match str(status_id):
			"poison": symbols.append("☠")
			"bleed": symbols.append("滴")
			"burn": symbols.append("♨")
			"curse": symbols.append("✦")
			"stun": symbols.append("✹")
			"armor_break": symbols.append("◇")
			"light_mark": symbols.append("☀")
	return " ".join(symbols)

func _status_color(status_id: String) -> Color:
	match status_id:
		"poison": return Color("#7BE66D")
		"bleed": return Color("#FF6F78")
		"burn": return Color("#FF9D55")
		"curse": return Color("#C98CFF")
		_: return Color("#FFF0A0")

func _effect_symbol(effect_id: String) -> String:
	match effect_id:
		"poison": return "☣"
		"bleed": return "滴"
		"burn": return "♨"
		"curse": return "✦"
		"stun": return "✹"
		"armor_break": return "◇"
		"light_mark", "pal_destello_sagrado", "pal_veredicto_solar", "pal_santuario": return "☀"
		"lifedrain", "mag_orbe_vampirico": return "♥"
		"arc_lluvia_tormenta": return "⚡"
		_: return "✧"

func _effect_color(effect_id: String, positive: bool) -> Color:
	if positive:
		match effect_id:
			"lifedrain", "mag_orbe_vampirico": return Color("#E18CFF")
			"poison": return Color("#8AE26D")
			"bleed": return Color("#FF7A85")
			_: return Color("#FFE58A")
	return _status_color(effect_id)

func _play_status_effect(target: Control, effect_id: String, positive: bool = false) -> void:
	if not is_instance_valid(target) or not is_instance_valid(interface_root):
		return
	var target_rect: Rect2 = target.get_global_rect()
	var root_rect: Rect2 = interface_root.get_global_rect()
	var center: Vector2 = target_rect.get_center() - root_rect.position
	var accent: Color = _effect_color(effect_id, positive)
	var glyph: String = _effect_symbol(effect_id)

	var pulse: Panel = Panel.new()
	pulse.position = center - Vector2(18.0, 18.0)
	pulse.size = Vector2(36.0, 36.0)
	pulse.mouse_filter = Control.MOUSE_FILTER_IGNORE
	pulse.z_index = 90
	pulse.pivot_offset = pulse.size / 2.0
	pulse.modulate = Color(accent.r, accent.g, accent.b, 0.0)
	pulse.add_theme_stylebox_override(
		"panel",
		_make_combat_card_style(
			Color(accent.r, accent.g, accent.b, 0.14),
			accent,
			2,
			18,
			Color(accent.r, accent.g, accent.b, 0.32),
			8
		)
	)
	interface_root.add_child(pulse)
	var pulse_tween: Tween = create_tween().bind_node(pulse)
	pulse_tween.set_trans(Tween.TRANS_QUAD)
	pulse_tween.set_ease(Tween.EASE_OUT)
	pulse_tween.parallel().tween_property(pulse, "scale", Vector2(2.15, 2.15), 0.48)
	pulse_tween.parallel().tween_property(pulse, "modulate:a", 0.95, 0.10)
	pulse_tween.tween_property(pulse, "modulate:a", 0.0, 0.28)
	pulse_tween.tween_callback(Callable(pulse, "queue_free"))

	for index: int in range(7):
		var particle: Label = _create_label(
			interface_root,
			glyph,
			center - Vector2(12.0, 12.0),
			Vector2(24.0, 24.0),
			13,
			HORIZONTAL_ALIGNMENT_CENTER,
			accent
		)
		particle.z_index = 95
		particle.pivot_offset = particle.size / 2.0
		particle.modulate.a = 0.0
		var angle: float = TAU * float(index) / 7.0 + randf_range(-0.18, 0.18)
		var distance: float = randf_range(22.0, 43.0)
		var destination: Vector2 = particle.position + Vector2(cos(angle), sin(angle)) * distance
		var particle_tween: Tween = create_tween().bind_node(particle)
		particle_tween.set_trans(Tween.TRANS_QUAD)
		particle_tween.set_ease(Tween.EASE_OUT)
		particle_tween.parallel().tween_property(particle, "position", destination, 0.52)
		particle_tween.parallel().tween_property(particle, "rotation", randf_range(-0.8, 0.8), 0.52)
		particle_tween.parallel().tween_property(particle, "modulate:a", 1.0, 0.10)
		particle_tween.tween_property(particle, "modulate:a", 0.0, 0.24)
		particle_tween.tween_callback(Callable(particle, "queue_free"))

func _update_compact_health_bars() -> void:
	for hero_id_variant: Variant in party_visual_hp_bars.keys():
		var hero_id: String = str(hero_id_variant)
		var state: Dictionary = _get_hero_state(hero_id)
		var hp_value: int = int(state.get("hp", 0))
		var max_hp_value: int = maxi(1, int(state.get("max_hp", 1)))
		var bar_variant: Variant = party_visual_hp_bars.get(hero_id)
		if bar_variant is Control:
			_set_compact_pill_value(bar_variant as Control, hp_value, max_hp_value)
		var shield_variant: Variant = party_visual_shield_bars.get(hero_id)
		if shield_variant is Control:
			var shield_bar: Control = shield_variant as Control
			var max_shield: int = int(state.get("max_shield", 0))
			var shield: int = int(state.get("shield", 0))
			shield_bar.visible = max_shield > 0 and shield > 0
			_set_compact_pill_value(shield_bar, shield, maxi(1, max_shield))
		var hp_text: Label = party_visual_hp_labels.get(hero_id) as Label
		if is_instance_valid(hp_text):
			hp_text.text = "%d/%d" % [hp_value, max_hp_value]
		var status_text: Label = party_visual_status_labels.get(hero_id) as Label
		if is_instance_valid(status_text):
			status_text.text = _status_symbols(state.get("statuses", {}))
		var card_variant: Variant = party_visual_cards.get(hero_id)
		if card_variant is Control:
			var card: Control = card_variant as Control
			if hp_value <= 0:
				card.modulate = Color(0.48, 0.48, 0.52, 0.62)
			elif card.modulate.a < 0.95:
				card.modulate = Color.WHITE
	_update_enemy_card_states()

func _start_walking_animation() -> void:
	_stop_walking_animation()

	if not is_instance_valid(player_visual):
		return

	var walking_target: Control = player_visual
	_stop_combat_card_motion(walking_target, true)
	player_visual_home_position = _combat_card_home_position(walking_target)
	walking_target.position = player_visual_home_position
	walking_target.scale = Vector2.ONE

	walking_tween = create_tween().bind_node(walking_target)
	walking_tween.set_loops()
	walking_tween.set_trans(Tween.TRANS_SINE)
	walking_tween.set_ease(Tween.EASE_IN_OUT)

	walking_tween.tween_property(
		walking_target,
		"position",
		player_visual_home_position + Vector2(5.0, -3.0),
		0.16
	)
	walking_tween.tween_property(
		walking_target,
		"position",
		player_visual_home_position + Vector2(11.0, 0.0),
		0.16
	)
	walking_tween.tween_property(
		walking_target,
		"position",
		player_visual_home_position + Vector2(5.0, -3.0),
		0.16
	)
	walking_tween.tween_property(
		walking_target,
		"position",
		player_visual_home_position,
		0.16
	)

func _stop_walking_animation() -> void:
	if walking_tween != null and walking_tween.is_valid():
		walking_tween.kill()
	walking_tween = null

	if is_instance_valid(player_visual):
		player_visual.position = player_visual_home_position
		player_visual.scale = Vector2.ONE

func _animate_player_attack() -> void:
	if is_instance_valid(player_visual):
		_animate_combat_card_lunge(player_visual, Vector2(26.0, -1.0))
func _animate_enemy_attack() -> void:
	if is_instance_valid(enemy_visual):
		_animate_combat_card_lunge(enemy_visual, Vector2(-24.0, -1.0))
func _animate_enemy_group_attack() -> void:
	for enemy_index: int in _alive_enemy_indices():
		if enemy_index < 0 or enemy_index >= enemy_visual_cards.size():
			continue
		var target: Panel = enemy_visual_cards[enemy_index]
		if is_instance_valid(target):
			_animate_combat_card_lunge(target, Vector2(-16.0, -1.0))
func _animate_enemy_defeat() -> void:
	if not is_instance_valid(enemy_visual):
		return
	var target: Control = enemy_visual
	var tween: Tween = create_tween().bind_node(target)
	tween.set_trans(Tween.TRANS_BACK)
	tween.set_ease(Tween.EASE_IN)
	tween.parallel().tween_property(target, "scale", Vector2(0.1, 0.1), 0.42)
	tween.parallel().tween_property(target, "modulate:a", 0.0, 0.36)

func _flash_character(character: Control, flash_color: Color) -> void:
	if not is_instance_valid(character):
		return
	character.modulate = flash_color
	var tween: Tween = create_tween().bind_node(character)
	tween.tween_property(character, "modulate", Color.WHITE, 0.22)

func _show_damage(
	damage: int,
	start_position: Vector2,
	damage_color: Color
) -> void:
	var damage_label: Label = Label.new()

	damage_label.text = "-%d" % damage
	damage_label.position = start_position
	damage_label.size = Vector2(100, 30)

	damage_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	damage_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER

	damage_label.add_theme_font_size_override(
		"font_size",
		20
	)

	damage_label.add_theme_color_override(
		"font_color",
		damage_color
	)

	damage_label.add_theme_color_override(
		"font_shadow_color",
		Color.BLACK
	)

	damage_label.add_theme_constant_override(
		"shadow_offset_x",
		1
	)

	damage_label.add_theme_constant_override(
		"shadow_offset_y",
		1
	)

	damage_label.mouse_filter = Control.MOUSE_FILTER_IGNORE

	interface_root.add_child(damage_label)

	var tween: Tween = create_tween().bind_node(damage_label)

	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_OUT)

	tween.parallel().tween_property(
		damage_label,
		"position",
		start_position - Vector2(0, 42),
		0.65
	)

	tween.parallel().tween_property(
		damage_label,
		"modulate:a",
		0.0,
		0.65
	)

	tween.tween_callback(
		damage_label.queue_free
	)

func _create_label(
	parent: Control,
	label_text: String,
	label_position: Vector2,
	label_size: Vector2,
	font_size: int,
	alignment: HorizontalAlignment,
	font_color: Color = Color.WHITE
) -> Label:
	var label: Label = Label.new()

	label.text = label_text
	label.position = label_position
	label.size = label_size
	label.horizontal_alignment = alignment
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS

	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", font_color)
	label.add_theme_constant_override("outline_size", 2 if font_size >= 12 else 1)
	label.add_theme_color_override("font_outline_color", Color(0.0, 0.0, 0.0, 0.92))
	label.set_meta("ui_font_role", "title" if font_size >= 14 else "body")

	var game_ui: Node = get_node_or_null("/root/GameUI")
	if game_ui != null:
		if font_size >= 14 and game_ui.has_method("get_bold_pixel_font"):
			label.add_theme_font_override("font", game_ui.call("get_bold_pixel_font"))
		elif game_ui.has_method("get_pixel_font"):
			label.add_theme_font_override("font", game_ui.call("get_pixel_font"))

	label.mouse_filter = Control.MOUSE_FILTER_IGNORE

	parent.add_child(label)

	return label

func _create_icon_button(
	parent: Control,
	icon_text: String,
	button_position: Vector2,
	button_size: Vector2,
	icon_font_size: int,
	danger_style: bool,
	icon_vertical_offset: float
) -> Button:
	var button: Button = Button.new()

	button.text = ""
	button.position = button_position
	button.size = button_size
	button.custom_minimum_size = button_size
	button.focus_mode = Control.FOCUS_NONE

	var normal_style: StyleBoxFlat = StyleBoxFlat.new()

	normal_style.border_width_left = 1
	normal_style.border_width_top = 1
	normal_style.border_width_right = 1
	normal_style.border_width_bottom = 1

	normal_style.corner_radius_top_left = 4
	normal_style.corner_radius_top_right = 4
	normal_style.corner_radius_bottom_left = 4
	normal_style.corner_radius_bottom_right = 4

	if danger_style:
		normal_style.bg_color = Color(
			0.24,
			0.035,
			0.045,
			0.96
		)

		normal_style.border_color = Color(
			0.96,
			0.28,
			0.32,
			0.90
		)
	else:
		normal_style.bg_color = Color(
			0.025,
			0.16,
			0.11,
			0.96
		)

		normal_style.border_color = Color(
			0.15,
			0.82,
			0.56,
			0.90
		)

	var hover_style: StyleBoxFlat = (
		normal_style.duplicate() as StyleBoxFlat
	)

	if danger_style:
		hover_style.bg_color = Color(
			0.50,
			0.06,
			0.08,
			1.0
		)

		hover_style.border_color = Color("#FF9A9A")
	else:
		hover_style.bg_color = Color(
			0.05,
			0.34,
			0.23,
			1.0
		)

		hover_style.border_color = Color("#7DFFD0")

	var pressed_style: StyleBoxFlat = (
		normal_style.duplicate() as StyleBoxFlat
	)

	if danger_style:
		pressed_style.bg_color = Color(
			0.32,
			0.025,
			0.04,
			1.0
		)
	else:
		pressed_style.bg_color = Color(
			0.025,
			0.22,
			0.15,
			1.0
		)

	button.add_theme_stylebox_override(
		"normal",
		normal_style
	)

	button.add_theme_stylebox_override(
		"hover",
		hover_style
	)

	button.add_theme_stylebox_override(
		"pressed",
		pressed_style
	)

	parent.add_child(button)

	var icon_label: Label = Label.new()

	icon_label.text = icon_text
	icon_label.position = Vector2(0.0, icon_vertical_offset)
	icon_label.size = button_size
	icon_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	icon_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	icon_label.mouse_filter = Control.MOUSE_FILTER_IGNORE

	icon_label.add_theme_font_size_override(
		"font_size",
		icon_font_size
	)

	icon_label.add_theme_font_override(
		"font",
		symbol_font
	)

	if danger_style:
		icon_label.add_theme_color_override(
			"font_color",
			Color("#FFE0E0")
		)
	else:
		icon_label.add_theme_color_override(
			"font_color",
			Color("#E0FFF4")
		)

	button.add_child(icon_label)

	return button

func _create_character_panel(
	panel_position: Vector2,
	panel_size: Vector2,
	background_color: Color,
	border_color: Color
) -> Panel:
	var panel: Panel = Panel.new()

	panel.position = panel_position
	panel.size = panel_size
	panel.mouse_filter = Control.MOUSE_FILTER_IGNORE

	var panel_style: StyleBoxFlat = StyleBoxFlat.new()

	panel_style.bg_color = background_color
	panel_style.border_width_left = 2
	panel_style.border_width_top = 2
	panel_style.border_width_right = 2
	panel_style.border_width_bottom = 2
	panel_style.border_color = border_color
	panel_style.corner_radius_top_left = 12
	panel_style.corner_radius_top_right = 12
	panel_style.corner_radius_bottom_left = 12
	panel_style.corner_radius_bottom_right = 12

	panel.add_theme_stylebox_override(
		"panel",
		panel_style
	)

	interface_root.add_child(panel)

	return panel

func _create_health_bar(
	bar_position: Vector2,
	bar_size: Vector2,
	fill_color: Color
) -> ProgressBar:
	var bar: ProgressBar = ProgressBar.new()
	bar.position = bar_position
	bar.size = bar_size
	bar.min_value = 0
	bar.max_value = 100
	bar.value = 100
	bar.show_percentage = false
	bar.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var radius: int = maxi(0, int(floor(bar_size.y * 0.5)))
	var background_style: StyleBoxFlat = StyleBoxFlat.new()
	background_style.bg_color = Color(0.01, 0.02, 0.03, 0.92)
	background_style.set_corner_radius_all(radius)
	var fill_style: StyleBoxFlat = StyleBoxFlat.new()
	fill_style.bg_color = fill_color
	fill_style.set_corner_radius_all(radius)
	bar.add_theme_stylebox_override("background", background_style)
	bar.add_theme_stylebox_override("fill", fill_style)
	interface_root.add_child(bar)
	return bar

func _close_game() -> void:
	is_traveling = false
	_stop_walking_animation()
	_save_settings()
	_save_progress()
	get_tree().quit()
