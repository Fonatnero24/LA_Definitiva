extends Control
class_name InventarioUI

signal inventory_changed
signal item_equipped(item_id: String, equipment_slot: String)
signal item_unequipped(item_id: String, equipment_slot: String)
signal item_used(item_id: String)
signal inventory_opened
signal inventory_closed

@export_group("Recursos")
@export_file("*.png") var inventory_background_path: String = (
	"res://Recursos/UI/Inventario/inventario_rpg_base.png"
)
@export_file("*.png") var character_texture_path: String = (
	"res://Recursos/Personajes/Paladin/Seleccion/Idle/Paladin1.png"
)

@export_group("Animación idle")
@export var enable_character_idle_animation: bool = true
@export_range(0.05, 1.0, 0.01) var character_idle_frame_seconds: float = 0.18
@export_range(1, 32, 1) var character_idle_max_frames: int = 24

@export_group("Ventana de inventario")
@export var usar_ventana_independiente: bool = true
@export var inventory_window_size: Vector2i = Vector2i(1254, 706)
@export var separacion_del_juego: int = 10
@export var start_open: bool = false
@export var show_open_button: bool = false

@export_group("Movimiento de ventana")
@export var permitir_mover_ventana: bool = true
@export_range(20.0, 100.0, 1.0) var altura_arrastre_ventana: float = 46.0
@export var tamano_vista_arrastre: Vector2i = Vector2i(104, 104)

@export_group("Botón de inventario")
@export var integrar_boton_en_barra_superior: bool = false
@export var posicion_boton_barra: Vector2 = Vector2(231.0, 7.0)
@export var tamano_boton_barra: Vector2 = Vector2(20.0, 20.0)
@export var simbolo_boton_inventario: String = "▦"

@export_group("Inventario")
@export_range(8, 80, 1) var maximum_slots: int = 40
@export var add_demo_items: bool = false
@export var starting_gold: int = 240


const REFERENCE_SIZE: Vector2 = Vector2(1672.0, 941.0)

const VISIBLE_UI_BOUNDS: Rect2 = Rect2(0.0, 0.0, 1672.0, 941.0)
const SAVE_PATH: String = "user://inventario.cfg"
const CHARACTER_SAVE_PATH: String = "user://partida.cfg"
const SKILL_SAVE_PATH: String = "user://habilidades.cfg"
const SETTINGS_PATH: String = "user://opciones.cfg"
const INVENTORY_BACKGROUND_FALLBACKS: Array[String] = [
	"res://Recursos/UI/Inventario/inventario_rpg_base.png",
	"res://Recursos/UI/inventario_base_recortado.png",
	"res://Recursos/UI/inventario_base_transparente.png",
	"res://Recursos/UI/Inventario/inventario_base_recortado.png",
	"res://Recursos/UI/Inventario/inventario_base_transparente.png"
]
const DRAG_THRESHOLD: float = 7.0

const CATEGORY_EQUIPMENT: String = "equipo"
const CATEGORY_OBJECTS: String = "objetos"
const CATEGORY_MATERIALS: String = "materiales"
const CATEGORY_QUESTS: String = "misiones"
const CATEGORY_SKILLS: String = "habilidades"
const CLOSE_ICON_PATH: String = "res://Recursos/UI/IconosBarra/cerrar.png"

const EQUIPMENT_SLOT_ORDER: Array[String] = [
	"casco",
	"armadura",
	"guantes",
	"botas",
	"arma",
	"estandarte",
	"amuleto",
	"reliquia",
	"anillo_1",
	"anillo_2",
	"escudo"
]

const EQUIPMENT_PLACEHOLDER_PATHS: Dictionary = {
	"casco": "res://Recursos/UI/Inventario/Slots/casco.png",
	"armadura": "res://Recursos/UI/Inventario/Slots/armadura.png",
	"guantes": "res://Recursos/UI/Inventario/Slots/guantes.png",
	"botas": "res://Recursos/UI/Inventario/Slots/botas.png",
	"espada": "res://Recursos/UI/Inventario/Slots/espada.png",
	"arco": "res://Recursos/UI/Inventario/Slots/arco.png",
	"vara": "res://Recursos/UI/Inventario/Slots/vara.png",
	"estandarte": "res://Recursos/UI/Inventario/Slots/estandarte.png",
	"escudo": "res://Recursos/UI/Inventario/Slots/escudo.png",
	"amuleto": "res://Recursos/UI/Inventario/Slots/amuleto.png",
	"reliquia": "res://Recursos/UI/Inventario/Slots/estandarte.png",
	"anillo": "res://Recursos/UI/Inventario/Slots/anillo.png"
}

const EQUIPMENT_SLOT_RECTS: Dictionary = {
	"casco": Rect2(192.0, 172.0, 86.0, 74.0),
	"armadura": Rect2(192.0, 252.0, 86.0, 74.0),
	"guantes": Rect2(192.0, 332.0, 86.0, 74.0),
	"botas": Rect2(192.0, 412.0, 86.0, 74.0),
	"arma": Rect2(554.0, 172.0, 86.0, 74.0),
	"estandarte": Rect2(554.0, 252.0, 86.0, 74.0),
	"amuleto": Rect2(554.0, 332.0, 86.0, 74.0),
	"reliquia": Rect2(554.0, 412.0, 86.0, 74.0),
	"anillo_1": Rect2(296, 473, 78, 74),
	"anillo_2": Rect2(387, 474, 74, 74),
	"escudo": Rect2(471, 474, 74, 74)
}

const EQUIPMENT_VISUAL_INSET: float = 0.0
const EQUIPMENT_FALLBACK_INSET: float = 7.0

const TAB_RECTS: Array[Rect2] = [
	Rect2(774.0, 160.0, 136.0, 45.0),
	Rect2(918.0, 160.0, 136.0, 45.0),
	Rect2(1062.0, 160.0, 136.0, 45.0),
	Rect2(1206.0, 160.0, 136.0, 45.0),
	Rect2(1350.0, 160.0, 150.0, 45.0)
]

const TAB_DATA: Array[Dictionary] = [
	{"id": CATEGORY_EQUIPMENT, "text_key": "category_equipment"},
	{"id": CATEGORY_OBJECTS, "text_key": "category_objects"},
	{"id": CATEGORY_MATERIALS, "text_key": "category_materials"},
	{"id": CATEGORY_QUESTS, "text_key": "category_quests"},
	{"id": CATEGORY_SKILLS, "text_key": "category_skills"}
]

var inventory_translations: Dictionary = {
	"es": {
			"inventory_title": "INVENTARIO",
			"inventory_subtitle": "EQUIPO DEL CAMPEÓN",
			"window_title": "Inventario del Campeón",
			"open_inventory": "Abrir inventario [I]",
			"close": "Cerrar",
			"category_equipment": "EQUIPO",
			"category_objects": "OBJETOS",
			"category_materials": "MATERIALES",
			"category_quests": "MISIONES",
			"category_skills": "HABILIDADES",
			"skills_title": "HABILIDADES EQUIPADAS",
			"skills_hint": "Desbloquéalas en el Árbol Astral. Pulsa una habilidad para equiparla o retirarla.",
			"active_skills": "ACTIVAS · 2 HUECOS",
			"passive_skills": "PASIVAS · 3 HUECOS",
			"available_skills": "DESBLOQUEADAS",
			"no_skills": "Todavía no has desbloqueado habilidades para esta clase.",
			"slot_relic": "RELIQUIA",
			"character_locked": "Personaje bloqueado",
			"unlock_character": "Haz clic para gastar una ficha y desbloquear a %s.",
			"need_character_token": "Necesitas desbloquear una ficha de personaje en el árbol de habilidades.",
			"character_unlocked": "Has desbloqueado a %s.",
			"character_selected": "Ahora controlas a %s.",
			"character_switch_full": "No hay espacio para guardar el equipo incompatible con este personaje.",
			"attributes": "ATRIBUTOS",
			"hero_progress": "NIVEL %d · EXP %d / %d",
			"stat_health": "VIDA",
			"stat_damage": "DAÑO",
			"stat_defense": "DEF",
			"stat_speed": "VEL",
			"stat_magic": "MAGIA",
			"no_selection": "Ningún objeto seleccionado",
			"drag_to_equip": "Arrastra un objeto para equiparlo",
			"equip": "EQUIPAR",
			"use": "USAR",
			"sort": "ORDENAR",
			"remove": "QUITAR",
			"incompatible": "NO COMPATIBLE",
			"empty_slot": "Casilla vacía",
			"unknown_item": "Objeto desconocido",
			"generic_item": "Objeto",
			"unique_item": "Objeto único",
			"rarity_level": "%s · NIVEL %d",
			"effects": "EFECTOS",
			"origin": "ORIGEN: %s",
			"class_label": "CLASE: ",
			"heal_effect": "• Al usarlo: recupera %d de vida",
			"max_health_effect": "• +%d Vida máxima",
			"damage_effect": "• +%d Daño por ataque",
			"defense_effect": "• +%d Defensa (reduce el daño recibido)",
			"speed_effect": "• +%d Velocidad (ataca con mayor frecuencia)",
			"magic_effect": "• +%d Poder mágico",
			"unique_power": "Poder único",
			"periodic_shield": "Cada %d s obtienes un escudo azul de %d puntos.",
			"generic_unique": "Este objeto posee un poder único.",
			"unique_passive": "PASIVA ÚNICA — %s\n%s",
			"rarity_common": "COMÚN",
			"rarity_uncommon": "POCO COMÚN",
			"rarity_rare": "RARO",
			"rarity_epic": "ÉPICO",
			"rarity_legendary": "LEGENDARIO",
			"rarity_mythic": "MÍTICO",
			"rarity_ancestral": "ANCESTRAL",
			"rarity_unique": "ÚNICO",
			"slot_helmet": "Casco",
			"slot_armor": "Armadura",
			"slot_gloves": "Guantes",
			"slot_boots": "Botas",
			"slot_weapon": "Arma",
			"slot_shield": "Escudo",
			"slot_banner": "Estandarte",
			"level_required": "REQUIERE NIVEL %d",
			"level_too_low": "Necesitas nivel %d para equipar %s",
			"slot_amulet": "Amuleto",
			"slot_ring1": "Anillo 1",
			"slot_ring2": "Anillo 2",
			"slot_accessory": "Accesorio",
			"class_paladin": "Paladín",
			"class_archer": "Arquero",
			"class_arcanist": "Arcanista",
			"class_knight": "Caballero",
			"class_assassin": "Asesino",
			"class_necromancer": "Nigromante",
			"cannot_use": "%s no puede usar %s",
			"shield_paladin_only": "Los escudos son exclusivos del Paladín",
			"archer_bows_only": "El Arquero solo puede usar arcos",
			"magic_weapons_only": "%s solo puede usar armas mágicas",
			"assassin_daggers_only": "El Asesino solo puede usar dagas",
			"sword_classes_only": "%s solo puede usar espadas o mandobles",
			"inventory_full": "El inventario está lleno",
			"missing_image": "No se encontró la imagen del inventario: ",
			"no_item_id": "No se puede añadir un objeto sin id.",
			"save_failed": "No se pudo guardar el inventario.",
			"transparency_unsupported": "El sistema no admite transparencia de ventana.",
			"mission_title": "TABLÓN DE MISIONES",
			"mission_claim": "RECLAMAR",
			"mission_claimed": "RECLAMADA",
			"mission_progress": "%d / %d",
			"mission_hint": "Acepta encargos, cacerías y contratos de forja para ganar cofres y puntos de habilidad.",
			"mission_claim_success": "Recompensa reclamada: %s",
			"mission_in_progress": "Misión en progreso: %s"
	},
	"en": {
			"inventory_title": "INVENTORY",
			"inventory_subtitle": "CHAMPION EQUIPMENT",
			"window_title": "Champion Inventory",
			"open_inventory": "Open inventory [I]",
			"close": "Close",
			"category_equipment": "EQUIPMENT",
			"category_objects": "ITEMS",
			"category_materials": "MATERIALS",
			"category_quests": "QUESTS",
			"category_skills": "SKILLS",
			"skills_title": "EQUIPPED SKILLS",
			"skills_hint": "Unlock them in the Astral Tree. Select a skill to equip or remove it.",
			"active_skills": "ACTIVE · 2 SLOTS",
			"passive_skills": "PASSIVE · 3 SLOTS",
			"available_skills": "UNLOCKED",
			"no_skills": "You have not unlocked skills for this class yet.",
			"slot_relic": "RELIC",
			"character_locked": "Character locked",
			"unlock_character": "Click to spend a token and unlock %s.",
			"need_character_token": "You need a character token from the skill tree.",
			"character_unlocked": "You unlocked %s.",
			"character_selected": "You now control %s.",
			"character_switch_full": "There is no room to store equipment incompatible with this character.",
			"attributes": "ATTRIBUTES",
			"hero_progress": "LEVEL %d · EXP %d / %d",
			"stat_health": "HEALTH",
			"stat_damage": "DAMAGE",
			"stat_defense": "DEF",
			"stat_speed": "SPD",
			"stat_magic": "MAGIC",
			"no_selection": "No item selected",
			"drag_to_equip": "Drag an item to equip it",
			"equip": "EQUIP",
			"use": "USE",
			"sort": "SORT",
			"remove": "REMOVE",
			"incompatible": "INCOMPATIBLE",
			"empty_slot": "Empty slot",
			"unknown_item": "Unknown item",
			"generic_item": "Item",
			"unique_item": "Unique item",
			"rarity_level": "%s · LEVEL %d",
			"effects": "EFFECTS",
			"origin": "ORIGIN: %s",
			"class_label": "CLASS: ",
			"heal_effect": "• On use: restores %d health",
			"max_health_effect": "• +%d Maximum health",
			"damage_effect": "• +%d Damage per attack",
			"defense_effect": "• +%d Defense (reduces damage taken)",
			"speed_effect": "• +%d Speed (attacks more frequently)",
			"magic_effect": "• +%d Magic power",
			"unique_power": "Unique power",
			"periodic_shield": "Every %d s, gain a blue shield worth %d points.",
			"generic_unique": "This item holds a unique power.",
			"unique_passive": "UNIQUE PASSIVE — %s\n%s",
			"rarity_common": "COMMON",
			"rarity_uncommon": "UNCOMMON",
			"rarity_rare": "RARE",
			"rarity_epic": "EPIC",
			"rarity_legendary": "LEGENDARY",
			"rarity_mythic": "MYTHIC",
			"rarity_ancestral": "ANCESTRAL",
			"rarity_unique": "UNIQUE",
			"slot_helmet": "Helmet",
			"slot_armor": "Armor",
			"slot_gloves": "Gloves",
			"slot_boots": "Boots",
			"slot_weapon": "Weapon",
			"slot_shield": "Shield",
			"slot_banner": "Banner",
			"level_required": "REQUIRES LEVEL %d",
			"level_too_low": "You need level %d to equip %s",
			"slot_amulet": "Amulet",
			"slot_ring1": "Ring 1",
			"slot_ring2": "Ring 2",
			"slot_accessory": "Accessory",
			"class_paladin": "Paladin",
			"class_archer": "Archer",
			"class_arcanist": "Arcanist",
			"class_knight": "Knight",
			"class_assassin": "Assassin",
			"class_necromancer": "Necromancer",
			"cannot_use": "%s cannot use %s",
			"shield_paladin_only": "Shields are exclusive to the Paladin",
			"archer_bows_only": "The Archer can only use bows",
			"magic_weapons_only": "%s can only use magical weapons",
			"assassin_daggers_only": "The Assassin can only use daggers",
			"sword_classes_only": "%s can only use swords or greatswords",
			"inventory_full": "The inventory is full",
			"missing_image": "Inventory image not found: ",
			"no_item_id": "Cannot add an item without an id.",
			"save_failed": "The inventory could not be saved.",
			"transparency_unsupported": "This system does not support window transparency."
	}
}

