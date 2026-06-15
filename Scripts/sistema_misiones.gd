
extends Node
class_name SistemaMisiones

signal missions_changed
signal mission_completed(mission_id: String)
signal reward_claimed(mission_id: String, reward: Dictionary)

const SAVE_PATH: String = "user://misiones.cfg"

var main_controller: Node
var inventory_ui: Node
var progress: Dictionary = {}
var claimed: Dictionary = {}
var current_language: String = "es"

const MISSIONS: Array[Dictionary] = [
	{"id":"v_kill_10","zone":"0-1","title_es":"Limpiar el sendero","title_en":"Clear the Road","desc_es":"Derrota 10 enemigos en la Ruta de Valdoria.","desc_en":"Defeat 10 enemies on the Valdoria Route.","event":"kill","target":10,"reward":{"gold":250}},
	{"id":"v_kill_50","zone":"0-1","title_es":"La ruta no se rinde","title_en":"The Road Endures","desc_es":"Derrota 50 enemigos en Valdoria.","desc_en":"Defeat 50 enemies in Valdoria.","event":"kill","target":50,"reward":{"gold":900,"chest":"raro"}},
	{"id":"v_kill_150","zone":"0-1","title_es":"Guardián del camino","title_en":"Guardian of the Road","desc_es":"Derrota 150 enemigos en Valdoria.","desc_en":"Defeat 150 enemies in Valdoria.","event":"kill","target":150,"reward":{"gold":3000,"chest":"epico"}},
	{"id":"v_phase_25","zone":"0-1","title_es":"Primer horizonte","title_en":"First Horizon","desc_es":"Alcanza la fase 25 de Valdoria.","desc_en":"Reach stage 25 in Valdoria.","event":"phase","target":25,"reward":{"gold":875,"chest":"poco_comun"}},
	{"id":"v_phase_50","zone":"0-1","title_es":"Mitad del juramento","title_en":"Halfway Through the Oath","desc_es":"Alcanza la fase 50 de Valdoria.","desc_en":"Reach stage 50 in Valdoria.","event":"phase","target":50,"reward":{"gold":1750,"chest":"raro"}},
	{"id":"v_phase_75","zone":"0-1","title_es":"La última colina","title_en":"The Last Hill","desc_es":"Alcanza la fase 75 de Valdoria.","desc_en":"Reach stage 75 in Valdoria.","event":"phase","target":75,"reward":{"gold":2625,"chest":"epico"}},
	{"id":"v_phase_100","zone":"0-1","title_es":"La ruta liberada","title_en":"The Liberated Road","desc_es":"Alcanza la fase 100 de Valdoria.","desc_en":"Reach stage 100 in Valdoria.","event":"phase","target":100,"reward":{"gold":3500,"chest":"epico"}},
	{"id":"v_elite_8","zone":"0-1","title_es":"Cazador de élites","title_en":"Elite Hunter","desc_es":"Derrota 8 enemigos de élite en Valdoria.","desc_en":"Defeat 8 elite enemies in Valdoria.","event":"elite","target":8,"reward":{"gold":1800,"chest":"raro"}},
	{"id":"v_secret","zone":"0-1","title_es":"El mito entre los árboles","title_en":"The Myth Among the Trees","desc_es":"Derrota un jefe secreto en Valdoria.","desc_en":"Defeat a secret boss in Valdoria.","event":"secret_boss","target":1,"reward":{"gold":3500,"chest":"legendario"}},
	{"id":"v_complete","zone":"0-1","title_es":"Juramento cumplido","title_en":"Oath Fulfilled","desc_es":"Completa 0-1 · Ruta de Valdoria.","desc_en":"Complete 0-1 · Valdoria Route.","event":"zone_complete","target":1,"reward":{"gold":5000,"chest":"epico","skill_points":1}},
	{"id":"b_kill_25","zone":"0-2","title_es":"Ecos entre la niebla","title_en":"Echoes in the Mist","desc_es":"Derrota 25 enemigos en el Paso de la Bruma.","desc_en":"Defeat 25 enemies in the Mist Pass.","event":"kill","target":25,"reward":{"gold":900}},
	{"id":"b_kill_100","zone":"0-2","title_es":"Romper el velo","title_en":"Break the Veil","desc_es":"Derrota 100 enemigos en la Bruma.","desc_en":"Defeat 100 enemies in the Mist.","event":"kill","target":100,"reward":{"gold":4000,"chest":"epico"}},
	{"id":"b_kill_250","zone":"0-2","title_es":"Silencio en la niebla","title_en":"Silence in the Mist","desc_es":"Derrota 250 enemigos en la Bruma.","desc_en":"Defeat 250 enemies in the Mist.","event":"kill","target":250,"reward":{"gold":9000,"chest":"legendario"}},
	{"id":"b_phase_25","zone":"0-2","title_es":"Tras la estatua rota","title_en":"Beyond the Broken Statue","desc_es":"Alcanza la fase 25 del Paso de la Bruma.","desc_en":"Reach stage 25 in the Mist Pass.","event":"phase","target":25,"reward":{"gold":1375,"chest":"raro"}},
	{"id":"b_phase_50","zone":"0-2","title_es":"La fortaleza olvidada","title_en":"The Forgotten Fortress","desc_es":"Alcanza la fase 50 del Paso de la Bruma.","desc_en":"Reach stage 50 in the Mist Pass.","event":"phase","target":50,"reward":{"gold":2750,"chest":"epico"}},
	{"id":"b_phase_75","zone":"0-2","title_es":"Donde muere la luz","title_en":"Where Light Dies","desc_es":"Alcanza la fase 75 del Paso de la Bruma.","desc_en":"Reach stage 75 in the Mist Pass.","event":"phase","target":75,"reward":{"gold":4125,"chest":"epico"}},
	{"id":"b_phase_100","zone":"0-2","title_es":"Señor de la Bruma","title_en":"Master of the Mist","desc_es":"Alcanza la fase 100 del Paso de la Bruma.","desc_en":"Reach stage 100 in the Mist Pass.","event":"phase","target":100,"reward":{"gold":5500,"chest":"legendario"}},
	{"id":"b_elite_12","zone":"0-2","title_es":"Verdugo de sombras","title_en":"Shadow Executioner","desc_es":"Derrota 12 élites en la Bruma.","desc_en":"Defeat 12 elites in the Mist.","event":"elite","target":12,"reward":{"gold":5000,"chest":"epico"}},
	{"id":"b_secret","zone":"0-2","title_es":"Leyenda oculta","title_en":"Hidden Legend","desc_es":"Derrota un jefe secreto en la Bruma.","desc_en":"Defeat a secret boss in the Mist.","event":"secret_boss","target":1,"reward":{"gold":7000,"chest":"legendario"}},
	{"id":"b_complete","zone":"0-2","title_es":"El velo desgarrado","title_en":"The Torn Veil","desc_es":"Completa 0-2 · Paso de la Bruma.","desc_en":"Complete 0-2 · Mist Pass.","event":"zone_complete","target":1,"reward":{"gold":10000,"chest":"legendario","skill_points":2}},
	{"id":"e_kill_25","zone":"0-3","title_es":"Piedras que respiran","title_en":"Breathing Stones","desc_es":"Derrota 25 enemigos en las Ruinas de Elaris.","desc_en":"Defeat 25 enemies in the Ruins of Elaris.","event":"kill","target":25,"reward":{"gold":1600}},
	{"id":"e_kill_120","zone":"0-3","title_es":"Ecos de un reino muerto","title_en":"Echoes of a Dead Kingdom","desc_es":"Derrota 120 enemigos en Elaris.","desc_en":"Defeat 120 enemies in Elaris.","event":"kill","target":120,"reward":{"gold":7500,"chest":"legendario"}},
	{"id":"e_kill_300","zone":"0-3","title_es":"La ruina te reconoce","title_en":"The Ruin Knows You","desc_es":"Derrota 300 enemigos en Elaris.","desc_en":"Defeat 300 enemies in Elaris.","event":"kill","target":300,"reward":{"gold":18000,"chest":"ancestral"}},
	{"id":"e_phase_25","zone":"0-3","title_es":"Bajo las runas","title_en":"Beneath the Runes","desc_es":"Alcanza la fase 25 de las Ruinas de Elaris.","desc_en":"Reach stage 25 in the Ruins of Elaris.","event":"phase","target":25,"reward":{"gold":2125,"chest":"epico"}},
	{"id":"e_phase_50","zone":"0-3","title_es":"La sala del veneno","title_en":"The Venom Hall","desc_es":"Alcanza la fase 50 de las Ruinas de Elaris.","desc_en":"Reach stage 50 in the Ruins of Elaris.","event":"phase","target":50,"reward":{"gold":4250,"chest":"legendario"}},
	{"id":"e_phase_75","zone":"0-3","title_es":"El trono sin memoria","title_en":"The Memoryless Throne","desc_es":"Alcanza la fase 75 de las Ruinas de Elaris.","desc_en":"Reach stage 75 in the Ruins of Elaris.","event":"phase","target":75,"reward":{"gold":6375,"chest":"legendario"}},
	{"id":"e_phase_100","zone":"0-3","title_es":"Corazón de Elaris","title_en":"Heart of Elaris","desc_es":"Alcanza la fase 100 de las Ruinas de Elaris.","desc_en":"Reach stage 100 in the Ruins of Elaris.","event":"phase","target":100,"reward":{"gold":8500,"chest":"ancestral"}},
	{"id":"e_elite_15","zone":"0-3","title_es":"Romper los sellos","title_en":"Break the Seals","desc_es":"Derrota 15 élites en Elaris.","desc_en":"Defeat 15 elites in Elaris.","event":"elite","target":15,"reward":{"gold":12000,"chest":"legendario"}},
	{"id":"e_secret","zone":"0-3","title_es":"Corona del olvido","title_en":"Crown of Oblivion","desc_es":"Derrota un jefe secreto en Elaris.","desc_en":"Defeat a secret boss in Elaris.","event":"secret_boss","target":1,"reward":{"gold":16000,"chest":"ancestral","skill_points":2}},
	{"id":"e_complete","zone":"0-3","title_es":"Las ruinas callan","title_en":"The Ruins Fall Silent","desc_es":"Completa 0-3 · Ruinas de Elaris.","desc_en":"Complete 0-3 · Ruins of Elaris.","event":"zone_complete","target":1,"reward":{"gold":25000,"chest":"ancestral","skill_points":4}},
	{"id":"gold_10000","zone":"all","title_es":"Fortuna del caminante","title_en":"Wanderer's Fortune","desc_es":"Ten 10.000 de oro al mismo tiempo.","desc_en":"Hold 10,000 gold at once.","event":"gold_balance","target":10000,"reward":{"chest":"epico"}},
	{"id":"gold_50000","zone":"all","title_es":"Mercader de leyenda","title_en":"Legendary Merchant","desc_es":"Ten 50.000 de oro al mismo tiempo.","desc_en":"Hold 50,000 gold at once.","event":"gold_balance","target":50000,"reward":{"gold":5000,"chest":"legendario"}},
	{"id":"gold_250000","zone":"all","title_es":"Tesoro de un reino","title_en":"A Kingdom's Treasure","desc_es":"Ten 250.000 de oro al mismo tiempo.","desc_en":"Hold 250,000 gold at once.","event":"gold_balance","target":250000,"reward":{"gold":25000,"chest":"ancestral","skill_points":2}},
	{"id":"gold_1000000","zone":"all","title_es":"Un millón de juramentos","title_en":"A Million Oaths","desc_es":"Ten 1.000.000 de oro al mismo tiempo.","desc_en":"Hold 1,000,000 gold at once.","event":"gold_balance","target":1000000,"reward":{"gold":100000,"chest":"ancestral","skill_points":5}},
	{"id":"chests_10","zone":"all","title_es":"Cazatesoros 10","title_en":"Treasure Hunter 10","desc_es":"Abre 10 cofres de cualquier origen.","desc_en":"Open 10 chests from any source.","event":"chest","target":10,"reward":{"gold":1200,"chest":"raro"}},
	{"id":"chests_50","zone":"all","title_es":"Cazatesoros 50","title_en":"Treasure Hunter 50","desc_es":"Abre 50 cofres de cualquier origen.","desc_en":"Open 50 chests from any source.","event":"chest","target":50,"reward":{"gold":6000,"chest":"epico"}},
	{"id":"chests_200","zone":"all","title_es":"Cazatesoros 200","title_en":"Treasure Hunter 200","desc_es":"Abre 200 cofres de cualquier origen.","desc_en":"Open 200 chests from any source.","event":"chest","target":200,"reward":{"gold":24000,"chest":"legendario"}},
	{"id":"chests_500","zone":"all","title_es":"Cazatesoros 500","title_en":"Treasure Hunter 500","desc_es":"Abre 500 cofres de cualquier origen.","desc_en":"Open 500 chests from any source.","event":"chest","target":500,"reward":{"gold":60000,"chest":"ancestral"}},
	{"id":"forge_5","zone":"all","title_es":"Forja: 5 creaciones","title_en":"Forge: 5 Creations","desc_es":"Forja 5 objetos de cualquier rareza.","desc_en":"Forge 5 items of any rarity.","event":"forge","target":5,"reward":{"gold":1500,"chest":"raro"}},
	{"id":"forge_20","zone":"all","title_es":"Forja: 20 creaciones","title_en":"Forge: 20 Creations","desc_es":"Forja 20 objetos de cualquier rareza.","desc_en":"Forge 20 items of any rarity.","event":"forge","target":20,"reward":{"gold":6000,"chest":"epico"}},
	{"id":"forge_75","zone":"all","title_es":"Forja: 75 creaciones","title_en":"Forge: 75 Creations","desc_es":"Forja 75 objetos de cualquier rareza.","desc_en":"Forge 75 items of any rarity.","event":"forge","target":75,"reward":{"gold":22500,"chest":"legendario"}},
	{"id":"forge_epic_3","zone":"all","title_es":"El fuego aprende tu nombre","title_en":"The Fire Learns Your Name","desc_es":"Forja 3 piezas épicas o superiores.","desc_en":"Forge 3 epic-or-better pieces.","event":"forge_epic","target":3,"reward":{"gold":6500,"chest":"legendario","skill_points":1}},
	{"id":"forge_epic_12","zone":"all","title_es":"Maestro de la forja","title_en":"Master of the Forge","desc_es":"Forja 12 piezas épicas o superiores.","desc_en":"Forge 12 epic-or-better pieces.","event":"forge_epic","target":12,"reward":{"gold":24000,"chest":"ancestral","skill_points":3}},
	{"id":"skills_10","zone":"all","title_es":"El arsenal invisible","title_en":"The Invisible Arsenal","desc_es":"Usa 10 habilidades activas equipadas.","desc_en":"Use 10 equipped active skills.","event":"skill_used","target":10,"reward":{"gold":1800,"chest":"raro"}},
	{"id":"skills_100","zone":"all","title_es":"Maestro de técnicas","title_en":"Master of Techniques","desc_es":"Usa 100 habilidades activas equipadas.","desc_en":"Use 100 equipped active skills.","event":"skill_used","target":100,"reward":{"gold":9000,"chest":"legendario","skill_points":2}},
	{"id":"status_50","zone":"all","title_es":"Alquimia de batalla","title_en":"Battle Alchemy","desc_es":"Aplica 50 estados alterados a enemigos.","desc_en":"Apply 50 status effects to enemies.","event":"status_inflicted","target":50,"reward":{"gold":5500,"chest":"epico"}},
	{"id":"poison_25","zone":"all","title_es":"Veneno en las venas","title_en":"Venom in Their Veins","desc_es":"Envenena enemigos 25 veces.","desc_en":"Poison enemies 25 times.","event":"poison_inflicted","target":25,"reward":{"gold":4000,"chest":"epico"}},
	{"id":"bleed_25","zone":"all","title_es":"El filo recuerda","title_en":"The Edge Remembers","desc_es":"Aplica sangrado 25 veces.","desc_en":"Apply bleeding 25 times.","event":"bleed_inflicted","target":25,"reward":{"gold":4000,"chest":"epico"}},
	{"id":"secret_5","zone":"all","title_es":"Cazador de mitos","title_en":"Myth Hunter","desc_es":"Derrota 5 jefes secretos.","desc_en":"Defeat 5 secret bosses.","event":"secret_boss","target":5,"reward":{"gold":30000,"chest":"ancestral","skill_points":4}},
	{"id":"hard_3","zone":"all","title_es":"El mundo contraataca","title_en":"The World Strikes Back","desc_es":"Completa 3 zonas en dificultad Difícil.","desc_en":"Complete 3 zones on Hard difficulty.","event":"hard_complete","target":3,"reward":{"gold":30000,"chest":"legendario","skill_points":3}},
	{"id":"inferno_3","zone":"all","title_es":"Caminar por el Inferno","title_en":"Walk Through Inferno","desc_es":"Completa 3 zonas en dificultad Inferno.","desc_en":"Complete 3 zones on Inferno difficulty.","event":"inferno_complete","target":3,"reward":{"gold":75000,"chest":"ancestral","skill_points":6}}
]

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	_load()
	call_deferred("_resolve_references")
	call_deferred("_sync_reconstructable_progress")

