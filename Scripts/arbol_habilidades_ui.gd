extends Control
class_name ArbolHabilidadesUI

signal skills_changed(effects: Dictionary)
signal character_tokens_changed(tokens: int)
signal potion_generated(item_data: Dictionary)
signal skill_tree_opened
signal skill_tree_closed

# =============================================================================
# ÁRBOL ASTRAL DE HABILIDADES — TASKBAR ADVENTURES RPG
# Godot 4.x · interfaz generada por código · compatible con guardados anteriores
# =============================================================================

@export_group("Ventana")
@export var skill_window_size: Vector2i = Vector2i(1320, 990)
@export var start_open: bool = false
@export var allow_window_drag: bool = true
@export_range(30.0, 100.0, 1.0) var drag_header_height: float = 58.0

@export_group("Recursos")
@export_file("*.png")
var skill_tree_background_path: String = "res://Recursos/UI/ArbolHabilidades/arbol_habilidades_base.png"
@export_file("*.svg", "*.png")
var module_top_icon_path: String = "res://Recursos/UI/ArbolHabilidades/Iconos/06_progreso_dorado/estrella_de_maestria.png"

@export_group("Pociones")
@export_range(60.0, 3600.0, 10.0) var potion_interval_seconds: float = 600.0
@export_range(1, 48, 1) var maximum_daily_potions: int = 24

const SKILL_SAVE_PATH: String = "user://habilidades.cfg"
const SETTINGS_PATH: String = "user://opciones.cfg"
const CHARACTER_SAVE_PATH: String = "user://partida.cfg"
const REFERENCE_SIZE: Vector2 = Vector2(1448.0, 1086.0)
const RESET_COST: int = 50
const RESET_CONFIRM_SECONDS: float = 3.5

const ICON_REFRESH: String = "res://Recursos/UI/ArbolHabilidades/Iconos/00_interfaz/brillo_magico.png"
const ICON_FORGE: String = "res://Recursos/UI/ArbolHabilidades/Iconos/00_interfaz/forja.png"
const ICON_INVENTORY: String = "res://Recursos/UI/IconosBarra/inventario.png"
const ICON_SETTINGS: String = "res://Recursos/UI/ArbolHabilidades/Iconos/00_interfaz/configuracion.png"
const ICON_CLOSE: String = "res://Recursos/UI/ArbolHabilidades/Iconos/00_interfaz/cerrar.png"

const BRANCH_COLORS: Dictionary = {
	"core": Color("#F5D674"),
	"offense": Color("#FF6759"),
	"defense": Color("#5DB8FF"),
	"fortune": Color("#69E77F"),
	"alchemy": Color("#D88BFF"),
	"progression": Color("#FFC94A"),
	"legacy": Color("#5DEAF2")
}

# Se conserva el coste de nodos retirados para no regalar puntos al migrar.
const LEGACY_COMPATIBILITY_COSTS: Dictionary = {
	"recovery": {"max_rank": 4, "base_cost": 2, "cost_growth": 1}
}

const TRANSLATIONS: Dictionary = {
	"es":
	{
		"window_title": "Árbol Astral de Habilidades",
		"open_tree": "Abrir árbol de habilidades [H]",
		"title": "ÁRBOL ASTRAL",
		"subtitle": "Cada nivel concede 1 punto. Elige el sendero que escribirá tu leyenda.",
		"points": "PUNTOS DISPONIBLES",
		"level": "NIVEL %d",
		"spent": "%d INVERTIDOS",
		"summary": "PODER ACUMULADO",
		"tokens": "FICHAS DE CAMPEÓN: %d",
		"potions": "POCIONES HOY: %d / %d",
		"selected": "HABILIDAD SELECCIONADA",
		"rank": "RANGO %d / %d",
		"cost": "COSTE: %d PUNTO(S)",
		"maxed": "DOMINADA",
		"unlock": "DESBLOQUEAR",
		"locked": "BLOQUEADA",
		"requires_level": "Requiere nivel %d",
		"requires_skill": "Requiere %s · rango %d",
		"not_enough": "No tienes suficientes puntos de habilidad.",
		"purchased": "Has mejorado: %s.",
		"core_ready": "El núcleo del campeón ya arde en tu interior.",
		"reset_tree": "REINICIAR ÁRBOL · %d ORO",
		"reset_confirm": "PULSA OTRA VEZ PARA CONFIRMAR",
		"reset_done": "El árbol ha renacido. Todos los puntos han regresado.",
		"reset_gold": "Necesitas %d de oro para reiniciar el árbol.",
		"refresh": "Actualizar información",
		"forge": "Abrir forja",
		"inventory": "Abrir inventario",
		"settings": "Ajustes del árbol",
		"close": "Cerrar",
		"settings_title": "AJUSTES VISUALES",
		"show_ranks": "Mostrar rangos en los nodos",
		"pixel_filter": "Filtrado pixel art",
		"always_on_top": "Mantener ventana siempre visible",
		"settings_hint": "Los cambios se guardan automáticamente.",
		"legend": "RUTAS",
		"branch_offense": "Guerra",
		"branch_defense": "Bastión",
		"branch_fortune": "Fortuna",
		"branch_alchemy": "Alquimia",
		"branch_progression": "Progreso",
		"branch_legacy": "Compañeros",
		"lore": "«El poder no se hereda: se talla, punto a punto, contra la noche.»",
		"footer": "TU CAMINO · TU LEYENDA",
		"status_ready": "Selecciona un nodo para descubrir su poder.",
		"potion_ready": "La alquimia ambulante ha creado una Poción de Vigor.",
		"missing_inventory": "La poción espera: no se encontró un inventario disponible.",
		"branch_mastered": "Sendero dominado",
		"current_effect": "EFECTO",
		"requirements": "REQUISITOS"
	},
	"en":
	{
		"window_title": "Astral Skill Tree",
		"open_tree": "Open skill tree [H]",
		"title": "ASTRAL SKILL TREE",
		"subtitle": "Each level grants 1 point. Choose the path that will write your legend.",
		"points": "AVAILABLE POINTS",
		"level": "LEVEL %d",
		"spent": "%d INVESTED",
		"summary": "ACCUMULATED POWER",
		"tokens": "CHAMPION TOKENS: %d",
		"potions": "POTIONS TODAY: %d / %d",
		"selected": "SELECTED SKILL",
		"rank": "RANK %d / %d",
		"cost": "COST: %d POINT(S)",
		"maxed": "MASTERED",
		"unlock": "UNLOCK",
		"locked": "LOCKED",
		"requires_level": "Requires level %d",
		"requires_skill": "Requires %s · rank %d",
		"not_enough": "You do not have enough skill points.",
		"purchased": "You improved: %s.",
		"core_ready": "The champion core already burns within you.",
		"reset_tree": "RESET TREE · %d GOLD",
		"reset_confirm": "PRESS AGAIN TO CONFIRM",
		"reset_done": "The tree has been reborn. Every point has returned.",
		"reset_gold": "You need %d gold to reset the tree.",
		"refresh": "Refresh information",
		"forge": "Open forge",
		"inventory": "Open inventory",
		"settings": "Tree settings",
		"close": "Close",
		"settings_title": "VISUAL SETTINGS",
		"show_ranks": "Show ranks on nodes",
		"pixel_filter": "Pixel art filtering",
		"always_on_top": "Keep window always visible",
		"settings_hint": "Changes are saved automatically.",
		"legend": "PATHS",
		"branch_offense": "Warfare",
		"branch_defense": "Bastion",
		"branch_fortune": "Fortune",
		"branch_alchemy": "Alchemy",
		"branch_progression": "Progress",
		"branch_legacy": "Companions",
		"lore": "“Power is not inherited: it is carved, point by point, against the night.”",
		"footer": "YOUR PATH · YOUR LEGEND",
		"status_ready": "Select a node to discover its power.",
		"potion_ready": "Wandering Alchemy created a Vigor Potion.",
		"missing_inventory": "The potion waits: no inventory was found.",
		"branch_mastered": "Path mastered",
		"current_effect": "EFFECT",
		"requirements": "REQUIREMENTS"
	}
}

