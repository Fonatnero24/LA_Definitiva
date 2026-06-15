extends RefCounted
class_name SistemaRegiones

const MUNDO_FRACTURA: String = "mundo_1"
const ZONA_VALDORIA: String = "0-1"
const ZONA_BRUMA: String = "0-2"
const ZONA_ELARIS: String = "0-3"
const ZONA_POR_DEFECTO: String = ZONA_VALDORIA
const ORDEN_ZONAS: Array[String] = [ZONA_VALDORIA, ZONA_BRUMA, ZONA_ELARIS]

const ZONAS: Dictionary = {
	ZONA_VALDORIA: {
		"codigo": ZONA_VALDORIA,
		"mundo": MUNDO_FRACTURA,
		"nombre_es": "Ruta de Valdoria",
		"nombre_en": "Valdoria Route",
		"nombre_corto_es": "VALDORIA",
		"nombre_corto_en": "VALDORIA",
		"descripcion_es": "Praderas antiguas, caminos derruidos y guardianes que aún protegen la ruta.",
		"descripcion_en": "Ancient meadows, ruined roads and guardians that still protect the route.",
		"fondo": "res://Recursos/Mundos/Mundo1/0-1.png",
		"fondo_respaldo": "",
		"fases": 100,
		"probabilidad_unico": 0.01,
		"zona_anterior": ""
	},
	ZONA_BRUMA: {
		"codigo": ZONA_BRUMA,
		"mundo": MUNDO_FRACTURA,
		"nombre_es": "Paso de la Bruma",
		"nombre_en": "Mist Pass",
		"nombre_corto_es": "BRUMA",
		"nombre_corto_en": "MIST PASS",
		"descripcion_es": "Un paso secreto cubierto de niebla, estatuas rotas y fortalezas olvidadas.",
		"descripcion_en": "A secret pass covered in mist, broken statues and forgotten strongholds.",
		"fondo": "res://Recursos/Mundos/Mundo1/0-2.png",
		"fondo_respaldo": "res://Recursos/Mundos/Mundo1/0-1.png",
		"fases": 100,
		"probabilidad_unico": 0.01,
		"zona_anterior": ZONA_VALDORIA
	},
	ZONA_ELARIS: {
		"codigo": ZONA_ELARIS,
		"mundo": MUNDO_FRACTURA,
		"nombre_es": "Ruinas de Elaris",
		"nombre_en": "Ruins of Elaris",
		"nombre_corto_es": "ELARIS",
		"nombre_corto_en": "ELARIS",
		"descripcion_es": "Una ciudad sagrada quebrada por la Fractura, donde venenos antiguos, guardianes rúnicos y ecos hambrientos aún cazan entre las piedras.",
		"descripcion_en": "A sacred city shattered by the Fracture, where ancient poisons, runic guardians and hungry echoes still hunt among the stones.",
		"fondo": "res://Recursos/Mundos/Mundo1/0-3.png",
		"fondo_respaldo": "res://Recursos/Mundos/Mundo1/0-2.png",
		"fases": 100,
		"probabilidad_unico": 0.0125,
		"zona_anterior": ZONA_BRUMA
	}
}

static func normalizar_zona(raw_zone: String) -> String:
	var value: String = raw_zone.to_lower().strip_edges()
	match value:
		"0-1", "01", "1", "valdoria", "ruta_valdoria", "ruta de valdoria", "medio":
			return ZONA_VALDORIA
		"0-2", "02", "2", "bruma", "paso_bruma", "paso de la bruma", "mist", "mist_pass":
			return ZONA_BRUMA
		"0-3", "03", "3", "elaris", "ruinas_elaris", "ruinas de elaris", "ruins", "ruins_of_elaris":
			return ZONA_ELARIS
		_:
			return ZONA_POR_DEFECTO

static func es_zona_valida(zone_id: String) -> bool:
	return ZONAS.has(normalizar_zona(zone_id))

static func obtener_datos(zone_id: String) -> Dictionary:
	var normalized: String = normalizar_zona(zone_id)
	var raw: Variant = ZONAS.get(normalized, ZONAS[ZONA_POR_DEFECTO])
	return (raw as Dictionary).duplicate(true) if raw is Dictionary else {}