func setup(main_node: Node, inventory_node: Node) -> void:
	main_controller = main_node
	inventory_ui = inventory_node
	_sync_reconstructable_progress()

func set_language(language_code: String) -> void:
	current_language = "en" if language_code.to_lower().begins_with("en") else "es"
	missions_changed.emit()

func _resolve_references() -> void:
	if not is_instance_valid(main_controller):
		main_controller = get_parent()
	if not is_instance_valid(inventory_ui) and is_instance_valid(main_controller):
		inventory_ui = main_controller.find_child("InventarioUI", true, false)

func registrar_muerte(enemy_data: Dictionary, zone_id: String, _difficulty: String) -> void:
	_increment("kill", zone_id, 1)
	var rank: String = str(enemy_data.get("rank", "normal"))
	if rank == "elite":
		_increment("elite", zone_id, 1)
	if bool(enemy_data.get("secret_boss", false)) or rank == "secret_boss":
		_increment("secret_boss", zone_id, 1)
	_save_and_emit()

func registrar_fase(zone_id: String, phase: int) -> void:
	_set_max("phase", zone_id, phase)
	_save_and_emit()

func registrar_cofre(zone_id: String) -> void:
	_increment("chest", zone_id, 1)
	_save_and_emit()

func registrar_oro(amount: int) -> void:
	if amount <= 0:
		return
	_increment("gold_earned", "all", amount)
	_sync_gold_balance(false)
	_save_and_emit()