var skill_definitions: Array[Dictionary] = [
	{
		"id": "core",
		"branch": "core",
		"center": Vector2(718.0, 535.0),
		"radius": 42.0,
		"icon": "res://Recursos/UI/ArbolHabilidades/Iconos/00_interfaz/gema_verde.png",
		"max_rank": 1,
		"base_cost": 0,
		"cost_growth": 0,
		"min_level": 1,
		"requires": [],
		"title_es": "Núcleo del campeón",
		"title_en": "Champion Core",
		"desc_es": "El corazón de tu leyenda. Abre todos los senderos.",
		"desc_en": "The heart of your legend. Opens every path.",
		"effect_es": "Desbloqueado desde el inicio.",
		"effect_en": "Unlocked from the beginning.",
		"auto_unlocked": true
	},
	{
		"id": "war_mastery",
		"branch": "offense",
		"center": Vector2(738.0, 94.0),
		"radius": 22.0,
		"icon":
		"res://Recursos/UI/ArbolHabilidades/Iconos/01_ataque_rojo/estandarte_de_batalla.png",
		"max_rank": 1,
		"base_cost": 5,
		"cost_growth": 0,
		"min_level": 25,
		"requires": [{"id": "attack_fury", "rank": 1}, {"id": "attack_colossus", "rank": 1}],
		"title_es": "Maestría de guerra",
		"title_en": "War Mastery",
		"desc_es": "Culmina el sendero ofensivo y convierte cada golpe en una sentencia.",
		"desc_en": "Completes the offensive path and turns every strike into a verdict.",
		"effect_es": "+12% daño y +10 velocidad.",
		"effect_en": "+12% damage and +10 speed.",
		"auto_unlocked": false
	},
	{
		"id": "attack_colossus",
		"branch": "offense",
		"center": Vector2(824.0, 109.0),
		"radius": 20.0,
		"icon": "res://Recursos/UI/ArbolHabilidades/Iconos/01_ataque_rojo/mandoble.png",
		"max_rank": 3,
		"base_cost": 2,
		"cost_growth": 1,
		"min_level": 18,
		"requires": [{"id": "attack_execution", "rank": 1}],
		"title_es": "Golpe colosal",
		"title_en": "Colossal Strike",
		"desc_es": "Aumenta el daño de los impactos críticos.",
		"desc_en": "Increases critical hit damage.",
		"effect_es": "+8% daño crítico por rango.",
		"effect_en": "+8% critical damage per rank.",
		"auto_unlocked": false
	},
	{
		"id": "attack_fury",
		"branch": "offense",
		"center": Vector2(647.0, 111.0),
		"radius": 23.0,
		"icon": "res://Recursos/UI/ArbolHabilidades/Iconos/01_ataque_rojo/furia.png",
		"max_rank": 3,
		"base_cost": 2,
		"cost_growth": 1,
		"min_level": 18,
		"requires": [{"id": "attack_reach", "rank": 1}],
		"title_es": "Furia contenida",
		"title_en": "Contained Fury",
		"desc_es": "La batalla prolongada despierta un poder cada vez mayor.",
		"desc_en": "Prolonged battle awakens ever greater power.",
		"effect_es": "+3% daño por rango.",
		"effect_en": "+3% damage per rank.",
		"auto_unlocked": false
	},
	{
		"id": "attack_execution",
		"branch": "offense",
		"center": Vector2(895.0, 141.0),
		"radius": 23.0,
		"icon": "res://Recursos/UI/ArbolHabilidades/Iconos/01_ataque_rojo/calavera_mortal.png",
		"max_rank": 3,
		"base_cost": 2,
		"cost_growth": 1,
		"min_level": 15,
		"requires": [{"id": "attack_lifesteal", "rank": 1}],
		"title_es": "Sentencia final",
		"title_en": "Final Sentence",
		"desc_es": "Inflige más daño a los enemigos debilitados.",
		"desc_en": "Deals more damage to weakened enemies.",
		"effect_es": "+6% ejecución por rango.",
		"effect_en": "+6% execution damage per rank.",
		"auto_unlocked": false
	},
	{
		"id": "attack_reach",
		"branch": "offense",
		"center": Vector2(579.0, 142.0),
		"radius": 19.0,
		"icon": "res://Recursos/UI/ArbolHabilidades/Iconos/01_ataque_rojo/estocada_de_lanza.png",
		"max_rank": 3,
		"base_cost": 2,
		"cost_growth": 1,
		"min_level": 14,
		"requires": [{"id": "attack_combo", "rank": 1}],
		"title_es": "Alcance mortal",
		"title_en": "Deadly Reach",
		"desc_es": "Tus ataques encuentran las grietas de una defensa rota.",
		"desc_en": "Your attacks find the cracks in a broken defense.",
		"effect_es": "+3% ejecución por rango.",
		"effect_en": "+3% execution damage per rank.",
		"auto_unlocked": false
	},
	{
		"id": "archer_active",
		"branch": "offense",
		"center": Vector2(808.0, 172.0),
		"radius": 19.0,
		"icon": "res://Recursos/UI/ArbolHabilidades/Iconos/01_ataque_rojo/disparo_de_arco.png",
		"max_rank": 3,
		"base_cost": 2,
		"cost_growth": 2,
		"min_level": 10,
		"requires": [{"id": "unlock_1", "rank": 1}, {"id": "damage", "rank": 1}],
		"title_es": "Técnicas activas del Arquero",
		"title_en": "Archer Active Techniques",
		"desc_es": "Cada rango desbloquea una habilidad activa para el Arquero.",
		"desc_en": "Each rank unlocks one active skill for the Archer.",
		"effect_es": "Desbloquea 1 técnica por rango.",
		"effect_en": "Unlocks 1 technique per rank.",
		"auto_unlocked": false
	},
	{
		"id": "attack_combo",
		"branch": "offense",
		"center": Vector2(666.0, 174.0),
		"radius": 21.0,
		"icon": "res://Recursos/UI/ArbolHabilidades/Iconos/01_ataque_rojo/hojas_gemelas.png",
		"max_rank": 3,
		"base_cost": 1,
		"cost_growth": 1,
		"min_level": 10,
		"requires": [{"id": "armor_break", "rank": 1}],
		"title_es": "Cadencia gemela",
		"title_en": "Twin Cadence",
		"desc_es": "Encadena impactos con precisión creciente.",
		"desc_en": "Chains strikes with growing precision.",
		"effect_es": "+4% daño crítico por rango.",
		"effect_en": "+4% critical damage per rank.",
		"auto_unlocked": false
	},
	{
		"id": "damage",
		"branch": "offense",
		"center": Vector2(736.0, 207.0),
		"radius": 30.0,
		"icon": "res://Recursos/UI/ArbolHabilidades/Iconos/01_ataque_rojo/espadas_cruzadas.png",
		"max_rank": 5,
		"base_cost": 1,
		"cost_growth": 0,
		"min_level": 1,
		"requires": [{"id": "core", "rank": 1}],
		"title_es": "Fuerza implacable",
		"title_en": "Relentless Strength",
		"desc_es": "Eleva el daño de todos tus campeones.",
		"desc_en": "Raises the damage of all your champions.",
		"effect_es": "+4% daño por rango.",
		"effect_en": "+4% damage per rank.",
		"auto_unlocked": false
	},
	{
		"id": "armor_break",
		"branch": "offense",
		"center": Vector2(607.0, 210.0),
		"radius": 23.0,
		"icon": "res://Recursos/UI/ArbolHabilidades/Iconos/01_ataque_rojo/hacha_de_guerra.png",
		"max_rank": 5,
		"base_cost": 1,
		"cost_growth": 0,
		"min_level": 6,
		"requires": [{"id": "speed", "rank": 1}],
		"title_es": "Quebrantar armadura",
		"title_en": "Armor Break",
		"desc_es": "Tus golpes atraviesan las defensas enemigas.",
		"desc_en": "Your blows pierce enemy defenses.",
		"effect_es": "+3% daño por rango.",
		"effect_en": "+3% damage per rank.",
		"auto_unlocked": false
	},
	{
		"id": "attack_lifesteal",
		"branch": "offense",
		"center": Vector2(865.0, 210.0),
		"radius": 22.0,
		"icon": "res://Recursos/UI/ArbolHabilidades/Iconos/01_ataque_rojo/daga_veloz.png",
		"max_rank": 3,
		"base_cost": 2,
		"cost_growth": 1,
		"min_level": 12,
		"requires": [{"id": "crit", "rank": 1}],
		"title_es": "Filo voraz",
		"title_en": "Voracious Edge",
		"desc_es": "Una parte del daño infligido regresa como vida.",
		"desc_en": "Part of the damage dealt returns as health.",
		"effect_es": "+1.5% robo de vida por rango.",
		"effect_en": "+1.5% lifesteal per rank.",
		"auto_unlocked": false
	},
	{
		"id": "crit",
		"branch": "offense",
		"center": Vector2(835.0, 278.0),
		"radius": 20.0,
		"icon": "res://Recursos/UI/ArbolHabilidades/Iconos/01_ataque_rojo/golpe_critico.png",
		"max_rank": 5,
		"base_cost": 1,
		"cost_growth": 0,
		"min_level": 5,
		"requires": [{"id": "damage", "rank": 2}],
		"title_es": "Golpe preciso",
		"title_en": "Precise Strike",
		"desc_es": "Aumenta la probabilidad de asestar golpes críticos.",
		"desc_en": "Increases critical hit chance.",
		"effect_es": "+2% crítico por rango.",
		"effect_en": "+2% critical chance per rank.",
		"auto_unlocked": false
	},
	{
		"id": "speed",
		"branch": "offense",
		"center": Vector2(636.0, 279.0),
		"radius": 21.0,
		"icon": "res://Recursos/UI/ArbolHabilidades/Iconos/01_ataque_rojo/corte_llameante.png",
		"max_rank": 5,
		"base_cost": 1,
		"cost_growth": 0,
		"min_level": 4,
		"requires": [{"id": "damage", "rank": 1}],
		"title_es": "Ritmo de batalla",
		"title_en": "Battle Rhythm",
		"desc_es": "Reduce el tiempo entre ataques.",
		"desc_en": "Reduces the time between attacks.",
		"effect_es": "+5 velocidad por rango.",
		"effect_en": "+5 speed per rank.",
		"auto_unlocked": false
	},
	{
		"id": "loot",
		"branch": "fortune",
		"center": Vector2(487.0, 208.0),
		"radius": 23.0,
		"icon": "res://Recursos/UI/ArbolHabilidades/Iconos/02_suerte_verde/hoja.png",
		"max_rank": 5,
		"base_cost": 1,
		"cost_growth": 0,
		"min_level": 7,
		"requires": [{"id": "gold", "rank": 1}],
		"title_es": "Instinto del saqueador",
		"title_en": "Scavenger Instinct",
		"desc_es": "Mejora la calidad del botín obtenido.",
		"desc_en": "Improves the quality of obtained loot.",
		"effect_es": "+4% suerte de botín por rango.",
		"effect_en": "+4% loot luck per rank.",
		"auto_unlocked": false
	},
	{
		"id": "treasure",
		"branch": "fortune",
		"center": Vector2(415.0, 238.0),
		"radius": 20.0,
		"icon": "res://Recursos/UI/ArbolHabilidades/Iconos/02_suerte_verde/bolsa_de_hierbas.png",
		"max_rank": 3,
		"base_cost": 2,
		"cost_growth": 1,
		"min_level": 12,
		"requires": [{"id": "loot", "rank": 1}],
		"title_es": "Tesoros ocultos",
		"title_en": "Hidden Treasures",
		"desc_es": "Encuentras rutas y escondites que otros pasan por alto.",
		"desc_en": "You find paths and caches others overlook.",
		"effect_es": "+4% oro y +3% suerte por rango.",
		"effect_en": "+4% gold and +3% luck per rank.",
		"auto_unlocked": false
	},
	{
		"id": "xp",
		"branch": "fortune",
		"center": Vector2(536.0, 262.0),
		"radius": 20.0,
		"icon": "res://Recursos/UI/ArbolHabilidades/Iconos/02_suerte_verde/brote.png",
		"max_rank": 5,
		"base_cost": 1,
		"cost_growth": 0,
		"min_level": 4,
		"requires": [{"id": "fortune", "rank": 1}],
		"title_es": "Aprendizaje veloz",
		"title_en": "Swift Learning",
		"desc_es": "Aumenta la experiencia conseguida.",
		"desc_en": "Increases experience gained.",
		"effect_es": "+6% EXP por rango.",
		"effect_en": "+6% EXP per rank.",
		"auto_unlocked": false
	},
	{
		"id": "relic",
		"branch": "fortune",
		"center": Vector2(461.0, 293.0),
		"radius": 21.0,
		"icon": "res://Recursos/UI/ArbolHabilidades/Iconos/02_suerte_verde/amuleto_sagrado.png",
		"max_rank": 3,
		"base_cost": 2,
		"cost_growth": 1,
		"min_level": 14,
		"requires": [{"id": "loot", "rank": 2}],
		"title_es": "Reliquias antiguas",
		"title_en": "Ancient Relics",
		"desc_es": "Las reliquias revelan mejores recompensas.",
		"desc_en": "Relics reveal better rewards.",
		"effect_es": "+3% EXP y +6% suerte por rango.",
		"effect_en": "+3% EXP and +6% luck per rank.",
		"auto_unlocked": false
	},
	{
		"id": "dodge",
		"branch": "fortune",
		"center": Vector2(366.0, 304.0),
		"radius": 21.0,
		"icon": "res://Recursos/UI/ArbolHabilidades/Iconos/02_suerte_verde/remolino_de_fortuna.png",
		"max_rank": 3,
		"base_cost": 2,
		"cost_growth": 1,
		"min_level": 11,
		"requires": [{"id": "treasure", "rank": 1}],
		"title_es": "Paso afortunado",
		"title_en": "Lucky Step",
		"desc_es": "La fortuna aparta algunos golpes de tu camino.",
		"desc_en": "Fortune turns some blows away from your path.",
		"effect_es": "+2% esquiva por rango.",
		"effect_en": "+2% dodge per rank.",
		"auto_unlocked": false
	},
	{
		"id": "gold",
		"branch": "fortune",
		"center": Vector2(576.0, 331.0),
		"radius": 23.0,
		"icon": "res://Recursos/UI/ArbolHabilidades/Iconos/02_suerte_verde/moneda_de_la_suerte.png",
		"max_rank": 5,
		"base_cost": 1,
		"cost_growth": 0,
		"min_level": 3,
		"requires": [{"id": "fortune", "rank": 1}],
		"title_es": "Monedas del viajero",
		"title_en": "Traveler's Coin",
		"desc_es": "Aumenta el oro obtenido en combate.",
		"desc_en": "Increases gold earned in combat.",
		"effect_es": "+6% oro por rango.",
		"effect_en": "+6% gold per rank.",
		"auto_unlocked": false
	},
	{
		"id": "fortune",
		"branch": "fortune",
		"center": Vector2(483.0, 365.0),
		"radius": 32.0,
		"icon": "res://Recursos/UI/ArbolHabilidades/Iconos/02_suerte_verde/trebol.png",
		"max_rank": 5,
		"base_cost": 1,
		"cost_growth": 0,
		"min_level": 1,
		"requires": [{"id": "core", "rank": 1}],
		"title_es": "Fortuna del viajero",
		"title_en": "Traveler's Fortune",
		"desc_es": "Abre el sendero de la riqueza y el hallazgo.",
		"desc_en": "Opens the path of wealth and discovery.",
		"effect_es": "+1% oro y EXP por rango.",
		"effect_en": "+1% gold and EXP per rank.",
		"auto_unlocked": false
	},
	{
		"id": "archer_passive",
		"branch": "fortune",
		"center": Vector2(350.0, 377.0),
		"radius": 22.0,
		"icon": "res://Recursos/UI/ArbolHabilidades/Iconos/02_suerte_verde/corazon_natural.png",
		"max_rank": 3,
		"base_cost": 2,
		"cost_growth": 2,
		"min_level": 12,
		"requires": [{"id": "archer_active", "rank": 1}],
		"title_es": "Instintos pasivos",
		"title_en": "Passive Instincts",
		"desc_es": "Desbloquea pasivas de sangrado, veneno y ejecución para el Arquero.",
		"desc_en": "Unlocks bleed, poison and execution passives for the Archer.",
		"effect_es": "Desbloquea 1 pasiva por rango.",
		"effect_en": "Unlocks 1 passive per rank.",
		"auto_unlocked": false
	},
	{
		"id": "shared_training",
		"branch": "fortune",
		"center": Vector2(340.0, 453.0),
		"radius": 23.0,
		"icon":
		"res://Recursos/UI/ArbolHabilidades/Iconos/02_suerte_verde/semilla_de_crecimiento.png",
		"max_rank": 5,
		"base_cost": 1,
		"cost_growth": 0,
		"min_level": 13,
		"requires": [{"id": "unlock_1", "rank": 1}],
		"title_es": "Entrenamiento compartido",
		"title_en": "Shared Training",
		"desc_es": "Los compañeros aprenden incluso cuando no lideran la formación.",
		"desc_en": "Companions learn even when they do not lead the formation.",
		"effect_es": "+3% EXP por rango.",
		"effect_en": "+3% EXP per rank.",
		"auto_unlocked": false
	},
	{
		"id": "fortune_charm",
		"branch": "fortune",
		"center": Vector2(371.0, 527.0),
		"radius": 23.0,
		"icon": "res://Recursos/UI/ArbolHabilidades/Iconos/02_suerte_verde/gota_curativa.png",
		"max_rank": 3,
		"base_cost": 2,
		"cost_growth": 1,
		"min_level": 17,
		"requires": [{"id": "dodge", "rank": 1}],
		"title_es": "Amuleto del camino",
		"title_en": "Road Charm",
		"desc_es": "Una pequeña bendición acompaña cada viaje.",
		"desc_en": "A small blessing follows every journey.",
		"effect_es": "+2% oro, EXP y suerte por rango.",
		"effect_en": "+2% gold, EXP and luck per rank.",
		"auto_unlocked": false
	},
	{
		"id": "fortune_mastery",
		"branch": "fortune",
		"center": Vector2(460.0, 543.0),
		"radius": 22.0,
		"icon": "res://Recursos/UI/ArbolHabilidades/Iconos/02_suerte_verde/bendicion_verde.png",
		"max_rank": 1,
		"base_cost": 5,
		"cost_growth": 0,
		"min_level": 25,
		"requires": [{"id": "relic", "rank": 1}, {"id": "fortune_charm", "rank": 1}],
		"title_es": "Maestría de fortuna",
		"title_en": "Fortune Mastery",
		"desc_es": "Domina el sendero de los hallazgos imposibles.",
		"desc_en": "Masters the path of impossible discoveries.",
		"effect_es": "+15% oro, +15% EXP y +12% suerte.",
		"effect_en": "+15% gold, +15% EXP and +12% luck.",
		"auto_unlocked": false
	},
	{
		"id": "damage_reduction",
		"branch": "defense",
		"center": Vector2(989.0, 207.0),
		"radius": 23.0,
		"icon": "res://Recursos/UI/ArbolHabilidades/Iconos/03_defensa_azul/escudo_torre.png",
		"max_rank": 5,
		"base_cost": 1,
		"cost_growth": 0,
		"min_level": 8,
		"requires": [{"id": "vitality", "rank": 1}],
		"title_es": "Muralla inquebrantable",
		"title_en": "Unbreakable Wall",
		"desc_es": "Reduce de forma directa el daño recibido.",
		"desc_en": "Directly reduces incoming damage.",
		"effect_es": "+2% reducción por rango.",
		"effect_en": "+2% reduction per rank.",
		"auto_unlocked": false
	},
	{
		"id": "paladin_active",
		"branch": "defense",
		"center": Vector2(1059.0, 240.0),
		"radius": 22.0,
		"icon": "res://Recursos/UI/ArbolHabilidades/Iconos/03_defensa_azul/escudo_y_espada.png",
		"max_rank": 3,
		"base_cost": 2,
		"cost_growth": 2,
		"min_level": 6,
		"requires": [{"id": "defense", "rank": 1}],
		"title_es": "Artes activas del Paladín",
		"title_en": "Paladin Active Arts",
		"desc_es": "Cada rango desbloquea una habilidad activa de Luz.",
		"desc_en": "Each rank unlocks one active Light skill.",
		"effect_es": "Desbloquea 1 técnica por rango.",
		"effect_en": "Unlocks 1 technique per rank.",
		"auto_unlocked": false
	},
	{
		"id": "vitality",
		"branch": "defense",
		"center": Vector2(940.0, 262.0),
		"radius": 21.0,
		"icon": "res://Recursos/UI/ArbolHabilidades/Iconos/03_defensa_azul/escudo_de_vida.png",
		"max_rank": 5,
		"base_cost": 1,
		"cost_growth": 0,
		"min_level": 2,
		"requires": [{"id": "defense", "rank": 1}],
		"title_es": "Vigor del guardián",
		"title_en": "Guardian Vigor",
		"desc_es": "Aumenta la vida máxima de la formación.",
		"desc_en": "Increases the party's maximum health.",
		"effect_es": "+5% vida por rango.",
		"effect_en": "+5% health per rank.",
		"auto_unlocked": false
	},
	{
		"id": "paladin_passive",
		"branch": "defense",
		"center": Vector2(1013.0, 291.0),
		"radius": 22.0,
		"icon": "res://Recursos/UI/ArbolHabilidades/Iconos/03_defensa_azul/yelmo_del_guardian.png",
		"max_rank": 3,
		"base_cost": 2,
		"cost_growth": 2,
		"min_level": 8,
		"requires": [{"id": "paladin_active", "rank": 1}],
		"title_es": "Juramentos pasivos",
		"title_en": "Passive Oaths",
		"desc_es": "Desbloquea las pasivas de Luz, vampirismo y resistencia del Paladín.",
		"desc_en": "Unlocks the Paladin's Light, vampirism and resistance passives.",
		"effect_es": "Desbloquea 1 pasiva por rango.",
		"effect_en": "Unlocks 1 passive per rank.",
		"auto_unlocked": false
	},
	{
		"id": "shield_on_kill",
		"branch": "defense",
		"center": Vector2(1109.0, 303.0),
		"radius": 22.0,
		"icon": "res://Recursos/UI/ArbolHabilidades/Iconos/03_defensa_azul/sello_de_proteccion.png",
		"max_rank": 3,
		"base_cost": 2,
		"cost_growth": 1,
		"min_level": 13,
		"requires": [{"id": "block", "rank": 2}],
		"title_es": "Sello victorioso",
		"title_en": "Victorious Seal",
		"desc_es": "Derrotar enemigos concede escudo temporal.",
		"desc_en": "Defeating enemies grants a temporary shield.",
		"effect_es": "+18 escudo por rango.",
		"effect_en": "+18 shield per rank.",
		"auto_unlocked": false
	},
	{
		"id": "block",
		"branch": "defense",
		"center": Vector2(903.0, 329.0),
		"radius": 22.0,
		"icon": "res://Recursos/UI/ArbolHabilidades/Iconos/03_defensa_azul/escudo.png",
		"max_rank": 5,
		"base_cost": 1,
		"cost_growth": 0,
		"min_level": 5,
		"requires": [{"id": "defense", "rank": 1}],
		"title_es": "Bloqueo disciplinado",
		"title_en": "Disciplined Block",
		"desc_es": "Aumenta la probabilidad de bloquear ataques.",
		"desc_en": "Increases the chance to block attacks.",
		"effect_es": "+3% bloqueo por rango.",
		"effect_en": "+3% block chance per rank.",
		"auto_unlocked": false
	},
	{
		"id": "defense",
		"branch": "defense",
		"center": Vector2(994.0, 365.0),
		"radius": 37.0,
		"icon": "res://Recursos/UI/ArbolHabilidades/Iconos/03_defensa_azul/armadura.png",
		"max_rank": 5,
		"base_cost": 1,
		"cost_growth": 0,
		"min_level": 1,
		"requires": [{"id": "core", "rank": 1}],
		"title_es": "Armadura reforzada",
		"title_en": "Reinforced Armor",
		"desc_es": "Eleva la defensa plana de todos los campeones.",
		"desc_en": "Raises flat defense for all champions.",
		"effect_es": "+6 defensa por rango.",
		"effect_en": "+6 defense per rank.",
		"auto_unlocked": false
	},
	{
		"id": "low_health_guard",
		"branch": "defense",
		"center": Vector2(1130.0, 377.0),
		"radius": 23.0,
		"icon": "res://Recursos/UI/ArbolHabilidades/Iconos/03_defensa_azul/aura_protectora.png",
		"max_rank": 3,
		"base_cost": 2,
		"cost_growth": 1,
		"min_level": 15,
		"requires": [{"id": "damage_reduction", "rank": 2}],
		"title_es": "Último bastión",
		"title_en": "Last Bastion",
		"desc_es": "Al caer la vida, el guardián se vuelve más difícil de derribar.",
		"desc_en": "At low health, the guardian becomes harder to bring down.",
		"effect_es": "+5% reducción con poca vida por rango.",
		"effect_en": "+5% low-health reduction per rank.",
		"auto_unlocked": false
	},
	{
		"id": "heal_on_kill",
		"branch": "defense",
		"center": Vector2(1137.0, 453.0),
		"radius": 23.0,
		"icon": "res://Recursos/UI/ArbolHabilidades/Iconos/03_defensa_azul/bloqueo_de_flecha.png",
		"max_rank": 3,
		"base_cost": 2,
		"cost_growth": 1,
		"min_level": 17,
		"requires": [{"id": "shield_on_kill", "rank": 1}],
		"title_es": "Aliento de victoria",
		"title_en": "Breath of Victory",
		"desc_es": "Cada enemigo derrotado restaura vida.",
		"desc_en": "Each defeated enemy restores health.",
		"effect_es": "+4 vida por baja y rango.",
		"effect_en": "+4 health per kill and rank.",
		"auto_unlocked": false
	},
	{
		"id": "defense_formation",
		"branch": "defense",
		"center": Vector2(1106.0, 525.0),
		"radius": 22.0,
		"icon": "res://Recursos/UI/ArbolHabilidades/Iconos/03_defensa_azul/formacion_tactica.png",
		"max_rank": 3,
		"base_cost": 2,
		"cost_growth": 1,
		"min_level": 18,
		"requires": [{"id": "paladin_passive", "rank": 2}],
		"title_es": "Formación protectora",
		"title_en": "Protective Formation",
		"desc_es": "La primera línea protege a quienes combaten detrás.",
		"desc_en": "The front line protects those fighting behind.",
		"effect_es": "+4 defensa por rango.",
		"effect_en": "+4 defense per rank.",
		"auto_unlocked": false
	},
	{
		"id": "guardian_mastery",
		"branch": "defense",
		"center": Vector2(1016.0, 538.0),
		"radius": 20.0,
		"icon": "res://Recursos/UI/ArbolHabilidades/Iconos/03_defensa_azul/fortaleza.png",
		"max_rank": 1,
		"base_cost": 5,
		"cost_growth": 0,
		"min_level": 25,
		"requires": [{"id": "heal_on_kill", "rank": 1}, {"id": "defense_formation", "rank": 1}],
		"title_es": "Maestría del guardián",
		"title_en": "Guardian Mastery",
		"desc_es": "La formación se convierte en una fortaleza viviente.",
		"desc_en": "The formation becomes a living fortress.",
		"effect_es": "+10% vida, +12 defensa y +5% reducción.",
		"effect_en": "+10% health, +12 defense and +5% reduction.",
		"auto_unlocked": false
	},
	{
		"id": "potion",
		"branch": "alchemy",
		"center": Vector2(370.0, 606.0),
		"radius": 21.0,
		"icon":
		"res://Recursos/UI/ArbolHabilidades/Iconos/04_alquimia_morada/pocion_de_cristal.png",
		"max_rank": 1,
		"base_cost": 2,
		"cost_growth": 0,
		"min_level": 8,
		"requires": [{"id": "alchemy_root", "rank": 1}],
		"title_es": "Alquimia ambulante",
		"title_en": "Wandering Alchemy",
		"desc_es": "Genera automáticamente una poción cada diez minutos, hasta el límite diario.",
		"desc_en": "Automatically creates a potion every ten minutes, up to the daily limit.",
		"effect_es": "Activa el generador de pociones.",
		"effect_en": "Enables the potion generator.",
		"auto_unlocked": false
	},
	{
		"id": "alchemy_root",
		"branch": "alchemy",
		"center": Vector2(463.0, 623.0),
		"radius": 30.0,
		"icon": "res://Recursos/UI/ArbolHabilidades/Iconos/04_alquimia_morada/frasco_arcano.png",
		"max_rank": 5,
		"base_cost": 1,
		"cost_growth": 0,
		"min_level": 4,
		"requires": [{"id": "core", "rank": 1}],
		"title_es": "Conocimiento alquímico",
		"title_en": "Alchemy Knowledge",
		"desc_es": "Abre el sendero de las pociones y catalizadores.",
		"desc_en": "Opens the path of potions and catalysts.",
		"effect_es": "+5% potencia de poción por rango.",
		"effect_en": "+5% potion power per rank.",
		"auto_unlocked": false
	},
	{
		"id": "potion_power",
		"branch": "alchemy",
		"center": Vector2(336.0, 675.0),
		"radius": 21.0,
		"icon": "res://Recursos/UI/ArbolHabilidades/Iconos/04_alquimia_morada/elixir.png",
		"max_rank": 5,
		"base_cost": 1,
		"cost_growth": 0,
		"min_level": 10,
		"requires": [{"id": "potion", "rank": 1}],
		"title_es": "Elixir concentrado",
		"title_en": "Concentrated Elixir",
		"desc_es": "Las pociones producen un efecto más intenso.",
		"desc_en": "Potions produce a stronger effect.",
		"effect_es": "+12% potencia por rango.",
		"effect_en": "+12% power per rank.",
		"auto_unlocked": false
	},
	{
		"id": "potion_flat",
		"branch": "alchemy",
		"center": Vector2(335.0, 754.0),
		"radius": 20.0,
		"icon": "res://Recursos/UI/ArbolHabilidades/Iconos/04_alquimia_morada/gota_arcana.png",
		"max_rank": 5,
		"base_cost": 1,
		"cost_growth": 0,
		"min_level": 12,
		"requires": [{"id": "potion_power", "rank": 1}],
		"title_es": "Esencia restauradora",
		"title_en": "Restorative Essence",
		"desc_es": "Añade curación plana a todas las pociones.",
		"desc_en": "Adds flat healing to every potion.",
		"effect_es": "+8 curación por rango.",
		"effect_en": "+8 healing per rank.",
		"auto_unlocked": false
	},
	{
		"id": "alchemy_mastery",
		"branch": "alchemy",
		"center": Vector2(475.0, 810.0),
		"radius": 23.0,
		"icon": "res://Recursos/UI/ArbolHabilidades/Iconos/04_alquimia_morada/transmutacion.png",
		"max_rank": 1,
		"base_cost": 5,
		"cost_growth": 0,
		"min_level": 24,
		"requires": [{"id": "potion_flat", "rank": 2}, {"id": "arcane_smoke", "rank": 1}],
		"title_es": "Maestría alquímica",
		"title_en": "Alchemy Mastery",
		"desc_es": "Domina la transmutación de la materia y la energía.",
		"desc_en": "Masters the transmutation of matter and energy.",
		"effect_es": "+25% potencia y +20 curación.",
		"effect_en": "+25% power and +20 healing.",
		"auto_unlocked": false
	},
	{
		"id": "poison_mastery",
		"branch": "alchemy",
		"center": Vector2(361.0, 823.0),
		"radius": 23.0,
		"icon": "res://Recursos/UI/ArbolHabilidades/Iconos/04_alquimia_morada/veneno.png",
		"max_rank": 3,
		"base_cost": 2,
		"cost_growth": 1,
		"min_level": 14,
		"requires": [{"id": "potion_power", "rank": 1}],
		"title_es": "Toxicología",
		"title_en": "Toxicology",
		"desc_es": "Mejora el daño persistente de venenos y sangrados.",
		"desc_en": "Improves persistent poison and bleed damage.",
		"effect_es": "+4% daño y +2% ejecución por rango.",
		"effect_en": "+4% damage and +2% execution per rank.",
		"auto_unlocked": false
	},
	{
		"id": "arcane_smoke",
		"branch": "alchemy",
		"center": Vector2(536.0, 864.0),
		"radius": 22.0,
		"icon": "res://Recursos/UI/ArbolHabilidades/Iconos/04_alquimia_morada/humo_arcano.png",
		"max_rank": 3,
		"base_cost": 2,
		"cost_growth": 1,
		"min_level": 16,
		"requires": [{"id": "potion_flat", "rank": 1}],
		"title_es": "Humo arcano",
		"title_en": "Arcane Smoke",
		"desc_es": "Una nube protectora desvía los ataques más peligrosos.",
		"desc_en": "A protective cloud diverts the most dangerous attacks.",
		"effect_es": "+1.5% esquiva por rango.",
		"effect_en": "+1.5% dodge per rank.",
		"auto_unlocked": false
	},
	{
		"id": "arcanist_active",
		"branch": "alchemy",
		"center": Vector2(425.0, 871.0),
		"radius": 20.0,
		"icon": "res://Recursos/UI/ArbolHabilidades/Iconos/04_alquimia_morada/bomba_maldita.png",
		"max_rank": 3,
		"base_cost": 2,
		"cost_growth": 2,
		"min_level": 20,
		"requires": [{"id": "unlock_2", "rank": 1}, {"id": "alchemy_root", "rank": 1}],
		"title_es": "Artes activas del Arcanista",
		"title_en": "Arcanist Active Arts",
		"desc_es": "Cada rango desbloquea una habilidad activa del Arcanista.",
		"desc_en": "Each rank unlocks one active Arcanist skill.",
		"effect_es": "Desbloquea 1 técnica por rango.",
		"effect_en": "Unlocks 1 technique per rank.",
		"auto_unlocked": false
	},
	{
		"id": "arcanist_passive",
		"branch": "alchemy",
		"center": Vector2(482.0, 906.0),
		"radius": 22.0,
		"icon":
		"res://Recursos/UI/ArbolHabilidades/Iconos/04_alquimia_morada/cristal_catalizador.png",
		"max_rank": 3,
		"base_cost": 2,
		"cost_growth": 2,
		"min_level": 22,
		"requires": [{"id": "arcanist_active", "rank": 1}],
		"title_es": "Ecos pasivos",
		"title_en": "Passive Echoes",
		"desc_es": "Desbloquea pasivas de magia, vampirismo y barrera astral.",
		"desc_en": "Unlocks magic, vampirism and astral barrier passives.",
		"effect_es": "Desbloquea 1 pasiva por rango.",
		"effect_en": "Unlocks 1 passive per rank.",
		"auto_unlocked": false
	},
	{
		"id": "legacy_power",
		"branch": "progression",
		"center": Vector2(1103.0, 606.0),
		"radius": 20.0,
		"icon": "res://Recursos/UI/ArbolHabilidades/Iconos/06_progreso_dorado/progreso.png",
		"max_rank": 3,
		"base_cost": 3,
		"cost_growth": 1,
		"min_level": 18,
		"requires": [{"id": "mastery", "rank": 1}],
		"title_es": "Poder del legado",
		"title_en": "Legacy Power",
		"desc_es": "El conocimiento acumulado fortalece todos los atributos principales.",
		"desc_en": "Accumulated knowledge strengthens all primary attributes.",
		"effect_es": "+2% vida, +2% daño y +2 defensa por rango.",
		"effect_en": "+2% health, +2% damage and +2 defense per rank.",
		"auto_unlocked": false
	},
	{
		"id": "mastery",
		"branch": "progression",
		"center": Vector2(1011.0, 623.0),
		"radius": 36.0,
		"icon":
		"res://Recursos/UI/ArbolHabilidades/Iconos/06_progreso_dorado/estrella_de_maestria.png",
		"max_rank": 5,
		"base_cost": 2,
		"cost_growth": 1,
		"min_level": 15,
		"requires": [{"id": "core", "rank": 1}],
		"title_es": "Maestría del campeón",
		"title_en": "Champion Mastery",
		"desc_es": "El campeón aprende a convertir experiencia en poder puro.",
		"desc_en": "The champion learns to turn experience into raw power.",
		"effect_es": "+3% vida, daño, oro y EXP; +3 defensa por rango.",
		"effect_en": "+3% health, damage, gold and EXP; +3 defense per rank.",
		"auto_unlocked": false
	},
	{
		"id": "progress_xp",
		"branch": "progression",
		"center": Vector2(1141.0, 675.0),
		"radius": 23.0,
		"icon":
		"res://Recursos/UI/ArbolHabilidades/Iconos/06_progreso_dorado/pluma_de_experiencia.png",
		"max_rank": 3,
		"base_cost": 2,
		"cost_growth": 1,
		"min_level": 20,
		"requires": [{"id": "legacy_power", "rank": 1}],
		"title_es": "Crónicas vivientes",
		"title_en": "Living Chronicles",
		"desc_es": "Cada batalla deja una lección más profunda.",
		"desc_en": "Every battle leaves a deeper lesson.",
		"effect_es": "+5% EXP por rango.",
		"effect_en": "+5% EXP per rank.",
		"auto_unlocked": false
	},
	{
		"id": "progress_gold",
		"branch": "progression",
		"center": Vector2(1141.0, 753.0),
		"radius": 19.0,
		"icon": "res://Recursos/UI/ArbolHabilidades/Iconos/06_progreso_dorado/trofeo.png",
		"max_rank": 3,
		"base_cost": 2,
		"cost_growth": 1,
		"min_level": 20,
		"requires": [{"id": "legacy_power", "rank": 1}],
		"title_es": "Gloria recompensada",
		"title_en": "Rewarded Glory",
		"desc_es": "Las gestas del campeón atraen mejores recompensas.",
		"desc_en": "The champion's deeds attract better rewards.",
		"effect_es": "+5% oro por rango.",
		"effect_en": "+5% gold per rank.",
		"auto_unlocked": false
	},
	{
		"id": "progress_legend",
		"branch": "progression",
		"center": Vector2(997.0, 812.0),
		"radius": 21.0,
		"icon":
		"res://Recursos/UI/ArbolHabilidades/Iconos/06_progreso_dorado/pergamino_de_mision.png",
		"max_rank": 1,
		"base_cost": 6,
		"cost_growth": 0,
		"min_level": 35,
		"requires": [{"id": "progress_all", "rank": 1}, {"id": "trinity_bonus", "rank": 1}],
		"title_es": "Leyenda de la Fractura",
		"title_en": "Legend of the Fracture",
		"desc_es": "El último sello une todos los senderos del árbol.",
		"desc_en": "The final seal unites every path of the tree.",
		"effect_es": "+8% daño, vida, oro y EXP; +8 defensa.",
		"effect_en": "+8% damage, health, gold and EXP; +8 defense.",
		"auto_unlocked": false
	},
	{
		"id": "progress_speed",
		"branch": "progression",
		"center": Vector2(1113.0, 826.0),
		"radius": 20.0,
		"icon":
		"res://Recursos/UI/ArbolHabilidades/Iconos/06_progreso_dorado/velocidad_temporal.png",
		"max_rank": 3,
		"base_cost": 2,
		"cost_growth": 1,
		"min_level": 24,
		"requires": [{"id": "progress_gold", "rank": 1}],
		"title_es": "Tiempo conquistado",
		"title_en": "Conquered Time",
		"desc_es": "El campeón actúa antes de que el enemigo pueda reaccionar.",
		"desc_en": "The champion acts before the enemy can react.",
		"effect_es": "+4 velocidad por rango.",
		"effect_en": "+4 speed per rank.",
		"auto_unlocked": false
	},
	{
		"id": "progress_all",
		"branch": "progression",
		"center": Vector2(939.0, 863.0),
		"radius": 21.0,
		"icon": "res://Recursos/UI/ArbolHabilidades/Iconos/06_progreso_dorado/subida_de_nivel.png",
		"max_rank": 1,
		"base_cost": 5,
		"cost_growth": 0,
		"min_level": 30,
		"requires": [{"id": "progress_health", "rank": 1}, {"id": "progress_damage", "rank": 1}],
		"title_es": "Ascenso heroico",
		"title_en": "Heroic Ascension",
		"desc_es": "Una mejora equilibrada nacida de todos los senderos.",
		"desc_en": "A balanced improvement born from every path.",
		"effect_es": "+5% daño y vida, +5 defensa y +3% crítico.",
		"effect_en": "+5% damage and health, +5 defense and +3% critical.",
		"auto_unlocked": false
	},
	{
		"id": "progress_health",
		"branch": "progression",
		"center": Vector2(1048.0, 871.0),
		"radius": 22.0,
		"icon": "res://Recursos/UI/ArbolHabilidades/Iconos/06_progreso_dorado/sol_radiante.png",
		"max_rank": 3,
		"base_cost": 2,
		"cost_growth": 1,
		"min_level": 24,
		"requires": [{"id": "progress_xp", "rank": 1}],
		"title_es": "Vitalidad ascendente",
		"title_en": "Ascending Vitality",
		"desc_es": "Cada nivel fortalece la resistencia del campeón.",
		"desc_en": "Each level strengthens the champion's resilience.",
		"effect_es": "+4% vida por rango.",
		"effect_en": "+4% health per rank.",
		"auto_unlocked": false
	},
	{
		"id": "progress_damage",
		"branch": "progression",
		"center": Vector2(986.0, 907.0),
		"radius": 21.0,
		"icon": "res://Recursos/UI/ArbolHabilidades/Iconos/06_progreso_dorado/reloj_de_arena.png",
		"max_rank": 3,
		"base_cost": 2,
		"cost_growth": 1,
		"min_level": 24,
		"requires": [{"id": "progress_xp", "rank": 1}],
		"title_es": "Poder acumulado",
		"title_en": "Accumulated Power",
		"desc_es": "El tiempo convierte la disciplina en fuerza.",
		"desc_en": "Time turns discipline into strength.",
		"effect_es": "+4% daño por rango.",
		"effect_en": "+4% damage per rank.",
		"auto_unlocked": false
	},
	{
		"id": "unlock_1",
		"branch": "legacy",
		"center": Vector2(739.0, 778.0),
		"radius": 31.0,
		"icon": "res://Recursos/UI/ArbolHabilidades/Iconos/05_companeros_cian/companero.png",
		"max_rank": 1,
		"base_cost": 3,
		"cost_growth": 0,
		"min_level": 10,
		"requires": [{"id": "core", "rank": 1}],
		"title_es": "Primer compañero",
		"title_en": "First Companion",
		"desc_es": "Concede una ficha para desbloquear al Arquero en el inventario.",
		"desc_en": "Grants one token to unlock the Archer in the inventory.",
		"effect_es": "+1 ficha de personaje.",
		"effect_en": "+1 character token.",
		"auto_unlocked": false
	},
	{
		"id": "companion_power",
		"branch": "legacy",
		"center": Vector2(577.0, 802.0),
		"radius": 19.0,
		"icon": "res://Recursos/UI/ArbolHabilidades/Iconos/05_companeros_cian/invocacion.png",
		"max_rank": 5,
		"base_cost": 1,
		"cost_growth": 0,
		"min_level": 12,
		"requires": [{"id": "unlock_1", "rank": 1}],
		"title_es": "Fuerza compartida",
		"title_en": "Shared Strength",
		"desc_es": "Los compañeros aportan parte de su poder a toda la formación.",
		"desc_en": "Companions lend part of their strength to the whole party.",
		"effect_es": "+2% daño por rango.",
		"effect_en": "+2% damage per rank.",
		"auto_unlocked": false
	},
	{
		"id": "unlock_2",
		"branch": "legacy",
		"center": Vector2(894.0, 802.0),
		"radius": 20.0,
		"icon": "res://Recursos/UI/ArbolHabilidades/Iconos/05_companeros_cian/dos_companeros.png",
		"max_rank": 1,
		"base_cost": 5,
		"cost_growth": 0,
		"min_level": 20,
		"requires": [{"id": "unlock_1", "rank": 1}],
		"title_es": "Segundo compañero",
		"title_en": "Second Companion",
		"desc_es": "Concede una ficha para desbloquear al Arcanista en el inventario.",
		"desc_en": "Grants one token to unlock the Arcanist in the inventory.",
		"effect_es": "+1 ficha de personaje.",
		"effect_en": "+1 character token.",
		"auto_unlocked": false
	},
	{
		"id": "companion_speed",
		"branch": "legacy",
		"center": Vector2(632.0, 855.0),
		"radius": 21.0,
		"icon": "res://Recursos/UI/ArbolHabilidades/Iconos/05_companeros_cian/mascota.png",
		"max_rank": 3,
		"base_cost": 2,
		"cost_growth": 1,
		"min_level": 15,
		"requires": [{"id": "companion_power", "rank": 1}],
		"title_es": "Ritmo de compañía",
		"title_en": "Companion Rhythm",
		"desc_es": "La coordinación acelera los ataques de todos.",
		"desc_en": "Coordination speeds up everyone's attacks.",
		"effect_es": "+3 velocidad por rango.",
		"effect_en": "+3 speed per rank.",
		"auto_unlocked": false
	},
	{
		"id": "companion_defense",
		"branch": "legacy",
		"center": Vector2(842.0, 859.0),
		"radius": 22.0,
		"icon":
		"res://Recursos/UI/ArbolHabilidades/Iconos/05_companeros_cian/aliados_vinculados.png",
		"max_rank": 3,
		"base_cost": 2,
		"cost_growth": 1,
		"min_level": 22,
		"requires": [{"id": "unlock_2", "rank": 1}],
		"title_es": "Vínculo protector",
		"title_en": "Protective Bond",
		"desc_es": "Los aliados comparten el peso de cada impacto.",
		"desc_en": "Allies share the weight of every impact.",
		"effect_es": "+4 defensa por rango.",
		"effect_en": "+4 defense per rank.",
		"auto_unlocked": false
	},
	{
		"id": "companion_heal",
		"branch": "legacy",
		"center": Vector2(609.0, 944.0),
		"radius": 21.0,
		"icon": "res://Recursos/UI/ArbolHabilidades/Iconos/05_companeros_cian/aura_de_apoyo.png",
		"max_rank": 3,
		"base_cost": 2,
		"cost_growth": 1,
		"min_level": 20,
		"requires": [{"id": "companion_speed", "rank": 1}],
		"title_es": "Aura de apoyo",
		"title_en": "Support Aura",
		"desc_es": "Las victorias restauran vida a la formación.",
		"desc_en": "Victories restore health to the party.",
		"effect_es": "+3 vida por baja y rango.",
		"effect_en": "+3 health per kill and rank.",
		"auto_unlocked": false
	},
	{
		"id": "companion_crit",
		"branch": "legacy",
		"center": Vector2(870.0, 947.0),
		"radius": 21.0,
		"icon": "res://Recursos/UI/ArbolHabilidades/Iconos/05_companeros_cian/bandera_de_mando.png",
		"max_rank": 3,
		"base_cost": 2,
		"cost_growth": 1,
		"min_level": 24,
		"requires": [{"id": "companion_defense", "rank": 1}],
		"title_es": "Orden de ataque",
		"title_en": "Attack Order",
		"desc_es": "Una orden precisa abre ventanas para golpes críticos.",
		"desc_en": "A precise command opens windows for critical hits.",
		"effect_es": "+2% crítico por rango.",
		"effect_en": "+2% critical chance per rank.",
		"auto_unlocked": false
	},
	{
		"id": "companion_mastery",
		"branch": "legacy",
		"center": Vector2(678.0, 981.0),
		"radius": 22.0,
		"icon":
		"res://Recursos/UI/ArbolHabilidades/Iconos/05_companeros_cian/formacion_de_grupo.png",
		"max_rank": 1,
		"base_cost": 5,
		"cost_growth": 0,
		"min_level": 30,
		"requires": [{"id": "companion_heal", "rank": 1}, {"id": "companion_crit", "rank": 1}],
		"title_es": "Maestría de formación",
		"title_en": "Formation Mastery",
		"desc_es": "La formación combate como una sola voluntad.",
		"desc_en": "The party fights as one will.",
		"effect_es": "+6% daño, +6% vida y +6 defensa.",
		"effect_en": "+6% damage, +6% health and +6 defense.",
		"auto_unlocked": false
	},
	{
		"id": "trinity_bonus",
		"branch": "legacy",
		"center": Vector2(793.0, 982.0),
		"radius": 22.0,
		"icon": "res://Recursos/UI/ArbolHabilidades/Iconos/05_companeros_cian/tres_companeros.png",
		"max_rank": 1,
		"base_cost": 6,
		"cost_growth": 0,
		"min_level": 35,
		"requires": [{"id": "companion_mastery", "rank": 1}, {"id": "legacy_power", "rank": 3}],
		"title_es": "Poder de la trinidad",
		"title_en": "Power of the Trinity",
		"desc_es": "Paladín, Arquero y Arcanista enlazan su poder.",
		"desc_en": "Paladin, Archer and Arcanist bind their power together.",
		"effect_es": "+6% vida, +6% daño, +5% crítico y +8 defensa.",
		"effect_en": "+6% health, +6% damage, +5% critical and +8 defense.",
		"auto_unlocked": false
	}
]