var item_translations_en: Dictionary = {
	"espada_hierro": ["Iron Sword", "A simple, reliable blade."],
	"casco_viajero": ["Traveler's Helm", "Basic protection for the road."],
	"coraza_cuero": ["Leather Cuirass", "Flexible and light."],
	"guantes_soldado": ["Soldier's Gloves", "Improve the weapon grip."],
	"botas_caminante": ["Wanderer's Boots", "Worn by countless roads."],
	"escudo_roble": ["Oak Shield", "Humble, heavy, and sturdy."],
	"amuleto_cobre": ["Copper Amulet", "Wards off a small share of bad luck."],
	"pocion_menor": ["Minor Health Potion", "Restores a small amount of health."],
	"fragmento_hierro": ["Iron Fragment", "Common smithing material."],
	"sable_explorador": ["Explorer's Saber", "Balanced for long expeditions."],
	"yelmo_guardabosques": ["Ranger's Helm", "Light and reinforced with steel leaves."],
	"malla_valdoria": ["Valdoria Mail", "Rings tempered in the kingdom's furnaces."],
	"botas_rastreador": ["Tracker's Boots", "Silent over earth and stone."],
	"anillo_jade": ["Jade Ring", "A green gem that preserves vitality."],
	"pocion_vigor": ["Vigor Potion", "Restores strength to the traveler."],
	"espada_valdoria": ["Sword of Valdoria", "Blue steel forged beside the ancient ruins."],
	"yelmo_esmeralda": ["Emerald Helm", "Its central gem seems to watch the battle."],
	"coraza_runica": ["Runic Cuirass", "Protective runes run across its plates."],
	"guantes_cazador": ["Hunter's Gloves", "Precision even while moving."],
	"escudo_lunar": ["Lunar Shield", "Reflects a moon that does not exist."],
	"amuleto_bruma": ["Mist Amulet", "Mist swirls around its gem."],
	"cristal_azur": ["Azure Crystal", "Rare material charged with energy."],
	"hoja_tormenta": ["Stormblade", "The edge trembles before every lightning strike."],
	"yelmo_centella": ["Lightning Helm", "Lightning runs through its engravings."],
	"armadura_grifo": ["Griffin Armor", "Made for champions of the heights."],
	"botas_portal": ["Portal Boots", "Every step seems to shorten the road."],
	"anillo_eclipse": ["Eclipse Ring", "Light and shadow pulse inside the gem."],
	"espada_rey_dorado": ["Golden King's Sword", "A relic of Valdoria's first crown."],
	"coraza_sol_inmortal": ["Immortal Sun Cuirass", "Its plates hold the warmth of an eternal dawn."],
	"escudo_ultimo_bastion": ["Last Bastion Shield", "It has never retreated before an enemy."],
	"amuleto_fenix": ["Phoenix Amulet", "An impossible ember sleeps within."],
	"filo_fractura": ["Fracture Edge", "Cuts matter and the echo it leaves behind."],
	"armadura_dragon_celeste": ["Celestial Dragon Armor", "Scales born above the clouds."],
	"corona_vacio": ["Void Crown", "Whispers names the world forgot."],
	"anillo_mil_estrellas": ["Ring of a Thousand Stars", "A tiny firmament turns within its gem."],
	"reliquia_primer_paladin": ["Relic of the First Paladin", "Holds the Dawn's oldest oath."],
	"mandoble_titan": ["Greatsword of the Sleeping Titan", "Its weight remembers a mountain."],
	"manto_era_perdida": ["Mantle of the Lost Age", "Woven before Valdoria had a name."],
	"juramento_eterno": ["Eternal Oath", "Only one exists. The light recognizes its bearer."],
	"corazon_valdoria": ["Heart of Valdoria", "The heartbeat of the realm turned into a relic."],
	"anillo_sin_nombre": ["The Nameless Ring", "Its true history has yet to be written."],
	"arco_fresno": ["Ash Bow", "A simple bow for learning the craft."],
	"arco_rastreador": ["Tracker's Bow", "Light and silent among the trees."],
	"arco_esmeralda": ["Emerald Bow", "Its arrows leave a green trail."],
	"arco_tormenta": ["Storm Bow", "Each string hums like distant thunder."],
	"arco_sol_dorado": ["Golden Sun Bow", "Fires light shaped into an arrow."],
	"arco_fractura": ["Fracture Bow", "Its projectiles pierce echoes of space."],
	"arco_bosque_primordial": ["Primordial Forest Bow", "Carved before roads existed."],
	"saeta_eterna": ["Eternal Arrow", "The unique bow that never misses twice."],
	"baston_aprendiz": ["Apprentice Staff", "Channels small sparks of magic."],
	"vara_bruma": ["Mist Wand", "Condenses mist into arcane energy."],
	"orbe_azur": ["Azure Orb", "A tiny sky turns within."],
	"baculo_celestial": ["Celestial Staff", "Summons fragments of fallen stars."],
	"cetro_fenix": ["Phoenix Scepter", "Burns without ever being consumed."],
	"grimorio_vacio": ["Void Grimoire", "Its pages answer with ancient voices."],
	"baston_era_perdida": ["Staff of the Lost Age", "Remembers spells forgotten by the world."],
	"codex_valdoria": ["Codex of Valdoria", "The realm's magic written in a single volume."],
	"daga_hierro": ["Iron Dagger", "Small, fast, and easy to conceal."],
	"dagas_callejon": ["Alley Daggers", "Two blades used by the capital's thieves."],
	"daga_lunar": ["Lunar Dagger", "Shines only before striking."],
	"cuchillas_eclipse": ["Eclipse Blades", "Two sharpened shadows that extinguish light."],
	"dagas_rey_sombra": ["Shadow King's Daggers", "No one remembers the monarch who wielded them."],
	"dagas_estelares": ["Stellar Daggers", "Every cut leaves a broken constellation."],
	"cuchillas_tiempo": ["Blades of Broken Time", "Strike a fraction of a second before they move."],
	"noche_sin_nombre": ["Nameless Night", "A unique pair of daggers that cast no shadow."]
}

var passive_translations_en: Dictionary = {
	"Égida del Juramento": "Oath Aegis",
	"Pulso Protector": "Protective Pulse",
	"Velo Innominado": "Nameless Veil",
	"Guardia del Viento": "Wind Guard",
	"Barrera Arcana": "Arcane Barrier",
	"Manto de Sombras": "Shadow Mantle"
}

const GRID_COLUMNS: int = 8
const GRID_ROWS: int = 5
const GRID_ORIGIN: Vector2 = Vector2(771, 235)
const GRID_SLOT_SIZE: Vector2 = Vector2(80.0, 78.0)
const GRID_GAP: Vector2 = Vector2(13.0, 10.0)

var inventory_items: Array[Dictionary] = []
var equipped_items: Dictionary = {}

var equipped_by_character: Dictionary = {}
var gold: int = 0

var active_category: String = CATEGORY_EQUIPMENT
var selected_inventory_index: int = -1
var selected_equipment_slot: String = ""

var base_stats: Dictionary = {
	"vida": 160,
	"daño": 30,
	"def": 18,
	"vel": 15,
	"magia": 10
}

var old_window_size: Vector2i = Vector2i.ZERO
var old_window_position: Vector2i = Vector2i.ZERO
var inventory_is_open: bool = false

var open_button: Button
var main_interface_root: Control
var main_controller: Node
var button_attached_to_main_bar: bool = false
var button_setup_done: bool = false
var inventory_started_open: bool = false
var inventory_window: Window
var inventory_window_dragging: bool = false
var inventory_window_drag_offset: Vector2i = Vector2i.ZERO
var inventory_window_manually_moved: bool = false
var overlay: Control
var menu_canvas: Control
var character_preview: TextureRect
var character_idle_frames: Array = []
var character_idle_time: float = 0.0
var character_idle_frame_index: int = 0
var character_idle_current_id: String = ""
var inventory_slot_buttons: Array[Button] = []
var equipment_buttons: Dictionary = {}
var tab_buttons: Array[Button] = []
var stat_value_labels: Dictionary = {}
var gold_label: Label
var capacity_label: Label
var selected_item_label: Label
var equip_button: Button
var use_button: Button

var current_character_id: String = "paladin_alba"
var current_character_group: String = "paladin"
var unlocked_character_ids: Array[String] = []
var character_unlock_tokens: int = 0
var character_buttons: Array[Button] = []
var character_placeholder_label: Label

var current_language: String = "es"
var game_ui: Node
var inventory_title_label: Label
var inventory_subtitle_label: Label
var attributes_title_label: Label
var character_progress_label: Label
var stat_name_labels: Dictionary = {}
var close_bottom_button: Button
var sort_button: Button
var close_top_button: Button

var drag_source_type: String = ""
var drag_inventory_index: int = -1
var drag_equipment_slot: String = ""
var drag_start_menu_position: Vector2 = Vector2.ZERO
var drag_active: bool = false
var drag_preview: Panel
var drag_preview_root: Control
var drag_preview_layer: Control
var suppress_next_button_press: bool = false
var gold_sync_accumulator: float = 0.0

var mission_system: Node
var mission_scroll: ScrollContainer
var mission_list: VBoxContainer
var mission_header: Label
var mission_hint: Label
var mission_count_label: Label

var skill_panel: Control
var skill_title_label: Label
var skill_hint_label: Label
var active_skill_title_label: Label
var passive_skill_title_label: Label
var available_skill_title_label: Label
var skill_empty_label: Label
var active_skill_slot_buttons: Array[Button] = []
var passive_skill_slot_buttons: Array[Button] = []
var unlocked_skill_list: VBoxContainer
var skill_loadouts_by_character: Dictionary = {}

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	set_process(true)
	main_controller = get_parent()
	_connect_game_ui()

	show_open_button = false
	integrar_boton_en_barra_superior = false
	call_deferred("_remove_legacy_inventory_top_button")

	_configure_window_transparency()
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	visible = true

	_load_language_setting()
	_load_current_character()
	_prepare_data()
	_load_character_progression()
	_resolve_mission_system()
	_build_inventory_interface()
	_load_inventory()
	_load_skill_loadouts()
	_sync_gold_from_main()

	if add_demo_items and _count_occupied_slots() == 0:
		_add_demo_inventory()

	_refresh_inventory_language()
	_sync_root_to_viewport()
	if is_instance_valid(game_ui) and game_ui.has_method("apply_font_to_tree"):
		game_ui.call_deferred("apply_font_to_tree", menu_canvas)

	if not get_window().size_changed.is_connected(_on_window_size_changed):
		get_window().size_changed.connect(_on_window_size_changed)
	if start_open:
		call_deferred("open_inventory")

func _resolve_mission_system() -> void:
	if is_instance_valid(main_controller) and main_controller.has_method("get_mission_system"):
		mission_system = main_controller.call("get_mission_system") as Node
	if not is_instance_valid(mission_system) and is_instance_valid(main_controller):
		mission_system = main_controller.find_child("SistemaMisiones", true, false)
	if is_instance_valid(mission_system) and mission_system.has_signal("missions_changed"):
		var callback: Callable = Callable(self, "_refresh_mission_panel")
		if not mission_system.is_connected("missions_changed", callback):
			mission_system.connect("missions_changed", callback)

func _process(delta: float) -> void:

	_process_character_idle_animation(delta)

	_update_drag_preview_from_global_mouse()
	_refresh_drag_preview_visibility()

	gold_sync_accumulator += delta
	if gold_sync_accumulator < 0.20:
		return

	gold_sync_accumulator = 0.0
	if _sync_gold_from_main() and is_instance_valid(gold_label):
		gold_label.text = "%d" % gold

func _refresh_drag_preview_visibility() -> void:
	if not is_instance_valid(drag_preview_layer):
		return

	if not drag_active:
		drag_preview_layer.visible = false
		return

	var forge_preview_ready: bool = bool(
		get_tree().root.get_meta("taskbar_forge_drag_preview_active", false)
	)
	drag_preview_layer.visible = not forge_preview_ready

func _update_drag_preview_from_global_mouse() -> void:
	if not drag_active:
		return
	if not is_instance_valid(drag_preview):
		return
	if not is_instance_valid(inventory_window):
		return
	if not is_instance_valid(menu_canvas):
		return

	var global_mouse: Vector2i = DisplayServer.mouse_get_position()
	var window_local: Vector2 = Vector2(global_mouse - inventory_window.position)
	var menu_mouse: Vector2 = _window_position_to_menu(window_local)
	_update_drag_preview(menu_mouse)

func set_drag_preview_visible(should_be_visible: bool) -> void:
	if not drag_active:
		return
	if is_instance_valid(drag_preview_layer):
		drag_preview_layer.visible = should_be_visible

func _has_property(target: Object, property_name: String) -> bool:
	if target == null:
		return false

	for property_data in target.get_property_list():
		if str(property_data.get("name", "")) == property_name:
			return true

	return false

func _resolve_main_controller() -> Node:
	if is_instance_valid(main_controller):
		return main_controller

	var parent_node: Node = get_parent()
	if parent_node != null:
		main_controller = parent_node

	return main_controller

func _sync_gold_from_main() -> bool:
	var controller: Node = _resolve_main_controller()
	if not is_instance_valid(controller):
		return false
	if not _has_property(controller, "player_gold"):
		return false

	var real_gold: int = maxi(0, int(controller.get("player_gold")))
	gold = real_gold
	return true

func _write_gold_to_main(new_gold: int) -> bool:
	var controller: Node = _resolve_main_controller()
	if not is_instance_valid(controller):
		return false
	if not _has_property(controller, "player_gold"):
		return false

	controller.set("player_gold", maxi(0, new_gold))
	if controller.has_method("_update_player_interface_only"):
		controller.call_deferred("_update_player_interface_only")
	elif controller.has_method("_update_interface"):
		controller.call_deferred("_update_interface")

	if controller.has_method("_save_progress"):
		controller.call_deferred("_save_progress")

	return true

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

func _load_language_setting() -> void:
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
	_refresh_inventory_language()

	if is_instance_valid(game_ui) and game_ui.has_method("apply_font_to_tree"):
		game_ui.call_deferred("apply_font_to_tree", menu_canvas)

func _inv_text(key: String) -> String:
	var spanish: Dictionary = inventory_translations.get("es", {})
	var selected: Dictionary = inventory_translations.get(
		current_language,
		spanish
	)

	if selected.has(key):
		return str(selected.get(key, key))

	return str(spanish.get(key, key))

func _item_display_name(item: Dictionary) -> String:
	var fallback: String = str(item.get("name", _inv_text("unknown_item")))
	if current_language != "en":
		return fallback
	var item_id: String = str(item.get("id", ""))
	var translated: Variant = item_translations_en.get(item_id, [])
	if translated is Array and translated.size() >= 1:
		return str(translated[0])
	return str(item.get("name_en", fallback))

func _item_display_description(item: Dictionary) -> String:
	var fallback: String = str(item.get("description", "")).strip_edges()
	if current_language != "en":
		return fallback
	var item_id: String = str(item.get("id", ""))
	var translated: Variant = item_translations_en.get(item_id, [])
	if translated is Array and translated.size() >= 2:
		return str(translated[1])
	return str(item.get("description_en", fallback)).strip_edges()

func _passive_display_name(passive: Dictionary) -> String:
	var fallback: String = str(passive.get("name", _inv_text("unique_power")))
	if current_language == "en":
		return str(passive_translations_en.get(fallback, fallback))
	return fallback

func _refresh_inventory_language() -> void:
	if is_instance_valid(inventory_window):
		inventory_window.title = _inv_text("window_title")
	if is_instance_valid(open_button):
		open_button.tooltip_text = _inv_text("open_inventory")
	if is_instance_valid(inventory_title_label):
		inventory_title_label.text = _inv_text("inventory_title")
	if is_instance_valid(inventory_subtitle_label):
		inventory_subtitle_label.text = _inv_text("inventory_subtitle")
	if is_instance_valid(attributes_title_label):
		attributes_title_label.text = _inv_text("attributes")

	var stat_keys: Dictionary = {
		"vida": "stat_health",
		"daño": "stat_damage",
		"def": "stat_defense",
		"vel": "stat_speed",
		"magia": "stat_magic"
	}
	for stat_id in stat_name_labels.keys():
		var stat_label: Label = stat_name_labels[stat_id]
		if is_instance_valid(stat_label):
			stat_label.text = _inv_text(str(stat_keys.get(stat_id, stat_id)))

	for index in range(tab_buttons.size()):
		if index >= TAB_DATA.size():
			continue
		var tab_button: Button = tab_buttons[index]
		if is_instance_valid(tab_button):
			tab_button.text = _inv_text(str(TAB_DATA[index].get("text_key", "")))

	if is_instance_valid(close_bottom_button):
		close_bottom_button.text = _inv_text("close")
	if is_instance_valid(sort_button):
		sort_button.text = _inv_text("sort")
	if is_instance_valid(close_top_button):
		close_top_button.tooltip_text = _inv_text("close")
	_refresh_everything()

func _configure_window_transparency() -> void:

	ProjectSettings.set_setting(
		"display/window/per_pixel_transparency/allowed",
		true
	)

	var root_viewport: Viewport = get_viewport()
	if root_viewport != null:
		root_viewport.gui_embed_subwindows = false

func _on_window_size_changed() -> void:
	_sync_root_to_viewport()
	if inventory_is_open:
		_position_inventory_window()

func _on_inventory_window_size_changed() -> void:
	if is_instance_valid(overlay):
		overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_fit_menu_canvas()

func _sync_root_to_viewport() -> void:

	if is_instance_valid(overlay) and is_instance_valid(inventory_window):
		overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_fit_menu_canvas()

func _prepare_data() -> void:
	inventory_items.clear()
	inventory_items.resize(maximum_slots)
	for index: int in range(maximum_slots):
		inventory_items[index] = {}

	equipped_items = _create_empty_equipment_set()
	equipped_by_character.clear()
	equipped_by_character[current_character_id] = equipped_items.duplicate(true)
	gold = starting_gold

func _create_empty_equipment_set() -> Dictionary:
	var result: Dictionary = {}
	for slot_name: String in EQUIPMENT_SLOT_ORDER:
		result[slot_name] = {}
	return result

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		var key_event: InputEventKey = event as InputEventKey

		if not key_event.pressed or key_event.echo:
			return

		if key_event.keycode == KEY_I:
			toggle_inventory()
			get_viewport().set_input_as_handled()
		elif key_event.keycode == KEY_ESCAPE and inventory_is_open:
			close_inventory()
			get_viewport().set_input_as_handled()

func toggle_inventory() -> void:
	if inventory_is_open:
		close_inventory()
	else:
		open_inventory()

func open_inventory() -> void:
	if inventory_is_open:
		return

	_load_language_setting()
	_sync_gold_from_main()
	_refresh_inventory_language()
	inventory_is_open = true
	visible = true

	if is_instance_valid(inventory_window):
		inventory_window.size = inventory_window_size
		_position_inventory_window()
		inventory_window.show()

	call_deferred("_apply_native_transparency")
	call_deferred("_finish_open_inventory")

func _finish_open_inventory() -> void:
	_sync_root_to_viewport()
	if is_instance_valid(overlay):
		overlay.visible = true
	_refresh_everything()
	inventory_opened.emit()

func _apply_native_transparency() -> void:
	if not is_instance_valid(inventory_window):
		return

	inventory_window.transparent = true
	inventory_window.transparent_bg = true

	if DisplayServer.is_window_transparency_available():
		DisplayServer.window_set_flag(
			DisplayServer.WINDOW_FLAG_TRANSPARENT,
			true,
			inventory_window.get_window_id()
		)
	else:
		push_warning(_inv_text("transparency_unsupported"))

func close_inventory() -> void:
	if not inventory_is_open:
		return

	_clear_drag_state()
	inventory_is_open = false

	if is_instance_valid(overlay):
		overlay.visible = false

	if is_instance_valid(inventory_window):
		inventory_window.hide()

	_save_inventory()
	inventory_closed.emit()

func is_inventory_open() -> bool:
	return inventory_is_open

func _position_inventory_window(force_position: bool = false) -> void:
	if not is_instance_valid(inventory_window):
		return
	if inventory_window_manually_moved and not force_position:
		return

	var game_window: Window = get_window()
	var screen_index: int = DisplayServer.window_get_current_screen()
	var usable_rect: Rect2i = DisplayServer.screen_get_usable_rect(screen_index)
	var game_position: Vector2i = game_window.position
	var game_size: Vector2i = game_window.size
	var inventory_size: Vector2i = inventory_window.size

	var target_x: int = game_position.x + int((game_size.x - inventory_size.x) / 2.0)
	var target_y: int = game_position.y - inventory_size.y - separacion_del_juego

	if target_y < usable_rect.position.y:
		target_y = game_position.y + game_size.y + separacion_del_juego

	target_x = clampi(
		target_x,
		usable_rect.position.x,
		usable_rect.position.x + usable_rect.size.x - inventory_size.x
	)
	target_y = clampi(
		target_y,
		usable_rect.position.y,
		usable_rect.position.y + usable_rect.size.y - inventory_size.y
	)

	inventory_window.position = Vector2i(target_x, target_y)