func registrar_saldo_oro(current_gold: int) -> void:
	_set_max("gold_balance", "all", maxi(0, current_gold))
	_save_and_emit()

func _sync_gold_balance(save_after: bool = true) -> void:
	_resolve_references()
	var current_gold: int = 0
	if is_instance_valid(main_controller):
		var value: Variant = main_controller.get("player_gold")
		if value is int or value is float:
			current_gold = maxi(0, int(value))
	_set_max("gold_balance", "all", current_gold)
	if save_after:
		_save_and_emit()

func _sync_reconstructable_progress() -> void:
	_resolve_references()
	_sync_gold_balance(false)
	if is_instance_valid(main_controller):
		for zone_id: String in SistemaRegiones.ORDEN_ZONAS:
			if main_controller.has_method("get_zone_phase"):
				_set_max("phase", zone_id, int(main_controller.call("get_zone_phase", zone_id)))
			if main_controller.has_method("is_zone_completed") and bool(main_controller.call("is_zone_completed", zone_id)):
				_set_max("zone_complete", zone_id, 1)
	_save_and_emit()

func registrar_zona_completada(zone_id: String, difficulty: String) -> void:
	_increment("zone_complete", zone_id, 1)
	var normalized: String = SistemaDificultad.normalizar(difficulty)
	if normalized == SistemaDificultad.DIFICIL:
		_increment("hard_complete", "all", 1)
	elif normalized == SistemaDificultad.INFERNO:
		_increment("inferno_complete", "all", 1)
	_save_and_emit()

