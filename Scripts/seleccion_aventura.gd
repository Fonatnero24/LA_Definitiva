extends Control

enum ScreenMode {
	AUTO,
	FACTION,
	CHARACTER
}

@export_enum("Automático", "Facción", "Personaje")
var mode_override: int = ScreenMode.AUTO

const FACTION_WINDOW_SIZE: Vector2i = Vector2i(1000, 600)
const CHARACTER_WINDOW_SIZE: Vector2i = Vector2i(1180, 760)

const MENU_SCENE_PATH: String = "res://escenas/MenuPrincipal.tscn"
const FACTION_SCENE_PATH: String = "res://escenas/SeleccionFaccion.tscn"
const CHARACTER_SCENE_PATH: String = "res://escenas/SeleccionPersonaje.tscn"
const MAIN_SCENE_PATH: String = "res://escenas/main.tscn"

const SAVE_PATH: String = "user://partida.cfg"
const SELECTION_SAVE_PATH: String = "user://seleccion.cfg"
const SETTINGS_PATH: String = "user://opciones.cfg"

const DRAG_AREA_HEIGHT: float = 68.0

const PALADIN_TEXTURE_PATH: String = "res://Recursos/Personajes/Paladin/Seleccion/Idle/Paladin1.png"
const PALADIN_IDLE_FOLDER: String = "res://Recursos/Personajes/Paladin/Seleccion/Idle"
const PALADIN_IDLE_FRAME_SECONDS: float = 0.18
const PALADIN_IDLE_MAX_FRAMES: int = 24

const FACTION_FRAME_POSITION: Vector2 = Vector2(18.0, 20.0)
const FACTION_FRAME_SIZE: Vector2 = Vector2(964.0, 560.0)
const FACTION_CARD_SIZE: Vector2 = Vector2(405.0, 350.0)
const FACTION_CARD_POSITIONS: Array[Vector2] = [
	Vector2(52.0, 115.0),
	Vector2(507.0, 115.0)
]

const CHARACTER_FRAME_POSITION: Vector2 = Vector2(18.0, 20.0)
const CHARACTER_FRAME_SIZE: Vector2 = Vector2(1144.0, 720.0)
const CHARACTER_CARD_SIZE: Vector2 = Vector2(330.0, 540.0)
const CHARACTER_CARD_POSITIONS: Array[Vector2] = [
	Vector2(42.0, 100.0),
	Vector2(407.0, 100.0),
	Vector2(772.0, 100.0)
]

const COLOR_BACKGROUND: Color = Color(0.003, 0.006, 0.012, 0.94)
const COLOR_FRAME: Color = Color(0.008, 0.013, 0.022, 0.97)
const COLOR_CARD: Color = Color(0.018, 0.025, 0.038, 0.98)
const COLOR_CARD_HOVER: Color = Color(0.030, 0.040, 0.058, 0.99)

const COLOR_TEXT: Color = Color("#F0E7D7")
const COLOR_MUTED: Color = Color("#BBB3A3")
const COLOR_GOLD: Color = Color("#E7C873")
const COLOR_GOLD_BRIGHT: Color = Color("#FFD66B")
const COLOR_SELECTED: Color = Color("#FFF0A4")
const COLOR_LIGHT_BLUE: Color = Color("#9CCBFF")
const COLOR_DISABLED: Color = Color("#77736C")

const COLOR_ALBA: Color = Color("#8DBBFF")
const COLOR_ALBA_BG: Color = Color(0.020, 0.045, 0.082, 0.98)
const COLOR_ALBA_HOVER: Color = Color(0.035, 0.080, 0.130, 0.99)

const COLOR_UMBRAL: Color = Color("#D578FF")
const COLOR_UMBRAL_BG: Color = Color(0.065, 0.022, 0.088, 0.98)
const COLOR_UMBRAL_HOVER: Color = Color(0.105, 0.035, 0.135, 0.99)

var current_language: String = "es"
var game_ui: Node

const ENGLISH_TEXTS: Dictionary = {
	"JURAMENTO DEL ALBA": "OATH OF THE DAWN",
	"LA SENDA DE LA LUZ": "THE PATH OF LIGHT",
	"Defiende los reinos y contiene la Fractura.": "Defend the realms and contain the Fracture.",
	"Bandidos · Monstruos · Cultistas · Demonios": "Bandits · Monsters · Cultists · Demons",
	"Paladín · Arquero · Arcanista": "Paladin · Archer · Arcanist",
	"PROTEGER": "PROTECT",

	"PACTO DEL UMBRAL": "PACT OF THE VEIL",
	"LA SENDA DE LA NOCHE": "THE PATH OF NIGHT",
	"Domina la Fractura y somete los reinos.": "Master the Fracture and subjugate the realms.",
	"Aventureros · Guardias · Paladines · Inquisidores": "Adventurers · Guards · Paladins · Inquisitors",
	"Nigromante · Caballero de Sangre · Asesino": "Necromancer · Blood Knight · Assassin",
	"CONQUISTAR": "CONQUER",

	"PALADÍN DEL ALBA": "DAWN PALADIN",
	"Defensor sagrado": "Holy defender",
	"Protegido por la luz.\nResiste el daño y puede curarse.": "Protected by the light.\nEndures damage and can heal.",
	"ESCUDO SAGRADO": "HOLY SHIELD",
	"Bloquea temporalmente el daño recibido.": "Temporarily blocks incoming damage.",

	"ARQUERO DEL BOSQUE": "FOREST ARCHER",
	"Atacante a distancia": "Ranged attacker",
	"Preciso a larga distancia.\nDestaca por su velocidad.": "Accurate at long range.\nExcels through speed.",
	"DISPARO TRIPLE": "TRIPLE SHOT",
	"Lanza tres flechas rápidamente.": "Fires three arrows in quick succession.",

	"ARCANISTA ESTELAR": "STELLAR ARCANIST",
	"Hechicero ofensivo": "Offensive spellcaster",
	"Domina fuerzas celestiales.\nDaña a varios enemigos.": "Commands celestial forces.\nDamages multiple enemies.",
	"LLUVIA ARCANA": "ARCANE RAIN",
	"Golpea a varios enemigos con magia celestial.": "Strikes multiple enemies with celestial magic.",

	"CABALLERO DEL OCASO": "DUSK KNIGHT",
	"Guerrero corrupto": "Corrupted warrior",
	"Una muralla de sombras.\nTransforma el dolor en poder.": "A wall of shadows.\nTurns pain into power.",
	"JURAMENTO MALDITO": "CURSED OATH",
	"Aumenta su daño cuando pierde vida.": "Increases damage as health is lost.",

	"ACECHADOR DE CENIZA": "ASH STALKER",
	"Asesino veloz": "Swift assassin",
	"Ataca antes de ser visto.\nDomina el daño crítico.": "Strikes before being seen.\nExcels at critical damage.",
	"CORTE SILENCIOSO": "SILENT SLASH",
	"Ejecuta un ataque crítico inmediato.": "Performs an immediate critical attack.",

	"NIGROMANTE DEL VACÍO": "VOID NECROMANCER",
	"Invocador oscuro": "Dark summoner",
	"Domina las almas caídas.\nInvoca servidores espectrales.": "Commands fallen souls.\nSummons spectral servants.",
	"EJÉRCITO ESPECTRAL": "SPECTRAL ARMY",
	"Invoca almas que atacan durante un tiempo.": "Summons souls that attack for a time.",

	"ELIGE TU DESTINO": "CHOOSE YOUR DESTINY",
	"La Fractura se abre ante ti. Decide qué juramento guiará tu aventura.": "The Fracture opens before you. Decide which oath will guide your adventure.",
	"Selecciona una facción para continuar.": "Select a faction to continue.",
	"ENEMIGOS": "ENEMIES",
	"CLASES": "CLASSES",
	"Has elegido %s.": "You have chosen %s.",
	"tu juramento": "your oath",

	"ELIGE A TU CAMPEÓN": "CHOOSE YOUR CHAMPION",
	"Selecciona un personaje para continuar.": "Select a character to continue.",
	"NO SE ENCONTRÓ\nPALADIN1.PNG": "PALADIN1.PNG\nWAS NOT FOUND",
	"RETRATO EN DESARROLLO": "PORTRAIT IN DEVELOPMENT",
	"VIDA": "HEALTH",
	"DAÑO": "DAMAGE",
	"VELOCIDAD": "SPEED",
	"MAGIA": "MAGIC",
	"%s ha respondido a tu llamada.": "%s has answered your call.",
	"El campeón": "The champion",

	"VOLVER": "BACK",
	"CONFIRMAR": "CONFIRM",
	"No se pudo volver a la selección de facción.": "Could not return to faction selection.",
	"No se pudo volver al menú principal.": "Could not return to the main menu.",
	"El destino ha sellado tu juramento...": "Destiny has sealed your oath...",
	"No se pudo abrir la selección de personaje.": "Could not open character selection.",
	"El destino ha elegido a %s...": "Destiny has chosen %s...",
	"tu campeón": "your champion",
	"No se pudo iniciar la aventura.": "Could not begin the adventure.",
	"No se encontró la escena: ": "Scene not found: ",
	"No se pudo guardar la facción en: ": "Could not save the faction to: ",
	"No se pudo guardar el personaje seleccionado.": "Could not save the selected character."
}