func _on_inventory_window_input(event: InputEvent) -> void:
	if event is InputEventKey:
		var key_event: InputEventKey = event as InputEventKey
		if not key_event.pressed or key_event.echo:
			return
		if key_event.keycode == KEY_ESCAPE or key_event.keycode == KEY_I:
			close_inventory()
		return

	if event is InputEventMouseButton:
		var mouse_event: InputEventMouseButton = event as InputEventMouseButton
		if mouse_event.button_index != MOUSE_BUTTON_LEFT:
			return

		if mouse_event.pressed:
			if _can_start_inventory_window_drag(mouse_event.position):
				inventory_window_dragging = true
				inventory_window_drag_offset = (
					DisplayServer.mouse_get_position()
					- inventory_window.position
				)
				return
		else:
			if inventory_window_dragging:
				inventory_window_dragging = false
				inventory_window_manually_moved = true
				return

			if not drag_source_type.is_empty():
				var menu_mouse: Vector2 = _window_position_to_menu(mouse_event.position)
				var dropped_in_forge: bool = false
				if drag_active and drag_source_type == "inventory":
					dropped_in_forge = _try_drop_inventory_item_into_forge(
						drag_inventory_index,
						DisplayServer.mouse_get_position()
					)
				if drag_active and not dropped_in_forge:
					_finish_manual_drop(menu_mouse)
				_clear_drag_state()
		return

	if event is InputEventMouseMotion:
		if inventory_window_dragging:
			inventory_window.position = (
				DisplayServer.mouse_get_position()
				- inventory_window_drag_offset
			)
			return

		if drag_source_type.is_empty():
			return

		var menu_mouse: Vector2 = _window_position_to_menu(event.position)
		if not drag_active:
			if menu_mouse.distance_to(drag_start_menu_position) >= DRAG_THRESHOLD:
				_activate_drag_preview(menu_mouse)
		elif is_instance_valid(drag_preview):
			_update_drag_preview(menu_mouse)

func _can_start_inventory_window_drag(window_position: Vector2) -> bool:
	if not permitir_mover_ventana:
		return false
	if not is_instance_valid(inventory_window):
		return false
	if not drag_source_type.is_empty():
		return false
	if window_position.y < 0.0 or window_position.y > altura_arrastre_ventana:
		return false

	return window_position.x < float(inventory_window.size.x - 58)

func _try_drop_inventory_item_into_forge(
	inventory_index: int,
	global_mouse_position: Vector2i
) -> bool:
	var current_scene: Node = get_tree().current_scene
	if current_scene == null:
		return false

	var forge_ui: Node = current_scene.find_child("ForjaUI", true, false)
	if forge_ui == null:
		return false
	if not forge_ui.has_method("insert_inventory_item_from_screen_position"):
		return false

	return bool(
		forge_ui.call(
			"insert_inventory_item_from_screen_position",
			inventory_index,
			global_mouse_position
		)
	)

func _remove_legacy_inventory_top_button() -> void:

	if is_instance_valid(open_button):
		if bool(open_button.get_meta("taskbar_top_button", false)):
			open_button.tooltip_text = _inv_text("open_inventory")
			return

		if open_button.get_parent() != null:
			open_button.get_parent().remove_child(open_button)
		open_button.queue_free()
		open_button = null

func _build_open_button(target_parent: Control) -> void:
	if not is_instance_valid(target_parent):
		return

	var managed_button: Node = target_parent.find_child(
		"BotonInventario",
		true,
		false
	)
	if managed_button is Button:
		open_button = managed_button as Button
		open_button.tooltip_text = _inv_text("open_inventory")

		return

	if is_instance_valid(open_button):
		if open_button.get_parent() != target_parent:
			open_button.reparent(target_parent, false)
	else:
		open_button = Button.new()
		open_button.name = "BotonInventario"
		open_button.tooltip_text = _inv_text("open_inventory")
		open_button.focus_mode = Control.FOCUS_NONE
		open_button.mouse_filter = Control.MOUSE_FILTER_STOP
		open_button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		open_button.pressed.connect(_on_open_button_pressed)

	open_button.text = simbolo_boton_inventario
	open_button.position = posicion_boton_barra
	open_button.size = tamano_boton_barra
	open_button.disabled = false
	open_button.z_as_relative = false
	open_button.z_index = 4095

	if is_instance_valid(main_controller):
		var font_candidate: Variant = main_controller.get("symbol_font")
		if font_candidate is Font:
			open_button.add_theme_font_override("font", font_candidate as Font)

	open_button.add_theme_font_size_override("font_size", 11)
	open_button.add_theme_stylebox_override(
		"normal",
		_make_style(
			Color(0.018, 0.115, 0.090, 0.99),
			Color("#53E4B1"),
			1,
			4,
			Color(0.0, 0.0, 0.0, 0.58),
			5,
			Vector2(0.0, 2.0)
		)
	)
	open_button.add_theme_stylebox_override(
		"hover",
		_make_style(
			Color(0.025, 0.220, 0.160, 1.0),
			Color("#A6FFDC"),
			1,
			4,
			Color(0.32, 1.0, 0.75, 0.34),
			7
		)
	)
	open_button.add_theme_stylebox_override(
		"pressed",
		_make_style(
			Color(0.12, 0.085, 0.020, 1.0),
			Color("#F5CF69"),
			2,
			8
		)
	)
	open_button.add_theme_stylebox_override(
		"focus",
		_make_style(
			Color(0.018, 0.115, 0.090, 0.99),
			Color("#53E4B1"),
			2,
			8
		)
	)
	open_button.add_theme_color_override("font_color", Color("#E7FFF7"))
	open_button.add_theme_color_override("font_hover_color", Color.WHITE)
	open_button.add_theme_color_override("font_pressed_color", Color("#FFE9A3"))
	open_button.visible = not inventory_is_open

	if open_button.get_parent() == null:
		target_parent.add_child(open_button)

	target_parent.move_child(open_button, target_parent.get_child_count() - 1)
	open_button.move_to_front()

func _on_open_button_pressed() -> void:
	toggle_inventory()

func _resolve_inventory_background_path() -> String:
	var candidates: Array[String] = []
	if not inventory_background_path.is_empty():
		candidates.append(inventory_background_path)

	for fallback_path in INVENTORY_BACKGROUND_FALLBACKS:
		if not candidates.has(fallback_path):
			candidates.append(fallback_path)

	for candidate_path in candidates:
		if ResourceLoader.exists(candidate_path):
			inventory_background_path = candidate_path
			return candidate_path

	return ""

func _ensure_drag_preview_layer() -> void:

	if is_instance_valid(drag_preview_layer):
		return
	if not is_instance_valid(menu_canvas):
		return

	drag_preview_layer = Control.new()
	drag_preview_layer.name = "CapaVistaArrastre"
	drag_preview_layer.position = Vector2.ZERO
	drag_preview_layer.size = REFERENCE_SIZE
	drag_preview_layer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	drag_preview_layer.z_index = 512
	drag_preview_layer.visible = false
	menu_canvas.add_child(drag_preview_layer)

	drag_preview_root = Control.new()
	drag_preview_root.name = "RaizVistaArrastre"
	drag_preview_root.position = Vector2.ZERO
	drag_preview_root.size = REFERENCE_SIZE
	drag_preview_root.mouse_filter = Control.MOUSE_FILTER_IGNORE
	drag_preview_layer.add_child(drag_preview_root)

func _clear_drag_preview_content() -> void:
	if not is_instance_valid(drag_preview_root):
		return

	for child in drag_preview_root.get_children():
		drag_preview_root.remove_child(child)
		child.queue_free()

	drag_preview = null

func _build_inventory_interface() -> void:
	inventory_window = Window.new()
	inventory_window.name = "VentanaInventario"
	inventory_window.title = _inv_text("window_title")
	inventory_window.size = inventory_window_size
	inventory_window.min_size = inventory_window_size
	inventory_window.borderless = true
	inventory_window.unresizable = true
	inventory_window.always_on_top = true
	inventory_window.exclusive = false

	inventory_window.transparent = true
	inventory_window.transparent_bg = true

	inventory_window.visible = false
	inventory_window.force_native = usar_ventana_independiente
	inventory_window.close_requested.connect(close_inventory)
	inventory_window.window_input.connect(_on_inventory_window_input)
	inventory_window.size_changed.connect(_on_inventory_window_size_changed)
	add_child(inventory_window)

	overlay = Control.new()
	overlay.name = "InventarioSinSombreado"
	overlay.mouse_filter = Control.MOUSE_FILTER_PASS
	overlay.clip_contents = true
	overlay.visible = true
	inventory_window.add_child(overlay)
	overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

	menu_canvas = Control.new()
	menu_canvas.name = "InventarioCanvas"
	menu_canvas.size = REFERENCE_SIZE
	menu_canvas.mouse_filter = Control.MOUSE_FILTER_PASS
	overlay.add_child(menu_canvas)
	_ensure_drag_preview_layer()

	var background: TextureRect = TextureRect.new()
	background.name = "FondoInventario"
	background.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	background.stretch_mode = TextureRect.STRETCH_SCALE
	background.mouse_filter = Control.MOUSE_FILTER_IGNORE

	var resolved_background_path: String = _resolve_inventory_background_path()
	if not resolved_background_path.is_empty():
		var background_texture: Texture2D = load(resolved_background_path) as Texture2D
		background.texture = background_texture

		if background_texture != null and background_texture.get_size().x < REFERENCE_SIZE.x - 20.0:
			background.position = VISIBLE_UI_BOUNDS.position
			background.size = VISIBLE_UI_BOUNDS.size
		else:
			background.position = Vector2.ZERO
			background.size = REFERENCE_SIZE
	else:
		push_warning(
			_inv_text("missing_image")
			+ inventory_background_path
		)
		background.position = VISIBLE_UI_BOUNDS.position
		background.size = VISIBLE_UI_BOUNDS.size

	menu_canvas.add_child(background)

	_build_titles()
	_build_character_preview()
	_build_character_roster_slots()
	_build_equipment_slots()
	_build_stats_panel()
	_build_tabs()
	_build_inventory_grid()
	_build_skill_panel()
	_build_bottom_information()
	_build_action_buttons()
	_build_close_button()

func _build_titles() -> void:
	inventory_title_label = _create_label(
		menu_canvas,
		_inv_text("inventory_title"),
		Vector2(824, 44),
		Vector2(672, 62),
		42,
		HORIZONTAL_ALIGNMENT_CENTER,
		Color("#F4D47A")
	)
	inventory_title_label.add_theme_constant_override("outline_size", 5)
	inventory_title_label.add_theme_color_override(
		"font_outline_color",
		Color(0.05, 0.025, 0.0, 0.96)
	)

	inventory_subtitle_label = _create_label(
		menu_canvas,
		_inv_text("inventory_subtitle"),
		Vector2(613, 130),
		Vector2(592, 30),
		18,
		HORIZONTAL_ALIGNMENT_CENTER,
		Color("#9DD7FF")
	)

func _build_character_preview() -> void:
	character_preview = TextureRect.new()
	character_preview.name = "PersonajeInventario"
	# Tamaño reducido para que no tape botones ni slots del panel.
	character_preview.position = Vector2(294, 201)
	character_preview.size = Vector2(262, 265)
	character_preview.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	character_preview.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	character_preview.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	character_preview.mouse_filter = Control.MOUSE_FILTER_IGNORE
	character_preview.visible = true
	menu_canvas.add_child(character_preview)
	character_preview.z_index = 5

	character_placeholder_label = _create_label(
		menu_canvas,
		"",
		Vector2(290.0, 260.0),
		Vector2(270.0, 150.0),
		24,
		HORIZONTAL_ALIGNMENT_CENTER,
		Color("#E9D58A")
	)
	character_placeholder_label.add_theme_constant_override("outline_size", 4)
	character_placeholder_label.add_theme_color_override("font_outline_color", Color(0, 0, 0, 0.95))

	_apply_active_character_visual()

func _build_character_roster_slots() -> void:
	character_buttons.clear()

	var roster_title := _create_label(
		menu_canvas,
		"CAMPEONES" if current_language == "es" else "CHAMPIONS",
		Vector2(268, 86),
		Vector2(300, 26),
		13,
		HORIZONTAL_ALIGNMENT_CENTER,
		Color("#F3D77A")
	)
	roster_title.name = "TituloCampeones"
	roster_title.add_theme_constant_override("outline_size", 2)
	roster_title.add_theme_color_override("font_outline_color", Color(0, 0, 0, 0.92))

	var positions: Array[Vector2] = [
		Vector2(272, 118),
		Vector2(370, 118),
		Vector2(462, 120)
	]
	for index in range(3):
		var button := Button.new()
		button.name = "PersonajeSlot%d" % index
		button.position = positions[index]
		button.size = Vector2(92.0, 54.0)
		button.focus_mode = Control.FOCUS_NONE
		button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		button.add_theme_font_size_override("font_size", 11)
		button.alignment = HORIZONTAL_ALIGNMENT_CENTER
		button.pressed.connect(_on_character_slot_pressed.bind(index))
		button.z_index = 30
		menu_canvas.add_child(button)
		character_buttons.append(button)

func _build_equipment_slots() -> void:
	for slot_name in EQUIPMENT_SLOT_ORDER:
		var slot_rect: Rect2 = EQUIPMENT_SLOT_RECTS[slot_name]
		var slot_button: Button = Button.new()
		slot_button.name = "Equipo_%s" % slot_name
		slot_button.position = slot_rect.position
		slot_button.size = slot_rect.size
		slot_button.text = ""

		slot_button.clip_contents = true
		slot_button.focus_mode = Control.FOCUS_NONE
		slot_button.tooltip_text = _equipment_slot_display_name(slot_name)
		slot_button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		slot_button.add_theme_stylebox_override(
			"normal",
			_make_style(
				Color(0.0, 0.0, 0.0, 0.0),
				Color(0.0, 0.0, 0.0, 0.0),
				0,
				8
			)
		)
		slot_button.add_theme_stylebox_override(
			"hover",
			_make_style(
				Color(0.12, 0.70, 0.48, 0.10),
				Color("#72F4C1"),
				2,
				8
			)
		)
		slot_button.add_theme_stylebox_override(
			"pressed",
			_make_style(
				Color(0.95, 0.76, 0.25, 0.10),
				Color("#FFD76A"),
				2,
				8
			)
		)
		slot_button.pressed.connect(_on_equipment_slot_pressed.bind(slot_name))
		slot_button.gui_input.connect(_on_equipment_slot_gui_input.bind(slot_name))
		menu_canvas.add_child(slot_button)
		equipment_buttons[slot_name] = slot_button

func _build_stats_panel() -> void:
	attributes_title_label = _create_label(
		menu_canvas,
		_inv_text("attributes"),
		Vector2(233, 666),
		Vector2(352, 24),
		18,
		HORIZONTAL_ALIGNMENT_CENTER,
		Color("#F0C965")
	)
	character_progress_label = _create_label(
		menu_canvas,
		"",
		Vector2(235, 861),
		Vector2(350, 28),
		14,
		HORIZONTAL_ALIGNMENT_CENTER,
		Color("#9FD9FF")
	)

	var stat_layout: Array[Dictionary] = [
		{"id": "vida", "text_key": "stat_health", "position": Vector2(162, 696)},
		{"id": "daño", "text_key": "stat_damage", "position": Vector2(160, 740)},
		{"id": "def", "text_key": "stat_defense", "position": Vector2(281, 782)},
		{"id": "vel", "text_key": "stat_speed", "position": Vector2(385, 698)},
		{"id": "magia", "text_key": "stat_magic", "position": Vector2(381, 740)}
	]

	for stat_data in stat_layout:
		var stat_id: String = str(stat_data["id"])
		var row_position: Vector2 = stat_data["position"]
		var stat_name_label: Label = _create_label(
			menu_canvas,
			_inv_text(str(stat_data["text_key"])),
			row_position,
			Vector2(115.0, 28.0),
			15,
			HORIZONTAL_ALIGNMENT_LEFT,
			Color("#E9C66D")
		)
		stat_name_labels[stat_id] = stat_name_label

		var value_label: Label = _create_label(
			menu_canvas,
			"0",
			row_position + Vector2(116.0, 0.0),
			Vector2(96.0, 28.0),
			15,
			HORIZONTAL_ALIGNMENT_RIGHT,
			Color("#F5E9C7")
		)
		stat_value_labels[stat_id] = value_label

func _build_tabs() -> void:
	for index in range(TAB_DATA.size()):
		var tab_info: Dictionary = TAB_DATA[index]
		var tab_rect: Rect2 = TAB_RECTS[index]
		var tab_button: Button = Button.new()
		tab_button.name = "Pestaña_%s" % str(tab_info["id"])
		tab_button.position = tab_rect.position
		tab_button.size = tab_rect.size
		tab_button.text = _inv_text(str(tab_info["text_key"]))
		tab_button.focus_mode = Control.FOCUS_NONE
		tab_button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		tab_button.add_theme_font_size_override("font_size", 16)
		tab_button.pressed.connect(_on_tab_pressed.bind(str(tab_info["id"])))
		menu_canvas.add_child(tab_button)
		tab_buttons.append(tab_button)

	_update_tab_styles()

func _build_inventory_grid() -> void:
	inventory_slot_buttons.clear()
	for visible_index: int in range(GRID_COLUMNS * GRID_ROWS):
		var column: int = visible_index % GRID_COLUMNS
		var row: int = int(floor(float(visible_index) / float(GRID_COLUMNS)))
		var slot_position: Vector2 = GRID_ORIGIN + Vector2(
			float(column) * (GRID_SLOT_SIZE.x + GRID_GAP.x),
			float(row) * (GRID_SLOT_SIZE.y + GRID_GAP.y)
		)
		var slot_button: Button = Button.new()
		slot_button.name = "CasillaInventario%d" % visible_index
		slot_button.position = slot_position
		slot_button.size = GRID_SLOT_SIZE
		slot_button.text = ""
		slot_button.focus_mode = Control.FOCUS_NONE
		slot_button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		slot_button.set_meta("visible_index", visible_index)
		slot_button.pressed.connect(_on_inventory_slot_pressed.bind(visible_index))
		slot_button.gui_input.connect(_on_inventory_slot_gui_input.bind(visible_index))
		menu_canvas.add_child(slot_button)
		inventory_slot_buttons.append(slot_button)

	_build_mission_panel()