func registrar_habilidad_usada() -> void:
	_increment("skill_used", "all", 1)
	_save_and_emit()

func registrar_estado_aplicado(status_id: String) -> void:
	_increment("status_inflicted", "all", 1)
	if status_id == "poison":
		_increment("poison_inflicted", "all", 1)
	elif status_id == "bleed":
		_increment("bleed_inflicted", "all", 1)
	_save_and_emit()

func registrar_forja(amount: int = 1, highest_rarity: String = "") -> void:
	if amount <= 0:
		return
	_increment("forge", "all", amount)
	var active_zone: String = SistemaRegiones.ZONA_VALDORIA
	if is_instance_valid(main_controller) and main_controller.has_method("get_current_zone_id"):
		active_zone = str(main_controller.call("get_current_zone_id"))
	_increment("forge", active_zone, amount)
	var rarity: String = highest_rarity.to_lower().strip_edges() if not highest_rarity.is_empty() else ""
	if rarity in ["epico", "legendario", "mitico", "ancestral", "unico"]:
		_increment("forge_epic", "all", 1)
	_save_and_emit()

func get_entries(zone_id: String = "") -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	var normalized_zone: String = SistemaRegiones.normalizar_zona(zone_id) if not zone_id.is_empty() else ""
	for raw in MISSIONS:
		var mission: Dictionary = raw.duplicate(true)
		var mission_zone: String = str(mission.get("zone", "all"))
		if not normalized_zone.is_empty() and mission_zone != "all" and mission_zone != normalized_zone:
			continue
		var mission_id: String = str(mission.get("id", ""))
		var value: int = int(progress.get(mission_id, 0))
		var target: int = maxi(1, int(mission.get("target", 1)))
		mission["progress"] = mini(value, target)
		mission["completed"] = value >= target
		mission["claimed"] = bool(claimed.get(mission_id, false))
		mission["title"] = str(mission.get("title_en" if current_language == "en" else "title_es", mission_id))
		mission["description"] = str(mission.get("desc_en" if current_language == "en" else "desc_es", ""))
		mission["reward_text"] = _reward_text(mission.get("reward", {}))
		result.append(mission)
	result.sort_custom(func(a: Dictionary, b: Dictionary) -> bool:
		var a_claimed: bool = bool(a.get("claimed", false))
		var b_claimed: bool = bool(b.get("claimed", false))
		if a_claimed != b_claimed:
			return not a_claimed
		var a_completed: bool = bool(a.get("completed", false))
		var b_completed: bool = bool(b.get("completed", false))
		if a_completed != b_completed:
			return a_completed
		return str(a.get("title", "")) < str(b.get("title", ""))
	)
	return result