func _connect_game_ui() -> void:
	game_ui = get_node_or_null("/root/GameUI")

func _load_language_setting() -> void:
	if is_instance_valid(game_ui) and game_ui.has_method("get_language"):
		current_language = str(game_ui.call("get_language"))
	else:
		var config: ConfigFile = ConfigFile.new()

		if config.load(SETTINGS_PATH) == OK:
			current_language = str(
				config.get_value(
					"general",
					"idioma",
					"es"
				)
			).to_lower().strip_edges()

	if current_language != "es" and current_language != "en":
		current_language = "es"

	TranslationServer.set_locale(current_language)

func _tr(source_text: String) -> String:
	if current_language == "en":
		return str(
			ENGLISH_TEXTS.get(
				source_text,
				source_text
			)
		)

	return source_text

var faction_data: Array[Dictionary] = [
	{
		"id": "alba",
		"title": "JURAMENTO DEL ALBA",
		"subtitle": "LA SENDA DE LA LUZ",
		"description": "Defiende los reinos y contiene la Fractura.",
		"enemies": "Bandidos · Monstruos · Cultistas · Demonios",
		"classes": "Paladín · Arquero · Arcanista",
		"destiny": "PROTEGER",
		"symbol": "✦",
		"accent": COLOR_ALBA,
		"background": COLOR_ALBA_BG,
		"hover": COLOR_ALBA_HOVER
	},
	{
		"id": "umbral",
		"title": "PACTO DEL UMBRAL",
		"subtitle": "LA SENDA DE LA NOCHE",
		"description": "Domina la Fractura y somete los reinos.",
		"enemies": "Aventureros · Guardias · Paladines · Inquisidores",
		"classes": "Nigromante · Caballero de Sangre · Asesino",
		"destiny": "CONQUISTAR",
		"symbol": "◆",
		"accent": COLOR_UMBRAL,
		"background": COLOR_UMBRAL_BG,
		"hover": COLOR_UMBRAL_HOVER
	}
]

var light_champions: Array[Dictionary] = [
	{
		"id": "paladin_alba",
		"name": "PALADÍN DEL ALBA",
		"role": "Defensor sagrado",
		"description": "Protegido por la luz.\nResiste el daño y puede curarse.",
		"stats": {
			"VIDA": 5,
			"DAÑO": 3,
			"VELOCIDAD": 2,
			"MAGIA": 3
		},
		"ability_name": "ESCUDO SAGRADO",
		"ability_description": "Bloquea temporalmente el daño recibido.",
		"animated": false,
		"sigil": "",
		"accent": Color("#72B7FF"),
		"card_bg": Color(0.012, 0.026, 0.052, 0.99)
	},
	{
		"id": "arquero_bosque",
		"name": "ARQUERO DEL BOSQUE",
		"role": "Atacante a distancia",
		"description": "Preciso a larga distancia.\nDestaca por su velocidad.",
		"stats": {
			"VIDA": 3,
			"DAÑO": 4,
			"VELOCIDAD": 5,
			"MAGIA": 1
		},
		"ability_name": "DISPARO TRIPLE",
		"ability_description": "Lanza tres flechas rápidamente.",
		"animated": false,
		"sigil": "",
		"accent": Color("#73D982"),
		"card_bg": Color(0.012, 0.043, 0.025, 0.99)
	},
	{
		"id": "arcanista_estelar",
		"name": "ARCANISTA ESTELAR",
		"role": "Hechicero ofensivo",
		"description": "Domina fuerzas celestiales.\nDaña a varios enemigos.",
		"stats": {
			"VIDA": 2,
			"DAÑO": 5,
			"VELOCIDAD": 3,
			"MAGIA": 5
		},
		"ability_name": "LLUVIA ARCANA",
		"ability_description": "Golpea a varios enemigos con magia celestial.",
		"animated": false,
		"sigil": "",
		"accent": Color("#B985FF"),
		"card_bg": Color(0.034, 0.014, 0.060, 0.99)
	}
]

var dark_champions: Array[Dictionary] = [
	{
		"id": "caballero_ocaso",
		"name": "CABALLERO DEL OCASO",
		"role": "Guerrero corrupto",
		"description": "Una muralla de sombras.\nTransforma el dolor en poder.",
		"stats": {
			"VIDA": 5,
			"DAÑO": 4,
			"VELOCIDAD": 2,
			"MAGIA": 2
		},
		"ability_name": "JURAMENTO MALDITO",
		"ability_description": "Aumenta su daño cuando pierde vida.",
		"animated": false,
		"sigil": "",
		"accent": Color("#FF8C68"),
		"card_bg": Color(0.060, 0.018, 0.012, 0.99)
	},
	{
		"id": "acechador_ceniza",
		"name": "ACECHADOR DE CENIZA",
		"role": "Asesino veloz",
		"description": "Ataca antes de ser visto.\nDomina el daño crítico.",
		"stats": {
			"VIDA": 2,
			"DAÑO": 5,
			"VELOCIDAD": 5,
			"MAGIA": 1
		},
		"ability_name": "CORTE SILENCIOSO",
		"ability_description": "Ejecuta un ataque crítico inmediato.",
		"animated": false,
		"sigil": "",
		"accent": Color("#D29BFF"),
		"card_bg": Color(0.042, 0.015, 0.052, 0.99)
	},
	{
		"id": "nigromante_vacio",
		"name": "NIGROMANTE DEL VACÍO",
		"role": "Invocador oscuro",
		"description": "Domina las almas caídas.\nInvoca servidores espectrales.",
		"stats": {
			"VIDA": 2,
			"DAÑO": 4,
			"VELOCIDAD": 2,
			"MAGIA": 5
		},
		"ability_name": "EJÉRCITO ESPECTRAL",
		"ability_description": "Invoca almas que atacan durante un tiempo.",
		"animated": false,
		"sigil": "",
		"accent": Color("#A999FF"),
		"card_bg": Color(0.022, 0.014, 0.052, 0.99)
	}
]

var current_mode: int = ScreenMode.FACTION
var selected_faction: String = ""
var selected_character_index: int = -1
var champions: Array[Dictionary] = []

var interface_root: Control
var main_frame: Panel
var status_label: Label
var confirm_button: Button
var back_button: Button

var selectable_buttons: Array[Button] = []
var selectable_glows: Array[ColorRect] = []

var dragging_window: bool = false
var drag_offset: Vector2i = Vector2i.ZERO
var transition_locked: bool = false
var paladin_idle_sprites: Array[Sprite2D] = []
var paladin_idle_frames: Array = []
var paladin_idle_time: float = 0.0
var paladin_idle_frame_index: int = 0

func _ready() -> void:
	visible = true
	set_process(true)
	_connect_game_ui()
	_load_language_setting()
	current_mode = _resolve_mode()

	print(
		"Selección de aventura iniciada en modo: ",
		"PERSONAJE"
		if current_mode == ScreenMode.CHARACTER
		else "FACCIÓN"
	)

	_clear_placeholder_nodes()

	if current_mode == ScreenMode.CHARACTER:
		selected_faction = _load_faction()
		_select_champion_list()

	_configure_window()
	_create_interface()

func _process(delta: float) -> void:
	_process_paladin_idle_animation(delta)


func _resolve_mode() -> int:
	if mode_override == ScreenMode.FACTION:
		return ScreenMode.FACTION

	if mode_override == ScreenMode.CHARACTER:
		return ScreenMode.CHARACTER

	var scene_path: String = ""
	var current_scene: Node = get_tree().current_scene

	if current_scene != null:
		scene_path = current_scene.scene_file_path.to_lower()

	var identity: String = (
		name.to_lower()
		+ " "
		+ scene_path
	)

	if identity.contains("personaje") or identity.contains("character"):
		return ScreenMode.CHARACTER

	return ScreenMode.FACTION

func _clear_placeholder_nodes() -> void:
	var old_children: Array[Node] = []

	for child in get_children():
		old_children.append(child)

	for child in old_children:
		remove_child(child)
		child.queue_free()