func _build_mission_panel() -> void:
	mission_header = _create_label(
		menu_canvas, _inv_text("mission_title"), Vector2(790.0, 218.0),
		Vector2(690.0, 38.0), 22, HORIZONTAL_ALIGNMENT_CENTER, Color("#F4D47A")
	)
	mission_header.name = "TituloMisiones"
	mission_header.visible = false

	mission_hint = _create_label(
		menu_canvas, _inv_text("mission_hint"), Vector2(790.0, 255.0),
		Vector2(690.0, 42.0), 15, HORIZONTAL_ALIGNMENT_CENTER, Color("#C6D6E8")
	)
	mission_hint.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	mission_hint.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	mission_hint.visible = false

	mission_count_label = _create_label(
		menu_canvas,
		"0 / 0",
		Vector2(1325.0, 218.0),
		Vector2(155.0, 26.0),
		14,
		HORIZONTAL_ALIGNMENT_RIGHT,
		Color("#E8D7A0")
	)
	mission_count_label.name = "ConteoMisiones"
	mission_count_label.visible = false

	mission_scroll = ScrollContainer.new()
	mission_scroll.name = "PanelMisiones"
	mission_scroll.position = Vector2(790.0, 305.0)
	mission_scroll.size = Vector2(690.0, 365.0)
	mission_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	mission_scroll.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_AUTO
	mission_scroll.visible = false
	menu_canvas.add_child(mission_scroll)

	mission_list = VBoxContainer.new()
	mission_list.name = "ListaMisiones"
	mission_list.custom_minimum_size = Vector2(665.0, 0.0)
	mission_list.add_theme_constant_override("separation", 10)
	mission_scroll.add_child(mission_list)

func _build_bottom_information() -> void:
	gold_label = _create_label(
		menu_canvas,
		"0",
		Vector2(815.0, 699.0),
		Vector2(175.0, 42.0),
		18,
		HORIZONTAL_ALIGNMENT_LEFT,
		Color("#F1CA62")
	)

	capacity_label = _create_label(
		menu_canvas,
		"0 / 0",
		Vector2(1097.0, 699.0),
		Vector2(160.0, 42.0),
		18,
		HORIZONTAL_ALIGNMENT_CENTER,
		Color("#A9D7FF")
	)

	selected_item_label = _create_label(
		menu_canvas,
		_inv_text("no_selection"),
		Vector2(790.0, 742.0),
		Vector2(690.0, 34.0),
		16,
		HORIZONTAL_ALIGNMENT_CENTER,
		Color("#D9CFB8")
	)

func _attach_close_icon(button: Button, side_by_side: bool = false) -> void:
	if button == null:
		return
	if not ResourceLoader.exists(CLOSE_ICON_PATH):
		return
	var icon_texture: Texture2D = load(CLOSE_ICON_PATH) as Texture2D
	if icon_texture == null:
		return
	var icon_rect: TextureRect = TextureRect.new()
	icon_rect.name = "IconoCerrar"
	icon_rect.texture = icon_texture
	icon_rect.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	icon_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	icon_rect.size = Vector2(18.0, 18.0)
	icon_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	if side_by_side and not button.text.is_empty():
		icon_rect.position = Vector2(8.0, (button.size.y - icon_rect.size.y) * 0.5)
		button.add_theme_constant_override("h_separation", 4)
		button.text = "   " + button.text
	else:
		icon_rect.position = (button.size - icon_rect.size) * 0.5
	button.add_child(icon_rect)

func _build_action_buttons() -> void:

	equip_button = _create_overlay_button(
		_inv_text("equip"),
		Rect2(828, 774, 148, 34),
		Color("#5FF0B5")
	)
	equip_button.pressed.connect(_on_equip_pressed)

	use_button = _create_overlay_button(
		_inv_text("use"),
		Rect2(1086, 772, 136, 34),
		Color("#91D5FF")
	)
	use_button.pressed.connect(_on_use_pressed)

	close_bottom_button = _create_overlay_button(
		_inv_text("close"),
		Rect2(1352, 774, 122, 34),
		Color("#F2D175")
	)
	close_bottom_button.pressed.connect(close_inventory)
	_attach_close_icon(close_bottom_button, true)

	sort_button = _create_overlay_button(
		_inv_text("sort"),
		Rect2(1414.0, 711.0, 78.0, 28.0),
		Color("#E8CA6A")
	)
	sort_button.add_theme_font_size_override("font_size", 10)
	sort_button.pressed.connect(_sort_inventory)

func _build_close_button() -> void:
	close_top_button = Button.new()
	var close_button: Button = close_top_button
	close_button.name = "CerrarInventarioSuperior"
	close_button.position = Vector2(1484.0, 57.0)
	close_button.size = Vector2(58.0, 58.0)
	close_button.text = ""
	close_button.focus_mode = Control.FOCUS_NONE
	close_button.tooltip_text = _inv_text("close")
	close_button.mouse_filter = Control.MOUSE_FILTER_STOP
	close_button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	close_button.add_theme_stylebox_override(
		"normal",
		_make_style(
			Color(0.0, 0.0, 0.0, 0.0),
			Color(0.0, 0.0, 0.0, 0.0),
			0,
			8
		)
	)
	close_button.add_theme_stylebox_override(
		"hover",
		_make_style(
			Color(0.80, 0.08, 0.08, 0.20),
			Color("#FFB186"),
			2,
			8
		)
	)
	close_button.pressed.connect(close_inventory)
	menu_canvas.add_child(close_button)
	_attach_close_icon(close_button, false)

func _fit_menu_canvas() -> void:
	if menu_canvas == null or overlay == null:
		return

	var available_size: Vector2 = overlay.size
	if available_size.x <= 0.0 or available_size.y <= 0.0:
		available_size = Vector2(inventory_window_size)

	var scale_factor: float = min(
		available_size.x / VISIBLE_UI_BOUNDS.size.x,
		available_size.y / VISIBLE_UI_BOUNDS.size.y
	)

	menu_canvas.scale = Vector2.ONE * scale_factor
	menu_canvas.position = (
		available_size - VISIBLE_UI_BOUNDS.size * scale_factor
	) * 0.5 - VISIBLE_UI_BOUNDS.position * scale_factor

func _update_tab_styles() -> void:
	for index in range(tab_buttons.size()):
		var button: Button = tab_buttons[index]
		var tab_id: String = str(TAB_DATA[index]["id"])
		var selected: bool = tab_id == active_category

		var normal_color: Color = Color(0.0, 0.0, 0.0, 0.02)
		var border_color: Color = Color(0.82, 0.65, 0.24, 0.18)
		var text_color: Color = Color("#E9D5A1")

		if selected:
			normal_color = Color(0.04, 0.43, 0.30, 0.33)
			border_color = Color("#67F0BC")
			text_color = Color("#E7FFF6")

		button.add_theme_stylebox_override(
			"normal",
			_make_style(normal_color, border_color, 1, 5)
		)
		button.add_theme_stylebox_override(
			"hover",
			_make_style(
				Color(0.05, 0.50, 0.35, 0.22),
				Color("#A6FFD9"),
				2,
				5
			)
		)
		button.add_theme_stylebox_override(
			"pressed",
			_make_style(
				Color(0.04, 0.33, 0.24, 0.35),
				Color("#F3D878"),
				2,
				5
			)
		)
		button.add_theme_color_override("font_color", text_color)
		button.add_theme_color_override("font_hover_color", Color.WHITE)

func _create_overlay_button(
	button_text: String,
	button_rect: Rect2,
	accent: Color
) -> Button:
	var button: Button = Button.new()
	button.text = button_text
	button.position = button_rect.position
	button.size = button_rect.size
	button.focus_mode = Control.FOCUS_NONE
	button.mouse_filter = Control.MOUSE_FILTER_STOP
	button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	button.add_theme_font_size_override("font_size", 11)
	button.add_theme_color_override("font_color", Color("#FFF4D8"))
	button.add_theme_color_override("font_hover_color", Color.WHITE)
	button.add_theme_color_override("font_pressed_color", Color("#FFE792"))
	button.add_theme_color_override("font_disabled_color", Color("#77736C"))
	button.add_theme_constant_override("outline_size", 2)
	button.add_theme_color_override("font_outline_color", Color(0.0, 0.0, 0.0, 0.88))
	button.add_theme_stylebox_override(
		"normal",
		_make_style(
			Color(0.025, 0.035, 0.045, 0.82),
			Color(accent.r, accent.g, accent.b, 0.72),
			2,
			8,
			Color(0.0, 0.0, 0.0, 0.30),
			4,
			Vector2(0.0, 2.0)
		)
	)
	button.add_theme_stylebox_override(
		"hover",
		_make_style(
			Color(accent.r * 0.18, accent.g * 0.18, accent.b * 0.18, 0.94),
			accent,
			3,
			10,
			Color(accent.r, accent.g, accent.b, 0.28),
			8
		)
	)
	button.add_theme_stylebox_override(
		"pressed",
		_make_style(
			Color(accent.r * 0.11, accent.g * 0.11, accent.b * 0.11, 1.0),
			Color("#FFF1A8"),
			3,
			10
		)
	)
	button.add_theme_stylebox_override(
		"disabled",
		_make_style(
			Color(0.018, 0.022, 0.028, 0.72),
			Color(0.25, 0.23, 0.18, 0.48),
			1,
			10
		)
	)
	menu_canvas.add_child(button)
	return button

func _refresh_everything() -> void:
	_refresh_character_preview()
	_refresh_character_roster_slots()
	_refresh_inventory_grid()
	_refresh_equipment_slots()
	_refresh_stats()
	_refresh_bottom_information()
	_refresh_mission_panel()
	_refresh_skill_panel()
	_update_tab_styles()
	_update_category_visibility()

func _refresh_character_preview() -> void:
	if character_preview == null:
		return
	_apply_active_character_visual()

func _refresh_character_roster_slots() -> void:
	if character_buttons.is_empty():
		return

	var roster_title := menu_canvas.get_node_or_null("TituloCampeones") as Label
	if is_instance_valid(roster_title):
		roster_title.text = "CAMPEONES" if current_language == "es" else "CHAMPIONS"

	var roster := _get_character_roster_ids()
	for index in range(character_buttons.size()):
		var button: Button = character_buttons[index]
		if index >= roster.size():
			button.visible = false
			continue

		button.visible = true
		var character_id := roster[index]
		var data := _get_character_data(character_id)
		var is_character_unlocked: bool = unlocked_character_ids.has(character_id)
		var active := character_id == current_character_id
		var accent: Color = data.get("accent", Color("#D3A83C"))
		var short_name := str(data.get("short", "PJ"))
		var full_name := str(data.get("name_en" if current_language == "en" else "name_es", character_id))

		if is_character_unlocked:
			var hero_level: int = _character_level(character_id)
			button.text = ("◆ " if active else "") + short_name + "\n" + (("Lv.%d" if current_language == "en" else "Nv.%d") % hero_level)
			button.tooltip_text = "%s · %s %d" % [full_name, "Level" if current_language == "en" else "Nivel", hero_level]
		else:
			button.text = "🔒\n" + short_name
			button.tooltip_text = (
				_inv_text("unlock_character") % full_name
				if character_unlock_tokens > 0
				else _inv_text("need_character_token")
			)

		var background := Color(accent.r * 0.10, accent.g * 0.10, accent.b * 0.10, 0.96)
		var border := accent if is_character_unlocked else Color("#665F55")
		if active:
			border = Color("#FFF0A0")
		elif not is_character_unlocked and character_unlock_tokens > 0:
			border = Color("#D7A5FF")

		button.add_theme_color_override("font_color", accent if is_character_unlocked else Color("#9A948D"))
		button.add_theme_color_override("font_hover_color", Color.WHITE)
		button.add_theme_stylebox_override("normal", _make_style(background, border, 3 if active else 2, 10, Color(0, 0, 0, 0.55), 7))
		button.add_theme_stylebox_override("hover", _make_style(background.lightened(0.10), border.lightened(0.15), 3, 10, Color(border.r, border.g, border.b, 0.20), 10))
		button.add_theme_stylebox_override("pressed", _make_style(background.darkened(0.10), Color("#FFF0A0"), 3, 10))

func _refresh_inventory_grid() -> void:
	var filtered_indices: Array[int] = _get_filtered_inventory_indices()
	var empty_indices: Array[int] = _get_empty_inventory_indices()

	for visible_index in range(inventory_slot_buttons.size()):
		var slot_button: Button = inventory_slot_buttons[visible_index]
		_clear_button_content(slot_button)
		slot_button.set_meta("inventory_index", -1)
		slot_button.set_meta("drop_inventory_index", -1)
		slot_button.tooltip_text = _inv_text("empty_slot")

		if visible_index < filtered_indices.size():
			var inventory_index: int = filtered_indices[visible_index]
			var item: Dictionary = inventory_items[inventory_index]
			slot_button.set_meta("inventory_index", inventory_index)
			slot_button.set_meta("drop_inventory_index", inventory_index)
			slot_button.tooltip_text = _build_item_tooltip(item)
			_create_item_visual(slot_button, item)
			_apply_inventory_slot_style(
				slot_button,
				inventory_index == selected_inventory_index,
				true,
				item
			)
			continue

		var empty_visual_index: int = visible_index - filtered_indices.size()
		if empty_visual_index >= 0 and empty_visual_index < empty_indices.size():
			slot_button.set_meta(
				"drop_inventory_index",
				empty_indices[empty_visual_index]
			)

		_apply_inventory_slot_style(slot_button, false, false, {})

func _refresh_equipment_slots() -> void:
	for slot_name: String in EQUIPMENT_SLOT_ORDER:
		var button: Button = equipment_buttons.get(slot_name) as Button
		if button == null:
			continue
		_clear_button_content(button)
		var item: Dictionary = equipped_items.get(slot_name, {})
		if item.is_empty():
			button.tooltip_text = _equipment_slot_display_name(slot_name)
			_apply_equipment_rarity_style(button, {})
			_create_equipment_placeholder(button, slot_name)
			continue

		button.tooltip_text = _build_item_tooltip(item)
		_create_item_visual(button, item, true)
		_apply_equipment_rarity_style(button, item)
		if selected_equipment_slot == slot_name:
			var selected_color: Color = _get_item_rarity_color(item)
			button.add_theme_stylebox_override(
				"normal",
				_make_style(Color(selected_color.r, selected_color.g, selected_color.b, 0.16), Color("#FFF0A0"), 3, 8)
			)

func _create_equipment_placeholder(button: Button, slot_name: String) -> void:
	var placeholder_key: String = slot_name

	if slot_name.begins_with("anillo"):
		placeholder_key = "anillo"
	elif slot_name == "arma":
		match current_character_group:
			"arquero":
				placeholder_key = "arco"
			"arcanista", "nigromante":
				placeholder_key = "vara"
			_:
				placeholder_key = "espada"

	var path: String = str(
		EQUIPMENT_PLACEHOLDER_PATHS.get(
			placeholder_key,
			""
		)
	)

	if path.is_empty() or not ResourceLoader.exists(path):
		return

	var icon: TextureRect = TextureRect.new()
	icon.name = "SombraEquipamiento"
	icon.position = Vector2.ONE * EQUIPMENT_VISUAL_INSET
	icon.size = button.size - Vector2.ONE * EQUIPMENT_VISUAL_INSET * 2.0
	icon.texture = load(path) as Texture2D
	icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon.stretch_mode = TextureRect.STRETCH_SCALE
	icon.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	icon.modulate = Color(0.72, 0.78, 0.86, 0.34)
	icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
	button.add_child(icon)

func _refresh_stats() -> void:
	var final_stats: Dictionary = base_stats.duplicate(true)
	var controller: Node = _resolve_main_controller()
	if is_instance_valid(controller) and controller.has_method("get_hero_combat_stats"):
		var stats_variant: Variant = controller.call("get_hero_combat_stats", current_character_id)
		if stats_variant is Dictionary:
			final_stats = (stats_variant as Dictionary).duplicate(true)
	else:
		for slot_name: String in EQUIPMENT_SLOT_ORDER:
			var item: Dictionary = equipped_items.get(slot_name, {})
			if item.is_empty():
				continue
			var item_stats: Dictionary = item.get("stats", {})
			for stat_name: Variant in final_stats.keys():
				final_stats[stat_name] = int(final_stats.get(stat_name, 0)) + int(item_stats.get(stat_name, 0))

	for stat_name: Variant in stat_value_labels.keys():
		var label: Label = stat_value_labels[stat_name]
		label.text = str(int(final_stats.get(stat_name, 0)))
	if is_instance_valid(character_progress_label):
		var progress: Dictionary = _character_progress(current_character_id)
		character_progress_label.text = _inv_text("hero_progress") % [
			int(progress.get("level", 1)),
			int(progress.get("xp", 0)),
			int(progress.get("xp_required", 30))
		]

func _refresh_bottom_information() -> void:
	_sync_gold_from_main()
	gold_label.text = "%d" % gold
	capacity_label.text = "%d / %d" % [
		_count_occupied_slots(),
		maximum_slots
	]

	var selected_item: Dictionary = _get_selected_item()
	if selected_item.is_empty():
		selected_item_label.text = _inv_text("drag_to_equip")
		selected_item_label.add_theme_color_override("font_color", Color("#E8DAB8"))
		equip_button.text = _inv_text("equip")
		equip_button.disabled = true
		use_button.disabled = true
		return

	selected_item_label.text = _item_display_name(selected_item)
	selected_item_label.add_theme_color_override(
		"font_color",
		_get_item_rarity_color(selected_item)
	)

	if not selected_equipment_slot.is_empty():
		equip_button.text = _inv_text("remove")
		equip_button.disabled = false
		use_button.disabled = true
		return

	var category: String = str(selected_item.get("category", ""))
	var target_slot: String = str(selected_item.get("equip_slot", ""))
	var level_allowed: bool = _can_equip_item_level(selected_item)
	var compatible: bool = _is_item_compatible_with_slot(selected_item, target_slot)
	if not level_allowed:
		equip_button.text = _inv_text("level_required") % _required_item_level(selected_item)
	else:
		equip_button.text = _inv_text("equip") if compatible else _inv_text("incompatible")
	equip_button.disabled = (
		category != CATEGORY_EQUIPMENT
		or target_slot.is_empty()
		or not compatible
		or not level_allowed
	)
	use_button.disabled = not bool(selected_item.get("consumable", false))

func _apply_inventory_slot_style(
	button: Button,
	selected: bool,
	contains_item: bool,
	item: Dictionary = {}
) -> void:
	var normal_border: Color = Color(0.75, 0.56, 0.18, 0.05)
	var normal_background: Color = Color(0.0, 0.0, 0.0, 0.01)
	var rarity_color: Color = Color(0.86, 0.66, 0.24, 0.35)

	if contains_item:
		rarity_color = _get_item_rarity_color(item)
		normal_border = Color(
			rarity_color.r,
			rarity_color.g,
			rarity_color.b,
			0.82
		)
		normal_background = Color(
			rarity_color.r,
			rarity_color.g,
			rarity_color.b,
			0.055
		)

	if selected:
		normal_border = Color("#F8E69B")
		normal_background = Color(
			rarity_color.r,
			rarity_color.g,
			rarity_color.b,
			0.16
		)

	button.add_theme_stylebox_override(
		"normal",
		_make_style(
			normal_background,
			normal_border,
			3 if selected else (2 if contains_item else 1),
			5
		)
	)
	button.add_theme_stylebox_override(
		"hover",
		_make_style(
			Color(rarity_color.r, rarity_color.g, rarity_color.b, 0.14),
			rarity_color.lightened(0.20),
			2,
			5
		)
	)
	button.add_theme_stylebox_override(
		"pressed",
		_make_style(
			Color(rarity_color.r, rarity_color.g, rarity_color.b, 0.20),
			Color("#FFF0A0"),
			2,
			5
		)
	)