var skill_definitions_by_id: Dictionary = {}
var skill_ranks: Dictionary = {}
var preserved_unknown_ranks: Dictionary = {}
var current_effects: Dictionary = {}
var extra_skill_points: int = 0
var character_tokens: int = 0
var potion_day_key: String = ""
var potions_today: int = 0
var last_potion_unix: int = 0

var current_language: String = "es"
var selected_skill_id: String = "core"
var skill_tree_is_open: bool = false
var reset_confirmation_deadline: float = 0.0
var animation_clock: float = 0.0
var twinkle_stars: Array[Control] = []

var show_rank_badges: bool = true
var use_pixel_filter: bool = true
var keep_always_on_top: bool = true

var main_controller: Node = null
var inventory_ui: Node = null
var main_interface_root: Control = null
var fallback_top_button: Button = null
var last_toggle_request_msec: int = -1000
const TOGGLE_DEBOUNCE_MSEC: int = 180

var skill_window: Window = null
var window_root: Control = null
var design_root: Control = null
var background_rect: TextureRect = null
var drag_surface: Control = null
var dragging_window: bool = false
var drag_mouse_origin: Vector2i = Vector2i.ZERO
var drag_window_origin: Vector2i = Vector2i.ZERO

var title_label: Label = null
var subtitle_label: Label = null
var points_label: Label = null
var level_label: Label = null
var spent_label: Label = null
var summary_title_label: Label = null
var summary_label: Label = null
var tokens_label: Label = null
var potions_label: Label = null
var reset_button: Button = null
var status_label: Label = null
var lore_label: Label = null
var footer_label: Label = null