func get_total_count(zone_id: String = "") -> int:
	return get_entries(zone_id).size()

func get_completed_count(zone_id: String = "") -> int:
	var count: int = 0
	for entry: Dictionary in get_entries(zone_id):
		if bool(entry.get("claimed", false)):
			count += 1
	return count

func claim_mission(mission_id: String) -> bool:
	var definition: Dictionary = _find_definition(mission_id)
	if definition.is_empty() or bool(claimed.get(mission_id, false)):
		return false
	if int(progress.get(mission_id, 0)) < int(definition.get("target", 1)):
		return false

	_resolve_references()
	var reward: Dictionary = (definition.get("reward", {}) as Dictionary).duplicate(true)
	var chest_rarity: String = str(reward.get("chest", ""))
	if not chest_rarity.is_empty():
		if not is_instance_valid(inventory_ui) or not inventory_ui.has_method("add_item"):
			return false
		var level: int = maxi(1, int(main_controller.get("player_level"))) if is_instance_valid(main_controller) else 1
		var character_id: String = str(inventory_ui.call("get_active_character_id")) if inventory_ui.has_method("get_active_character_id") else "paladin_alba"
		var mission_zone: String = str(definition.get("zone", "all"))
		var zone_id: String = (
			SistemaRegiones.normalizar_zona(mission_zone)
			if mission_zone != "all"
			else (
				str(main_controller.call("get_current_zone_id"))
				if is_instance_valid(main_controller) and main_controller.has_method("get_current_zone_id")
				else SistemaRegiones.ZONA_VALDORIA
			)
		)
		var item: Dictionary = BaseDatosObjetos.generar_objeto_forzado(
			chest_rarity,
			level,
			character_id,
			zone_id
		)
		if item.is_empty() or not bool(inventory_ui.call("add_item", item)):
			return false
		_increment("chest", zone_id, 1)

	var gold: int = int(reward.get("gold", 0))
	if gold > 0 and is_instance_valid(main_controller):
		var new_balance: int = int(main_controller.get("player_gold")) + gold
		main_controller.set("player_gold", new_balance)
		_set_max("gold_balance", "all", new_balance)
		if main_controller.has_method("_save_progress"):
			main_controller.call("_save_progress")

	var extra_points: int = int(reward.get("skill_points", 0))
	if extra_points > 0:
		var skill_tree: Node = null
		if is_instance_valid(main_controller):
			skill_tree = main_controller.find_child("ArbolHabilidadesUI", true, false)
		if is_instance_valid(skill_tree) and skill_tree.has_method("add_extra_skill_points"):
			skill_tree.call("add_extra_skill_points", extra_points)
		else:
			var config: ConfigFile = ConfigFile.new()
			config.load("user://habilidades.cfg")
			var current_points: int = int(config.get_value("habilidades", "puntos_extra", 0))
			config.set_value("habilidades", "puntos_extra", current_points + extra_points)
			config.save("user://habilidades.cfg")

	claimed[mission_id] = true
	_save()
	missions_changed.emit()
	reward_claimed.emit(mission_id, reward)
	return true