func _apply_equipment_rarity_style(button: Button, item: Dictionary) -> void:
	if item.is_empty():
		button.add_theme_stylebox_override(
			"normal",
			_make_style(
				Color(0.0, 0.0, 0.0, 0.0),
				Color(0.0, 0.0, 0.0, 0.0),
				0,
				8
			)
		)
		return

	var rarity_color: Color = _get_item_rarity_color(item)
	button.add_theme_stylebox_override(
		"normal",
		_make_style(
			Color(rarity_color.r, rarity_color.g, rarity_color.b, 0.07),
			Color(rarity_color.r, rarity_color.g, rarity_color.b, 0.88),
			2,
			8
		)
	)

func _create_item_visual(
	parent_button: Control,
	item: Dictionary,
	large_equipment_icon: bool = false
) -> void:
	var icon_path: String = str(item.get("icon_path", ""))
	var rarity_color: Color = _get_item_rarity_color(item)

	if not icon_path.is_empty() and ResourceLoader.exists(icon_path):
		var icon_rect: TextureRect = TextureRect.new()
		icon_rect.name = "IconoObjeto"

		if large_equipment_icon:

			icon_rect.position = Vector2.ONE * EQUIPMENT_VISUAL_INSET
			icon_rect.size = (
				parent_button.size
				- Vector2.ONE * EQUIPMENT_VISUAL_INSET * 2.0
			)
		else:
			icon_rect.position = Vector2(8.0, 7.0)
			icon_rect.size = parent_button.size - Vector2(16.0, 14.0)

		icon_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		icon_rect.stretch_mode = TextureRect.STRETCH_SCALE if large_equipment_icon else TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		icon_rect.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		icon_rect.texture = load(icon_path) as Texture2D
		icon_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
		parent_button.add_child(icon_rect)
	else:
		var abbreviation: String = _item_display_name(item)
		if abbreviation.length() > 2:
			abbreviation = abbreviation.substr(0, 2).to_upper()

		var fallback_position: Vector2 = Vector2.ZERO
		var fallback_size: Vector2 = parent_button.size
		var fallback_font_size: int = 15

		if large_equipment_icon:
			fallback_position = Vector2.ONE * EQUIPMENT_FALLBACK_INSET
			fallback_size = (
				parent_button.size
				- Vector2.ONE * EQUIPMENT_FALLBACK_INSET * 2.0
			)
			fallback_font_size = 13

		var fallback_label: Label = _create_label(
			parent_button,
			abbreviation,
			fallback_position,
			fallback_size,
			fallback_font_size,
			HORIZONTAL_ALIGNMENT_CENTER,
			rarity_color
		)
		fallback_label.add_theme_constant_override("outline_size", 3)
		fallback_label.add_theme_color_override(
			"font_outline_color",
			Color(0.0, 0.0, 0.0, 0.96)
		)

	var rarity_line: ColorRect = ColorRect.new()
	rarity_line.name = "ColorRareza"
	rarity_line.position = Vector2(7.0, parent_button.size.y - 6.0)
	rarity_line.size = Vector2(parent_button.size.x - 14.0, 3.0)
	rarity_line.color = rarity_color
	rarity_line.mouse_filter = Control.MOUSE_FILTER_IGNORE
	parent_button.add_child(rarity_line)

	var quantity: int = int(item.get("quantity", 1))
	if quantity > 1:
		var quantity_label: Label = _create_label(
			parent_button,
			str(quantity),
			Vector2(parent_button.size.x - 31.0, parent_button.size.y - 25.0),
			Vector2(27.0, 21.0),
			12,
			HORIZONTAL_ALIGNMENT_RIGHT,
			Color.WHITE
		)
		quantity_label.name = "CantidadObjeto"
		quantity_label.add_theme_constant_override("outline_size", 3)
		quantity_label.add_theme_color_override(
			"font_outline_color",
			Color(0.0, 0.0, 0.0, 0.95)
		)

func _clear_button_content(button: Button) -> void:
	var children_to_remove: Array[Node] = []

	for child in button.get_children():
		children_to_remove.append(child)

	for child in children_to_remove:
		button.remove_child(child)
		child.queue_free()

func _on_tab_pressed(category_id: String) -> void:
	active_category = category_id
	selected_inventory_index = -1
	selected_equipment_slot = ""
	_refresh_everything()

func _update_category_visibility() -> void:
	var showing_missions: bool = active_category == CATEGORY_QUESTS
	var showing_skills: bool = active_category == CATEGORY_SKILLS
	for button: Button in inventory_slot_buttons:
		button.visible = not showing_missions and not showing_skills
	if is_instance_valid(mission_header):
		mission_header.visible = showing_missions
	if is_instance_valid(mission_hint):
		mission_hint.visible = showing_missions
	if is_instance_valid(mission_count_label):
		mission_count_label.visible = showing_missions
	if is_instance_valid(mission_scroll):
		mission_scroll.visible = showing_missions
	if is_instance_valid(skill_panel):
		skill_panel.visible = showing_skills
	if is_instance_valid(equip_button):
		equip_button.visible = not showing_missions and not showing_skills
	if is_instance_valid(use_button):
		use_button.visible = not showing_missions and not showing_skills
	if is_instance_valid(sort_button):
		sort_button.visible = not showing_missions and not showing_skills
	if is_instance_valid(gold_label):
		gold_label.visible = not showing_missions
	if is_instance_valid(capacity_label):
		capacity_label.visible = not showing_missions and not showing_skills

func _build_skill_panel() -> void:
	skill_panel = Control.new()
	skill_panel.name = "PanelHabilidadesEquipables"
	skill_panel.position = Vector2(765.0, 212.0)
	skill_panel.size = Vector2(735.0, 515.0)
	skill_panel.visible = false
	menu_canvas.add_child(skill_panel)

	var background: Panel = Panel.new()
	background.position = Vector2.ZERO
	background.size = skill_panel.size
	background.mouse_filter = Control.MOUSE_FILTER_IGNORE
	background.add_theme_stylebox_override("panel", _make_style(Color(0.004,0.012,0.020,0.88), Color(0.75,0.55,0.18,0.65), 2, 8))
	skill_panel.add_child(background)

	skill_title_label = _create_label(skill_panel, _inv_text("skills_title"), Vector2(52, 41), Vector2(699, 34), 22, HORIZONTAL_ALIGNMENT_CENTER, Color("#F4D47A"))
	skill_hint_label = _create_label(skill_panel, _inv_text("skills_hint"), Vector2(89, 42), Vector2(679, 46), 14, HORIZONTAL_ALIGNMENT_CENTER, Color("#C6D6E8"))
	skill_hint_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	active_skill_title_label = _create_label(skill_panel, _inv_text("active_skills"), Vector2(24, 100), Vector2(300, 28), 16, HORIZONTAL_ALIGNMENT_CENTER, Color("#FFCF6A"))
	passive_skill_title_label = _create_label(skill_panel, _inv_text("passive_skills"), Vector2(24, 260), Vector2(300, 28), 16, HORIZONTAL_ALIGNMENT_CENTER, Color("#79E8C1"))
	available_skill_title_label = _create_label(skill_panel, _inv_text("available_skills"), Vector2(279, 173), Vector2(360, 28), 16, HORIZONTAL_ALIGNMENT_CENTER, Color("#D6B0FF"))

	active_skill_slot_buttons.clear()
	for index: int in range(SistemaHabilidadesEquipables.MAX_ACTIVE_SLOTS):
		var button: Button = _create_skill_slot_button(Vector2(32.0 + float(index) * 145.0, 140.0), Vector2(130.0, 92.0), SistemaHabilidadesEquipables.TYPE_ACTIVE, index)
		active_skill_slot_buttons.append(button)
	passive_skill_slot_buttons.clear()
	for index: int in range(SistemaHabilidadesEquipables.MAX_PASSIVE_SLOTS):
		var button: Button = _create_skill_slot_button(Vector2(18.0 + float(index) * 102.0, 302.0), Vector2(94.0, 94.0), SistemaHabilidadesEquipables.TYPE_PASSIVE, index)
		passive_skill_slot_buttons.append(button)

	var scroll: ScrollContainer = ScrollContainer.new()
	scroll.position = Vector2(383, 133)
	scroll.size = Vector2(360, 342)
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	skill_panel.add_child(scroll)
	unlocked_skill_list = VBoxContainer.new()
	unlocked_skill_list.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	unlocked_skill_list.add_theme_constant_override("separation", 8)
	scroll.add_child(unlocked_skill_list)
	skill_empty_label = _create_label(skill_panel, _inv_text("no_skills"), Vector2(370, 250), Vector2(320, 80), 15, HORIZONTAL_ALIGNMENT_CENTER, Color("#AEB7C3"))
	skill_empty_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	skill_empty_label.visible = false

func _create_skill_slot_button(position_value: Vector2, size_value: Vector2, skill_type: String, index: int) -> Button:
	var button: Button = Button.new()
	button.position = position_value
	button.size = size_value
	button.text = "—"
	button.focus_mode = Control.FOCUS_NONE
	button.set_meta("skill_type", skill_type)
	button.set_meta("skill_index", index)
	button.pressed.connect(_on_equipped_skill_slot_pressed.bind(skill_type, index))
	button.add_theme_font_size_override("font_size", 12)
	button.add_theme_stylebox_override("normal", _make_style(Color(0.01,0.025,0.035,0.92), Color(0.40,0.38,0.28,0.80), 2, 8))
	button.add_theme_stylebox_override("hover", _make_style(Color(0.03,0.10,0.08,0.96), Color("#FFE18A"), 2, 8))
	skill_panel.add_child(button)
	return button

func _get_skill_ranks_from_save() -> Dictionary:
	var config: ConfigFile = ConfigFile.new()
	if config.load(SKILL_SAVE_PATH) == OK:
		var raw: Variant = config.get_value("habilidades", "rangos", {})
		if raw is Dictionary:
			return (raw as Dictionary).duplicate(true)
	return {}

func _get_unlocked_equipable_skills(character_id: String) -> Array[String]:
	return SistemaHabilidadesEquipables.habilidades_desbloqueadas(_get_skill_ranks_from_save(), character_id)

func _ensure_character_skill_loadout(character_id: String) -> Dictionary:
	var unlocked: Array[String] = _get_unlocked_equipable_skills(character_id)
	var raw: Variant = skill_loadouts_by_character.get(character_id, {})
	var normalized: Dictionary = SistemaHabilidadesEquipables.normalizar_carga(raw, character_id, unlocked)
	skill_loadouts_by_character[character_id] = normalized
	return normalized

func get_equipped_skills_for_character(character_id: String) -> Dictionary:
	return _ensure_character_skill_loadout(character_id).duplicate(true)

func _refresh_skill_panel() -> void:
	if not is_instance_valid(skill_panel):
		return
	if is_instance_valid(skill_title_label): skill_title_label.text = _inv_text("skills_title")
	if is_instance_valid(skill_hint_label): skill_hint_label.text = _inv_text("skills_hint")
	if is_instance_valid(active_skill_title_label): active_skill_title_label.text = _inv_text("active_skills")
	if is_instance_valid(passive_skill_title_label): passive_skill_title_label.text = _inv_text("passive_skills")
	if is_instance_valid(available_skill_title_label): available_skill_title_label.text = _inv_text("available_skills")
	var loadout: Dictionary = _ensure_character_skill_loadout(current_character_id)
	_refresh_skill_slot_group(active_skill_slot_buttons, loadout.get("active", []))
	_refresh_skill_slot_group(passive_skill_slot_buttons, loadout.get("passive", []))
	if not is_instance_valid(unlocked_skill_list):
		return
	for child: Node in unlocked_skill_list.get_children(): child.queue_free()
	var unlocked: Array[String] = _get_unlocked_equipable_skills(current_character_id)
	if is_instance_valid(skill_empty_label):
		skill_empty_label.text = _inv_text("no_skills")
		skill_empty_label.visible = unlocked.is_empty()
	for skill_id: String in unlocked:
		var data: Dictionary = SistemaHabilidadesEquipables.obtener_habilidad(skill_id)
		var button: Button = Button.new()
		button.custom_minimum_size = Vector2(334, 70)
		button.focus_mode = Control.FOCUS_NONE
		button.text = "%s  %s\n%s" % [str(data.get("symbol", "✦")), SistemaHabilidadesEquipables.obtener_nombre(skill_id, current_language), SistemaHabilidadesEquipables.obtener_descripcion(skill_id, current_language)]
		button.alignment = HORIZONTAL_ALIGNMENT_LEFT
		button.add_theme_font_size_override("font_size", 12)
		button.tooltip_text = SistemaHabilidadesEquipables.obtener_descripcion(skill_id, current_language)
		var accent: Color = Color(str(data.get("accent", "#FFE18A")))
		var equipped: bool = _loadout_contains(loadout, skill_id)
		button.add_theme_stylebox_override("normal", _make_style(Color(accent.r,accent.g,accent.b,0.17 if equipped else 0.05), accent, 2 if equipped else 1, 7))
		button.add_theme_stylebox_override("hover", _make_style(Color(accent.r,accent.g,accent.b,0.25), Color.WHITE, 2, 7))
		button.pressed.connect(_on_skill_choice_pressed.bind(skill_id))
		unlocked_skill_list.add_child(button)

func _refresh_skill_slot_group(buttons: Array[Button], raw_skills: Variant) -> void:
	var skills: Array = raw_skills if raw_skills is Array else []
	for index: int in range(buttons.size()):
		var button: Button = buttons[index]
		var skill_id: String = str(skills[index]) if index < skills.size() else ""
		button.set_meta("skill_id", skill_id)
		if skill_id.is_empty():
			button.text = "—\nHUECO" if current_language == "es" else "—\nSLOT"
			button.tooltip_text = ""
			continue
		var data: Dictionary = SistemaHabilidadesEquipables.obtener_habilidad(skill_id)
		button.text = "%s\n%s" % [str(data.get("symbol", "✦")), SistemaHabilidadesEquipables.obtener_nombre(skill_id, current_language)]
		button.tooltip_text = SistemaHabilidadesEquipables.obtener_descripcion(skill_id, current_language)

func _loadout_contains(loadout: Dictionary, skill_id: String) -> bool:
	for type_id: String in [SistemaHabilidadesEquipables.TYPE_ACTIVE, SistemaHabilidadesEquipables.TYPE_PASSIVE]:
		var raw: Variant = loadout.get(type_id, [])
		if raw is Array and (raw as Array).has(skill_id): return true
	return false

func _on_skill_choice_pressed(skill_id: String) -> void:
	var data: Dictionary = SistemaHabilidadesEquipables.obtener_habilidad(skill_id)
	if data.is_empty(): return
	var type_id: String = str(data.get("type", ""))
	var loadout: Dictionary = _ensure_character_skill_loadout(current_character_id)
	var slots: Array = (loadout.get(type_id, []) as Array).duplicate()
	var existing_index: int = slots.find(skill_id)
	if existing_index >= 0:
		slots[existing_index] = ""
	else:
		var empty_index: int = slots.find("")
		if empty_index < 0: empty_index = 0
		slots[empty_index] = skill_id
	loadout[type_id] = slots
	skill_loadouts_by_character[current_character_id] = loadout
	_save_skill_loadouts()
	_refresh_skill_panel()
	inventory_changed.emit()

func _on_equipped_skill_slot_pressed(skill_type: String, index: int) -> void:
	var loadout: Dictionary = _ensure_character_skill_loadout(current_character_id)
	var slots: Array = (loadout.get(skill_type, []) as Array).duplicate()
	if index >= 0 and index < slots.size() and not str(slots[index]).is_empty():
		slots[index] = ""
		loadout[skill_type] = slots
		skill_loadouts_by_character[current_character_id] = loadout
		_save_skill_loadouts()
		_refresh_skill_panel()
		inventory_changed.emit()

func _load_skill_loadouts() -> void:
	var config: ConfigFile = ConfigFile.new()
	if config.load(SKILL_SAVE_PATH) == OK:
		var raw: Variant = config.get_value("equipadas", "por_personaje", {})
		if raw is Dictionary:
			skill_loadouts_by_character = (raw as Dictionary).duplicate(true)
	_ensure_character_skill_loadout(current_character_id)

func _save_skill_loadouts() -> void:
	var config: ConfigFile = ConfigFile.new()
	config.load(SKILL_SAVE_PATH)
	config.set_value("equipadas", "por_personaje", skill_loadouts_by_character)
	var error: Error = config.save(SKILL_SAVE_PATH)
	if error != OK: push_warning("No se pudieron guardar las habilidades equipadas.")