func _configure_window() -> void:
	var target_size: Vector2i = FACTION_WINDOW_SIZE
	var always_on_top: bool = true

	if current_mode == ScreenMode.CHARACTER:
		target_size = CHARACTER_WINDOW_SIZE

	var game_window: Window = get_window()
	game_window.transparent_bg = true

	if DisplayServer.is_window_transparency_available():
		DisplayServer.window_set_flag(
			DisplayServer.WINDOW_FLAG_TRANSPARENT,
			true
		)

	DisplayServer.window_set_mode(
		DisplayServer.WINDOW_MODE_WINDOWED
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
	DisplayServer.window_set_size(target_size)

	_center_window(target_size)

func _center_window(target_size: Vector2i) -> void:
	var screen_index: int = DisplayServer.window_get_current_screen()
	var usable_rect: Rect2i = DisplayServer.screen_get_usable_rect(screen_index)

	var position_x: int = (
		usable_rect.position.x
		+ int(
			(
				float(usable_rect.size.x)
				- float(target_size.x)
			) / 2.0
		)
	)

	var position_y: int = (
		usable_rect.position.y
		+ int(
			(
				float(usable_rect.size.y)
				- float(target_size.y)
			) / 2.0
		)
	)

	DisplayServer.window_set_position(
		Vector2i(position_x, position_y)
	)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var mouse_event: InputEventMouseButton = (
			event as InputEventMouseButton
		)

		if mouse_event.button_index != MOUSE_BUTTON_LEFT:
			return

		if mouse_event.pressed:
			if mouse_event.position.y <= DRAG_AREA_HEIGHT:
				dragging_window = true
				drag_offset = (
					DisplayServer.mouse_get_position()
					- get_window().position
				)
			else:
				dragging_window = false
		else:
			dragging_window = false

	elif event is InputEventMouseMotion and dragging_window:
		get_window().position = (
			DisplayServer.mouse_get_position()
			- drag_offset
		)

func _create_interface() -> void:
	var root_size: Vector2 = Vector2(FACTION_WINDOW_SIZE)

	if current_mode == ScreenMode.CHARACTER:
		root_size = Vector2(CHARACTER_WINDOW_SIZE)

	interface_root = Control.new()
	interface_root.name = "InterfaceRoot"
	interface_root.position = Vector2.ZERO
	interface_root.size = root_size
	interface_root.mouse_filter = Control.MOUSE_FILTER_PASS
	add_child(interface_root)

	if current_mode == ScreenMode.CHARACTER:
		main_frame = _create_rounded_frame(
			CHARACTER_FRAME_POSITION,
			CHARACTER_FRAME_SIZE
		)
		_create_character_screen()
	else:
		main_frame = _create_rounded_frame(
			FACTION_FRAME_POSITION,
			FACTION_FRAME_SIZE
		)
		_create_faction_screen()

func _create_rounded_frame(
	frame_position: Vector2,
	frame_size: Vector2
) -> Panel:
	var shadow: Panel = Panel.new()
	shadow.position = frame_position + Vector2(4.0, 6.0)
	shadow.size = frame_size
	shadow.mouse_filter = Control.MOUSE_FILTER_IGNORE
	shadow.add_theme_stylebox_override(
		"panel",
		_make_style(
			Color(0.0, 0.0, 0.0, 0.72),
			Color(0.82, 0.64, 0.18, 0.16),
			1,
			30,
			Color(0.0, 0.0, 0.0, 0.68),
			14,
			Vector2(0.0, 5.0)
		)
	)
	interface_root.add_child(shadow)

	var frame: Panel = Panel.new()
	frame.position = frame_position
	frame.size = frame_size
	frame.clip_contents = true
	frame.mouse_filter = Control.MOUSE_FILTER_PASS
	frame.add_theme_stylebox_override(
		"panel",
		_make_style(
			COLOR_FRAME,
			COLOR_GOLD_BRIGHT,
			6,
			32,
			Color(0.0, 0.0, 0.0, 0.68),
			10,
			Vector2(0.0, 4.0)
		)
	)
	interface_root.add_child(frame)

	var inner_border: Panel = Panel.new()
	inner_border.position = Vector2(10.0, 10.0)
	inner_border.size = frame_size - Vector2(20.0, 20.0)
	inner_border.mouse_filter = Control.MOUSE_FILTER_IGNORE
	inner_border.add_theme_stylebox_override(
		"panel",
		_make_style(
			Color(0.0, 0.0, 0.0, 0.0),
			Color(0.99, 0.86, 0.42, 0.52),
			3,
			26
		)
	)
	frame.add_child(inner_border)

	return frame

func _create_ambient_glow(
	parent: Control,
	glow_position: Vector2,
	glow_size: Vector2,
	color: Color
) -> void:
	var glow: ColorRect = ColorRect.new()
	glow.position = glow_position
	glow.size = glow_size
	glow.color = color
	glow.mouse_filter = Control.MOUSE_FILTER_IGNORE
	parent.add_child(glow)

func _create_header(
	title_text: String,
	subtitle_text: String,
	subtitle_color: Color,
	frame_width: float
) -> void:
	var title_shadow: Label = _create_label(
		main_frame,
		title_text,
		Vector2(32.0, 15.0),
		Vector2(frame_width - 64.0, 46.0),
		31,
		HORIZONTAL_ALIGNMENT_CENTER,
		Color(0.0, 0.0, 0.0, 0.76)
	)
	title_shadow.position += Vector2(2.0, 3.0)

	var title_label: Label = _create_label(
		main_frame,
		title_text,
		Vector2(30.0, 11.0),
		Vector2(frame_width - 60.0, 50.0),
		33,
		HORIZONTAL_ALIGNMENT_CENTER,
		COLOR_GOLD
	)
	title_label.add_theme_constant_override("outline_size", 4)
	title_label.add_theme_color_override(
		"font_outline_color",
		Color(0.05, 0.025, 0.0, 0.96)
	)

	_create_label(
		main_frame,
		subtitle_text,
		Vector2(30.0, 57.0),
		Vector2(frame_width - 60.0, 28.0),
		18,
		HORIZONTAL_ALIGNMENT_CENTER,
		subtitle_color
	)

	var line_width: float = (frame_width - 250.0) / 2.0

	_create_color_rect(
		main_frame,
		Vector2(78.0, 96.0),
		Vector2(line_width - 78.0, 1.0),
		Color(0.90, 0.70, 0.24, 0.58)
	)

	var gem: Panel = Panel.new()
	gem.position = Vector2(frame_width / 2.0 - 7.0, 89.0)
	gem.size = Vector2(14.0, 14.0)
	gem.rotation = deg_to_rad(45.0)
	gem.mouse_filter = Control.MOUSE_FILTER_IGNORE
	gem.add_theme_stylebox_override(
		"panel",
		_make_style(
			COLOR_GOLD_BRIGHT,
			Color("#FFF1B0"),
			1,
			2,
			Color(1.0, 0.76, 0.20, 0.40),
			8
		)
	)
	main_frame.add_child(gem)

	_create_color_rect(
		main_frame,
		Vector2(frame_width / 2.0 + 82.0, 96.0),
		Vector2(line_width - 78.0, 1.0),
		Color(0.90, 0.70, 0.24, 0.58)
	)

func _create_faction_screen() -> void:
	selected_faction = ""
	selected_character_index = -1
	selectable_buttons.clear()
	selectable_glows.clear()

	_create_ambient_glow(
		main_frame,
		Vector2(10.0, 92.0),
		Vector2(462.0, 390.0),
		Color(0.025, 0.105, 0.235, 0.17)
	)
	_create_ambient_glow(
		main_frame,
		Vector2(492.0, 92.0),
		Vector2(462.0, 390.0),
		Color(0.170, 0.020, 0.225, 0.16)
	)

	_create_header(
		_tr("ELIGE TU DESTINO"),
		_tr("La Fractura se abre ante ti. Decide qué juramento guiará tu aventura."),
		COLOR_MUTED,
		FACTION_FRAME_SIZE.x
	)

	for index in range(faction_data.size()):
		_create_faction_card(
			index,
			faction_data[index],
			FACTION_CARD_POSITIONS[index]
		)

	_create_status_and_buttons(
		_tr("Selecciona una facción para continuar."),
		Vector2(267.0, 466.0),
		Vector2(430.0, 32.0),
		Vector2(252.0, 508.0),
		Vector2(492.0, 508.0)
	)

func _create_faction_card(
	index: int,
	data: Dictionary,
	card_position: Vector2
) -> void:
	var accent: Color = data.get("accent", COLOR_GOLD)
	var background: Color = data.get("background", COLOR_CARD)
	var hover: Color = data.get("hover", COLOR_CARD_HOVER)

	var card: Button = Button.new()
	card.name = "FactionCard%d" % index
	card.text = ""
	card.position = card_position
	card.size = FACTION_CARD_SIZE
	card.focus_mode = Control.FOCUS_NONE
	card.clip_contents = true
	card.pivot_offset = FACTION_CARD_SIZE / 2.0
	card.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	card.set_meta("id", str(data.get("id", "")))
	card.set_meta("base_position", card_position)
	card.set_meta("accent", accent)
	card.set_meta("background", background)
	card.set_meta("hover", hover)
	main_frame.add_child(card)

	var glow: ColorRect = _create_color_rect(
		card,
		Vector2(5.0, 5.0),
		FACTION_CARD_SIZE - Vector2(10.0, 10.0),
		Color(accent.r, accent.g, accent.b, 0.0)
	)
	glow.name = "SelectionGlow"

	selectable_buttons.append(card)
	selectable_glows.append(glow)

	_apply_selectable_style(index, false)
	_add_corner_ornaments(card, FACTION_CARD_SIZE)

	var emblem: Panel = Panel.new()
	emblem.position = Vector2(145.0, 18.0)
	emblem.size = Vector2(115.0, 115.0)
	emblem.mouse_filter = Control.MOUSE_FILTER_IGNORE
	emblem.add_theme_stylebox_override(
		"panel",
		_make_style(
			Color(
				accent.r * 0.08,
				accent.g * 0.08,
				accent.b * 0.08,
				0.42
			),
			accent,
			2,
			58,
			Color(accent.r, accent.g, accent.b, 0.20),
			12
		)
	)
	card.add_child(emblem)

	_create_label(
		emblem,
		str(data.get("symbol", "◆")),
		Vector2.ZERO,
		emblem.size,
		42,
		HORIZONTAL_ALIGNMENT_CENTER,
		accent
	)

	var name_plate: Panel = Panel.new()
	name_plate.position = Vector2(46.0, 140.0)
	name_plate.size = Vector2(313.0, 40.0)
	name_plate.mouse_filter = Control.MOUSE_FILTER_IGNORE
	name_plate.add_theme_stylebox_override(
		"panel",
		_make_style(
			Color(0.17, 0.11, 0.04, 0.97),
			COLOR_GOLD_BRIGHT,
			2,
			10,
			Color(0.0, 0.0, 0.0, 0.54),
			5
		)
	)
	card.add_child(name_plate)

	_create_label(
		name_plate,
		_tr(str(data.get("title", ""))),
		Vector2.ZERO,
		name_plate.size,
		18,
		HORIZONTAL_ALIGNMENT_CENTER,
		COLOR_TEXT
	)

	_create_label(
		card,
		_tr(str(data.get("subtitle", ""))),
		Vector2(30.0, 187.0),
		Vector2(345.0, 20.0),
		13,
		HORIZONTAL_ALIGNMENT_CENTER,
		accent
	)

	var description: Label = _create_label(
		card,
		_tr(str(data.get("description", ""))),
		Vector2(34.0, 210.0),
		Vector2(337.0, 32.0),
		12,
		HORIZONTAL_ALIGNMENT_CENTER,
		COLOR_TEXT
	)
	description.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	description.clip_text = true
	description.add_theme_constant_override("line_spacing", 1)

	var info_panel: Panel = Panel.new()
	info_panel.position = Vector2(30.0, 245.0)
	info_panel.size = Vector2(345.0, 64.0)
	info_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	info_panel.add_theme_stylebox_override(
		"panel",
		_make_style(
			Color(0.0, 0.0, 0.0, 0.92),
			COLOR_GOLD_BRIGHT,
			2,
			12,
			Color(0.0, 0.0, 0.0, 0.52),
			4
		)
	)
	card.add_child(info_panel)

	_create_info_row(
		info_panel,
		_tr("ENEMIGOS"),
		_tr(str(data.get("enemies", ""))),
		Vector2(5.0, 8.0),
		accent
	)
	_create_info_row(
		info_panel,
		_tr("CLASES"),
		_tr(str(data.get("classes", ""))),
		Vector2(5.0, 36.0),
		accent
	)

	var destiny_plate: Panel = Panel.new()
	destiny_plate.position = Vector2(122.0, 316.0)
	destiny_plate.size = Vector2(161.0, 27.0)
	destiny_plate.mouse_filter = Control.MOUSE_FILTER_IGNORE
	destiny_plate.add_theme_stylebox_override(
		"panel",
		_make_style(
			Color(0.07, 0.045, 0.018, 0.97),
			COLOR_GOLD_BRIGHT,
			1,
			10
		)
	)
	card.add_child(destiny_plate)

	_create_label(
		destiny_plate,
		_tr(str(data.get("destiny", ""))),
		Vector2.ZERO,
		destiny_plate.size,
		11,
		HORIZONTAL_ALIGNMENT_CENTER,
		accent
	)

	card.pressed.connect(_on_faction_pressed.bind(index))
	card.mouse_entered.connect(_on_selectable_entered.bind(index))
	card.mouse_exited.connect(_on_selectable_exited.bind(index))

func _create_info_row(
	parent: Control,
	title: String,
	value: String,
	row_position: Vector2,
	accent: Color
) -> void:
	_create_label(
		parent,
		title,
		row_position,
		Vector2(78.0, 20.0),
		10,
		HORIZONTAL_ALIGNMENT_RIGHT,
		accent
	)

	var value_label: Label = _create_label(
		parent,
		value,
		row_position + Vector2(88.0, 0.0),
		Vector2(247.0, 20.0),
		10,
		HORIZONTAL_ALIGNMENT_LEFT,
		COLOR_TEXT
	)
	value_label.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS

func _on_faction_pressed(index: int) -> void:
	if transition_locked:
		return

	if index < 0 or index >= faction_data.size():
		return

	selected_faction = str(faction_data[index].get("id", ""))

	for card_index in range(selectable_buttons.size()):
		_apply_selectable_style(
			card_index,
			card_index == index
		)

	status_label.text = (
		_tr("Has elegido %s.")
		% _tr(
			str(
				faction_data[index].get(
					"title",
					"tu juramento"
				)
			)
		)
	)
	confirm_button.disabled = false

func _create_character_screen() -> void:
	selected_character_index = -1
	selectable_buttons.clear()
	selectable_glows.clear()

	var subtitle: String = _tr("JURAMENTO DEL ALBA")
	var subtitle_color: Color = COLOR_LIGHT_BLUE

	if selected_faction == "umbral":
		subtitle = _tr("PACTO DEL UMBRAL")
		subtitle_color = Color("#FF9A83")

	_create_ambient_glow(
		main_frame,
		Vector2(135.0, 0.0),
		Vector2(874.0, 106.0),
		Color(0.30, 0.20, 0.04, 0.09)
	)

	_create_header(
		_tr("ELIGE A TU CAMPEÓN"),
		subtitle,
		subtitle_color,
		CHARACTER_FRAME_SIZE.x
	)

	for index in range(champions.size()):
		var data: Dictionary = champions[index]
		var accent: Color = data.get("accent", COLOR_GOLD)
		var card_position: Vector2 = CHARACTER_CARD_POSITIONS[index]

		_create_ambient_glow(
			main_frame,
			card_position + Vector2(14.0, 14.0),
			CHARACTER_CARD_SIZE - Vector2(28.0, 28.0),
			Color(accent.r, accent.g, accent.b, 0.035)
		)

		_create_character_card(index, data, card_position)

	_create_status_and_buttons(
		_tr("Selecciona un personaje para continuar."),
		Vector2(272.0, 642.0),
		Vector2(600.0, 28.0),
		Vector2(317.0, 672.0),
		Vector2(587.0, 672.0)
	)

func _create_character_card(
	index: int,
	data: Dictionary,
	card_position: Vector2
) -> void:
	var accent: Color = data.get("accent", COLOR_GOLD)
	var card_background: Color = data.get("card_bg", COLOR_CARD)
	var hover_background: Color = card_background.lightened(0.045)

	var card: Button = Button.new()
	card.name = "CharacterCard%d" % index
	card.text = ""
	card.position = card_position
	card.size = CHARACTER_CARD_SIZE
	card.focus_mode = Control.FOCUS_NONE
	card.clip_contents = true
	card.pivot_offset = CHARACTER_CARD_SIZE / 2.0
	card.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	card.set_meta("base_position", card_position)
	card.set_meta("background", card_background)
	card.set_meta("hover", hover_background)
	card.set_meta("accent", accent)
	main_frame.add_child(card)

	var glow: ColorRect = _create_color_rect(
		card,
		Vector2(5.0, 5.0),
		CHARACTER_CARD_SIZE - Vector2(10.0, 10.0),
		Color(accent.r, accent.g, accent.b, 0.0)
	)
	glow.name = "SelectionGlow"

	selectable_buttons.append(card)
	selectable_glows.append(glow)

	_apply_selectable_style(index, false)
	_add_corner_ornaments(card, CHARACTER_CARD_SIZE)

	var inner_frame: Panel = Panel.new()
	inner_frame.position = Vector2(10.0, 10.0)
	inner_frame.size = CHARACTER_CARD_SIZE - Vector2(20.0, 20.0)
	inner_frame.mouse_filter = Control.MOUSE_FILTER_IGNORE
	inner_frame.add_theme_stylebox_override(
		"panel",
		_make_style(
			Color(card_background.r, card_background.g, card_background.b, 0.94),
			Color(accent.r, accent.g, accent.b, 0.42),
			1,
			17
		)
	)
	card.add_child(inner_frame)

	var portrait_panel: Panel = Panel.new()
	portrait_panel.position = Vector2(15.0, 18.0)
	portrait_panel.size = Vector2(300.0, 330.0)
	portrait_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	portrait_panel.clip_contents = true
	portrait_panel.add_theme_stylebox_override(
		"panel",
		_make_style(
			Color(
				accent.r * 0.045,
				accent.g * 0.045,
				accent.b * 0.045,
				0.99
			),
			Color(accent.r, accent.g, accent.b, 0.78),
			2,
			15,
			Color(accent.r, accent.g, accent.b, 0.14),
			10
		)
	)
	card.add_child(portrait_panel)

	_create_color_rect(
		portrait_panel,
		Vector2(9.0, 8.0),
		Vector2(282.0, 2.0),
		Color(accent.r, accent.g, accent.b, 0.48)
	)
	_create_color_rect(
		portrait_panel,
		Vector2(9.0, 319.0),
		Vector2(282.0, 2.0),
		Color(accent.r, accent.g, accent.b, 0.26)
	)

	if str(data.get("id", "")) == "paladin_alba":
		_create_paladin_static_art(portrait_panel)
	else:
		_create_sigil_placeholder(
			portrait_panel,
			str(data.get("sigil", "")),
			accent
		)

	var crest_shadow: Panel = Panel.new()
	crest_shadow.position = Vector2(132.0, 5.0)
	crest_shadow.size = Vector2(66.0, 66.0)
	crest_shadow.mouse_filter = Control.MOUSE_FILTER_IGNORE
	crest_shadow.add_theme_stylebox_override(
		"panel",
		_make_style(
			Color(0.0, 0.0, 0.0, 0.58),
			Color(0.0, 0.0, 0.0, 0.0),
			0,
			33,
			Color(0.0, 0.0, 0.0, 0.62),
			8,
			Vector2(0.0, 4.0)
		)
	)
	card.add_child(crest_shadow)

	var crest: Panel = Panel.new()
	crest.name = "SymbolSlot"
	crest.position = Vector2(135.0, 2.0)
	crest.size = Vector2(60.0, 60.0)
	crest.mouse_filter = Control.MOUSE_FILTER_IGNORE
	crest.add_theme_stylebox_override(
		"panel",
		_make_style(
			Color(
				accent.r * 0.13,
				accent.g * 0.13,
				accent.b * 0.13,
				0.98
			),
			COLOR_GOLD_BRIGHT,
			3,
			30,
			Color(accent.r, accent.g, accent.b, 0.34),
			10
		)
	)
	card.add_child(crest)

	var crest_inner: Panel = Panel.new()
	crest_inner.position = Vector2(8.0, 8.0)
	crest_inner.size = Vector2(44.0, 44.0)
	crest_inner.mouse_filter = Control.MOUSE_FILTER_IGNORE
	crest_inner.add_theme_stylebox_override(
		"panel",
		_make_style(
			Color(0.0, 0.0, 0.0, 0.0),
			Color(accent.r, accent.g, accent.b, 0.34),
			1,
			22
		)
	)
	crest.add_child(crest_inner)

	var name_plate: Panel = Panel.new()
	name_plate.position = Vector2(22.0, 313.0)
	name_plate.size = Vector2(286.0, 41.0)
	name_plate.mouse_filter = Control.MOUSE_FILTER_IGNORE
	name_plate.add_theme_stylebox_override(
		"panel",
		_make_style(
			Color(
				accent.r * 0.15,
				accent.g * 0.15,
				accent.b * 0.15,
				0.98
			),
			COLOR_GOLD_BRIGHT,
			2,
			9,
			Color(0.0, 0.0, 0.0, 0.56),
			5
		)
	)
	card.add_child(name_plate)
	name_plate.z_index = 20

	var name_label: Label = _create_label(
		name_plate,
		_tr(str(data.get("name", ""))),
		Vector2(7.0, 0.0),
		Vector2(272.0, 41.0),
		16,
		HORIZONTAL_ALIGNMENT_CENTER,
		Color("#FFF2D1")
	)
	name_label.add_theme_constant_override("outline_size", 2)
	name_label.add_theme_color_override(
		"font_outline_color",
		Color(0.0, 0.0, 0.0, 0.84)
	)

	var description_strip: Panel = Panel.new()
	description_strip.position = Vector2(20.0, 362.0)
	description_strip.size = Vector2(290.0, 42.0)
	description_strip.mouse_filter = Control.MOUSE_FILTER_IGNORE
	description_strip.add_theme_stylebox_override(
		"panel",
		_make_style(
			Color(0.0, 0.0, 0.0, 0.78),
			Color(accent.r, accent.g, accent.b, 0.18),
			1,
			9
		)
	)
	card.add_child(description_strip)
	description_strip.z_index = 20

	var description: Label = _create_label(
		description_strip,
		_tr(str(data.get("description", ""))),
		Vector2(14.0, 0.0),
		Vector2(262.0, 42.0),
		10,
		HORIZONTAL_ALIGNMENT_CENTER,
		Color("#EDE4D3")
	)
	description.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	description.clip_text = true
	description.add_theme_constant_override("line_spacing", 2)

	var stats_panel: Panel = Panel.new()
	stats_panel.position = Vector2(47.0, 409.0)
	stats_panel.size = Vector2(236.0, 70.0)
	stats_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	stats_panel.add_theme_stylebox_override(
		"panel",
		_make_style(
			Color(0.0, 0.0, 0.0, 0.94),
			Color(accent.r, accent.g, accent.b, 0.84),
			2,
			13,
			Color(0.0, 0.0, 0.0, 0.54),
			5
		)
	)
	card.add_child(stats_panel)
	stats_panel.z_index = 20
	_create_stats_block(stats_panel, data, Vector2.ZERO, accent)

	var role_label: Label = _create_label(
		card,
		_tr(str(data.get("role", ""))),
		Vector2(26.0, 484.0),
		Vector2(278.0, 18.0),
		13,
		HORIZONTAL_ALIGNMENT_CENTER,
		accent
	)
	role_label.add_theme_constant_override("outline_size", 2)
	role_label.add_theme_color_override(
		"font_outline_color",
		Color(0.0, 0.0, 0.0, 0.92)
	)

	var ability_plate: Panel = Panel.new()
	ability_plate.position = Vector2(34.0, 507.0)
	ability_plate.size = Vector2(262.0, 23.0)
	ability_plate.mouse_filter = Control.MOUSE_FILTER_IGNORE
	ability_plate.add_theme_stylebox_override(
		"panel",
		_make_style(
			Color(
				accent.r * 0.10,
				accent.g * 0.10,
				accent.b * 0.10,
				0.98
			),
			COLOR_GOLD_BRIGHT,
			2,
			7
		)
	)
	card.add_child(ability_plate)
	ability_plate.z_index = 20

	_create_label(
		ability_plate,
		"✦",
		Vector2(8.0, 0.0),
		Vector2(24.0, 23.0),
		10,
		HORIZONTAL_ALIGNMENT_CENTER,
		accent
	)
	_create_label(
		ability_plate,
		_tr(str(data.get("ability_name", ""))),
		Vector2(32.0, 0.0),
		Vector2(222.0, 23.0),
		10,
		HORIZONTAL_ALIGNMENT_CENTER,
		COLOR_GOLD_BRIGHT
	)

	card.pressed.connect(_on_character_pressed.bind(index))
	card.mouse_entered.connect(_on_selectable_entered.bind(index))
	card.mouse_exited.connect(_on_selectable_exited.bind(index))

func _create_card_fades(card: Control) -> void:

	if card == null:
		return


func _load_paladin_idle_frames() -> Array:
	if not paladin_idle_frames.is_empty():
		return paladin_idle_frames

	var naming_sets: Array[Dictionary] = [
		{"prefix":"paladin idle ", "suffix":".png"},
		{"prefix":"paladin_idle_", "suffix":".png"},
		{"prefix":"paladin-idle-", "suffix":".png"},
		{"prefix":"Paladin", "suffix":".png"},
		{"prefix":"Paladin_", "suffix":".png"},
		{"prefix":"idle_", "suffix":".png"},
		{"prefix":"", "suffix":".png"}
	]

	for naming: Dictionary in naming_sets:
		for index: int in range(1, PALADIN_IDLE_MAX_FRAMES + 1):
			var candidate_path: String = "%s/%s%d%s" % [
				PALADIN_IDLE_FOLDER,
				str(naming.get("prefix", "")),
				index,
				str(naming.get("suffix", ".png"))
			]
			if ResourceLoader.exists(candidate_path):
				var texture: Texture2D = load(candidate_path) as Texture2D
				if texture != null and not paladin_idle_frames.has(texture):
					paladin_idle_frames.append(texture)
		if paladin_idle_frames.size() >= 2:
			break

	if paladin_idle_frames.is_empty() and ResourceLoader.exists(PALADIN_TEXTURE_PATH):
		var fallback_texture: Texture2D = load(PALADIN_TEXTURE_PATH) as Texture2D
		if fallback_texture != null:
			paladin_idle_frames.append(fallback_texture)

	return paladin_idle_frames

func _process_paladin_idle_animation(delta: float) -> void:
	if paladin_idle_sprites.is_empty():
		return

	var frames: Array = _load_paladin_idle_frames()
	if frames.size() <= 1:
		return

	paladin_idle_time += delta
	if paladin_idle_time < PALADIN_IDLE_FRAME_SECONDS:
		return

	paladin_idle_time = 0.0
	paladin_idle_frame_index = (paladin_idle_frame_index + 1) % frames.size()

	for sprite: Sprite2D in paladin_idle_sprites:
		if is_instance_valid(sprite):
			sprite.texture = frames[paladin_idle_frame_index]
			sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST

func _create_paladin_static_art(portrait_panel: Control) -> void:
	if not ResourceLoader.exists(PALADIN_TEXTURE_PATH):
		var missing_label: Label = _create_label(
			portrait_panel,
			_tr("NO SE ENCONTRÓ\nPALADIN1.PNG"),
			Vector2.ZERO,
			portrait_panel.size,
			13,
			HORIZONTAL_ALIGNMENT_CENTER,
			Color("#FF8F8F")
		)
		missing_label.add_theme_constant_override("outline_size", 2)
		return

	var frames: Array = _load_paladin_idle_frames()
	if frames.is_empty():
		push_warning("No se pudieron cargar los frames idle del Paladín.")
		return

	var final_texture: Texture2D = frames[0]
	var source_image: Image = final_texture.get_image()

	if source_image != null:
		var used_rect: Rect2i = source_image.get_used_rect()
		if used_rect.size.x > 0 and used_rect.size.y > 0:
			var cropped_image: Image = source_image.get_region(used_rect)
			if cropped_image != null:
				final_texture = ImageTexture.create_from_image(cropped_image)

	var light_column: ColorRect = _create_color_rect(
		portrait_panel,
		Vector2(92.0, 10.0),
		Vector2(116.0, 296.0),
		Color(0.45, 0.70, 1.0, 0.052)
	)
	light_column.mouse_filter = Control.MOUSE_FILTER_IGNORE

	var halo: Panel = Panel.new()
	halo.position = Vector2(48.0, 24.0)
	halo.size = Vector2(204.0, 204.0)
	halo.mouse_filter = Control.MOUSE_FILTER_IGNORE
	halo.add_theme_stylebox_override(
		"panel",
		_make_style(
			Color(0.10, 0.18, 0.30, 0.17),
			Color(0.80, 0.91, 1.0, 0.36),
			2,
			102,
			Color(0.46, 0.72, 1.0, 0.17),
			18
		)
	)
	portrait_panel.add_child(halo)

	var halo_inner: Panel = Panel.new()
	halo_inner.position = Vector2(14.0, 14.0)
	halo_inner.size = Vector2(176.0, 176.0)
	halo_inner.mouse_filter = Control.MOUSE_FILTER_IGNORE
	halo_inner.add_theme_stylebox_override(
		"panel",
		_make_style(
			Color(0.0, 0.0, 0.0, 0.0),
			Color(0.69, 0.84, 1.0, 0.18),
			1,
			88
		)
	)
	halo.add_child(halo_inner)

	var floor_shadow: Panel = Panel.new()
	floor_shadow.position = Vector2(54.0, 303.0)
	floor_shadow.size = Vector2(192.0, 14.0)
	floor_shadow.mouse_filter = Control.MOUSE_FILTER_IGNORE
	floor_shadow.add_theme_stylebox_override(
		"panel",
		_make_style(
			Color(0.0, 0.0, 0.0, 0.46),
			Color(0.0, 0.0, 0.0, 0.0),
			0,
			7
		)
	)
	portrait_panel.add_child(floor_shadow)

	var paladin_sprite: Sprite2D = Sprite2D.new()
	paladin_sprite.name = "Paladin1"
	paladin_sprite.texture = final_texture
	paladin_sprite.centered = true
	paladin_sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	paladin_sprite.z_index = 5

	var texture_size: Vector2 = final_texture.get_size()
	if texture_size.x > 0.0 and texture_size.y > 0.0:
		var available_size: Vector2 = Vector2(
			portrait_panel.size.x - 18.0,
			portrait_panel.size.y - 10.0
		)
		var scale_factor: float = min(
			available_size.x / texture_size.x,
			available_size.y / texture_size.y
		)
		var boosted_scale: float = scale_factor * 1.03
		var scaled_size: Vector2 = texture_size * boosted_scale
		if scaled_size.y > portrait_panel.size.y - 6.0:
			boosted_scale = (portrait_panel.size.y - 6.0) / texture_size.y
			scaled_size = texture_size * boosted_scale
		if scaled_size.x > portrait_panel.size.x - 8.0:
			boosted_scale = min(boosted_scale, (portrait_panel.size.x - 8.0) / texture_size.x)
			scaled_size = texture_size * boosted_scale

		paladin_sprite.scale = Vector2.ONE * boosted_scale
		paladin_sprite.position = Vector2(
			portrait_panel.size.x * 0.5,
			portrait_panel.size.y - 2.0 - scaled_size.y * 0.5
		)
	else:
		paladin_sprite.position = Vector2(
			portrait_panel.size.x * 0.5,
			portrait_panel.size.y * 0.5
		)

	portrait_panel.add_child(paladin_sprite)
	if not paladin_idle_sprites.has(paladin_sprite):
		paladin_idle_sprites.append(paladin_sprite)

func _create_paladin_animation(parent: Control) -> void:

	_create_paladin_static_art(parent)

func _create_checker_removal_material() -> ShaderMaterial:

	var checker_shader: Shader = Shader.new()
	checker_shader.code = """
shader_type canvas_item;
void fragment() {
	COLOR = texture(TEXTURE, UV);
}
"""

	var checker_material: ShaderMaterial = ShaderMaterial.new()
	checker_material.shader = checker_shader
	return checker_material

func _create_sigil_placeholder(
	parent: Control,
	_reserved_symbol: String,
	accent: Color
) -> void:

	for stripe_index in range(9):
		var stripe_alpha: float = 0.026 + float(stripe_index) * 0.005
		_create_color_rect(
			parent,
			Vector2(27.0 + float(stripe_index) * 27.0, 30.0),
			Vector2(2.0, 246.0),
			Color(accent.r, accent.g, accent.b, stripe_alpha)
		)

	var ring_shadow: Panel = Panel.new()
	ring_shadow.position = Vector2(63.0, 50.0)
	ring_shadow.size = Vector2(174.0, 174.0)
	ring_shadow.mouse_filter = Control.MOUSE_FILTER_IGNORE
	ring_shadow.add_theme_stylebox_override(
		"panel",
		_make_style(
			Color(0.0, 0.0, 0.0, 0.36),
			Color(0.0, 0.0, 0.0, 0.0),
			0,
			92,
			Color(accent.r, accent.g, accent.b, 0.28),
			18
		)
	)
	parent.add_child(ring_shadow)

	var ring: Panel = Panel.new()
	ring.name = "FuturePortraitSlot"
	ring.position = Vector2(67.0, 46.0)
	ring.size = Vector2(166.0, 166.0)
	ring.mouse_filter = Control.MOUSE_FILTER_IGNORE
	ring.add_theme_stylebox_override(
		"panel",
		_make_style(
			Color(
				accent.r * 0.10,
				accent.g * 0.10,
				accent.b * 0.10,
				0.72
			),
			accent,
			2,
			88,
			Color(accent.r, accent.g, accent.b, 0.18),
			13
		)
	)
	parent.add_child(ring)

	var inner_ring: Panel = Panel.new()
	inner_ring.position = Vector2(13.0, 13.0)
	inner_ring.size = Vector2(140.0, 140.0)
	inner_ring.mouse_filter = Control.MOUSE_FILTER_IGNORE
	inner_ring.add_theme_stylebox_override(
		"panel",
		_make_style(
			Color(0.0, 0.0, 0.0, 0.0),
			Color(accent.r, accent.g, accent.b, 0.34),
			1,
			74
		)
	)
	ring.add_child(inner_ring)

	_create_label(
		parent,
		_tr("RETRATO EN DESARROLLO"),
		Vector2(40.0, 270.0),
		Vector2(220.0, 20.0),
		8,
		HORIZONTAL_ALIGNMENT_CENTER,
		Color(accent.r, accent.g, accent.b, 0.72)
	)

func _create_stats_block(
	parent: Control,
	data: Dictionary,
	block_position: Vector2,
	accent: Color
) -> void:
	var stats: Dictionary = data.get("stats", {})
	var entries: Array[Dictionary] = [
		{
			"title": _tr("VIDA"),
			"value": int(stats.get("VIDA", 0))
		},
		{
			"title": _tr("DAÑO"),
			"value": int(stats.get("DAÑO", 0))
		},
		{
			"title": "DEF",
			"value": _calculate_defense_value(stats)
		}
	]

	for index in range(entries.size()):
		var entry: Dictionary = entries[index]
		var row_y: float = block_position.y + 7.0 + float(index) * 19.0

		var title_label: Label = _create_label(
			parent,
			str(entry.get("title", "")),
			Vector2(16.0, row_y),
			Vector2(46.0, 15.0),
			11,
			HORIZONTAL_ALIGNMENT_LEFT,
			COLOR_GOLD
		)
		title_label.add_theme_constant_override("outline_size", 1)
		title_label.add_theme_color_override(
			"font_outline_color",
			Color(0.0, 0.0, 0.0, 0.86)
		)

		var stars_label: Label = _create_label(
			parent,
			_create_stars(int(entry.get("value", 0))),
			Vector2(62.0, row_y - 1.0),
			Vector2(parent.size.x - 78.0, 16.0),
			12,
			HORIZONTAL_ALIGNMENT_RIGHT,
			COLOR_GOLD_BRIGHT
		)
		stars_label.add_theme_constant_override("outline_size", 2)
		stars_label.add_theme_color_override(
			"font_outline_color",
			Color(accent.r * 0.15, accent.g * 0.15, accent.b * 0.15, 0.95)
		)

		if index < entries.size() - 1:
			_create_color_rect(
				parent,
				Vector2(14.0, row_y + 16.0),
				Vector2(parent.size.x - 28.0, 1.0),
				Color(accent.r, accent.g, accent.b, 0.14)
			)

func _calculate_defense_value(stats: Dictionary) -> int:
	var life: int = int(stats.get("VIDA", 0))
	var speed: int = int(stats.get("VELOCIDAD", 0))

	return clampi(
		int(
			round(
				float(life) * 0.75
				+ float(speed) * 0.25
			)
		),
		1,
		5
	)

func _on_character_pressed(index: int) -> void:
	if transition_locked:
		return

	if index < 0 or index >= champions.size():
		return

	selected_character_index = index

	for card_index in range(selectable_buttons.size()):
		_apply_selectable_style(
			card_index,
			card_index == index
		)

	status_label.text = (
		_tr("%s ha respondido a tu llamada.")
		% _tr(
			str(
				champions[index].get(
					"name",
					"El campeón"
				)
			)
		)
	)
	confirm_button.disabled = false

func _create_status_and_buttons(
	initial_text: String,
	status_position: Vector2,
	status_size: Vector2,
	back_position: Vector2,
	confirm_position: Vector2
) -> void:
	status_label = _create_label(
		main_frame,
		initial_text,
		status_position + Vector2(0.0, 2.0),
		status_size - Vector2(0.0, 4.0),
		15,
		HORIZONTAL_ALIGNMENT_CENTER,
		Color("#EFE5CF")
	)
	back_button = _create_action_button(
		_tr("VOLVER"),
		back_position,
		false
	)
	back_button.pressed.connect(_on_back_pressed)

	confirm_button = _create_action_button(
		_tr("CONFIRMAR"),
		confirm_position,
		true
	)
	confirm_button.disabled = true
	confirm_button.pressed.connect(_on_confirm_pressed)

func _create_action_button(
	button_text: String,
	button_position: Vector2,
	_primary: bool
) -> Button:
	var button: Button = Button.new()
	button.text = button_text
	button.position = button_position
	button.size = Vector2(240.0, 44.0)
	button.focus_mode = Control.FOCUS_NONE
	button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	button.add_theme_font_size_override("font_size", 16)

	var normal_background: Color = Color(0.040, 0.055, 0.083, 0.98)
	var normal_border: Color = Color(0.72, 0.56, 0.22, 0.95)

	if _primary:
		normal_background = Color(0.12, 0.085, 0.025, 0.98)
		normal_border = COLOR_GOLD

	var normal_style: StyleBoxFlat = _make_style(
		normal_background,
		normal_border,
		2,
		11
	)
	var hover_style: StyleBoxFlat = _make_style(
		Color(0.15, 0.10, 0.035, 0.99),
		COLOR_GOLD_BRIGHT,
		2,
		11
	)
	var pressed_style: StyleBoxFlat = _make_style(
		Color(0.085, 0.055, 0.018, 1.0),
		COLOR_GOLD_BRIGHT,
		3,
		11
	)
	var disabled_style: StyleBoxFlat = _make_style(
		Color(0.025, 0.030, 0.043, 0.92),
		Color("#413B30"),
		1,
		11
	)

	button.add_theme_stylebox_override("normal", normal_style)
	button.add_theme_stylebox_override("hover", hover_style)
	button.add_theme_stylebox_override("pressed", pressed_style)
	button.add_theme_stylebox_override("disabled", disabled_style)
	button.add_theme_stylebox_override("focus", normal_style)

	button.add_theme_color_override("font_color", COLOR_TEXT)
	button.add_theme_color_override("font_hover_color", Color.WHITE)
	button.add_theme_color_override("font_pressed_color", COLOR_GOLD_BRIGHT)
	button.add_theme_color_override("font_disabled_color", COLOR_DISABLED)

	main_frame.add_child(button)
	return button

func _on_back_pressed() -> void:
	if transition_locked:
		return

	if current_mode == ScreenMode.CHARACTER:
		_change_scene(
			FACTION_SCENE_PATH,
			_tr("No se pudo volver a la selección de facción.")
		)
	else:
		_change_scene(
			MENU_SCENE_PATH,
			_tr("No se pudo volver al menú principal.")
		)

func _on_confirm_pressed() -> void:
	if transition_locked:
		return

	if current_mode == ScreenMode.CHARACTER:
		_confirm_character()
	else:
		_confirm_faction()

func _confirm_faction() -> void:
	if selected_faction.is_empty():
		return

	_lock_interface(
		_tr("El destino ha sellado tu juramento...")
	)
	_save_faction(selected_faction)

	await get_tree().create_timer(0.35).timeout

	if is_inside_tree():
		_change_scene(
			CHARACTER_SCENE_PATH,
			_tr("No se pudo abrir la selección de personaje.")
		)

func _confirm_character() -> void:
	if (
		selected_character_index < 0
		or selected_character_index >= champions.size()
	):
		return

	var data: Dictionary = champions[selected_character_index]

	_lock_interface(
		_tr("El destino ha elegido a %s...")
		% _tr(
			str(
				data.get(
					"name",
					"tu campeón"
				)
			)
		)
	)
	_save_character(data)

	await get_tree().create_timer(0.45).timeout

	if is_inside_tree():
		_change_scene(
			MAIN_SCENE_PATH,
			_tr("No se pudo iniciar la aventura.")
		)

func _lock_interface(message: String) -> void:
	transition_locked = true
	status_label.text = message
	confirm_button.disabled = true
	back_button.disabled = true

	for button in selectable_buttons:
		button.disabled = true

func _unlock_interface(error_message: String) -> void:
	transition_locked = false
	status_label.text = error_message
	back_button.disabled = false

	for button in selectable_buttons:
		button.disabled = false

	if current_mode == ScreenMode.FACTION:
		confirm_button.disabled = selected_faction.is_empty()
	else:
		confirm_button.disabled = selected_character_index < 0

func _change_scene(path: String, error_message: String) -> void:
	if not ResourceLoader.exists(path):
		push_error(_tr("No se encontró la escena: ") + path)
		_unlock_interface(error_message)
		return

	var change_error: Error = get_tree().change_scene_to_file(path)

	if change_error != OK:
		push_error(error_message)
		_unlock_interface(error_message)

func _save_faction(faction_id: String) -> void:
	var normalized: String = _normalize_faction(faction_id)
	var legacy_value: String = "luz"

	if normalized == "umbral":
		legacy_value = "oscuro"

	get_tree().set_meta("faccion_elegida", normalized)
	get_tree().set_meta("faccion_juego", legacy_value)

	_write_faction_file(
		SAVE_PATH,
		normalized,
		legacy_value
	)
	_write_faction_file(
		SELECTION_SAVE_PATH,
		normalized,
		legacy_value
	)

func _write_faction_file(
	path: String,
	faction_id: String,
	legacy_value: String
) -> void:
	var config: ConfigFile = ConfigFile.new()
	config.load(path)

	config.set_value("jugador", "faccion", legacy_value)
	config.set_value("seleccion", "faccion", faction_id)
	config.set_value("faccion", "seleccionada", faction_id)

	var save_error: Error = config.save(path)

	if save_error != OK:
		push_warning(_tr("No se pudo guardar la facción en: ") + path)

func _load_faction() -> String:
	var possible_paths: Array[String] = [
		SAVE_PATH,
		SELECTION_SAVE_PATH
	]

	for path in possible_paths:
		var config: ConfigFile = ConfigFile.new()

		if config.load(path) != OK:
			continue

		var possible_locations: Array[Array] = [
			["seleccion", "faccion"],
			["faccion", "seleccionada"],
			["jugador", "faccion"],
			["partida", "faccion"],
			["faccion", "nombre"]
		]

		for location in possible_locations:
			var section_name: String = str(location[0])
			var key_name: String = str(location[1])

			if config.has_section_key(section_name, key_name):
				return _normalize_faction(
					str(
						config.get_value(
							section_name,
							key_name,
							""
						)
					)
				)

	return "alba"

func _normalize_faction(raw_value: String) -> String:
	var value: String = raw_value.to_lower().strip_edges()

	if (
		value.contains("umbral")
		or value.contains("osc")
		or value.contains("som")
		or value.contains("mal")
	):
		return "umbral"

	return "alba"

func _select_champion_list() -> void:
	if selected_faction == "umbral":
		champions = dark_champions
	else:
		champions = light_champions

func _save_character(data: Dictionary) -> void:
	var config: ConfigFile = ConfigFile.new()
	config.load(SAVE_PATH)

	var legacy_faction: String = "luz"

	if selected_faction == "umbral":
		legacy_faction = "oscuro"

	config.set_value("jugador", "faccion", legacy_faction)
	config.set_value("seleccion", "faccion", selected_faction)
	config.set_value("jugador", "personaje", str(data.get("id", "")))
	config.set_value("jugador", "nombre_personaje", str(data.get("name", "")))
	config.set_value("jugador", "clase", str(data.get("role", "")))

	config.set_value("mapa", "zona_actual", SistemaRegiones.ZONA_VALDORIA)
	SistemaRegiones.escribir_estado_zona(
		config,
		SistemaRegiones.ZONA_VALDORIA,
		1,
		false,
		true
	)
	SistemaRegiones.escribir_estado_zona(
		config,
		SistemaRegiones.ZONA_BRUMA,
		1,
		false,
		false
	)
	config.set_value("mundos", "mundo_2_desbloqueado", false)

	var stats: Dictionary = data.get("stats", {})
	var defense: int = _calculate_defense_value(stats)

	config.set_value("personaje", "vida_estrellas", int(stats.get("VIDA", 0)))
	config.set_value("personaje", "daño_estrellas", int(stats.get("DAÑO", 0)))
	config.set_value("personaje", "defensa_estrellas", defense)

	config.set_value(
		"personaje",
		"velocidad_estrellas",
		int(stats.get("VELOCIDAD", 0))
	)
	config.set_value(
		"personaje",
		"magia_estrellas",
		int(stats.get("MAGIA", 0))
	)

	var save_error: Error = config.save(SAVE_PATH)

	if save_error != OK:
		push_warning(_tr("No se pudo guardar el personaje seleccionado."))

func _apply_selectable_style(
	index: int,
	selected: bool
) -> void:
	if index < 0 or index >= selectable_buttons.size():
		return

	var button: Button = selectable_buttons[index]
	var background: Color = button.get_meta("background", COLOR_CARD)
	var hover: Color = button.get_meta("hover", COLOR_CARD_HOVER)
	var accent: Color = button.get_meta("accent", COLOR_GOLD)

	var border: Color = COLOR_GOLD
	var border_width: int = 3
	var shadow_color: Color = Color(0.0, 0.0, 0.0, 0.58)
	var shadow_size: int = 10

	if selected:
		background = hover
		border = COLOR_SELECTED
		border_width = 5
		shadow_color = Color(
			accent.r,
			accent.g,
			accent.b,
			0.30
		)
		shadow_size = 17

	var normal_style: StyleBoxFlat = _make_style(
		background,
		border,
		border_width,
		22,
		shadow_color,
		shadow_size,
		Vector2(0.0, 5.0)
	)
	var hover_style: StyleBoxFlat = _make_style(
		hover,
		COLOR_GOLD_BRIGHT,
		3,
		22,
		Color(
			COLOR_GOLD_BRIGHT.r,
			COLOR_GOLD_BRIGHT.g,
			COLOR_GOLD_BRIGHT.b,
			0.22
		),
		14,
		Vector2(0.0, 5.0)
	)
	var pressed_style: StyleBoxFlat = _make_style(
		hover.darkened(0.08),
		COLOR_SELECTED,
		3,
		22,
		Color(
			COLOR_GOLD_BRIGHT.r,
			COLOR_GOLD_BRIGHT.g,
			COLOR_GOLD_BRIGHT.b,
			0.28
		),
		15,
		Vector2(0.0, 5.0)
	)

	button.add_theme_stylebox_override("normal", normal_style)
	button.add_theme_stylebox_override("hover", hover_style)
	button.add_theme_stylebox_override("pressed", pressed_style)
	button.add_theme_stylebox_override("focus", normal_style)

	var target_scale: Vector2 = Vector2.ONE
	var target_offset_y: float = 0.0

	if selected:
		target_scale = Vector2(1.024, 1.024)
		target_offset_y = -5.0

	_animate_selectable(
		index,
		target_scale,
		target_offset_y
	)

	if index < selectable_glows.size():
		var glow: ColorRect = selectable_glows[index]

		if selected:
			glow.color = Color(
				accent.r,
				accent.g,
				accent.b,
				0.08
			)
		else:
			glow.color = Color(
				accent.r,
				accent.g,
				accent.b,
				0.0
			)

func _on_selectable_entered(index: int) -> void:
	if transition_locked:
		return

	if index < 0 or index >= selectable_buttons.size():
		return

	var button: Button = selectable_buttons[index]
	var is_selected: bool = false

	if current_mode == ScreenMode.FACTION:
		is_selected = (
			str(button.get_meta("id", ""))
			== selected_faction
		)
	else:
		is_selected = index == selected_character_index

	if not is_selected:
		_animate_selectable(
			index,
			Vector2(1.012, 1.012),
			-3.0
		)

func _on_selectable_exited(index: int) -> void:
	if index < 0 or index >= selectable_buttons.size():
		return

	var button: Button = selectable_buttons[index]
	var is_selected: bool = false

	if current_mode == ScreenMode.FACTION:
		is_selected = (
			str(button.get_meta("id", ""))
			== selected_faction
		)
	else:
		is_selected = index == selected_character_index

	if is_selected:
		_animate_selectable(
			index,
			Vector2(1.024, 1.024),
			-5.0
		)
	else:
		_animate_selectable(
			index,
			Vector2.ONE,
			0.0
		)

func _animate_selectable(
	index: int,
	target_scale: Vector2,
	target_offset_y: float
) -> void:
	if index < 0 or index >= selectable_buttons.size():
		return

	var button: Button = selectable_buttons[index]
	var base_position: Vector2 = button.get_meta(
		"base_position",
		button.position
	)

	var tween: Tween = create_tween()
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(
		button,
		"scale",
		target_scale,
		0.16
	)
	tween.parallel().tween_property(
		button,
		"position",
		base_position + Vector2(0.0, target_offset_y),
		0.16
	)

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
	text: String,
	node_position: Vector2,
	node_size: Vector2,
	font_size: int,
	alignment: HorizontalAlignment,
	color: Color
) -> Label:
	var label: Label = Label.new()
	label.text = text
	label.position = node_position
	label.size = node_size
	label.horizontal_alignment = alignment
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", color)
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	parent.add_child(label)
	return label