var selected_header_label: Label = null
var selected_icon_rect: TextureRect = null
var selected_title_label: Label = null
var selected_rank_label: Label = null
var selected_description_label: Label = null
var selected_effect_title_label: Label = null
var selected_effect_label: Label = null
var selected_requirements_title_label: Label = null
var selected_requirements_label: Label = null
var purchase_button: Button = null

var legend_title_label: Label = null
var legend_label: Label = null

var node_buttons: Dictionary = {}
var node_icons: Dictionary = {}
var node_rank_badges: Dictionary = {}


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	set_process(true)
	set_process_unhandled_input(true)
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	_prepare_native_window_support()
	_prepare_definitions()
	_refresh_references()
	_load_language()
	_load_visual_settings()
	_load_progress()
	_build_window()
	call_deferred("_mount_top_button_when_ready")
	_refresh_all()
	_notify_main_effects()
	if start_open:
		call_deferred("open_skill_tree")


func _process(delta: float) -> void:
	animation_clock += delta
	if skill_tree_is_open:
		_animate_selected_node()
		_animate_twinkle_stars()
		_process_potion_generator()
	if reset_confirmation_deadline > 0.0:
		var now_seconds: float = Time.get_ticks_msec() / 1000.0
		if now_seconds > reset_confirmation_deadline:
			reset_confirmation_deadline = 0.0
			_refresh_reset_button()


func _unhandled_input(event: InputEvent) -> void:
	if not (event is InputEventKey):
		return
	var key_event: InputEventKey = event as InputEventKey
	if not key_event.pressed or key_event.echo:
		return

	if key_event.keycode == KEY_H:
		if not _main_options_are_open():
			toggle_skill_tree()
			get_viewport().set_input_as_handled()
	elif key_event.keycode == KEY_ESCAPE and skill_tree_is_open:
		close_skill_tree()
		get_viewport().set_input_as_handled()


# =============================================================================
# API PÚBLICA — CONSERVADA PARA MAIN, INVENTARIO Y MISIONES
# =============================================================================


func toggle_skill_tree() -> void:
	# Main.gd controla el botón superior. Esta protección se conserva para
	# impedir repeticiones accidentales procedentes del teclado o de plugins.
	var now_msec: int = Time.get_ticks_msec()
	if now_msec - last_toggle_request_msec < TOGGLE_DEBOUNCE_MSEC:
		return
	last_toggle_request_msec = now_msec

	if _main_options_are_open():
		return
	if skill_tree_is_open:
		close_skill_tree()
	else:
		open_skill_tree()


func open_skill_tree() -> void:
	if skill_tree_is_open:
		_refresh_all()
		call_deferred("_finish_open_skill_tree")
		return

	_prepare_native_window_support()
	_refresh_references()
	_load_language()
	_load_visual_settings()
	_reload_character_tokens_only()
	skill_tree_is_open = true
	visible = true

	if is_instance_valid(skill_window):
		# Todas las propiedades que afectan a la ventana nativa se aplican
		# mientras permanece oculta.
		skill_window.hide()
		_fit_window_to_screen()
		_apply_native_window_flags()
		skill_window.show()

	call_deferred("_finish_open_skill_tree")
	_refresh_all()
	skill_tree_opened.emit()


func _finish_open_skill_tree() -> void:
	if not skill_tree_is_open:
		return
	if not is_instance_valid(skill_window):
		return

	# Aquí la ventana ya está mostrada: solo pedimos el foco.
	skill_window.grab_focus()


func close_skill_tree() -> void:
	if not skill_tree_is_open:
		return
	skill_tree_is_open = false
	dragging_window = false
	reset_confirmation_deadline = 0.0
	if is_instance_valid(skill_window):
		skill_window.hide()
	skill_tree_closed.emit()