static func obtener_nombre(zone_id: String, language_code: String = "es", include_code: bool = true) -> String:
	var normalized: String = normalizar_zona(zone_id)
	var data: Dictionary = obtener_datos(normalized)
	var key: String = "nombre_en" if language_code.to_lower().begins_with("en") else "nombre_es"
	var result: String = str(data.get(key, normalized))
	return "%s · %s" % [normalized, result] if include_code else result

static func obtener_nombre_corto(zone_id: String, language_code: String = "es") -> String:
	var data: Dictionary = obtener_datos(zone_id)
	return str(data.get("nombre_corto_en" if language_code.to_lower().begins_with("en") else "nombre_corto_es", normalizar_zona(zone_id)))

static func obtener_descripcion(zone_id: String, language_code: String = "es") -> String:
	var data: Dictionary = obtener_datos(zone_id)
	return str(data.get("descripcion_en" if language_code.to_lower().begins_with("en") else "descripcion_es", ""))

static func obtener_ruta_fondo(zone_id: String) -> String:
	var data: Dictionary = obtener_datos(zone_id)
	var preferred: String = str(data.get("fondo", ""))
	if not preferred.is_empty() and ResourceLoader.exists(preferred):
		return preferred
	return str(data.get("fondo_respaldo", preferred))

static func obtener_fases(zone_id: String) -> int:
	return maxi(1, int(obtener_datos(zone_id).get("fases", 100)))

static func obtener_probabilidad_unico(zone_id: String) -> float:
	return maxf(0.0, float(obtener_datos(zone_id).get("probabilidad_unico", 0.01)))

static func obtener_zona_anterior(zone_id: String) -> String:
	return str(obtener_datos(zone_id).get("zona_anterior", ""))

static func obtener_siguiente_zona(zone_id: String) -> String:
	var index: int = ORDEN_ZONAS.find(normalizar_zona(zone_id))
	return "" if index < 0 or index + 1 >= ORDEN_ZONAS.size() else ORDEN_ZONAS[index + 1]

static func clave_fase(zone_id: String) -> String:
	return "fase_" + normalizar_zona(zone_id).replace("-", "_")

static func clave_completada(zone_id: String) -> String:
	return "completada_" + normalizar_zona(zone_id).replace("-", "_")

static func clave_desbloqueada(zone_id: String) -> String:
	return "desbloqueada_" + normalizar_zona(zone_id).replace("-", "_")

static func leer_zona_actual(config: ConfigFile) -> String:
	return normalizar_zona(str(config.get_value("mapa", "zona_actual", ZONA_POR_DEFECTO)))

static func leer_fase(config: ConfigFile, zone_id: String, legacy_default: int = 1) -> int:
	var normalized: String = normalizar_zona(zone_id)
	var fallback: int = int(config.get_value("mundo_1", "fase", legacy_default)) if normalized == ZONA_VALDORIA else legacy_default
	return clampi(int(config.get_value("zonas", clave_fase(normalized), fallback)), 1, obtener_fases(normalized))

static func leer_completada(config: ConfigFile, zone_id: String) -> bool:
	var normalized: String = normalizar_zona(zone_id)
	var fallback: bool = bool(config.get_value("mundo_1", "completado", false)) if normalized == ZONA_VALDORIA else false
	return bool(config.get_value("zonas", clave_completada(normalized), fallback))

static func esta_desbloqueada(config: ConfigFile, zone_id: String) -> bool:
	var normalized: String = normalizar_zona(zone_id)
	if normalized == ZONA_VALDORIA:
		return true
	var previous_zone: String = obtener_zona_anterior(normalized)
	var fallback: bool = not previous_zone.is_empty() and leer_completada(config, previous_zone)
	return bool(config.get_value("zonas", clave_desbloqueada(normalized), fallback))

static func escribir_zona_actual(config: ConfigFile, zone_id: String) -> void:
	config.set_value("mapa", "zona_actual", normalizar_zona(zone_id))

static func escribir_estado_zona(config: ConfigFile, zone_id: String, phase: int, completed: bool, unlocked: bool = true) -> void:
	var normalized: String = normalizar_zona(zone_id)
	var safe_phase: int = clampi(phase, 1, obtener_fases(normalized))
	config.set_value("zonas", clave_fase(normalized), safe_phase)
	config.set_value("zonas", clave_completada(normalized), completed)
	config.set_value("zonas", clave_desbloqueada(normalized), unlocked)
	if normalized == ZONA_VALDORIA:
		config.set_value("mundo_1", "fase", safe_phase)
		config.set_value("mundo_1", "completado", completed)