func _refresh_mission_panel() -> void:
	if not is_instance_valid(mission_list):
		return
	for child: Node in mission_list.get_children():
		child.queue_free()
	if not is_instance_valid(mission_system):
		_resolve_mission_system()
	if not is_instance_valid(mission_system) or not mission_system.has_method("get_entries"):
		return
	var zone_id: String = ""
	if is_instance_valid(main_controller) and main_controller.has_method("get_current_zone_id"):
		zone_id = str(main_controller.call("get_current_zone_id"))
	var entries: Array = mission_system.call("get_entries", zone_id)
	var total_count: int = entries.size()
	var completed_count: int = 0
	for raw_entry: Variant in entries:
		if raw_entry is Dictionary and bool((raw_entry as Dictionary).get("claimed", false)):
			completed_count += 1
	if is_instance_valid(mission_header):
		mission_header.text = _inv_text("mission_title")
	if is_instance_valid(mission_count_label):
		mission_count_label.text = "%d / %d" % [completed_count, total_count]
	if is_instance_valid(mission_hint):
		mission_hint.text = _inv_text("mission_hint")
	for raw_entry: Variant in entries:
		if not (raw_entry is Dictionary):
			continue
		var entry: Dictionary = raw_entry
		var mission_id: String = str(entry.get("id", ""))
		var is_mission_completed: bool = bool(entry.get("completed", false))
		var claimed: bool = bool(entry.get("claimed", false))
		var accent: Color = Color("#55E6B0") if is_mission_completed and not claimed else Color("#D4B35D")
		var parchment: Color = Color(0.065, 0.048, 0.020, 0.96)
		if claimed:
			accent = Color("#7D8791")
			parchment = Color(0.030, 0.035, 0.045, 0.94)
		var card: Button = Button.new()
		card.name = "Mision_" + mission_id
		card.custom_minimum_size = Vector2(650.0, 110.0)
		card.focus_mode = Control.FOCUS_NONE
		card.alignment = HORIZONTAL_ALIGNMENT_LEFT
		card.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		card.add_theme_font_size_override("font_size", 15)
		card.add_theme_color_override("font_color", Color("#F5EBD7"))
		card.add_theme_color_override("font_hover_color", Color.WHITE)
		card.add_theme_constant_override("outline_size", 2)
		card.add_theme_color_override("font_outline_color", Color(0, 0, 0, 0.95))
		card.add_theme_stylebox_override("normal", _make_style(parchment, accent, 2, 8))
		card.add_theme_stylebox_override("hover", _make_style(Color(0.095, 0.070, 0.032, 0.98), accent.lightened(0.15), 3, 8))
		var status: String = _inv_text("mission_claimed") if claimed else (_inv_text("mission_claim") if is_mission_completed else (_inv_text("mission_progress") % [int(entry.get("progress", 0)), int(entry.get("target", 1))]))
		card.text = "  [MISIÓN]\n  %s\n  %s\n  %s  ·  %s" % [str(entry.get("title", mission_id)), str(entry.get("description", "")), str(entry.get("reward_text", "")), status]
		card.tooltip_text = str(entry.get("description", ""))
		card.disabled = claimed
		card.pressed.connect(_on_mission_pressed.bind(mission_id, str(entry.get("title", mission_id)), str(entry.get("reward_text", ""))))
		mission_list.add_child(card)

func _on_mission_pressed(mission_id: String, title: String, reward_text: String) -> void:
	if not is_instance_valid(mission_system):
		return
	var claimed_now: bool = bool(mission_system.call("claim_mission", mission_id))
	if claimed_now:
		selected_item_label.text = _inv_text("mission_claim_success") % reward_text
		selected_item_label.add_theme_color_override("font_color", Color("#73F2BE"))
		_refresh_mission_panel()
		_sync_gold_from_main()
	else:
		selected_item_label.text = _inv_text("mission_in_progress") % title
		selected_item_label.add_theme_color_override("font_color", Color("#F2D079"))

func _on_inventory_slot_pressed(visible_index: int) -> void:
	if _consume_suppressed_button_press():
		return
	if visible_index < 0 or visible_index >= inventory_slot_buttons.size():
		return

	var button: Button = inventory_slot_buttons[visible_index]
	var inventory_index: int = int(button.get_meta("inventory_index", -1))

	if inventory_index < 0 or inventory_index >= inventory_items.size():
		selected_inventory_index = -1
		selected_equipment_slot = ""
		_refresh_everything()
		return

	selected_inventory_index = inventory_index
	selected_equipment_slot = ""
	_refresh_everything()

func _on_equipment_slot_pressed(slot_name: String) -> void:
	if _consume_suppressed_button_press():
		return

	var equipped_item: Dictionary = equipped_items.get(slot_name, {})
	if equipped_item.is_empty():
		selected_equipment_slot = ""
		selected_inventory_index = -1
	else:
		selected_equipment_slot = slot_name
		selected_inventory_index = -1
	_refresh_everything()

func _on_equip_pressed() -> void:
	if not selected_equipment_slot.is_empty():
		_unequip_equipment_slot(selected_equipment_slot, -1)
		return

	var item: Dictionary = _get_selected_item()
	if item.is_empty():
		return

	var target_slot: String = str(item.get("equip_slot", ""))
	_equip_inventory_item_to_slot(selected_inventory_index, target_slot)

func _on_use_pressed() -> void:
	var item: Dictionary = _get_selected_item()
	if item.is_empty() or not bool(item.get("consumable", false)):
		return

	var item_id: String = str(item.get("id", ""))
	var quantity: int = int(item.get("quantity", 1)) - 1

	if quantity <= 0:
		inventory_items[selected_inventory_index] = {}
		selected_inventory_index = -1
	else:
		item["quantity"] = quantity
		inventory_items[selected_inventory_index] = item

	item_used.emit(item_id)
	inventory_changed.emit()
	_refresh_everything()
	_save_inventory()

func _sort_inventory() -> void:
	var occupied_items: Array[Dictionary] = []

	for item in inventory_items:
		if not item.is_empty():
			occupied_items.append(item.duplicate(true))

	occupied_items.sort_custom(
		func(first: Dictionary, second: Dictionary) -> bool:
			var first_key: String = (
				str(first.get("category", ""))
				+ "_"
				+ str(first.get("name", ""))
			).to_lower()
			var second_key: String = (
				str(second.get("category", ""))
				+ "_"
				+ str(second.get("name", ""))
			).to_lower()
			return first_key < second_key
	)

	for index in range(inventory_items.size()):
		inventory_items[index] = {}

	for index in range(occupied_items.size()):
		inventory_items[index] = occupied_items[index]

	selected_inventory_index = -1
	inventory_changed.emit()
	_refresh_everything()
	_save_inventory()

func add_item(item_data: Dictionary) -> bool:
	var normalized_item: Dictionary = _normalize_item(item_data)
	var item_id: String = str(normalized_item.get("id", ""))

	if item_id.is_empty():
		push_warning(_inv_text("no_item_id"))
		return false

	if bool(normalized_item.get("stackable", false)):
		for index in range(inventory_items.size()):
			var existing_item: Dictionary = inventory_items[index]
			if str(existing_item.get("id", "")) == item_id:
				existing_item["quantity"] = (
					int(existing_item.get("quantity", 1))
					+ int(normalized_item.get("quantity", 1))
				)
				inventory_items[index] = existing_item
				inventory_changed.emit()
				_refresh_everything()
				_save_inventory()
				return true

	var free_index: int = _find_first_empty_slot()
	if free_index == -1:
		return false

	inventory_items[free_index] = normalized_item
	inventory_changed.emit()
	_refresh_everything()
	_save_inventory()
	return true

func remove_item(item_id: String, amount: int = 1) -> bool:
	for index in range(inventory_items.size()):
		var item: Dictionary = inventory_items[index]
		if str(item.get("id", "")) != item_id:
			continue

		var quantity: int = int(item.get("quantity", 1)) - amount
		if quantity <= 0:
			inventory_items[index] = {}
		else:
			item["quantity"] = quantity
			inventory_items[index] = item

		inventory_changed.emit()
		_refresh_everything()
		_save_inventory()
		return true

	return false

func has_item(item_id: String, amount: int = 1) -> bool:
	var total_quantity: int = 0

	for item in inventory_items:
		if str(item.get("id", "")) == item_id:
			total_quantity += int(item.get("quantity", 1))

	return total_quantity >= amount

func set_character_texture(texture_path: String) -> void:
	character_texture_path = texture_path

	if character_preview == null:
		return

	_load_character_idle_frames(current_character_id, texture_path)
	if character_idle_frames.size() > 0:
		character_idle_frame_index = 0
		character_idle_time = 0.0
		character_preview.texture = character_idle_frames[0] as Texture2D
		character_preview.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		character_preview.visible = true
		if is_instance_valid(character_placeholder_label):
			character_placeholder_label.visible = false
		_bring_inventory_controls_to_front()
		return

	if texture_path.is_empty() or not ResourceLoader.exists(texture_path):
		character_preview.texture = null
		return

	character_preview.texture = load(texture_path) as Texture2D
	character_preview.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	_bring_inventory_controls_to_front()

func set_base_stats(new_stats: Dictionary) -> void:
	for stat_name in base_stats.keys():
		if new_stats.has(stat_name):
			base_stats[stat_name] = int(new_stats[stat_name])

	_refresh_stats()

func add_gold(amount: int) -> void:
	_sync_gold_from_main()
	gold = maxi(0, gold + amount)
	_write_gold_to_main(gold)
	_refresh_bottom_information()
	_save_inventory()

func get_equipped_item(slot_name: String) -> Dictionary:
	return equipped_items.get(slot_name, {}).duplicate(true)

func get_inventory_copy() -> Array[Dictionary]:
	return inventory_items.duplicate(true)

func take_item_at(index: int) -> Dictionary:
	if index < 0 or index >= inventory_items.size():
		return {}

	var item: Dictionary = inventory_items[index]
	if item.is_empty():
		return {}

	inventory_items[index] = {}
	selected_inventory_index = -1
	inventory_changed.emit()
	_refresh_everything()
	_save_inventory()
	return item.duplicate(true)

func take_one_item_at(index: int) -> Dictionary:
	if index < 0 or index >= inventory_items.size():
		return {}

	var stored_item: Dictionary = inventory_items[index]
	if stored_item.is_empty():
		return {}

	var extracted_item: Dictionary = stored_item.duplicate(true)
	var quantity: int = maxi(1, int(stored_item.get("quantity", 1)))
	extracted_item["quantity"] = 1

	if bool(stored_item.get("stackable", false)) and quantity > 1:
		stored_item["quantity"] = quantity - 1
		inventory_items[index] = stored_item
	else:
		inventory_items[index] = {}

	selected_inventory_index = -1
	inventory_changed.emit()
	_refresh_everything()
	_save_inventory()
	return extracted_item

func cancel_external_drag() -> void:
	_clear_drag_state()

func get_inventory_item_at(index: int) -> Dictionary:
	if index < 0 or index >= inventory_items.size():
		return {}
	return inventory_items[index].duplicate(true)

func get_free_slot_count() -> int:
	var free_slots: int = 0
	for item in inventory_items:
		if item.is_empty():
			free_slots += 1
	return free_slots

func get_equipment_bonus_stats() -> Dictionary:
	var result: Dictionary = {
		"vida": 0,
		"daño": 0,
		"def": 0,
		"vel": 0,
		"magia": 0
	}

	for slot_name in EQUIPMENT_SLOT_ORDER:
		var item: Dictionary = equipped_items.get(slot_name, {})
		if item.is_empty():
			continue

		var stats_variant: Variant = item.get("stats", {})
		if not (stats_variant is Dictionary):
			continue

		var item_stats: Dictionary = stats_variant
		for stat_name in result.keys():
			result[stat_name] = (
				int(result.get(stat_name, 0))
				+ int(item_stats.get(stat_name, 0))
			)

	return result

func get_equipped_items_for_character(character_id: String) -> Dictionary:
	if character_id == current_character_id:
		return equipped_items.duplicate(true)
	var raw: Variant = equipped_by_character.get(character_id, {})
	return (raw as Dictionary).duplicate(true) if raw is Dictionary else _create_empty_equipment_set()

func get_equipment_bonus_stats_for_character(character_id: String) -> Dictionary:
	var stats: Dictionary = {"vida": 0, "daño": 0, "def": 0, "vel": 0, "magia": 0}
	var hero_equipment: Dictionary = get_equipped_items_for_character(character_id)
	for slot_name: String in EQUIPMENT_SLOT_ORDER:
		var item: Dictionary = hero_equipment.get(slot_name, {})
		if item.is_empty():
			continue
		var raw_stats: Variant = item.get("stats", {})
		if not (raw_stats is Dictionary):
			continue
		for stat_name: String in stats.keys():
			stats[stat_name] = int(stats[stat_name]) + int((raw_stats as Dictionary).get(stat_name, 0))
	return stats

func get_active_unique_passives() -> Array[Dictionary]:
	var result: Array[Dictionary] = []

	for slot_name in EQUIPMENT_SLOT_ORDER:
		var item: Dictionary = equipped_items.get(slot_name, {})
		if item.is_empty():
			continue
		if str(item.get("rarity", item.get("rareza", "comun"))) != "unico":
			continue

		var passive_variant: Variant = item.get("passive", {})
		if not (passive_variant is Dictionary):
			continue

		var passive: Dictionary = (passive_variant as Dictionary).duplicate(true)
		if passive.is_empty():
			continue

		passive["item_id"] = str(item.get("id", ""))
		passive["item_name"] = str(item.get("name", "Objeto único"))
		passive["equipment_slot"] = slot_name
		result.append(passive)

	return result

func get_equipment_effects() -> Dictionary:
	return {
		"stats": get_equipment_bonus_stats(),
		"passives": get_active_unique_passives()
	}

func _is_valid_item_dictionary(item_data: Dictionary) -> bool:

	if item_data.is_empty():
		return false

	var item_id: String = str(item_data.get("id", "")).strip_edges()
	if item_id.is_empty():
		return false

	return true

func _normalize_item(item_data: Dictionary) -> Dictionary:

	if not _is_valid_item_dictionary(item_data):
		return {}

	var item: Dictionary = BaseDatosObjetos.completar_objeto_guardado(
		item_data
	)

	if not _is_valid_item_dictionary(item):
		return {}

	if not item.has("name") or str(item.get("name", "")).strip_edges().is_empty():
		item["name"] = _inv_text("unknown_item")
	if not item.has("category"):
		item["category"] = CATEGORY_OBJECTS
	if not item.has("quantity"):
		item["quantity"] = 1
	if not item.has("stackable"):
		item["stackable"] = false
	if not item.has("consumable"):
		item["consumable"] = false
	if not item.has("equip_slot"):
		item["equip_slot"] = ""
	if str(item.get("equip_slot", "")) == "accesorio":
		item["equip_slot"] = "estandarte"
	if not item.has("icon_path"):
		item["icon_path"] = ""
	if not item.has("description"):
		item["description"] = ""
	if not item.has("stats"):
		item["stats"] = {}
	if not item.has("rarity"):
		item["rarity"] = "comun"
	if not item.has("rareza"):
		item["rareza"] = str(item.get("rarity", "comun"))
	if not item.has("rarity_name"):
		item["rarity_name"] = _get_rarity_display_name(
			str(item.get("rarity", "comun"))
		)
	if not item.has("rarity_color"):
		item["rarity_color"] = _get_item_rarity_color(item).to_html()
	if not item.has("item_level"):
		item["item_level"] = 1
	if not item.has("weapon_type"):
		item["weapon_type"] = _infer_weapon_type(item)
	if not item.has("allowed_classes"):
		item["allowed_classes"] = []
	if not item.has("passive"):
		item["passive"] = {}

	if str(item.get("rarity", "comun")) != "unico":
		item["passive"] = {}

	return item

func _sanitize_inventory_data() -> bool:

	var changed: bool = false

	for index in range(inventory_items.size()):
		var item: Dictionary = inventory_items[index]
		if item.is_empty():
			continue
		if not _is_valid_item_dictionary(item):
			inventory_items[index] = {}
			changed = true

	for slot_name in EQUIPMENT_SLOT_ORDER:
		var equipped_variant: Variant = equipped_items.get(slot_name, {})
		if not (equipped_variant is Dictionary):
			equipped_items[slot_name] = {}
			changed = true
			continue

		var equipped_item: Dictionary = equipped_variant
		if not equipped_item.is_empty() and not _is_valid_item_dictionary(equipped_item):
			equipped_items[slot_name] = {}
			changed = true

	return changed

func _get_filtered_inventory_indices() -> Array[int]:
	var result: Array[int] = []

	for index in range(inventory_items.size()):
		var item: Dictionary = inventory_items[index]
		if not _is_valid_item_dictionary(item):
			continue

		if str(item.get("category", "")) == active_category:
			result.append(index)

	return result

func _get_empty_inventory_indices() -> Array[int]:
	var result: Array[int] = []

	for index in range(inventory_items.size()):
		if not _is_valid_item_dictionary(inventory_items[index]):
			result.append(index)

	return result

func _get_selected_item() -> Dictionary:
	if not selected_equipment_slot.is_empty():
		return equipped_items.get(selected_equipment_slot, {})

	if (
		selected_inventory_index < 0
		or selected_inventory_index >= inventory_items.size()
	):
		return {}

	return inventory_items[selected_inventory_index]

func _find_first_empty_slot() -> int:
	for index in range(inventory_items.size()):
		if not _is_valid_item_dictionary(inventory_items[index]):
			return index
	return -1

func _count_occupied_slots() -> int:
	var amount: int = 0

	for item in inventory_items:
		if _is_valid_item_dictionary(item):
			amount += 1

	return amount

func _build_item_tooltip(item: Dictionary) -> String:
	if not _is_valid_item_dictionary(item):
		return _inv_text("empty_slot")

	var rarity: String = str(item.get("rarity", item.get("rareza", "comun")))
	var rarity_name: String = _get_rarity_display_name(rarity)
	var item_name: String = _item_display_name(item)
	var item_level: int = maxi(1, int(item.get("item_level", 1)))
	var quantity: int = maxi(1, int(item.get("quantity", 1)))

	var lines: Array[String] = []
	lines.append(_inv_text("rarity_level") % [rarity_name, item_level])

	var name_line: String = item_name
	if quantity > 1:
		name_line += " x%d" % quantity
	lines.append(name_line)

	var description: String = _item_display_description(item)
	if not description.is_empty():
		lines.append(description)

	var source_zone: String = str(item.get("source_zone", "")).strip_edges()
	if not source_zone.is_empty():
		lines.append(
			_inv_text("origin")
			% SistemaRegiones.obtener_nombre(
				source_zone,
				current_language,
				true
			)
		)

	var effect_lines: Array[String] = []
	var stats_variant: Variant = item.get("stats", {})
	if stats_variant is Dictionary:
		var stats: Dictionary = stats_variant
		for stat_name in ["vida", "daño", "def", "vel", "magia"]:
			var value: int = int(stats.get(stat_name, 0))
			if value != 0:
				effect_lines.append(_stat_effect_text(stat_name, value))

	var consumable_variant: Variant = item.get("effect", {})
	if consumable_variant is Dictionary:
		var consumable_effect: Dictionary = consumable_variant
		var healing: int = int(consumable_effect.get("heal", 0))
		if healing > 0:
			effect_lines.append(_inv_text("heal_effect") % healing)

	if not effect_lines.is_empty():
		lines.append(_inv_text("effects"))
		for effect_line in effect_lines:
			lines.append(effect_line)

	var allowed_variant: Variant = item.get("allowed_classes", [])
	if allowed_variant is Array:
		var allowed_classes: Array = allowed_variant
		if not allowed_classes.is_empty():
			var class_names: Array[String] = []
			for class_id in allowed_classes:
				class_names.append(_class_display_name(str(class_id)))
			lines.append(_inv_text("class_label") + ", ".join(class_names))

	if rarity == "unico":
		var passive_variant: Variant = item.get("passive", {})
		if passive_variant is Dictionary:
			var passive: Dictionary = passive_variant
			if not passive.is_empty():
				lines.append(_build_unique_passive_tooltip(passive))

	return "\n".join(lines)