func is_skill_tree_open() -> bool:
	return skill_tree_is_open


func get_skill_ranks() -> Dictionary:
	var result: Dictionary = preserved_unknown_ranks.duplicate(true)
	for skill_id: String in skill_ranks.keys():
		result[skill_id] = skill_ranks[skill_id]
	return result


func get_unlocked_equipable_skills(hero_id: String) -> Array[String]:
	return SistemaHabilidadesEquipables.habilidades_desbloqueadas(get_skill_ranks(), hero_id)


func add_extra_skill_points(amount: int) -> void:
	if amount <= 0:
		return
	extra_skill_points += amount
	_save_progress()
	_refresh_all()


func get_extra_skill_points() -> int:
	return extra_skill_points


func get_available_skill_points() -> int:
	return _get_available_points()


func get_total_spent_points() -> int:
	return _get_total_spent_points()


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


func reload_from_disk() -> void:
	_load_language()
	_load_visual_settings()
	_load_progress()
	_refresh_all()
	_notify_main_effects()


func reload_language() -> void:
	_load_language()
	_refresh_all()


func is_skill_unlocked(skill_id: String, minimum_rank: int = 1) -> bool:
	return int(skill_ranks.get(skill_id, preserved_unknown_ranks.get(skill_id, 0))) >= minimum_rank


func reset_skill_tree() -> void:
	_reset_skill_tree()


# =============================================================================
# PREPARACIÓN Y REFERENCIAS
# =============================================================================


func _prepare_definitions() -> void:
	skill_definitions_by_id.clear()
	for raw_definition: Dictionary in skill_definitions:
		var skill_id: String = str(raw_definition.get("id", ""))
		if skill_id.is_empty():
			continue
		skill_definitions_by_id[skill_id] = raw_definition


func _refresh_references() -> void:
	var current_scene: Node = get_tree().current_scene
	main_controller = get_parent()
	if current_scene != null:
		if (
			current_scene.has_method("_refresh_skill_tree_effects")
			or _object_has_property(current_scene, "player_level")
		):
			main_controller = current_scene
		inventory_ui = current_scene.find_child("InventarioUI", true, false)

		# Main guarda la barra en la propiedad interface_root. Usamos primero
		# esa referencia real y solo después buscamos el nombre del nodo.
		if _object_has_property(current_scene, "interface_root"):
			var root_value: Variant = current_scene.get("interface_root")
			if root_value is Control:
				main_interface_root = root_value as Control

		if not is_instance_valid(main_interface_root):
			var interface_candidate: Node = current_scene.find_child("InterfaceRoot", true, false)
			if interface_candidate is Control:
				main_interface_root = interface_candidate as Control

	if is_instance_valid(main_controller):
		if not is_instance_valid(inventory_ui):
			inventory_ui = main_controller.find_child("InventarioUI", true, false)
		if (
			not is_instance_valid(main_interface_root)
			and _object_has_property(main_controller, "interface_root")
		):
			var controller_root: Variant = main_controller.get("interface_root")
			if controller_root is Control:
				main_interface_root = controller_root as Control


func _object_has_property(target: Object, property_name: String) -> bool:
	if target == null:
		return false
	for property_data: Dictionary in target.get_property_list():
		if str(property_data.get("name", "")) == property_name:
			return true
	return false


func _main_options_are_open() -> bool:
	_refresh_references()
	if is_instance_valid(main_controller) and _object_has_property(main_controller, "options_open"):
		return bool(main_controller.get("options_open"))
	return false


func _main_number(property_name: String, fallback: int = 0) -> int:
	if is_instance_valid(main_controller) and _object_has_property(main_controller, property_name):
		return int(main_controller.get(property_name))
	return fallback


func _get_player_level() -> int:
	var level: int = _main_number("player_level", 0)
	if level > 0:
		return level
	var config: ConfigFile = ConfigFile.new()
	if config.load(CHARACTER_SAVE_PATH) == OK:
		return maxi(1, int(config.get_value("jugador", "nivel", 1)))
	return 1


func _load_language() -> void:
	current_language = "es"
	var game_ui: Node = get_node_or_null("/root/GameUI")
	if is_instance_valid(game_ui) and _object_has_property(game_ui, "current_language"):
		current_language = str(game_ui.get("current_language")).to_lower().strip_edges()
	else:
		var config: ConfigFile = ConfigFile.new()
		if config.load(SETTINGS_PATH) == OK:
			current_language = (
				str(config.get_value("general", "idioma", "es")).to_lower().strip_edges()
			)
	if current_language != "en":
		current_language = "es"


func _text(key: String) -> String:
	var spanish: Dictionary = TRANSLATIONS["es"]
	var table: Dictionary = TRANSLATIONS.get(current_language, spanish)
	if table.has(key):
		return str(table[key])
	if spanish.has(key):
		return str(spanish[key])
	return key


func _skill_title(definition: Dictionary) -> String:
	var key: String = "title_en" if current_language == "en" else "title_es"
	return str(definition.get(key, definition.get("id", "")))


func _skill_description(definition: Dictionary) -> String:
	var key: String = "desc_en" if current_language == "en" else "desc_es"
	return str(definition.get(key, ""))


func _skill_effect_text(definition: Dictionary) -> String:
	var key: String = "effect_en" if current_language == "en" else "effect_es"
	return str(definition.get(key, ""))


# =============================================================================
# VENTANA E INTERFAZ
# =============================================================================


func _prepare_native_window_support() -> void:
	# El juego principal mide solo 900x240. Si Godot incrusta las subventanas,
	# el árbol de 1320x990 queda recortado dentro de esa franja y parece
	# abrirse/cerrarse. Forzamos una ventana real del sistema operativo.
	ProjectSettings.set_setting(
		"display/window/per_pixel_transparency/allowed",
		true
	)

	var root_viewport: Viewport = get_viewport()
	if root_viewport != null:
		root_viewport.gui_embed_subwindows = false


func _build_window() -> void:
	skill_window = Window.new()

	# Window nace visible por defecto. force_native no puede cambiarse mientras
	# una ventana está mostrada, así que debe ocultarse antes de configurar nada.
	skill_window.visible = false
	skill_window.force_native = true

	skill_window.name = "VentanaArbolHabilidades"
	skill_window.title = _text("window_title")
	skill_window.size = skill_window_size
	skill_window.min_size = Vector2i(900, 675)
	skill_window.unresizable = false
	skill_window.borderless = true
	skill_window.transparent = true
	skill_window.transparent_bg = true
	skill_window.exclusive = false
	skill_window.transient = false
	skill_window.always_on_top = keep_always_on_top
	skill_window.close_requested.connect(close_skill_tree)
	skill_window.size_changed.connect(_fit_design_to_window)
	add_child(skill_window)

	window_root = Control.new()
	window_root.name = "WindowRoot"
	window_root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	window_root.mouse_filter = Control.MOUSE_FILTER_STOP
	skill_window.add_child(window_root)

	design_root = Control.new()
	design_root.name = "DesignRoot"
	design_root.position = Vector2.ZERO
	design_root.size = REFERENCE_SIZE
	design_root.mouse_filter = Control.MOUSE_FILTER_PASS
	window_root.add_child(design_root)

	background_rect = TextureRect.new()
	background_rect.name = "FondoArbol"
	background_rect.position = Vector2.ZERO
	background_rect.size = REFERENCE_SIZE
	background_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	background_rect.stretch_mode = TextureRect.STRETCH_SCALE
	background_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	background_rect.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	if ResourceLoader.exists(skill_tree_background_path):
		background_rect.texture = load(skill_tree_background_path) as Texture2D
	else:
		push_warning("No se encontró el fondo del árbol: " + skill_tree_background_path)
	design_root.add_child(background_rect)

	_build_twinkling_stars()
	_build_titles_and_panels()
	_build_skill_nodes()
	_build_top_actions()
	_build_drag_surface()
	_fit_design_to_window()


func _build_titles_and_panels() -> void:
	title_label = _create_label(
		design_root,
		"",
		Vector2(137, 21),
		Vector2(770, 42),
		27,
		HORIZONTAL_ALIGNMENT_CENTER,
		Color("#FFE4A1")
	)
	title_label.add_theme_constant_override("outline_size", 5)

	subtitle_label = _create_label(
		design_root,
		"",
		Vector2(138, -32),
		Vector2(790, 32),
		13,
		HORIZONTAL_ALIGNMENT_CENTER,
		Color("#D9C9AA")
	)

	points_label = _create_label(
		design_root,
		"",
		Vector2(61, 112),
		Vector2(235, 38),
		14,
		HORIZONTAL_ALIGNMENT_CENTER,
		Color("#E9C97B")
	)
	var points_value_label: Label = _create_label(
		design_root,
		"0",
		Vector2(59, 125),
		Vector2(220, 74),
		48,
		HORIZONTAL_ALIGNMENT_CENTER,
		Color("#7EF2B8")
	)
	points_value_label.name = "PointsValue"
	points_value_label.add_theme_constant_override("outline_size", 5)
	points_label.set_meta("value_label", points_value_label)

	level_label = _create_label(
		design_root,
		"",
		Vector2(48, 213),
		Vector2(112, 34),
		14,
		HORIZONTAL_ALIGNMENT_CENTER,
		Color("#F0E5D0")
	)
	spent_label = _create_label(
		design_root,
		"",
		Vector2(160, 210),
		Vector2(123, 34),
		12,
		HORIZONTAL_ALIGNMENT_CENTER,
		Color("#BDB4A6")
	)

	summary_title_label = _create_label(
		design_root,
		"",
		Vector2(57, 399),
		Vector2(225, 34),
		15,
		HORIZONTAL_ALIGNMENT_CENTER,
		Color("#E9C97B")
	)
	summary_label = _create_label(
		design_root,
		"",
		Vector2(53, 439),
		Vector2(215, 170),
		12,
		HORIZONTAL_ALIGNMENT_LEFT,
		Color("#E8E2D7")
	)
	summary_label.vertical_alignment = VERTICAL_ALIGNMENT_TOP

	tokens_label = _create_label(
		design_root,
		"",
		Vector2(37, 644),
		Vector2(235, 30),
		12,
		HORIZONTAL_ALIGNMENT_CENTER,
		Color("#66EAF2")
	)
	potions_label = _create_label(
		design_root,
		"",
		Vector2(38, 675),
		Vector2(235, 28),
		11,
		HORIZONTAL_ALIGNMENT_CENTER,
		Color("#D99AFF")
	)
	status_label = _create_label(
		design_root,
		"",
		Vector2(39, 710),
		Vector2(230, 34),
		10,
		HORIZONTAL_ALIGNMENT_CENTER,
		Color("#D8D0C3")
	)
	status_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART

	lore_label = _create_label(
		design_root,
		"",
		Vector2(43, 790),
		Vector2(230, 82),
		11,
		HORIZONTAL_ALIGNMENT_CENTER,
		Color("#BEB3A2")
	)
	lore_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	lore_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER

	reset_button = Button.new()
	reset_button.name = "ResetTreeButton"
	reset_button.position = Vector2(55, 890)
	reset_button.size = Vector2(205, 45)
	reset_button.focus_mode = Control.FOCUS_NONE
	reset_button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	reset_button.add_theme_font_size_override("font_size", 11)
	reset_button.add_theme_stylebox_override(
		"normal", _make_style(Color(0.10, 0.035, 0.025, 0.92), Color("#9E5A39"), 1, 6)
	)
	reset_button.add_theme_stylebox_override(
		"hover", _make_style(Color(0.20, 0.055, 0.035, 0.98), Color("#FFB56B"), 2, 6)
	)
	reset_button.add_theme_stylebox_override(
		"pressed", _make_style(Color(0.07, 0.02, 0.015, 1.0), Color("#FFE09A"), 2, 6)
	)
	reset_button.pressed.connect(_on_reset_button_pressed)
	design_root.add_child(reset_button)

	selected_header_label = _create_label(
		design_root,
		"",
		Vector2(1220, 156),
		Vector2(185, 31),
		13,
		HORIZONTAL_ALIGNMENT_CENTER,
		Color("#E9C97B")
	)
	selected_icon_rect = TextureRect.new()
	selected_icon_rect.name = "SelectedIcon"
	selected_icon_rect.position = Vector2(1238, 206)
	selected_icon_rect.size = Vector2(78, 78)
	selected_icon_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	selected_icon_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	selected_icon_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	selected_icon_rect.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	design_root.add_child(selected_icon_rect)

	selected_title_label = _create_label(
		design_root,
		"",
		Vector2(1225, 286),
		Vector2(182, 54),
		17,
		HORIZONTAL_ALIGNMENT_CENTER,
		Color("#FFF0C3")
	)
	selected_title_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART

	selected_rank_label = _create_label(
		design_root,
		"",
		Vector2(1221, 339),
		Vector2(174, 27),
		12,
		HORIZONTAL_ALIGNMENT_CENTER,
		Color("#7EF2B8")
	)

	selected_description_label = _create_label(
		design_root,
		"",
		Vector2(1226, 379),
		Vector2(174, 92),
		11,
		HORIZONTAL_ALIGNMENT_LEFT,
		Color("#DDD6CB")
	)
	selected_description_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	selected_description_label.vertical_alignment = VERTICAL_ALIGNMENT_TOP

	selected_effect_title_label = _create_label(
		design_root,
		"",
		Vector2(1223, 468),
		Vector2(174, 24),
		10,
		HORIZONTAL_ALIGNMENT_LEFT,
		Color("#E9C97B")
	)
	selected_effect_label = _create_label(
		design_root,
		"",
		Vector2(1228, 498),
		Vector2(174, 75),
		11,
		HORIZONTAL_ALIGNMENT_LEFT,
		Color("#8CEFC4")
	)
	selected_effect_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	selected_effect_label.vertical_alignment = VERTICAL_ALIGNMENT_TOP

	selected_requirements_title_label = _create_label(
		design_root,
		"",
		Vector2(1234, 651),
		Vector2(180, 22),
		10,
		HORIZONTAL_ALIGNMENT_LEFT,
		Color("#E9C97B")
	)
	selected_requirements_label = _create_label(
		design_root,
		"",
		Vector2(1217, 672),
		Vector2(180, 62),
		10,
		HORIZONTAL_ALIGNMENT_LEFT,
		Color("#D4C8B9")
	)
	selected_requirements_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	selected_requirements_label.vertical_alignment = VERTICAL_ALIGNMENT_TOP

	purchase_button = Button.new()
	purchase_button.name = "PurchaseSkillButton"
	purchase_button.position = Vector2(1224, 738)
	purchase_button.size = Vector2(172, 38)
	purchase_button.focus_mode = Control.FOCUS_NONE
	purchase_button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	purchase_button.add_theme_font_size_override("font_size", 12)
	purchase_button.add_theme_stylebox_override(
		"normal", _make_style(Color(0.04, 0.19, 0.12, 0.95), Color("#4BD89B"), 1, 6)
	)
	purchase_button.add_theme_stylebox_override(
		"hover", _make_style(Color(0.06, 0.31, 0.19, 1.0), Color("#A4FFD3"), 2, 6)
	)
	purchase_button.add_theme_stylebox_override(
		"pressed", _make_style(Color(0.025, 0.13, 0.08, 1.0), Color("#FFE7A3"), 2, 6)
	)
	purchase_button.add_theme_stylebox_override(
		"disabled", _make_style(Color(0.045, 0.05, 0.06, 0.82), Color("#5B5D62"), 1, 6)
	)
	purchase_button.pressed.connect(_purchase_selected_skill)
	design_root.add_child(purchase_button)

	legend_title_label = _create_label(
		design_root,
		"",
		Vector2(1227, 823),
		Vector2(170, 28),
		13,
		HORIZONTAL_ALIGNMENT_CENTER,
		Color("#E9C97B")
	)
	legend_label = _create_label(
		design_root,
		"",
		Vector2(1226, 864),
		Vector2(170, 118),
		11,
		HORIZONTAL_ALIGNMENT_LEFT,
		Color("#E8E1D5")
	)
	legend_label.vertical_alignment = VERTICAL_ALIGNMENT_TOP

	footer_label = _create_label(
		design_root,
		"",
		Vector2(456, 1033),
		Vector2(500, 30),
		12,
		HORIZONTAL_ALIGNMENT_CENTER,
		Color("#BFA969")
	)