func _increment(event_name: String, zone_id: String, amount: int) -> void:
	for raw in MISSIONS:
		var mission: Dictionary = raw
		if str(mission.get("event", "")) != event_name:
			continue
		var mission_zone: String = str(mission.get("zone", "all"))
		if mission_zone != "all" and mission_zone != SistemaRegiones.normalizar_zona(zone_id):
			continue
		var id: String = str(mission.get("id", ""))
		var previous_value: int = int(progress.get(id, 0))
		var new_value: int = previous_value + amount
		progress[id] = new_value
		var target: int = int(mission.get("target", 1))
		if previous_value < target and new_value >= target and not bool(claimed.get(id, false)):
			mission_completed.emit(id)

func _set_max(event_name: String, zone_id: String, value: int) -> void:
	for raw in MISSIONS:
		var mission: Dictionary = raw
		if str(mission.get("event", "")) != event_name:
			continue
		var mission_zone: String = str(mission.get("zone", "all"))
		if mission_zone != "all" and mission_zone != SistemaRegiones.normalizar_zona(zone_id):
			continue
		var id: String = str(mission.get("id", ""))
		var previous_value: int = int(progress.get(id, 0))
		var new_value: int = maxi(previous_value, value)
		progress[id] = new_value
		var target: int = int(mission.get("target", 1))
		if previous_value < target and new_value >= target and not bool(claimed.get(id, false)):
			mission_completed.emit(id)