func _stat_effect_text(stat_name: String, value: int) -> String:
	match stat_name:
		"vida":
			return _inv_text("max_health_effect") % value
		"daño":
			return _inv_text("damage_effect") % value
		"def":
			return _inv_text("defense_effect") % value
		"vel":
			return _inv_text("speed_effect") % value
		"magia":
			return _inv_text("magic_effect") % value
		_:
			return "• +%d %s" % [value, stat_name.capitalize()]

func _build_unique_passive_tooltip(passive: Dictionary) -> String:
	var passive_name: String = _passive_display_name(passive)
	var passive_description: String = ""

	match str(passive.get("type", "")):
		"periodic_shield":
			passive_description = _inv_text("periodic_shield") % [
				int(round(float(passive.get("cooldown", 50.0)))),
				int(passive.get("shield", 0))
			]
		_:
			passive_description = _inv_text("generic_unique")

	return _inv_text("unique_passive") % [
		passive_name.to_upper(),
		passive_description
	]

func _get_item_rarity_color(item: Dictionary) -> Color:
	var html_color: String = str(item.get("rarity_color", ""))
	if not html_color.is_empty():
		return Color(html_color)

	var rarity: String = str(item.get("rarity", item.get("rareza", "comun")))
	match rarity:
		"poco_comun":
			return Color("#55D978")
		"raro":
			return Color("#4FA4FF")
		"epico":
			return Color("#B66CFF")
		"legendario":
			return Color("#FFAD45")
		"mitico":
			return Color("#FF4F7B")
		"ancestral":
			return Color("#55F2E1")
		"unico":
			return Color("#58FFB5")
		_:
			return Color("#C7CCD4")

func _get_rarity_display_name(rarity: String) -> String:
	match rarity:
		"poco_comun":
			return _inv_text("rarity_uncommon")
		"raro":
			return _inv_text("rarity_rare")
		"epico":
			return _inv_text("rarity_epic")
		"legendario":
			return _inv_text("rarity_legendary")
		"mitico":
			return _inv_text("rarity_mythic")
		"ancestral":
			return _inv_text("rarity_ancestral")
		"unico":
			return _inv_text("rarity_unique")
		_:
			return _inv_text("rarity_common")

func _equipment_slot_display_name(slot_name: String) -> String:
	var keys: Dictionary = {
		"casco": "slot_helmet",
		"armadura": "slot_armor",
		"guantes": "slot_gloves",
		"botas": "slot_boots",
		"arma": "slot_weapon",
		"escudo": "slot_shield",
		"estandarte": "slot_banner",
		"amuleto": "slot_amulet",
		"reliquia": "slot_relic",
		"anillo_1": "slot_ring1",
		"anillo_2": "slot_ring2"
	}
	return _inv_text(str(keys.get(slot_name, slot_name)))

func _load_current_character() -> void:
	var config: ConfigFile = ConfigFile.new()
	if config.load(CHARACTER_SAVE_PATH) == OK:
		current_character_id = str(
			config.get_value("jugador", "personaje", "paladin_alba")
		).to_lower().strip_edges()

	if current_character_id.is_empty():
		current_character_id = "paladin_alba"

	current_character_group = _character_group_from_id(current_character_id)

func _get_character_roster_ids() -> Array[String]:
	if current_character_id in ["paladin_alba", "arquero_bosque", "arcanista_estelar"]:
		return ["paladin_alba", "arquero_bosque", "arcanista_estelar"]
	return ["caballero_ocaso", "acechador_ceniza", "nigromante_vacio"]

func _get_character_data(character_id: String) -> Dictionary:
	var all_data: Dictionary = {
		"paladin_alba": {"name_es":"Paladín del Alba", "name_en":"Dawn Paladin", "short":"PAL", "accent":Color("#72B7FF"), "texture":"res://Recursos/Personajes/Paladin/Seleccion/Idle/Paladin1.png"},
		"arquero_bosque": {"name_es":"Arquero del Bosque", "name_en":"Forest Archer", "short":"ARQ", "accent":Color("#73D982"), "texture":"res://Recursos/Personajes/Arquero/Seleccion/Idle/Arquero1.png"},
		"arcanista_estelar": {"name_es":"Arcanista Estelar", "name_en":"Stellar Arcanist", "short":"ARC", "accent":Color("#B985FF"), "texture":"res://Recursos/Personajes/Arcanista/Seleccion/Idle/Arcanista1.png"},
		"caballero_ocaso": {"name_es":"Caballero del Ocaso", "name_en":"Dusk Knight", "short":"CAB", "accent":Color("#FF8C68"), "texture":"res://Recursos/Personajes/Caballero/Seleccion/Idle/Caballero1.png"},
		"acechador_ceniza": {"name_es":"Acechador de Ceniza", "name_en":"Ash Stalker", "short":"ACE", "accent":Color("#D29BFF"), "texture":"res://Recursos/Personajes/Acechador/Seleccion/Idle/Acechador1.png"},
		"nigromante_vacio": {"name_es":"Nigromante del Vacío", "name_en":"Void Necromancer", "short":"NIG", "accent":Color("#A999FF"), "texture":"res://Recursos/Personajes/Nigromante/Seleccion/Idle/Nigromante1.png"}
	}
	var result: Dictionary = all_data.get(character_id, all_data["paladin_alba"])
	return result.duplicate(true)

func _load_character_progression() -> void:
	var config := ConfigFile.new()
	var loaded_unlocked: Array[String] = []
	if config.load(SKILL_SAVE_PATH) == OK:
		var unlocked_variant: Variant = config.get_value("personajes", "desbloqueados", [])
		if unlocked_variant is Array:
			for raw_id in unlocked_variant:
				var character_id := str(raw_id)
				if not character_id.is_empty() and not loaded_unlocked.has(character_id):
					loaded_unlocked.append(character_id)
		character_unlock_tokens = maxi(0, int(config.get_value("personajes", "fichas", 0)))

	if not loaded_unlocked.has(current_character_id):
		loaded_unlocked.append(current_character_id)
	unlocked_character_ids = loaded_unlocked
	_save_character_progression()

func _save_character_progression() -> void:
	var config := ConfigFile.new()
	config.load(SKILL_SAVE_PATH)
	config.set_value("personajes", "desbloqueados", unlocked_character_ids)
	config.set_value("personajes", "fichas", character_unlock_tokens)
	config.save(SKILL_SAVE_PATH)

func refresh_character_roster_from_skills() -> void:
	_load_character_progression()
	_refresh_character_roster_slots()

func _on_character_slot_pressed(index: int) -> void:
	var roster := _get_character_roster_ids()
	if index < 0 or index >= roster.size():
		return
	var character_id := roster[index]
	var data := _get_character_data(character_id)
	var display_name := str(data.get("name_en" if current_language == "en" else "name_es", character_id))

	if not unlocked_character_ids.has(character_id):
		if character_unlock_tokens <= 0:
			selected_item_label.text = _inv_text("need_character_token")
			selected_item_label.add_theme_color_override("font_color", Color("#FF9B86"))
			return
		character_unlock_tokens -= 1
		unlocked_character_ids.append(character_id)
		_save_character_progression()
		_notify_skill_tree_character_state()
		selected_item_label.text = _inv_text("character_unlocked") % display_name
		selected_item_label.add_theme_color_override("font_color", Color("#77F2C0"))

	_switch_active_character(character_id)

func _switch_active_character(character_id: String) -> bool:
	if character_id == current_character_id:
		return true
	if not unlocked_character_ids.has(character_id):
		return false

	equipped_by_character[current_character_id] = equipped_items.duplicate(true)
	current_character_id = character_id
	current_character_group = _character_group_from_id(character_id)
	var stored: Variant = equipped_by_character.get(character_id, {})
	if stored is Dictionary and not (stored as Dictionary).is_empty():
		equipped_items = (stored as Dictionary).duplicate(true)
	else:
		equipped_items = _create_empty_equipment_set()
		equipped_by_character[character_id] = equipped_items.duplicate(true)

	_save_active_character_to_progress()
	_apply_active_character_visual()
	var data: Dictionary = _get_character_data(character_id)
	var display_name: String = str(data.get("name_en" if current_language == "en" else "name_es", character_id))
	selected_item_label.text = _inv_text("character_selected") % display_name
	selected_item_label.add_theme_color_override("font_color", Color("#77F2C0"))
	selected_inventory_index = -1
	selected_equipment_slot = ""
	inventory_changed.emit()
	_refresh_everything()
	_save_inventory()
	return true

func _save_active_character_to_progress() -> void:
	var config := ConfigFile.new()
	config.load(CHARACTER_SAVE_PATH)
	config.set_value("jugador", "personaje", current_character_id)
	config.save(CHARACTER_SAVE_PATH)


func _get_character_idle_folder(character_id: String, fallback_texture_path: String = "") -> String:
	match character_id:
		"paladin_alba":
			return "res://Recursos/Personajes/Paladin/Seleccion/Idle"
		"arquero_bosque":
			return "res://Recursos/Personajes/Arquero/Seleccion/Idle"
		"arcanista_estelar":
			return "res://Recursos/Personajes/Arcanista/Seleccion/Idle"
		_:
			if fallback_texture_path.contains("/"):
				return fallback_texture_path.get_base_dir()
	return ""

func _load_character_idle_frames(character_id: String, fallback_texture_path: String = "") -> void:
	character_idle_current_id = character_id
	character_idle_frames.clear()
	character_idle_time = 0.0
	character_idle_frame_index = 0

	var folder: String = _get_character_idle_folder(character_id, fallback_texture_path)
	if folder.is_empty():
		return

	var base_prefix: String = ""
	match character_id:
		"paladin_alba":
			base_prefix = "paladin"
		"arquero_bosque":
			base_prefix = "arquero"
		"arcanista_estelar":
			base_prefix = "arcanista"
		_:
			base_prefix = character_id

	var capitalized_prefix: String = base_prefix.capitalize()
	var naming_sets: Array[Dictionary] = [
		{"prefix":base_prefix + " idle ", "suffix":".png"},
		{"prefix":capitalized_prefix + " idle ", "suffix":".png"},
		{"prefix":base_prefix + "_idle_", "suffix":".png"},
		{"prefix":capitalized_prefix + "_idle_", "suffix":".png"},
		{"prefix":base_prefix + "-idle-", "suffix":".png"},
		{"prefix":capitalized_prefix + "-idle-", "suffix":".png"},
		{"prefix":"paladin idle ", "suffix":".png"},
		{"prefix":"Paladin idle ", "suffix":".png"},
		{"prefix":"Paladin", "suffix":".png"},
		{"prefix":"idle_", "suffix":".png"},
		{"prefix":"idle ", "suffix":".png"},
		{"prefix":"", "suffix":".png"}
	]

	for naming: Dictionary in naming_sets:
		for index: int in range(1, character_idle_max_frames + 1):
			var candidate_path: String = "%s/%s%d%s" % [
				folder,
				str(naming.get("prefix", "")),
				index,
				str(naming.get("suffix", ".png"))
			]
			if ResourceLoader.exists(candidate_path):
				var texture: Texture2D = load(candidate_path) as Texture2D
				if texture != null and not character_idle_frames.has(texture):
					character_idle_frames.append(texture)
		if character_idle_frames.size() >= 2:
			break

	if character_idle_frames.is_empty() and not fallback_texture_path.is_empty() and ResourceLoader.exists(fallback_texture_path):
		var fallback_texture: Texture2D = load(fallback_texture_path) as Texture2D
		if fallback_texture != null:
			character_idle_frames.append(fallback_texture)

func _process_character_idle_animation(delta: float) -> void:
	if not enable_character_idle_animation:
		return
	if not inventory_is_open:
		return
	if not is_instance_valid(character_preview):
		return
	if character_idle_frames.size() <= 1:
		return

	character_idle_time += delta
	if character_idle_time < character_idle_frame_seconds:
		return

	character_idle_time = 0.0
	character_idle_frame_index = (character_idle_frame_index + 1) % character_idle_frames.size()
	character_preview.texture = character_idle_frames[character_idle_frame_index]
	character_preview.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	character_preview.visible = true
	character_preview.z_index = 5
	_bring_inventory_controls_to_front()

func _notify_skill_tree_character_state() -> void:
	var current_scene := get_tree().current_scene
	if current_scene == null:
		return
	var skill_tree := current_scene.find_child("ArbolHabilidadesUI", true, false)
	if skill_tree != null and skill_tree.has_method("refresh_character_state"):
		skill_tree.call_deferred("refresh_character_state")


func _bring_inventory_controls_to_front() -> void:
	# El personaje animado debe quedar por encima del fondo, pero nunca por
	# encima de botones, slots, pestañas, equipo ni textos. Este refuerzo se
	# llama al abrir/actualizar/animar para evitar que una textura nueva cambie
	# el orden visual.
	if is_instance_valid(character_preview):
		character_preview.z_index = 5

	var protected_names: Array[String] = [
		"Campeones",
		"Tabs",
		"Equipo",
		"Objetos",
		"Materiales",
		"Misiones",
		"Habilidades",
		"Cerrar",
		"Ordenar",
		"Equipar",
		"Usar"
	]

	if is_instance_valid(menu_canvas):
		for child: Node in menu_canvas.get_children():
			if child == character_preview:
				continue
			if child is Button or child is Label or child is LineEdit:
				(child as CanvasItem).z_index = 30
				(child as CanvasItem).move_to_front()
				continue
			if child.name in protected_names and child is CanvasItem:
				(child as CanvasItem).z_index = 30
				(child as CanvasItem).move_to_front()

		# Botones y labels anidados dentro de paneles/grids.
		var stack: Array[Node] = menu_canvas.get_children()
		while not stack.is_empty():
			var current: Node = stack.pop_back()
			for nested: Node in current.get_children():
				stack.append(nested)
				if nested == character_preview:
					continue
				if nested is Button or nested is Label or nested is LineEdit:
					(nested as CanvasItem).z_index = 35
					(nested as CanvasItem).move_to_front()



func _apply_active_character_visual() -> void:
	if character_preview == null:
		return

	var data := _get_character_data(current_character_id)
	var texture_path := str(data.get("texture", ""))

	# Antes el inventario solo intentaba animar si existía Paladin1.png.
	# Tus archivos se llaman "paladin idle 1.png", "paladin idle 2.png", etc.,
	# así que cargamos primero los frames del idle aunque la textura fija no exista.
	_load_character_idle_frames(current_character_id, texture_path)

	if character_idle_frames.size() > 0:
		character_texture_path = texture_path
		character_idle_frame_index = 0
		character_idle_time = 0.0
		character_preview.texture = character_idle_frames[0] as Texture2D
		character_preview.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		character_preview.visible = true
		if is_instance_valid(character_placeholder_label):
			character_placeholder_label.visible = false
		_bring_inventory_controls_to_front()
		return

	if not texture_path.is_empty() and ResourceLoader.exists(texture_path):
		character_texture_path = texture_path
		character_preview.texture = load(texture_path) as Texture2D
		character_preview.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		character_preview.visible = true
		if is_instance_valid(character_placeholder_label):
			character_placeholder_label.visible = false
		_bring_inventory_controls_to_front()
		return

	character_preview.texture = null
	if is_instance_valid(character_placeholder_label):
		character_placeholder_label.visible = true
		character_placeholder_label.text = (
			str(data.get("short", "PJ"))
			+ "\n"
			+ str(data.get("name_en" if current_language == "en" else "name_es", current_character_id))
		)
		var accent: Color = data.get("accent", Color("#E9D58A"))
		character_placeholder_label.add_theme_color_override("font_color", accent)
	_bring_inventory_controls_to_front()

func get_active_character_id() -> String:
	return current_character_id

func get_unlocked_character_ids() -> Array[String]:
	var ordered: Array[String] = []
	for character_id: String in _get_character_roster_ids():
		if unlocked_character_ids.has(character_id):
			ordered.append(character_id)
	for character_id: String in unlocked_character_ids:
		if not ordered.has(character_id):
			ordered.append(character_id)
	return ordered

func _character_group_from_id(character_id: String) -> String:
	match character_id.to_lower():
		"paladin_alba":
			return "paladin"
		"arquero_bosque":
			return "arquero"
		"arcanista_estelar":
			return "arcanista"
		"caballero_ocaso":
			return "caballero"
		"acechador_ceniza":
			return "asesino"
		"nigromante_vacio":
			return "nigromante"
		_:
			return "paladin"

func _class_display_name(class_group: String) -> String:
	var keys: Dictionary = {
		"paladin": "class_paladin",
		"arquero": "class_archer",
		"arcanista": "class_arcanist",
		"caballero": "class_knight",
		"asesino": "class_assassin",
		"nigromante": "class_necromancer"
	}
	return _inv_text(str(keys.get(class_group, class_group)))

func _infer_weapon_type(item: Dictionary) -> String:
	if str(item.get("equip_slot", "")) != "arma":
		return ""

	var identity: String = (
		str(item.get("id", ""))
		+ " "
		+ str(item.get("name", ""))
	).to_lower()

	if identity.contains("arco") or identity.contains("bow") or identity.contains("saeta"):
		return "arco"
	if (
		identity.contains("baston")
		or identity.contains("bastón")
		or identity.contains("baculo")
		or identity.contains("báculo")
		or identity.contains("varita")
		or identity.contains("orbe")
		or identity.contains("grimorio")
		or identity.contains("cetro")
		or identity.contains("codex")
	):
		return "magia"
	if (
		identity.contains("daga")
		or identity.contains("puñal")
		or identity.contains("punal")
		or identity.contains("cuchilla")
	):
		return "daga"
	if identity.contains("mandoble"):
		return "mandoble"
	if (
		identity.contains("espada")
		or identity.contains("sable")
		or identity.contains("hoja")
		or identity.contains("filo")
		or identity.contains("juramento")
	):
		return "espada"
	return "generica"

func _slot_matches_item(item: Dictionary, target_slot: String) -> bool:
	var item_slot: String = str(item.get("equip_slot", ""))
	if item_slot == target_slot:
		return true
	return item_slot.begins_with("anillo_") and target_slot.begins_with("anillo_")