func _build_skill_nodes() -> void:
	node_buttons.clear()
	node_icons.clear()
	node_rank_badges.clear()

	for raw_definition: Dictionary in skill_definitions:
		var definition: Dictionary = raw_definition
		var skill_id: String = str(definition.get("id", ""))
		var center: Vector2 = definition.get("center", Vector2.ZERO)
		var radius: float = float(definition.get("radius", 22.0))
		var branch: String = str(definition.get("branch", "core"))
		var button: Button = Button.new()
		button.name = "Skill_" + skill_id
		button.position = center - Vector2(radius, radius)
		button.size = Vector2(radius * 2.0, radius * 2.0)
		button.focus_mode = Control.FOCUS_NONE
		button.mouse_filter = Control.MOUSE_FILTER_STOP
		button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		button.clip_contents = false
		button.tooltip_text = _skill_title(definition)
		button.add_theme_stylebox_override("normal", _node_style(branch, false, false, false))
		button.add_theme_stylebox_override("hover", _node_style(branch, false, true, false))
		button.add_theme_stylebox_override("pressed", _node_style(branch, true, true, false))
		button.pressed.connect(_on_skill_node_pressed.bind(skill_id))
		design_root.add_child(button)
		node_buttons[skill_id] = button

		var icon_rect: TextureRect = TextureRect.new()
		icon_rect.name = "Icon"
		var icon_margin: float = radius * 0.20
		if skill_id == "core":
			icon_margin = radius * 0.16
		icon_rect.position = Vector2(icon_margin, icon_margin)
		icon_rect.size = button.size - Vector2(icon_margin * 2.0, icon_margin * 2.0)
		icon_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		icon_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		icon_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
		icon_rect.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		var icon_path: String = str(definition.get("icon", ""))
		if ResourceLoader.exists(icon_path):
			icon_rect.texture = load(icon_path) as Texture2D
		button.add_child(icon_rect)
		icon_rect.visible = skill_id != "core"
		node_icons[skill_id] = icon_rect

		var badge: Label = Label.new()
		badge.name = "RankBadge"
		badge.position = Vector2(button.size.x - 20.0, button.size.y - 17.0)
		badge.size = Vector2(22, 18)
		badge.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		badge.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		badge.mouse_filter = Control.MOUSE_FILTER_IGNORE
		badge.add_theme_font_size_override("font_size", 8)
		badge.add_theme_color_override("font_color", Color("#FFF3C5"))
		badge.add_theme_color_override("font_outline_color", Color(0, 0, 0, 1))
		badge.add_theme_constant_override("outline_size", 3)
		button.add_child(badge)
		node_rank_badges[skill_id] = badge


func _build_twinkling_stars() -> void:
	twinkle_stars.clear()

	var star_data: Array[Dictionary] = [
		{"position": Vector2(322, 92), "pixel": 2, "color": Color("#FFE7A0"), "phase": 0.10, "speed": 2.10},
		{"position": Vector2(1128, 94), "pixel": 2, "color": Color("#8BEFFF"), "phase": 1.70, "speed": 1.65},
		{"position": Vector2(380, 164), "pixel": 1, "color": Color("#FFF2B8"), "phase": 2.50, "speed": 2.55},
		{"position": Vector2(1068, 178), "pixel": 1, "color": Color("#A8F6FF"), "phase": 0.80, "speed": 2.35},
		{"position": Vector2(315, 705), "pixel": 2, "color": Color("#D9A8FF"), "phase": 3.10, "speed": 1.85},
		{"position": Vector2(1135, 690), "pixel": 2, "color": Color("#FFD36F"), "phase": 4.20, "speed": 2.00},
		{"position": Vector2(402, 884), "pixel": 1, "color": Color("#A7FFF0"), "phase": 5.10, "speed": 2.70},
		{"position": Vector2(1052, 874), "pixel": 1, "color": Color("#FFE6A4"), "phase": 2.20, "speed": 2.45},
		{"position": Vector2(262, 1020), "pixel": 2, "color": Color("#FFD76E"), "phase": 0.45, "speed": 1.75},
		{"position": Vector2(997, 1020), "pixel": 2, "color": Color("#FFD76E"), "phase": 2.95, "speed": 1.90},
		{"position": Vector2(1125, 1020), "pixel": 2, "color": Color("#FFD76E"), "phase": 4.75, "speed": 1.70},
		{"position": Vector2(702, 112), "pixel": 1, "color": Color("#FFFFFF"), "phase": 1.25, "speed": 2.85},
		{"position": Vector2(752, 650), "pixel": 1, "color": Color("#B8FFF6"), "phase": 3.80, "speed": 2.20},
		{"position": Vector2(596, 735), "pixel": 1, "color": Color("#FFF0A8"), "phase": 5.70, "speed": 2.50}
	]

	for index: int in range(star_data.size()):
		var data: Dictionary = star_data[index]
		var star: Control = _create_pixel_star(
			Vector2(data.get("position", Vector2.ZERO)),
			int(data.get("pixel", 1)),
			data.get("color", Color.WHITE) as Color
		)
		star.name = "EstrellaPixel_%02d" % index
		star.set_meta("twinkle_phase", float(data.get("phase", 0.0)))
		star.set_meta("twinkle_speed", float(data.get("speed", 2.0)))
		star.set_meta("twinkle_index", index)
		design_root.add_child(star)
		twinkle_stars.append(star)


func _create_pixel_star(
	star_position: Vector2,
	pixel_size: int,
	star_color: Color
) -> Control:
	var safe_pixel: int = maxi(1, pixel_size)
	var extent: int = safe_pixel * 7

	var star: Control = Control.new()
	star.position = star_position.round()
	star.size = Vector2(extent, extent)
	star.mouse_filter = Control.MOUSE_FILTER_IGNORE
	star.pivot_offset = star.size * 0.5
	star.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST

	var horizontal: ColorRect = ColorRect.new()
	horizontal.position = Vector2(0, safe_pixel * 3)
	horizontal.size = Vector2(extent, safe_pixel)
	horizontal.color = Color(star_color.r, star_color.g, star_color.b, 0.72)
	horizontal.mouse_filter = Control.MOUSE_FILTER_IGNORE
	star.add_child(horizontal)

	var vertical: ColorRect = ColorRect.new()
	vertical.position = Vector2(safe_pixel * 3, 0)
	vertical.size = Vector2(safe_pixel, extent)
	vertical.color = Color(star_color.r, star_color.g, star_color.b, 0.72)
	vertical.mouse_filter = Control.MOUSE_FILTER_IGNORE
	star.add_child(vertical)

	var core: ColorRect = ColorRect.new()
	core.position = Vector2(safe_pixel * 2, safe_pixel * 2)
	core.size = Vector2(safe_pixel * 3, safe_pixel * 3)
	core.color = star_color
	core.mouse_filter = Control.MOUSE_FILTER_IGNORE
	star.add_child(core)

	var center: ColorRect = ColorRect.new()
	center.position = Vector2(safe_pixel * 3, safe_pixel * 3)
	center.size = Vector2(safe_pixel, safe_pixel)
	center.color = Color.WHITE
	center.mouse_filter = Control.MOUSE_FILTER_IGNORE
	star.add_child(center)

	return star


func _animate_twinkle_stars() -> void:
	for index: int in range(twinkle_stars.size()):
		var star: Control = twinkle_stars[index]
		if not is_instance_valid(star):
			continue

		var phase: float = float(star.get_meta("twinkle_phase", 0.0))
		var speed: float = float(star.get_meta("twinkle_speed", 2.0))
		var wave: float = (sin(animation_clock * speed + phase) + 1.0) * 0.5
		var sparkle: float = wave * wave
		var alpha: float = lerpf(0.16, 1.0, sparkle)
		var pulse: float = lerpf(0.82, 1.18, sparkle)

		star.modulate.a = alpha
		star.scale = Vector2.ONE * pulse


func _build_top_actions() -> void:
	var definitions: Array[Dictionary] = [
		{
			"name": "RefreshButton",
			"x": 1253.0,
			"icon": ICON_REFRESH,
			"tooltip": "refresh",
			"method": Callable(self, "_on_refresh_pressed")
		},
		{
			"name": "ForgeButton",
			"x": 1296.0,
			"icon": ICON_FORGE,
			"tooltip": "forge",
			"method": Callable(self, "_on_forge_pressed")
		},
		{
			"name": "InventoryButton",
			"x": 1339.0,
			"icon": ICON_INVENTORY,
			"tooltip": "inventory",
			"method": Callable(self, "_on_inventory_pressed")
		},
		{
			"name": "CloseButton",
			"x": 1382.0,
			"icon": ICON_CLOSE,
			"tooltip": "close",
			"method": Callable(self, "close_skill_tree")
		}
	]
	for raw_data: Dictionary in definitions:
		var button: Button = _create_icon_action_button(
			design_root,
			str(raw_data.get("name", "Action")),
			Vector2(float(raw_data.get("x", 0.0)), 16.0),
			Vector2(38, 38),
			str(raw_data.get("icon", "")),
			str(raw_data.get("tooltip", "")) == "close"
		)
		button.set_meta("tooltip_key", str(raw_data.get("tooltip", "")))
		var callback: Callable = raw_data.get("method", Callable())
		if callback.is_valid():
			button.pressed.connect(callback)


func _build_drag_surface() -> void:
	drag_surface = Control.new()
	drag_surface.name = "DragSurface"
	drag_surface.position = Vector2(0, 0)
	drag_surface.size = Vector2(1195, drag_header_height)
	drag_surface.mouse_filter = Control.MOUSE_FILTER_PASS
	drag_surface.gui_input.connect(_on_drag_surface_gui_input)
	design_root.add_child(drag_surface)
	design_root.move_child(drag_surface, design_root.get_child_count() - 1)


func _fit_window_to_screen() -> void:
	if not is_instance_valid(skill_window):
		return
	var screen_index: int = DisplayServer.window_get_current_screen()
	var usable: Rect2i = DisplayServer.screen_get_usable_rect(screen_index)
	var max_size: Vector2i = Vector2i(
		maxi(900, int(float(usable.size.x) * 0.94)), maxi(675, int(float(usable.size.y) * 0.94))
	)
	var target: Vector2i = Vector2i(
		mini(skill_window_size.x, max_size.x), mini(skill_window_size.y, max_size.y)
	)
	skill_window.size = target
	var centered: Vector2i = (
		usable.position
		+ Vector2i(int((usable.size.x - target.x) / 2.0), int((usable.size.y - target.y) / 2.0))
	)
	skill_window.position = centered
	_fit_design_to_window()


func _fit_design_to_window() -> void:
	if not is_instance_valid(skill_window) or not is_instance_valid(design_root):
		return
	# WindowRoot usa PRESET_FULL_RECT y ya hereda automáticamente el tamaño
	# de la ventana. No escribimos size para evitar el aviso de anchors.
	var available: Vector2 = Vector2(skill_window.size)
	var scale_factor: float = minf(available.x / REFERENCE_SIZE.x, available.y / REFERENCE_SIZE.y)
	scale_factor = maxf(scale_factor, 0.1)
	design_root.scale = Vector2.ONE * scale_factor
	design_root.position = ((available - REFERENCE_SIZE * scale_factor) * 0.5).round()


func _apply_native_window_flags() -> void:
	if not is_instance_valid(skill_window):
		return

	# Las propiedades de Window son suficientes. No usamos window_set_flag()
	# porque una Window recién creada puede no estar registrada todavía en
	# DisplayServer y producir: Condition "!windows.has(p_window)" is true.
	skill_window.always_on_top = true
	skill_window.transparent = true
	skill_window.transparent_bg = true


func _on_drag_surface_gui_input(event: InputEvent) -> void:
	if not allow_window_drag or not is_instance_valid(skill_window):
		return
	if event is InputEventMouseButton:
		var mouse_button: InputEventMouseButton = event as InputEventMouseButton
		if mouse_button.button_index != MOUSE_BUTTON_LEFT:
			return
		if mouse_button.pressed:
			dragging_window = true
			drag_mouse_origin = DisplayServer.mouse_get_position()
			drag_window_origin = skill_window.position
		else:
			dragging_window = false
	elif event is InputEventMouseMotion and dragging_window:
		skill_window.position = (
			drag_window_origin + DisplayServer.mouse_get_position() - drag_mouse_origin
		)


# =============================================================================
# BOTÓN SUPERIOR DEL JUEGO
# =============================================================================


func _mount_top_button_when_ready() -> void:
	# Main.gd es el único propietario del clic del botón superior.
	# Este módulo solo espera a que exista para retirar cualquier conexión
	# antigua que pudiera provocar: abrir -> cerrar en el mismo clic.
	for _attempt: int in range(240):
		_refresh_references()
		if is_instance_valid(main_interface_root):
			_mount_top_button()
			var mounted: Node = main_interface_root.find_child(
				"BotonHabilidades",
				true,
				false
			)
			if mounted is Button:
				return
		await get_tree().process_frame

	push_warning(
		(
			"ArbolHabilidadesUI no encontró BotonHabilidades. "
			+ "La tecla H seguirá disponible."
		)
	)


func _mount_top_button() -> void:
	_refresh_references()
	if not is_instance_valid(main_interface_root):
		return

	var existing: Node = main_interface_root.find_child(
		"BotonHabilidades",
		true,
		false
	)
	if not (existing is Button):
		return

	var managed_button: Button = existing as Button
	fallback_top_button = managed_button
	managed_button.tooltip_text = _text("open_tree")
	managed_button.mouse_filter = Control.MOUSE_FILTER_STOP
	managed_button.disabled = false

	# Nunca conectamos toggle_skill_tree() aquí. Main.gd ya controla este botón.
	# También limpiamos una conexión antigua si la escena venía de una versión
	# anterior del script.
	var local_toggle: Callable = Callable(self, "toggle_skill_tree")
	if managed_button.pressed.is_connected(local_toggle):
		managed_button.pressed.disconnect(local_toggle)


# =============================================================================
# INTERACCIÓN DE NODOS
# =============================================================================


func _on_skill_node_pressed(skill_id: String) -> void:
	if not skill_definitions_by_id.has(skill_id):
		return
	selected_skill_id = skill_id
	_refresh_skill_nodes()
	_refresh_selected_panel()


func _purchase_selected_skill() -> void:
	if not skill_definitions_by_id.has(selected_skill_id):
		return
	var definition: Dictionary = skill_definitions_by_id[selected_skill_id]
	var validation: Dictionary = _validate_purchase(definition)
	if not bool(validation.get("ok", false)):
		_set_status(str(validation.get("message", _text("locked"))), Color("#FF9A87"))
		return

	var current_rank: int = int(skill_ranks.get(selected_skill_id, 0))
	var cost: int = _rank_cost(definition, current_rank)
	skill_ranks[selected_skill_id] = current_rank + 1

	if selected_skill_id == "unlock_1" or selected_skill_id == "unlock_2":
		character_tokens += 1
		character_tokens_changed.emit(character_tokens)

	current_effects = _calculate_effects()
	_save_progress()
	_refresh_all()
	_notify_main_effects()
	_notify_inventory_character_progress()
	_set_status(_text("purchased") % _skill_title(definition), Color("#7EF2B8"))


