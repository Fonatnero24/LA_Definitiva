extends RefCounted
class_name SistemaDificultad

const NORMAL: String = "normal"
const DIFICIL: String = "dificil"
const INFERNO: String = "inferno"
const ORDEN: Array[String] = [NORMAL, DIFICIL, INFERNO]
const DATOS: Dictionary = {
	NORMAL: {"nombre_es":"NORMAL","nombre_en":"NORMAL","hp":1.00,"damage":1.00,"gold":1.00,"xp":1.00,"enemy_bonus":0,"secret_boss_chance":0.25,"loot_luck":0.0,"ability_chance":1.0},
	DIFICIL: {"nombre_es":"DIFÍCIL","nombre_en":"HARD","hp":2.20,"damage":1.75,"gold":1.65,"xp":1.60,"enemy_bonus":1,"secret_boss_chance":0.70,"loot_luck":15.0,"ability_chance":1.15},
	INFERNO: {"nombre_es":"INFERNO","nombre_en":"INFERNO","hp":5.75,"damage":3.50,"gold":3.10,"xp":2.70,"enemy_bonus":3,"secret_boss_chance":1.35,"loot_luck":40.0,"ability_chance":1.35}
}

static func normalizar(value: String) -> String:
	match value.to_lower().strip_edges():
		"hard", "difficult", "dificil", "difícil":
			return DIFICIL
		"inferno", "infierno":
			return INFERNO
		_:
			return NORMAL

static func obtener_datos(mode: String) -> Dictionary:
	return (DATOS.get(normalizar(mode), DATOS[NORMAL]) as Dictionary).duplicate(true)

static func obtener_nombre(mode: String, language_code: String = "es") -> String:
	var data: Dictionary = obtener_datos(mode)
	return str(data.get("nombre_en" if language_code.to_lower().begins_with("en") else "nombre_es", "NORMAL"))

static func crear_progreso_zonas() -> Dictionary:
	var result: Dictionary = {}
	for index: int in range(SistemaRegiones.ORDEN_ZONAS.size()):
		var zone_id: String = SistemaRegiones.ORDEN_ZONAS[index]
		result[zone_id] = {"phase":1,"completed":false,"unlocked":index == 0}
	return result

static func crear_progreso_completo() -> Dictionary:
	return {NORMAL:crear_progreso_zonas(),DIFICIL:crear_progreso_zonas(),INFERNO:crear_progreso_zonas()}

static func _normalizar_progreso_modo(raw_mode_data: Dictionary) -> Dictionary:
	var result: Dictionary = crear_progreso_zonas()
	for zone_id: String in SistemaRegiones.ORDEN_ZONAS:
		var raw_zone: Variant = raw_mode_data.get(zone_id, {})
		if raw_zone is Dictionary:
			var zone_data: Dictionary = (raw_zone as Dictionary).duplicate(true)
			zone_data["phase"] = clampi(int(zone_data.get("phase", 1)), 1, SistemaRegiones.obtener_fases(zone_id))
			zone_data["completed"] = bool(zone_data.get("completed", false))
			zone_data["unlocked"] = true if zone_id == SistemaRegiones.ZONA_VALDORIA else bool(zone_data.get("unlocked", false))
			result[zone_id] = zone_data

	# Migración: si una versión anterior no conocía la siguiente zona,
	# completar la anterior debe mantener abierto el camino.
	for index: int in range(1, SistemaRegiones.ORDEN_ZONAS.size()):
		var zone_id: String = SistemaRegiones.ORDEN_ZONAS[index]
		var previous_id: String = SistemaRegiones.ORDEN_ZONAS[index - 1]
		var previous_data: Dictionary = result.get(previous_id, {})
		var zone_data: Dictionary = result.get(zone_id, {})
		if bool(previous_data.get("completed", false)):
			zone_data["unlocked"] = true
		result[zone_id] = zone_data
	return result

static func cargar_progreso(config: ConfigFile, migrated_normal: Dictionary = {}) -> Dictionary:
	var loaded: Variant = config.get_value("dificultad", "progreso_por_modo", {})
	var result: Dictionary = crear_progreso_completo()
	if loaded is Dictionary:
		for mode: String in ORDEN:
			var mode_data: Variant = (loaded as Dictionary).get(mode, {})
			if mode_data is Dictionary and not (mode_data as Dictionary).is_empty():
				result[mode] = _normalizar_progreso_modo(mode_data as Dictionary)
	if not migrated_normal.is_empty() and not config.has_section_key("dificultad", "progreso_por_modo"):
		result[NORMAL] = _normalizar_progreso_modo(migrated_normal)
	return result

static func guardar_progreso(config: ConfigFile, progress: Dictionary, current_mode: String, unlocked_modes: Array[String]) -> void:
	config.set_value("dificultad", "progreso_por_modo", progress)
	config.set_value("dificultad", "modo_actual", normalizar(current_mode))
	config.set_value("dificultad", "modos_desbloqueados", unlocked_modes)

static func cargar_modo(config: ConfigFile) -> String:
	return normalizar(str(config.get_value("dificultad", "modo_actual", NORMAL)))

static func cargar_desbloqueados(config: ConfigFile) -> Array[String]:
	var result: Array[String] = [NORMAL]
	var raw: Variant = config.get_value("dificultad", "modos_desbloqueados", [NORMAL])
	if raw is Array:
		for entry: Variant in raw:
			var mode: String = normalizar(str(entry))
			if not result.has(mode):
				result.append(mode)
	return result

static func siguiente_modo(mode: String) -> String:
	var index: int = ORDEN.find(normalizar(mode))
	return "" if index < 0 or index + 1 >= ORDEN.size() else ORDEN[index + 1]

static func aplicar_a_enemigo(enemy: Dictionary, mode: String) -> Dictionary:
	var result: Dictionary = enemy.duplicate(true)
	var normalized: String = normalizar(mode)
	var data: Dictionary = obtener_datos(normalized)
	var hp_multiplier: float = float(data.get("hp", 1.0))
	var damage_multiplier: float = float(data.get("damage", 1.0))
	var rank: String = str(result.get("rank", "normal"))
	if normalized == INFERNO:
		if rank in ["boss", "secret_boss"]:
			hp_multiplier *= 1.28
			damage_multiplier *= 1.18
		elif rank == "elite":
			hp_multiplier *= 1.14
	result["hp"] = maxi(1, int(round(float(result.get("hp", 1)) * hp_multiplier)))
	result["damage"] = maxi(1, int(round(float(result.get("damage", 1)) * damage_multiplier)))
	result["gold"] = maxi(1, int(round(float(result.get("gold", 1)) * float(data.get("gold", 1.0)))))
	result["xp"] = maxi(1, int(round(float(result.get("xp", 1)) * float(data.get("xp", 1.0)))))
	result["difficulty"] = normalized
	result["ability_chance_multiplier"] = float(data.get("ability_chance", 1.0))
	return result
