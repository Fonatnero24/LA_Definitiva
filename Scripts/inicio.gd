extends Node

const SAVE_PATH: String = "user://partida.cfg"
const MENU_SCENE_PATH: String = "res://escenas/MenuPrincipal.tscn"
const GAME_SCENE_PATH: String = "res://escenas/main.tscn"

var _changing_scene: bool = false

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	call_deferred("_route_startup")

func _route_startup() -> void:
	if _changing_scene:
		return
	_open_scene(GAME_SCENE_PATH if _has_valid_saved_game() else MENU_SCENE_PATH)

func _has_valid_saved_game() -> bool:
	if not FileAccess.file_exists(SAVE_PATH):
		return false

	var config: ConfigFile = ConfigFile.new()
	if config.load(SAVE_PATH) != OK:
		return false

	var character_id: String = str(
		config.get_value("jugador", "personaje", "")
	).strip_edges()
	if not character_id.is_empty():
		return true

	var has_zone_progress: bool = (
		config.has_section_key("mapa", "zona_actual")
		or config.has_section_key("zonas", "fase_0_1")
		or config.has_section_key("zonas", "fase_0_2")
		or config.has_section_key("zonas", "fase_0_3")
		or config.has_section_key("mundo_1", "fase")
	)
	var has_player_progress: bool = (
		config.has_section_key("jugador", "nivel")
		or config.has_section_key("jugador", "experiencia")
		or config.has_section_key("jugador", "oro")
	)
	return has_zone_progress and has_player_progress

func _open_scene(scene_path: String) -> void:
	if _changing_scene:
		return
	if not ResourceLoader.exists(scene_path):
		push_error("No existe la escena inicial: " + scene_path)
		return

	_changing_scene = true
	var change_error: Error = get_tree().change_scene_to_file(scene_path)
	if change_error != OK:
		_changing_scene = false
		push_error(
			"No se pudo cargar la escena %s. Código: %s"
			% [scene_path, str(change_error)]
		)