func _validate_purchase(definition: Dictionary) -> Dictionary:
	var skill_id: String = str(definition.get("id", ""))
	var current_rank: int = int(skill_ranks.get(skill_id, 0))
	var max_rank: int = int(definition.get("max_rank", 1))

	if bool(definition.get("auto_unlocked", false)):
		return {"ok": false, "message": _text("core_ready")}
	if current_rank >= max_rank:
		return {"ok": false, "message": _text("maxed")}

	var level: int = _get_player_level()
	var minimum_level: int = int(definition.get("min_level", 1))
	if level < minimum_level:
		return {"ok": false, "message": _text("requires_level") % minimum_level}

	var requirements: Array = definition.get("requires", [])
	for raw_requirement: Variant in requirements:
		if not (raw_requirement is Dictionary):
			continue
		var requirement: Dictionary = raw_requirement
		var required_id: String = str(requirement.get("id", ""))
		var required_rank: int = int(requirement.get("rank", 1))
		var owned_rank: int = int(
			skill_ranks.get(required_id, preserved_unknown_ranks.get(required_id, 0))
		)
		if owned_rank < required_rank:
			var required_name: String = required_id
			if skill_definitions_by_id.has(required_id):
				required_name = _skill_title(skill_definitions_by_id[required_id])
			return {
				"ok": false, "message": _text("requires_skill") % [required_name, required_rank]
			}

	var cost: int = _rank_cost(definition, current_rank)
	if _get_available_points() < cost:
		return {"ok": false, "message": _text("not_enough")}
	return {"ok": true, "message": ""}


func _rank_cost(definition: Dictionary, rank_before_purchase: int) -> int:
	return maxi(
		0,
		(
			int(definition.get("base_cost", 1))
			+ int(definition.get("cost_growth", 0)) * rank_before_purchase
		)
	)


func _get_available_points() -> int:
	return maxi(0, _get_player_level() + extra_skill_points - _get_total_spent_points())


func _get_total_spent_points() -> int:
	var spent: int = 0
	for raw_definition: Dictionary in skill_definitions:
		var definition: Dictionary = raw_definition
		var skill_id: String = str(definition.get("id", ""))
		if skill_id == "core":
			continue
		var rank: int = clampi(
			int(skill_ranks.get(skill_id, 0)), 0, int(definition.get("max_rank", 1))
		)
		for purchased_rank: int in range(rank):
			spent += _rank_cost(definition, purchased_rank)

	for legacy_id: String in LEGACY_COMPATIBILITY_COSTS.keys():
		if skill_definitions_by_id.has(legacy_id):
			continue
		var legacy_data: Dictionary = LEGACY_COMPATIBILITY_COSTS[legacy_id]
		var legacy_rank: int = clampi(
			int(preserved_unknown_ranks.get(legacy_id, 0)), 0, int(legacy_data.get("max_rank", 0))
		)
		for purchased_rank: int in range(legacy_rank):
			spent += (
				int(legacy_data.get("base_cost", 0))
				+ int(legacy_data.get("cost_growth", 0)) * purchased_rank
			)
	return spent


func _refresh_all() -> void:
	current_effects = _calculate_effects()
	_refresh_header_only()
	_refresh_skill_nodes()
	_refresh_selected_panel()
	_refresh_summary()
	_refresh_language()
	_apply_texture_filtering()
	_refresh_reset_button()


func _refresh_header_only() -> void:
	var available: int = _get_available_points()
	var spent: int = _get_total_spent_points()
	var level: int = _get_player_level()

	if is_instance_valid(points_label):
		points_label.text = _text("points")
		var value_candidate: Variant = points_label.get_meta("value_label", null)
		if value_candidate is Label:
			(value_candidate as Label).text = str(available)
	if is_instance_valid(level_label):
		level_label.text = _text("level") % level
	if is_instance_valid(spent_label):
		spent_label.text = _text("spent") % spent
	if is_instance_valid(tokens_label):
		tokens_label.text = _text("tokens") % character_tokens
	if is_instance_valid(potions_label):
		potions_label.text = _text("potions") % [potions_today, maximum_daily_potions]


func _refresh_skill_nodes() -> void:
	for raw_definition: Dictionary in skill_definitions:
		var definition: Dictionary = raw_definition
		var skill_id: String = str(definition.get("id", ""))
		var branch: String = str(definition.get("branch", "core"))
		var button: Button = node_buttons.get(skill_id) as Button
		if not is_instance_valid(button):
			continue

		var rank: int = int(skill_ranks.get(skill_id, 0))
		var max_rank: int = int(definition.get("max_rank", 1))
		var is_selected: bool = skill_id == selected_skill_id
		var validation: Dictionary = _validate_purchase(definition)
		var can_purchase: bool = bool(validation.get("ok", false))
		var mastered: bool = rank >= max_rank
		var owned: bool = rank > 0

		button.add_theme_stylebox_override(
			"normal", _node_style(branch, is_selected, false, mastered)
		)
		button.add_theme_stylebox_override("hover", _node_style(branch, true, true, mastered))
		button.add_theme_stylebox_override("pressed", _node_style(branch, true, true, mastered))
		button.tooltip_text = "%s\n%s" % [_skill_title(definition), _skill_effect_text(definition)]

		var icon_rect: TextureRect = node_icons.get(skill_id) as TextureRect
		if is_instance_valid(icon_rect):
			if mastered:
				icon_rect.modulate = Color(1.15, 1.15, 1.05, 1.0)
			elif owned:
				icon_rect.modulate = Color.WHITE
			elif can_purchase:
				icon_rect.modulate = Color(0.92, 0.92, 0.92, 0.92)
			else:
				icon_rect.modulate = Color(0.34, 0.36, 0.39, 0.72)

		var badge: Label = node_rank_badges.get(skill_id) as Label
		if is_instance_valid(badge):
			badge.visible = show_rank_badges and skill_id != "core"
			badge.text = "%d/%d" % [rank, max_rank]
			badge.modulate = Color.WHITE if owned or can_purchase else Color(0.55, 0.55, 0.55, 0.8)


func _refresh_selected_panel() -> void:
	if not skill_definitions_by_id.has(selected_skill_id):
		selected_skill_id = "core"
	var definition: Dictionary = skill_definitions_by_id[selected_skill_id]
	var rank: int = int(skill_ranks.get(selected_skill_id, 0))
	var max_rank: int = int(definition.get("max_rank", 1))
	var cost: int = _rank_cost(definition, rank)
	var validation: Dictionary = _validate_purchase(definition)

	if is_instance_valid(selected_title_label):
		selected_title_label.text = _skill_title(definition)
	if is_instance_valid(selected_rank_label):
		selected_rank_label.text = _text("rank") % [rank, max_rank]
	if is_instance_valid(selected_description_label):
		selected_description_label.text = _skill_description(definition)
	if is_instance_valid(selected_effect_label):
		selected_effect_label.text = _skill_effect_text(definition)
	if is_instance_valid(selected_icon_rect):
		var icon_path: String = str(definition.get("icon", ""))
		selected_icon_rect.texture = (
			load(icon_path) as Texture2D if ResourceLoader.exists(icon_path) else null
		)
		selected_icon_rect.modulate = BRANCH_COLORS.get(
			str(definition.get("branch", "core")), Color.WHITE
		)

	if is_instance_valid(selected_requirements_label):
		selected_requirements_label.text = _requirements_text(definition)

	if is_instance_valid(purchase_button):
		if bool(definition.get("auto_unlocked", false)):
			purchase_button.text = _text("maxed")
			purchase_button.disabled = true
		elif rank >= max_rank:
			purchase_button.text = _text("maxed")
			purchase_button.disabled = true
		else:
			purchase_button.text = "%s · %d" % [_text("unlock"), cost]
			purchase_button.disabled = not bool(validation.get("ok", false))
			purchase_button.tooltip_text = str(validation.get("message", ""))


func _requirements_text(definition: Dictionary) -> String:
	var lines: Array[String] = []
	var minimum_level: int = int(definition.get("min_level", 1))
	if minimum_level > 1:
		lines.append(_text("requires_level") % minimum_level)
	var requirements: Array = definition.get("requires", [])
	for raw_requirement: Variant in requirements:
		if not (raw_requirement is Dictionary):
			continue
		var requirement: Dictionary = raw_requirement
		var required_id: String = str(requirement.get("id", ""))
		var required_rank: int = int(requirement.get("rank", 1))
		var required_name: String = required_id
		if skill_definitions_by_id.has(required_id):
			required_name = _skill_title(skill_definitions_by_id[required_id])
		lines.append(_text("requires_skill") % [required_name, required_rank])
	if lines.is_empty():
		return "—"
	return "\n".join(lines)


func _refresh_summary() -> void:
	if not is_instance_valid(summary_label):
		return
	var effects: Dictionary = current_effects
	if current_language == "en":
		summary_label.text = (
			"ATK   +%.0f%%\n" % float(effects.get("damage_percent", 0.0))
			+ "HP     +%.0f%%\n" % float(effects.get("health_percent", 0.0))
			+ "DEF   +%d\n" % int(effects.get("defense_flat", 0))
			+ "SPD   +%d\n" % int(effects.get("speed_flat", 0))
			+ "CRIT  +%.1f%%\n" % float(effects.get("critical_chance", 0.0))
			+ "GOLD  +%.0f%%\n" % float(effects.get("gold_percent", 0.0))
			+ "EXP   +%.0f%%\n" % float(effects.get("xp_percent", 0.0))
			+ "LUCK  +%.0f%%" % float(effects.get("loot_luck_percent", 0.0))
		)
	else:
		summary_label.text = (
			"ATQ   +%.0f%%\n" % float(effects.get("damage_percent", 0.0))
			+ "VID    +%.0f%%\n" % float(effects.get("health_percent", 0.0))
			+ "DEF   +%d\n" % int(effects.get("defense_flat", 0))
			+ "VEL   +%d\n" % int(effects.get("speed_flat", 0))
			+ "CRIT  +%.1f%%\n" % float(effects.get("critical_chance", 0.0))
			+ "ORO   +%.0f%%\n" % float(effects.get("gold_percent", 0.0))
			+ "EXP   +%.0f%%\n" % float(effects.get("xp_percent", 0.0))
			+ "SUERTE +%.0f%%" % float(effects.get("loot_luck_percent", 0.0))
		)

	if is_instance_valid(legend_label):
		legend_label.text = (
			"◆ %s\n" % _text("branch_offense")
			+ "◆ %s\n" % _text("branch_defense")
			+ "◆ %s\n" % _text("branch_fortune")
			+ "◆ %s\n" % _text("branch_alchemy")
			+ "◆ %s\n" % _text("branch_progression")
			+ "◆ %s" % _text("branch_legacy")
		)


func _refresh_language() -> void:
	if is_instance_valid(skill_window):
		skill_window.title = _text("window_title")
	if is_instance_valid(fallback_top_button):
		fallback_top_button.tooltip_text = _text("open_tree")
	if is_instance_valid(title_label):
		title_label.text = _text("title")
	if is_instance_valid(subtitle_label):
		subtitle_label.text = _text("subtitle")
	if is_instance_valid(summary_title_label):
		summary_title_label.text = _text("summary")
	if is_instance_valid(selected_header_label):
		selected_header_label.text = _text("selected")
	if is_instance_valid(selected_effect_title_label):
		selected_effect_title_label.text = _text("current_effect")
	if is_instance_valid(selected_requirements_title_label):
		selected_requirements_title_label.text = _text("requirements")
	if is_instance_valid(legend_title_label):
		legend_title_label.text = _text("legend")
	if is_instance_valid(lore_label):
		lore_label.text = _text("lore")
	if is_instance_valid(footer_label):
		footer_label.text = _text("footer")
	if is_instance_valid(design_root):
		for child: Node in design_root.get_children():
			if child is Button and child.has_meta("tooltip_key"):
				(child as Button).tooltip_text = _text(str(child.get_meta("tooltip_key")))

	for raw_definition: Dictionary in skill_definitions:
		var definition: Dictionary = raw_definition
		var skill_id: String = str(definition.get("id", ""))
		var button: Button = node_buttons.get(skill_id) as Button
		if is_instance_valid(button):
			button.tooltip_text = (
				"%s\n%s" % [_skill_title(definition), _skill_effect_text(definition)]
			)

	if is_instance_valid(status_label) and status_label.text.is_empty():
		status_label.text = _text("status_ready")

	_refresh_header_only()
	_refresh_selected_panel()
	_refresh_summary()
	_refresh_reset_button()


func _animate_selected_node() -> void:
	var button: Button = node_buttons.get(selected_skill_id) as Button
	if not is_instance_valid(button):
		return
	var pulse: float = 1.0 + sin(animation_clock * 3.1) * 0.035
	button.scale = Vector2.ONE * pulse
	button.pivot_offset = button.size * 0.5
	for skill_id: String in node_buttons.keys():
		if skill_id == selected_skill_id:
			continue
		var other: Button = node_buttons[skill_id] as Button
		if is_instance_valid(other) and other.scale != Vector2.ONE:
			other.scale = Vector2.ONE


# =============================================================================
# EFECTOS Y COMPATIBILIDAD CON MAIN
# =============================================================================


func _rank(skill_id: String) -> int:
	return int(skill_ranks.get(skill_id, preserved_unknown_ranks.get(skill_id, 0)))