func _character_progress(character_id: String) -> Dictionary:
	var controller: Node = _resolve_main_controller()
	if is_instance_valid(controller) and controller.has_method("get_hero_progress"):
		var value: Variant = controller.call("get_hero_progress", character_id)
		if value is Dictionary:
			return (value as Dictionary).duplicate(true)
	var config: ConfigFile = ConfigFile.new()
	if config.load(CHARACTER_SAVE_PATH) == OK:
		var all_progress: Variant = config.get_value("heroes", "progreso_individual", {})
		if all_progress is Dictionary:
			var raw: Variant = (all_progress as Dictionary).get(character_id, {})
			if raw is Dictionary and not (raw as Dictionary).is_empty():
				return (raw as Dictionary).duplicate(true)
		if character_id == str(config.get_value("jugador", "personaje", "paladin_alba")):
			return {
				"level": maxi(1, int(config.get_value("jugador", "nivel", 1))),
				"xp": maxi(0, int(config.get_value("jugador", "experiencia", 0))),
				"xp_required": maxi(1, int(config.get_value("jugador", "experiencia_necesaria", 30)))
			}
	return {"level":1, "xp":0, "xp_required":30}

func _character_level(character_id: String) -> int:
	return maxi(1, int(_character_progress(character_id).get("level", 1)))

func refresh_character_progression_ui() -> void:
	_refresh_character_roster_slots()
	_refresh_stats()
	_refresh_bottom_information()

func _current_player_level() -> int:
	return _character_level(current_character_id)

func _required_item_level(item: Dictionary) -> int:
	return maxi(1, maxi(int(item.get("min_level", 1)), int(item.get("item_level", 1))))

func _can_equip_item_level(item: Dictionary) -> bool:
	return _current_player_level() >= _required_item_level(item)

func _show_level_requirement_error(item: Dictionary) -> void:
	var required_level: int = _required_item_level(item)
	selected_item_label.text = _inv_text("level_too_low") % [required_level, _item_display_name(item)]
	selected_item_label.add_theme_color_override("font_color", Color("#FF8A8A"))

func _is_item_compatible_with_slot(item: Dictionary, target_slot: String) -> bool:
	if item.is_empty() or target_slot.is_empty():
		return false
	if str(item.get("category", "")) != CATEGORY_EQUIPMENT:
		return false
	if not _slot_matches_item(item, target_slot):
		return false

	var allowed_variant: Variant = item.get("allowed_classes", [])
	if allowed_variant is Array:
		var allowed_classes: Array = allowed_variant
		if not allowed_classes.is_empty():
			var class_allowed: bool = false
			for raw_class in allowed_classes:
				var allowed: String = str(raw_class).to_lower()
				if allowed == current_character_group or allowed == current_character_id:
					class_allowed = true
					break
			if not class_allowed:
				return false

	if target_slot == "escudo":
		return current_character_group == "paladin"

	if target_slot != "arma":
		return true

	var weapon_type: String = str(
		item.get("weapon_type", _infer_weapon_type(item))
	).to_lower()

	match current_character_group:
		"paladin":
			return weapon_type in ["espada", "mandoble", "generica"]
		"arquero":
			return weapon_type == "arco"
		"arcanista", "nigromante":
			return weapon_type == "magia"
		"caballero":
			return weapon_type in ["espada", "mandoble", "generica"]
		"asesino":
			return weapon_type == "daga"
		_:
			return true

func _show_compatibility_error(item: Dictionary, target_slot: String) -> void:
	var item_name: String = _item_display_name(item)
	var character_class_name: String = _class_display_name(current_character_group)
	selected_item_label.text = _inv_text("cannot_use") % [character_class_name, item_name]
	selected_item_label.add_theme_color_override("font_color", Color("#FF8585"))

	if target_slot == "escudo":
		selected_item_label.text = _inv_text("shield_paladin_only")
	elif target_slot == "arma":
		match current_character_group:
			"arquero":
				selected_item_label.text = _inv_text("archer_bows_only")
			"arcanista", "nigromante":
				selected_item_label.text = _inv_text("magic_weapons_only") % character_class_name
			"asesino":
				selected_item_label.text = _inv_text("assassin_daggers_only")
			"paladin", "caballero":
				selected_item_label.text = _inv_text("sword_classes_only") % character_class_name

func _equip_inventory_item_to_slot(inventory_index: int, target_slot: String) -> bool:
	if inventory_index < 0 or inventory_index >= inventory_items.size():
		return false

	var item: Dictionary = inventory_items[inventory_index]
	if not _can_equip_item_level(item):
		_show_level_requirement_error(item)
		return false
	if not _is_item_compatible_with_slot(item, target_slot):
		_show_compatibility_error(item, target_slot)
		return false

	var old_equipped: Dictionary = equipped_items.get(target_slot, {})
	equipped_items[target_slot] = item.duplicate(true)
	inventory_items[inventory_index] = (
		{}
		if old_equipped.is_empty()
		else old_equipped.duplicate(true)
	)

	selected_inventory_index = -1
	selected_equipment_slot = target_slot
	item_equipped.emit(str(item.get("id", "")), target_slot)
	inventory_changed.emit()
	_refresh_everything()
	_save_inventory()
	return true

func _unequip_equipment_slot(slot_name: String, preferred_inventory_index: int) -> bool:
	var equipped_item: Dictionary = equipped_items.get(slot_name, {})
	if equipped_item.is_empty():
		return false

	var target_index: int = preferred_inventory_index
	if (
		target_index < 0
		or target_index >= inventory_items.size()
		or not inventory_items[target_index].is_empty()
	):
		target_index = _find_first_empty_slot()

	if target_index == -1:
		selected_item_label.text = _inv_text("inventory_full")
		selected_item_label.add_theme_color_override("font_color", Color("#FF8585"))
		return false

	inventory_items[target_index] = equipped_item.duplicate(true)
	equipped_items[slot_name] = {}
	selected_inventory_index = target_index
	selected_equipment_slot = ""
	item_unequipped.emit(str(equipped_item.get("id", "")), slot_name)
	inventory_changed.emit()
	_refresh_everything()
	_save_inventory()
	return true

func _swap_inventory_items(source_index: int, target_index: int) -> void:
	if source_index < 0 or target_index < 0:
		return
	if source_index >= inventory_items.size() or target_index >= inventory_items.size():
		return
	if source_index == target_index:
		return

	var temporary: Dictionary = inventory_items[target_index]
	inventory_items[target_index] = inventory_items[source_index]
	inventory_items[source_index] = temporary
	selected_inventory_index = target_index
	inventory_changed.emit()
	_refresh_everything()
	_save_inventory()

func _swap_equipment_with_inventory(slot_name: String, inventory_index: int) -> bool:
	if inventory_index < 0 or inventory_index >= inventory_items.size():
		return false

	var target_item: Dictionary = inventory_items[inventory_index]
	if target_item.is_empty():
		return _unequip_equipment_slot(slot_name, inventory_index)

	if not _is_item_compatible_with_slot(target_item, slot_name):
		_show_compatibility_error(target_item, slot_name)
		return false

	var equipped_item: Dictionary = equipped_items.get(slot_name, {})
	equipped_items[slot_name] = target_item.duplicate(true)
	inventory_items[inventory_index] = equipped_item.duplicate(true)
	selected_equipment_slot = slot_name
	selected_inventory_index = -1
	inventory_changed.emit()
	_refresh_everything()
	_save_inventory()
	return true

func _on_inventory_slot_gui_input(event: InputEvent, visible_index: int) -> void:
	if not (event is InputEventMouseButton):
		return
	var mouse_event: InputEventMouseButton = event as InputEventMouseButton
	if mouse_event.button_index != MOUSE_BUTTON_LEFT or not mouse_event.pressed:
		return
	if visible_index < 0 or visible_index >= inventory_slot_buttons.size():
		return

	var button: Button = inventory_slot_buttons[visible_index]
	var inventory_index: int = int(button.get_meta("inventory_index", -1))
	if inventory_index < 0:
		return

	_start_drag_candidate("inventory", inventory_index, "")

func _on_equipment_slot_gui_input(event: InputEvent, slot_name: String) -> void:
	if not (event is InputEventMouseButton):
		return
	var mouse_event: InputEventMouseButton = event as InputEventMouseButton
	if mouse_event.button_index != MOUSE_BUTTON_LEFT or not mouse_event.pressed:
		return
	if equipped_items.get(slot_name, {}).is_empty():
		return

	_start_drag_candidate("equipment", -1, slot_name)

func _start_drag_candidate(source_type: String, inventory_index: int, equipment_slot: String) -> void:
	drag_source_type = source_type
	drag_inventory_index = inventory_index
	drag_equipment_slot = equipment_slot
	drag_start_menu_position = _get_menu_mouse_position()
	drag_active = false

func _get_dragged_item() -> Dictionary:
	if drag_source_type == "inventory":
		if drag_inventory_index >= 0 and drag_inventory_index < inventory_items.size():
			return inventory_items[drag_inventory_index]
	elif drag_source_type == "equipment":
		return equipped_items.get(drag_equipment_slot, {})
	return {}

func _activate_drag_preview(_menu_mouse: Vector2) -> void:
	var item: Dictionary = _get_dragged_item()
	if item.is_empty():
		_clear_drag_state()
		return

	drag_active = true
	suppress_next_button_press = true
	get_tree().root.remove_meta("taskbar_forge_drag_preview_active")

	if drag_source_type == "inventory":
		get_tree().root.set_meta(
			"taskbar_inventory_drag_index",
			drag_inventory_index
		)

	_ensure_drag_preview_layer()
	if not is_instance_valid(drag_preview_layer):
		_clear_drag_state()
		return

	_clear_drag_preview_content()

	drag_preview = Panel.new()
	drag_preview.name = "VistaArrastre"
	drag_preview.position = Vector2(5.0, 5.0)
	drag_preview.size = Vector2(tamano_vista_arrastre) - Vector2(10.0, 10.0)
	drag_preview.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var rarity_color: Color = _get_item_rarity_color(item)
	drag_preview.add_theme_stylebox_override(
		"panel",
		_make_style(
			Color(0.015, 0.020, 0.026, 0.96),
			rarity_color,
			3,
			12,
			Color(rarity_color.r, rarity_color.g, rarity_color.b, 0.42),
			12
		)
	)
	drag_preview_root.add_child(drag_preview)
	_create_item_visual(drag_preview, item, true)

	if is_instance_valid(drag_preview_layer):
		drag_preview_layer.visible = true
		_update_drag_preview(_menu_mouse)

func _update_drag_preview(menu_mouse: Vector2) -> void:
	if not is_instance_valid(drag_preview):
		return
	if not is_instance_valid(drag_preview_layer):
		return

	var preview_size: Vector2 = drag_preview.size
	var half_size: Vector2 = preview_size * 0.5
	var clamped_center: Vector2 = Vector2(
		clampf(menu_mouse.x, half_size.x, REFERENCE_SIZE.x - half_size.x),
		clampf(menu_mouse.y, half_size.y, REFERENCE_SIZE.y - half_size.y)
	)
	drag_preview.position = clamped_center - half_size

func _finish_manual_drop(menu_mouse: Vector2) -> void:
	var item: Dictionary = _get_dragged_item()
	if item.is_empty():
		return

	for slot_name in EQUIPMENT_SLOT_ORDER:
		var equipment_button: Button = equipment_buttons.get(slot_name) as Button
		if equipment_button == null:
			continue
		if Rect2(equipment_button.position, equipment_button.size).has_point(menu_mouse):
			if drag_source_type == "inventory":
				_equip_inventory_item_to_slot(drag_inventory_index, slot_name)
			return

	for inventory_button in inventory_slot_buttons:
		if not Rect2(inventory_button.position, inventory_button.size).has_point(menu_mouse):
			continue

		var target_index: int = int(
			inventory_button.get_meta("drop_inventory_index", -1)
		)
		if target_index < 0:
			return

		if drag_source_type == "inventory":
			_swap_inventory_items(drag_inventory_index, target_index)
		elif drag_source_type == "equipment":
			_swap_equipment_with_inventory(drag_equipment_slot, target_index)
		return

func _clear_drag_state() -> void:
	if is_instance_valid(drag_preview_layer):
		drag_preview_layer.visible = false
	_clear_drag_preview_content()
	if get_tree().root.has_meta("taskbar_inventory_drag_index"):
		get_tree().root.remove_meta("taskbar_inventory_drag_index")
	if get_tree().root.has_meta("taskbar_forge_drag_preview_active"):
		get_tree().root.remove_meta("taskbar_forge_drag_preview_active")
	drag_source_type = ""
	drag_inventory_index = -1
	drag_equipment_slot = ""
	drag_active = false

func _consume_suppressed_button_press() -> bool:
	if not suppress_next_button_press:
		return false
	suppress_next_button_press = false
	return true

func _window_position_to_menu(window_position: Vector2) -> Vector2:
	var scale_x: float = maxf(menu_canvas.scale.x, 0.0001)
	var scale_y: float = maxf(menu_canvas.scale.y, 0.0001)
	return Vector2(
		(window_position.x - menu_canvas.position.x) / scale_x,
		(window_position.y - menu_canvas.position.y) / scale_y
	)

func _get_menu_mouse_position() -> Vector2:
	if not is_instance_valid(inventory_window):
		return Vector2.ZERO
	return _window_position_to_menu(inventory_window.get_mouse_position())

func _save_inventory() -> void:
	_sync_gold_from_main()
	_sanitize_inventory_data()
	equipped_by_character[current_character_id] = equipped_items.duplicate(true)

	var config: ConfigFile = ConfigFile.new()
	config.set_value("inventario", "items", inventory_items)
	config.set_value("inventario", "equipado", equipped_items)
	config.set_value("inventario", "equipado_por_personaje", equipped_by_character)
	config.set_value("inventario", "oro", gold)
	config.set_value("inventario", "estadisticas_base", base_stats)
	var save_error: Error = config.save(SAVE_PATH)
	_save_skill_loadouts()
	if save_error != OK:
		push_warning(_inv_text("save_failed"))

func _load_inventory() -> void:
	var config: ConfigFile = ConfigFile.new()
	if config.load(SAVE_PATH) != OK:
		equipped_by_character[current_character_id] = equipped_items.duplicate(true)
		return

	var loaded_items_variant: Variant = config.get_value("inventario", "items", [])
	var loaded_equipment_variant: Variant = config.get_value("inventario", "equipado", {})
	var loaded_by_character: Variant = config.get_value("inventario", "equipado_por_personaje", {})
	var data_was_cleaned: bool = false

	for index: int in range(inventory_items.size()):
		inventory_items[index] = {}
	if loaded_items_variant is Array:
		var loaded_items: Array = loaded_items_variant
		for index: int in range(mini(loaded_items.size(), maximum_slots)):
			var raw_item: Variant = loaded_items[index]
			if raw_item is Dictionary and _is_valid_item_dictionary(raw_item as Dictionary):
				inventory_items[index] = _normalize_item(raw_item as Dictionary)
			elif raw_item is Dictionary and not (raw_item as Dictionary).is_empty():
				data_was_cleaned = true
	else:
		data_was_cleaned = true

	equipped_by_character.clear()
	if loaded_by_character is Dictionary:
		for raw_character_id: Variant in (loaded_by_character as Dictionary).keys():
			var character_id: String = str(raw_character_id)
			var raw_set: Variant = (loaded_by_character as Dictionary).get(raw_character_id, {})
			if not (raw_set is Dictionary):
				continue
			var clean_set: Dictionary = _create_empty_equipment_set()
			for slot_name: String in EQUIPMENT_SLOT_ORDER:
				var raw_equipped: Variant = (raw_set as Dictionary).get(slot_name, {})
				if raw_equipped is Dictionary and _is_valid_item_dictionary(raw_equipped as Dictionary):
					clean_set[slot_name] = _normalize_item(raw_equipped as Dictionary)
			var legacy_accessory: Variant = (raw_set as Dictionary).get("accesorio", {})
			if legacy_accessory is Dictionary and _is_valid_item_dictionary(legacy_accessory as Dictionary) and (clean_set["estandarte"] as Dictionary).is_empty():
				clean_set["estandarte"] = _normalize_item(legacy_accessory as Dictionary)
			equipped_by_character[character_id] = clean_set

	if equipped_by_character.is_empty():
		var migrated: Dictionary = _create_empty_equipment_set()
		if loaded_equipment_variant is Dictionary:
			for slot_name: String in EQUIPMENT_SLOT_ORDER:
				var raw_equipped: Variant = (loaded_equipment_variant as Dictionary).get(slot_name, {})
				if raw_equipped is Dictionary and _is_valid_item_dictionary(raw_equipped as Dictionary):
					migrated[slot_name] = _normalize_item(raw_equipped as Dictionary)
			var legacy_accessory: Variant = (loaded_equipment_variant as Dictionary).get("accesorio", {})
			if legacy_accessory is Dictionary and _is_valid_item_dictionary(legacy_accessory as Dictionary) and (migrated["estandarte"] as Dictionary).is_empty():
				migrated["estandarte"] = _normalize_item(legacy_accessory as Dictionary)
		equipped_by_character[current_character_id] = migrated
		data_was_cleaned = true

	var current_set: Variant = equipped_by_character.get(current_character_id, {})
	equipped_items = (current_set as Dictionary).duplicate(true) if current_set is Dictionary else _create_empty_equipment_set()
	if not _sync_gold_from_main():
		gold = int(config.get_value("inventario", "oro", starting_gold))
	var loaded_base_stats: Variant = config.get_value("inventario", "estadisticas_base", base_stats)
	if loaded_base_stats is Dictionary:
		base_stats = (loaded_base_stats as Dictionary).duplicate(true)
	if _sanitize_inventory_data():
		data_was_cleaned = true
	if data_was_cleaned:
		call_deferred("_save_inventory")

func _add_demo_inventory() -> void:
	add_item({
		"id": "espada_del_alba",
		"name": "Espada del Alba",
		"description": "Una hoja bendecida por la luz.",
		"category": CATEGORY_EQUIPMENT,
		"equip_slot": "arma",
		"quantity": 1,
		"stats": {"daño": 12}
	})

	add_item({
		"id": "pocion_vida",
		"name": "Poción de vida",
		"description": "Recupera una parte de la vida.",
		"category": CATEGORY_OBJECTS,
		"quantity": 3,
		"stackable": true,
		"consumable": true
	})

	add_item({
		"id": "fragmento_esmeralda",
		"name": "Fragmento de esmeralda",
		"description": "Material brillante hallado durante la aventura.",
		"category": CATEGORY_MATERIALS,
		"quantity": 5,
		"stackable": true
	})

func _make_style(
	background: Color,
	border: Color,
	border_width: int,
	radius: int,
	shadow_color: Color = Color(0.0, 0.0, 0.0, 0.0),
	shadow_size: int = 0,
	shadow_offset: Vector2 = Vector2.ZERO
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
	style.shadow_offset = shadow_offset
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
	var label: Label = Label.new()
	label.text = label_text
	label.position = label_position
	label.size = label_size
	label.horizontal_alignment = alignment
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", font_color)
	label.set_meta(
		"ui_font_role",
		"title" if font_size >= 18 else "body"
	)
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	parent.add_child(label)
	return label