func _find_definition(mission_id: String) -> Dictionary:
	for raw in MISSIONS:
		if str(raw.get("id", "")) == mission_id:
			return (raw as Dictionary).duplicate(true)
	return {}

func _reward_text(raw_reward: Variant) -> String:
	if not (raw_reward is Dictionary):
		return ""
	var reward: Dictionary = raw_reward
	var parts: Array[String] = []
	if int(reward.get("gold", 0)) > 0:
		parts.append("%d oro" % int(reward.get("gold", 0)) if current_language == "es" else "%d gold" % int(reward.get("gold", 0)))
	if not str(reward.get("chest", "")).is_empty():
		parts.append(("Cofre " if current_language == "es" else "Chest ") + BaseDatosObjetos.obtener_nombre_rareza(str(reward.get("chest", ""))))
	if int(reward.get("skill_points", 0)) > 0:
		parts.append("+%d puntos" % int(reward.get("skill_points", 0)) if current_language == "es" else "+%d points" % int(reward.get("skill_points", 0)))
	return " · ".join(parts)

func _load() -> void:
	var config := ConfigFile.new()
	if config.load(SAVE_PATH) == OK:
		var loaded_progress: Variant = config.get_value("misiones", "progreso", {})
		var loaded_claimed: Variant = config.get_value("misiones", "reclamadas", {})
		progress = (loaded_progress as Dictionary).duplicate(true) if loaded_progress is Dictionary else {}
		claimed = (loaded_claimed as Dictionary).duplicate(true) if loaded_claimed is Dictionary else {}

func _save() -> void:
	var config := ConfigFile.new()
	config.set_value("misiones", "progreso", progress)
	config.set_value("misiones", "reclamadas", claimed)
	config.save(SAVE_PATH)

func _save_and_emit() -> void:
	_save()
	missions_changed.emit()