func _calculate_effects() -> Dictionary:
	var effects: Dictionary = {
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

	effects["damage_percent"] = float(
		(
			_rank("damage") * 4
			+ _rank("armor_break") * 3
			+ _rank("attack_fury") * 3
			+ _rank("poison_mastery") * 4
			+ _rank("companion_power") * 2
			+ _rank("legacy_power") * 2
			+ _rank("trinity_bonus") * 6
			+ _rank("war_mastery") * 12
			+ _rank("mastery") * 3
			+ _rank("progress_damage") * 4
			+ _rank("progress_all") * 5
			+ _rank("progress_legend") * 8
			+ _rank("companion_mastery") * 6
		)
	)

	effects["health_percent"] = float(
		(
			_rank("vitality") * 5
			+ _rank("legacy_power") * 2
			+ _rank("trinity_bonus") * 6
			+ _rank("guardian_mastery") * 10
			+ _rank("mastery") * 3
			+ _rank("progress_health") * 4
			+ _rank("progress_all") * 5
			+ _rank("progress_legend") * 8
			+ _rank("companion_mastery") * 6
		)
	)

	effects["defense_flat"] = (
		_rank("defense") * 6
		+ _rank("defense_formation") * 4
		+ _rank("companion_defense") * 4
		+ _rank("legacy_power") * 2
		+ _rank("trinity_bonus") * 8
		+ _rank("guardian_mastery") * 12
		+ _rank("mastery") * 3
		+ _rank("progress_all") * 5
		+ _rank("progress_legend") * 8
		+ _rank("companion_mastery") * 6
	)

	effects["speed_flat"] = (
		_rank("speed") * 5
		+ _rank("war_mastery") * 10
		+ _rank("progress_speed") * 4
		+ _rank("companion_speed") * 3
	)

	effects["critical_chance"] = float(
		(
			_rank("crit") * 2
			+ _rank("companion_crit") * 2
			+ _rank("progress_all") * 3
			+ _rank("trinity_bonus") * 5
		)
	)

	effects["critical_damage_percent"] = float(
		50 + _rank("attack_combo") * 4 + _rank("attack_colossus") * 8
	)

	effects["damage_reduction_percent"] = float(
		_rank("damage_reduction") * 2 + _rank("guardian_mastery") * 5
	)

	effects["gold_percent"] = float(
		(
			_rank("fortune")
			+ _rank("gold") * 6
			+ _rank("treasure") * 4
			+ _rank("fortune_charm") * 2
			+ _rank("fortune_mastery") * 15
			+ _rank("mastery") * 3
			+ _rank("progress_gold") * 5
			+ _rank("progress_legend") * 8
		)
	)

	effects["xp_percent"] = float(
		(
			_rank("fortune")
			+ _rank("xp") * 6
			+ _rank("relic") * 3
			+ _rank("shared_training") * 3
			+ _rank("fortune_charm") * 2
			+ _rank("fortune_mastery") * 15
			+ _rank("mastery") * 3
			+ _rank("progress_xp") * 5
			+ _rank("progress_legend") * 8
		)
	)

	effects["loot_luck_percent"] = float(
		(
			_rank("loot") * 4
			+ _rank("treasure") * 3
			+ _rank("relic") * 6
			+ _rank("fortune_charm") * 2
			+ _rank("fortune_mastery") * 12
		)
	)

	effects["potion_generator"] = _rank("potion") > 0
	effects["potion_power_percent"] = float(
		_rank("alchemy_root") * 5 + _rank("potion_power") * 12 + _rank("alchemy_mastery") * 25
	)
	effects["potion_heal_flat"] = _rank("potion_flat") * 8 + _rank("alchemy_mastery") * 20
	effects["dodge_chance"] = float(_rank("dodge") * 2 + _rank("arcane_smoke") * 1.5)
	effects["block_chance"] = float(_rank("block") * 3)
	effects["lifesteal_percent"] = float(_rank("attack_lifesteal") * 1.5)
	effects["execution_damage_percent"] = float(
		_rank("attack_reach") * 3 + _rank("attack_execution") * 6 + _rank("poison_mastery") * 2
	)
	effects["heal_on_kill"] = (
		_rank("heal_on_kill") * 4 + _rank("companion_heal") * 3 + _rank("recovery") * 4
	)
	effects["shield_on_kill"] = _rank("shield_on_kill") * 18
	effects["low_health_reduction_percent"] = float(_rank("low_health_guard") * 5)
	return effects


func _notify_main_effects() -> void:
	skills_changed.emit(current_effects.duplicate(true))
	_refresh_references()
	if is_instance_valid(main_controller):
		if main_controller.has_method("_refresh_skill_tree_effects"):
			main_controller.call_deferred("_refresh_skill_tree_effects")
		elif main_controller.has_method("_apply_inventory_equipment_effects"):
			main_controller.call_deferred("_apply_inventory_equipment_effects")


func _notify_inventory_character_progress() -> void:
	_refresh_references()
	if (
		is_instance_valid(inventory_ui)
		and inventory_ui.has_method("refresh_character_roster_from_skills")
	):
		inventory_ui.call_deferred("refresh_character_roster_from_skills")


# =============================================================================
# GUARDADO Y MIGRACIÓN
# =============================================================================


func _load_progress() -> void:
	skill_ranks.clear()
	preserved_unknown_ranks.clear()
	for raw_definition: Dictionary in skill_definitions:
		var definition: Dictionary = raw_definition
		skill_ranks[str(definition.get("id", ""))] = 0

	var config: ConfigFile = ConfigFile.new()
	if config.load(SKILL_SAVE_PATH) == OK:
		var ranks_variant: Variant = config.get_value("habilidades", "rangos", {})
		if ranks_variant is Dictionary:
			var loaded_ranks: Dictionary = ranks_variant
			for raw_id: Variant in loaded_ranks.keys():
				var skill_id: String = str(raw_id)
				var loaded_rank: int = maxi(0, int(loaded_ranks[raw_id]))
				if skill_definitions_by_id.has(skill_id):
					var definition: Dictionary = skill_definitions_by_id[skill_id]
					skill_ranks[skill_id] = mini(
						loaded_rank, int(definition.get("max_rank", loaded_rank))
					)
				else:
					preserved_unknown_ranks[skill_id] = loaded_rank

		extra_skill_points = maxi(0, int(config.get_value("habilidades", "puntos_extra", 0)))
		character_tokens = maxi(0, int(config.get_value("personajes", "fichas", 0)))
		potion_day_key = str(config.get_value("pociones", "dia", ""))
		potions_today = maxi(0, int(config.get_value("pociones", "cantidad_hoy", 0)))
		last_potion_unix = maxi(0, int(config.get_value("pociones", "ultimo_unix", 0)))

	skill_ranks["core"] = 1
	current_effects = _calculate_effects()
	_refresh_daily_potion_counter()


func _reload_character_tokens_only() -> void:
	var config: ConfigFile = ConfigFile.new()
	if config.load(SKILL_SAVE_PATH) == OK:
		character_tokens = maxi(0, int(config.get_value("personajes", "fichas", character_tokens)))


func _save_progress() -> void:
	var config: ConfigFile = ConfigFile.new()
	config.load(SKILL_SAVE_PATH)

	var ranks_to_save: Dictionary = preserved_unknown_ranks.duplicate(true)
	for skill_id: String in skill_ranks.keys():
		ranks_to_save[skill_id] = skill_ranks[skill_id]

	config.set_value("habilidades", "rangos", ranks_to_save)
	config.set_value("habilidades", "puntos_extra", extra_skill_points)
	config.set_value("habilidades", "efectos", current_effects)
	config.set_value("personajes", "fichas", character_tokens)
	config.set_value("pociones", "dia", potion_day_key)
	config.set_value("pociones", "cantidad_hoy", potions_today)
	config.set_value("pociones", "ultimo_unix", last_potion_unix)

	var error: Error = config.save(SKILL_SAVE_PATH)
	if error != OK:
		push_warning("No se pudo guardar el árbol de habilidades.")


func _reset_skill_tree() -> void:
	if _get_total_spent_points() <= 0:
		return
	var gold: int = _main_number("player_gold", 0)
	if gold < RESET_COST:
		_set_status(_text("reset_gold") % RESET_COST, Color("#FF8F82"))
		return

	if is_instance_valid(main_controller):
		main_controller.set("player_gold", gold - RESET_COST)
		if main_controller.has_method("_save_progress"):
			main_controller.call("_save_progress")

	for raw_definition: Dictionary in skill_definitions:
		var skill_id: String = str(raw_definition.get("id", ""))
		skill_ranks[skill_id] = 1 if skill_id == "core" else 0
	preserved_unknown_ranks.clear()
	character_tokens = 0
	current_effects = _calculate_effects()
	reset_confirmation_deadline = 0.0
	_save_progress()
	_refresh_all()
	_notify_main_effects()
	_notify_inventory_character_progress()
	character_tokens_changed.emit(character_tokens)
	_set_status(_text("reset_done"), Color("#7EF2B8"))


func _on_reset_button_pressed() -> void:
	if _get_total_spent_points() <= 0:
		return
	var now_seconds: float = Time.get_ticks_msec() / 1000.0
	if reset_confirmation_deadline <= now_seconds:
		reset_confirmation_deadline = now_seconds + RESET_CONFIRM_SECONDS
		_refresh_reset_button()
		return
	_reset_skill_tree()


func _refresh_reset_button() -> void:
	if not is_instance_valid(reset_button):
		return
	var now_seconds: float = Time.get_ticks_msec() / 1000.0
	if reset_confirmation_deadline > now_seconds:
		reset_button.text = _text("reset_confirm")
		reset_button.add_theme_color_override("font_color", Color("#FFD18A"))
	else:
		reset_button.text = _text("reset_tree") % RESET_COST
		reset_button.add_theme_color_override("font_color", Color("#D8C6A5"))
	reset_button.disabled = _get_total_spent_points() <= 0


# =============================================================================
# GENERADOR DE POCIONES
# =============================================================================


func _process_potion_generator() -> void:
	current_effects = _calculate_effects()
	if not bool(current_effects.get("potion_generator", false)):
		return

	_refresh_daily_potion_counter()
	if potions_today >= maximum_daily_potions:
		return

	var now: int = int(Time.get_unix_time_from_system())
	if last_potion_unix <= 0:
		last_potion_unix = now
		_save_progress()
		return

	var elapsed: int = now - last_potion_unix
	if elapsed < int(potion_interval_seconds):
		return

	_refresh_references()
	if not is_instance_valid(inventory_ui) or not inventory_ui.has_method("add_item"):
		_set_status(_text("missing_inventory"), Color("#EFC486"))
		return

	var due_count: int = mini(
		int(floor(float(elapsed) / maxf(potion_interval_seconds, 1.0))),
		maximum_daily_potions - potions_today
	)
	for index: int in range(due_count):
		var potion: Dictionary = _create_generated_potion()
		var added: bool = bool(inventory_ui.call("add_item", potion))
		if not added:
			break
		potions_today += 1
		last_potion_unix += int(potion_interval_seconds)
		potion_generated.emit(potion.duplicate(true))
		_set_status(_text("potion_ready"), Color("#D99AFF"))

	_save_progress()
	_refresh_header_only()


func _create_generated_potion() -> Dictionary:
	var heal_amount: int = 45 + int(current_effects.get("potion_heal_flat", 0))
	heal_amount = int(
		round(
			(
				float(heal_amount)
				* (1.0 + float(current_effects.get("potion_power_percent", 0.0)) / 100.0)
			)
		)
	)
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
		"effect": {"heal": heal_amount},
		"stats": {},
		"icon_path": "res://Recursos/UI/ArbolHabilidades/Iconos/02_suerte_verde/pocion_verde.png"
	}


func _refresh_daily_potion_counter() -> void:
	var date: Dictionary = Time.get_date_dict_from_system()
	var new_key: String = (
		"%04d-%02d-%02d"
		% [int(date.get("year", 0)), int(date.get("month", 0)), int(date.get("day", 0))]
	)
	if potion_day_key != new_key:
		potion_day_key = new_key
		potions_today = 0
		last_potion_unix = int(Time.get_unix_time_from_system())
		_save_progress()


# =============================================================================
# ACCIONES SUPERIORES Y AJUSTES
# =============================================================================


func _on_refresh_pressed() -> void:
	_refresh_references()
	_load_language()
	_reload_character_tokens_only()
	_refresh_all()
	_notify_main_effects()
	_set_status(_text("status_ready"), Color("#D8D0C3"))


func _on_forge_pressed() -> void:
	_refresh_references()
	var forge_ui: Node = null
	var current_scene: Node = get_tree().current_scene
	if current_scene != null:
		forge_ui = current_scene.find_child("ForjaUI", true, false)
	close_skill_tree()
	if is_instance_valid(forge_ui) and forge_ui.has_method("toggle_forge"):
		forge_ui.call_deferred("toggle_forge")


func _on_inventory_pressed() -> void:
	_refresh_references()
	var target_inventory: Node = inventory_ui
	close_skill_tree()
	if is_instance_valid(target_inventory) and target_inventory.has_method("toggle_inventory"):
		target_inventory.call_deferred("toggle_inventory")


func _load_visual_settings() -> void:
	# Configuración fija del Árbol Astral.
	# El panel de opciones interno ha sido retirado.
	show_rank_badges = true
	use_pixel_filter = true
	keep_always_on_top = true


func _apply_texture_filtering() -> void:
	var filter_mode: TextureFilter = CanvasItem.TEXTURE_FILTER_NEAREST

	if is_instance_valid(window_root):
		window_root.texture_filter = filter_mode
	if is_instance_valid(design_root):
		design_root.texture_filter = filter_mode
	if is_instance_valid(background_rect):
		background_rect.texture_filter = filter_mode
	if is_instance_valid(selected_icon_rect):
		selected_icon_rect.texture_filter = filter_mode

	for raw_icon: Variant in node_icons.values():
		if raw_icon is TextureRect:
			(raw_icon as TextureRect).texture_filter = filter_mode

	for star: Control in twinkle_stars:
		if is_instance_valid(star):
			star.texture_filter = filter_mode

	for raw_child: Node in design_root.get_children():
		if raw_child is Button:
			(raw_child as Button).texture_filter = filter_mode
		for nested_child: Node in raw_child.get_children():
			if nested_child is TextureRect:
				(nested_child as TextureRect).texture_filter = filter_mode


# =============================================================================
# ESTILOS Y HELPERS
# =============================================================================


func _branch_color(branch: String) -> Color:
	return BRANCH_COLORS.get(branch, Color("#D3A83C"))


func _node_style(branch: String, selected: bool, hovered: bool, mastered: bool) -> StyleBoxFlat:
	var accent: Color = _branch_color(branch)
	var background_alpha: float = 0.04
	if hovered:
		background_alpha = 0.13
	if selected:
		background_alpha = 0.20
	if mastered:
		background_alpha = 0.17

	var border: Color = accent
	if selected:
		border = Color("#FFF0A8")
	elif mastered:
		border = accent.lightened(0.28)

	var style: StyleBoxFlat = _make_style(
		Color(accent.r, accent.g, accent.b, background_alpha),
		border,
		3 if selected else 1,
		64,
		Color(accent.r, accent.g, accent.b, 0.18 if selected else 0.0),
		8 if selected else 0
	)
	style.anti_aliasing = false
	return style


func _make_style(
	background_color: Color,
	border_color: Color,
	border_width: int,
	radius: int,
	shadow_color: Color = Color(0, 0, 0, 0),
	shadow_size: int = 0
) -> StyleBoxFlat:
	var style: StyleBoxFlat = StyleBoxFlat.new()
	style.bg_color = background_color
	style.border_color = border_color
	style.set_border_width_all(border_width)
	style.corner_radius_top_left = radius
	style.corner_radius_top_right = radius
	style.corner_radius_bottom_left = radius
	style.corner_radius_bottom_right = radius
	style.shadow_color = shadow_color
	style.shadow_size = shadow_size
	style.content_margin_left = 4.0
	style.content_margin_right = 4.0
	style.content_margin_top = 4.0
	style.content_margin_bottom = 4.0
	style.anti_aliasing = false
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
	label.add_theme_color_override("font_outline_color", Color(0.0, 0.0, 0.0, 0.96))
	label.add_theme_constant_override("outline_size", 3)
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	parent.add_child(label)
	return label


func _create_icon_action_button(
	parent: Control,
	button_name: String,
	button_position: Vector2,
	button_size: Vector2,
	icon_path: String,
	danger_style: bool
) -> Button:
	var button: Button = Button.new()
	button.name = button_name
	button.position = button_position
	button.size = button_size
	button.focus_mode = Control.FOCUS_NONE
	button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	button.add_theme_stylebox_override(
		"normal",
		_make_style(
			Color(0.15, 0.035, 0.035, 0.80) if danger_style else Color(0.025, 0.10, 0.085, 0.88),
			Color("#FF8C8C") if danger_style else Color("#B98A3D"),
			1,
			6
		)
	)
	button.add_theme_stylebox_override(
		"hover",
		_make_style(
			Color(0.30, 0.05, 0.05, 0.96) if danger_style else Color(0.04, 0.22, 0.15, 0.98),
			Color("#FFD0D0") if danger_style else Color("#FFE1A0"),
			2,
			6
		)
	)
	button.add_theme_stylebox_override(
		"pressed", _make_style(Color(0.02, 0.04, 0.035, 1.0), Color("#FFF0B0"), 2, 6)
	)
	parent.add_child(button)

	var icon_rect: TextureRect = TextureRect.new()
	icon_rect.position = Vector2(5, 5)
	icon_rect.size = button_size - Vector2(10, 10)
	icon_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	icon_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	icon_rect.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	if ResourceLoader.exists(icon_path):
		icon_rect.texture = load(icon_path) as Texture2D
	button.add_child(icon_rect)
	return button


func _set_status(message: String, color: Color = Color("#D8D0C3")) -> void:
	if not is_instance_valid(status_label):
		return
	status_label.text = message
	status_label.add_theme_color_override("font_color", color)