func _create_color_rect(
	parent: Control,
	node_position: Vector2,
	node_size: Vector2,
	color: Color
) -> ColorRect:
	var rect: ColorRect = ColorRect.new()
	rect.position = node_position
	rect.size = node_size
	rect.color = color
	rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	parent.add_child(rect)
	return rect

func _add_corner_ornaments(
	parent: Control,
	card_size: Vector2
) -> void:
	var pieces: Array[Dictionary] = [
		{
			"position": Vector2(18.0, 18.0),
			"size": Vector2(34.0, 2.0)
		},
		{
			"position": Vector2(18.0, 18.0),
			"size": Vector2(2.0, 34.0)
		},
		{
			"position": Vector2(card_size.x - 52.0, 18.0),
			"size": Vector2(34.0, 2.0)
		},
		{
			"position": Vector2(card_size.x - 20.0, 18.0),
			"size": Vector2(2.0, 34.0)
		},
		{
			"position": Vector2(18.0, card_size.y - 20.0),
			"size": Vector2(34.0, 2.0)
		},
		{
			"position": Vector2(18.0, card_size.y - 52.0),
			"size": Vector2(2.0, 34.0)
		},
		{
			"position": Vector2(card_size.x - 52.0, card_size.y - 20.0),
			"size": Vector2(34.0, 2.0)
		},
		{
			"position": Vector2(card_size.x - 20.0, card_size.y - 52.0),
			"size": Vector2(2.0, 34.0)
		}
	]
 
	for piece_data in pieces:
		_create_color_rect(
			parent,
			piece_data.get("position", Vector2.ZERO),
			piece_data.get("size", Vector2.ZERO),
			Color(
				COLOR_GOLD_BRIGHT.r,
				COLOR_GOLD_BRIGHT.g,
				COLOR_GOLD_BRIGHT.b,
				0.94
			)
		)
  



func _create_stars(value: int) -> String:
	var result: String = ""

	for index in range(5):
		if index < value:
			result += "★"
		else:
			result += "☆"

	return result
