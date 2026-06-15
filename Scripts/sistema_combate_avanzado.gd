extends RefCounted
class_name SistemaCombateAvanzado

const VALDORIA_ENEMIES: Array[Dictionary] = [
	{"id":"slime_luminoso","name_es":"Slime luminoso","name_en":"Luminous Slime","hp":30,"damage":4,"gold":6,"xp":9,"abilities":[]},
	{"id":"bandido_camino","name_es":"Bandido del camino","name_en":"Road Bandit","hp":42,"damage":5,"gold":8,"xp":11,"abilities":[{"type":"bleed","chance":10.0,"power":2,"turns":2,"name_es":"Corte sucio","name_en":"Dirty Cut"}]},
	{"id":"lobo_valdoria","name_es":"Lobo de Valdoria","name_en":"Valdorian Wolf","hp":48,"damage":6,"gold":9,"xp":12,"abilities":[{"type":"bleed","chance":14.0,"power":3,"turns":2,"name_es":"Mordisco desgarrador","name_en":"Rending Bite"}]},
	{"id":"arana_prado","name_es":"Araña del prado","name_en":"Meadow Spider","hp":40,"damage":7,"gold":9,"xp":13,"abilities":[{"type":"poison","chance":18.0,"power":3,"turns":3,"name_es":"Veneno silvestre","name_en":"Wild Venom"}]},
	{"id":"saqueador_ruinas","name_es":"Saqueador de ruinas","name_en":"Ruins Raider","hp":55,"damage":7,"gold":11,"xp":14,"abilities":[{"type":"armor_break","chance":12.0,"power":12,"turns":2,"name_es":"Golpe quebracorazas","name_en":"Armorbreaker"}]},
	{"id":"jabali_bruma","name_es":"Jabalí de la bruma","name_en":"Mist Boar","hp":66,"damage":8,"gold":13,"xp":16,"abilities":[{"type":"stun","chance":8.0,"power":1,"turns":1,"name_es":"Embestida","name_en":"Charge"}]},
	{"id":"arquero_errante","name_es":"Arquero errante","name_en":"Wandering Archer","hp":52,"damage":10,"gold":14,"xp":18,"abilities":[{"type":"bleed","chance":16.0,"power":4,"turns":3,"name_es":"Flecha serrada","name_en":"Serrated Arrow"}]},
	{"id":"cultista_hiedra","name_es":"Cultista de la Hiedra","name_en":"Ivy Cultist","hp":61,"damage":11,"gold":16,"xp":20,"abilities":[{"type":"curse","chance":13.0,"power":12,"turns":3,"name_es":"Marca de hiedra","name_en":"Ivy Mark"}]},
	{"id":"golem_musgo","name_es":"Gólem de Musgo","name_en":"Moss Golem","hp":85,"damage":9,"gold":18,"xp":22,"abilities":[{"type":"stun","chance":10.0,"power":1,"turns":1,"name_es":"Martillo pétreo","name_en":"Stone Hammer"}]}
]

const BRUMA_ENEMIES: Array[Dictionary] = [
	{"id":"espectro_bruma","name_es":"Espectro de la Bruma","name_en":"Mist Wraith","hp":130,"damage":15,"gold":25,"xp":30,"abilities":[{"type":"curse","chance":18.0,"power":15,"turns":3,"name_es":"Susurro del velo","name_en":"Veil Whisper"}]},
	{"id":"sabueso_ceniza","name_es":"Sabueso de Ceniza","name_en":"Ash Hound","hp":155,"damage":17,"gold":28,"xp":33,"abilities":[{"type":"burn","chance":16.0,"power":5,"turns":3,"name_es":"Mordisco de ascua","name_en":"Ember Bite"}]},
	{"id":"caballero_velado","name_es":"Caballero Velado","name_en":"Veiled Knight","hp":188,"damage":20,"gold":33,"xp":38,"abilities":[{"type":"armor_break","chance":18.0,"power":18,"turns":3,"name_es":"Tajo del velo","name_en":"Veil Cleave"}]},
	{"id":"acechador_cueva","name_es":"Acechador de la Cueva","name_en":"Cave Stalker","hp":145,"damage":23,"gold":34,"xp":40,"abilities":[{"type":"bleed","chance":22.0,"power":6,"turns":3,"name_es":"Garra cavernaria","name_en":"Cavern Claw"}]},
	{"id":"centinela_derruido","name_es":"Centinela Derruido","name_en":"Ruined Sentinel","hp":220,"damage":21,"gold":38,"xp":45,"abilities":[{"type":"stun","chance":14.0,"power":1,"turns":1,"name_es":"Impacto de fortaleza","name_en":"Fortress Impact"}]},
	{"id":"merodeador_velo","name_es":"Merodeador del Velo","name_en":"Veil Marauder","hp":178,"damage":25,"gold":41,"xp":48,"abilities":[{"type":"bleed","chance":24.0,"power":7,"turns":3,"name_es":"Doble incisión","name_en":"Twin Incision"}]},
	{"id":"arana_piedra","name_es":"Araña de Piedra","name_en":"Stone Spider","hp":165,"damage":27,"gold":44,"xp":51,"abilities":[{"type":"poison","chance":30.0,"power":7,"turns":4,"name_es":"Toxina mineral","name_en":"Mineral Toxin"}]},
	{"id":"monje_sin_rostro","name_es":"Monje sin Rostro","name_en":"Faceless Monk","hp":202,"damage":29,"gold":48,"xp":55,"abilities":[{"type":"curse","chance":24.0,"power":20,"turns":3,"name_es":"Letanía sin rostro","name_en":"Faceless Litany"}]},
	{"id":"vigia_niebla","name_es":"Vigía de la Niebla","name_en":"Mist Watcher","hp":236,"damage":28,"gold":52,"xp":60,"abilities":[{"type":"armor_break","chance":22.0,"power":20,"turns":3,"name_es":"Mirada reveladora","name_en":"Revealing Gaze"}]}
]

const ELARIS_ENEMIES: Array[Dictionary] = [
	{"id":"arana_plaga_elaris","name_es":"Araña de la Plaga","name_en":"Plague Spider","hp":300,"damage":34,"gold":60,"xp":72,"abilities":[{"type":"poison","chance":38.0,"power":10,"turns":4,"name_es":"Veneno de Elaris","name_en":"Elaris Venom"}]},
	{"id":"guardian_runico","name_es":"Guardián Rúnico","name_en":"Runic Guardian","hp":390,"damage":31,"gold":67,"xp":80,"abilities":[{"type":"stun","chance":18.0,"power":1,"turns":1,"name_es":"Sello de piedra","name_en":"Stone Seal"},{"type":"armor_break","chance":18.0,"power":24,"turns":3,"name_es":"Runa quebrada","name_en":"Broken Rune"}]},
	{"id":"devorador_ecos","name_es":"Devorador de Ecos","name_en":"Echo Devourer","hp":330,"damage":39,"gold":70,"xp":84,"abilities":[{"type":"lifedrain","chance":25.0,"power":18,"turns":1,"name_es":"Hambre de recuerdos","name_en":"Memory Hunger"}]},
	{"id":"sacerdote_fractura","name_es":"Sacerdote de la Fractura","name_en":"Fracture Priest","hp":315,"damage":43,"gold":76,"xp":90,"abilities":[{"type":"curse","chance":32.0,"power":26,"turns":4,"name_es":"Maldición fracturada","name_en":"Fractured Curse"}]},
	{"id":"acechador_obsidiana","name_es":"Acechador de Obsidiana","name_en":"Obsidian Stalker","hp":350,"damage":46,"gold":81,"xp":96,"abilities":[{"type":"bleed","chance":34.0,"power":11,"turns":4,"name_es":"Garra de obsidiana","name_en":"Obsidian Claw"}]},
	{"id":"vampiro_ruinas","name_es":"Vástago de las Ruinas","name_en":"Ruins Scion","hp":420,"damage":42,"gold":88,"xp":105,"abilities":[{"type":"lifedrain","chance":32.0,"power":24,"turns":1,"name_es":"Banquete carmesí","name_en":"Crimson Feast"}]},
	{"id":"caballero_elaris","name_es":"Caballero de Elaris","name_en":"Knight of Elaris","hp":480,"damage":44,"gold":94,"xp":112,"abilities":[{"type":"armor_break","chance":30.0,"power":28,"turns":4,"name_es":"Veredicto en ruinas","name_en":"Ruined Verdict"}]},
	{"id":"oraculo_ciego","name_es":"Oráculo Ciego","name_en":"Blind Oracle","hp":360,"damage":50,"gold":101,"xp":120,"abilities":[{"type":"curse","chance":35.0,"power":30,"turns":4,"name_es":"Profecía vacía","name_en":"Empty Prophecy"},{"type":"stun","chance":12.0,"power":1,"turns":1,"name_es":"Visión imposible","name_en":"Impossible Vision"}]},
	{"id":"coloso_elaris","name_es":"Coloso de Elaris","name_en":"Elaris Colossus","hp":620,"damage":47,"gold":110,"xp":132,"abilities":[{"type":"stun","chance":24.0,"power":1,"turns":1,"name_es":"Pisotón del coloso","name_en":"Colossus Stomp"}]}
]

const SECRET_BOSSES: Dictionary = {
	SistemaRegiones.ZONA_VALDORIA: [
		{"id":"rey_ciervo_antiguo","name_es":"Rey Ciervo Antiguo","name_en":"Ancient Stag King","hp":2800,"damage":70,"gold":1200,"xp":1450,"abilities":[{"type":"bleed","chance":30.0,"power":12,"turns":4,"name_es":"Cornamenta ancestral","name_en":"Ancestral Antlers"}]},
		{"id":"caballero_sin_amanecer","name_es":"Caballero sin Amanecer","name_en":"Dawnless Knight","hp":3200,"damage":76,"gold":1400,"xp":1600,"abilities":[{"type":"curse","chance":30.0,"power":28,"turns":4,"name_es":"Juramento vacío","name_en":"Hollow Oath"}]}
	],
	SistemaRegiones.ZONA_BRUMA: [
		{"id":"madre_niebla","name_es":"Madre de la Niebla","name_en":"Mother of Mist","hp":5200,"damage":102,"gold":2200,"xp":2600,"abilities":[{"type":"poison","chance":32.0,"power":14,"turns":5,"name_es":"Aliento de niebla","name_en":"Mist Breath"},{"type":"curse","chance":22.0,"power":30,"turns":4,"name_es":"Velo materno","name_en":"Motherly Veil"}]},
		{"id":"paladin_juramento_roto","name_es":"Paladín del Juramento Roto","name_en":"Paladin of the Broken Oath","hp":5900,"damage":112,"gold":2500,"xp":2900,"abilities":[{"type":"armor_break","chance":34.0,"power":32,"turns":4,"name_es":"Mandoble profanado","name_en":"Profaned Greatsword"}]}
	],
	SistemaRegiones.ZONA_ELARIS: [
		{"id":"reina_arana_elaris","name_es":"Reina Araña de Elaris","name_en":"Elaris Spider Queen","hp":8700,"damage":145,"gold":3900,"xp":4400,"abilities":[{"type":"poison","chance":55.0,"power":20,"turns":6,"name_es":"Veneno real","name_en":"Royal Venom"},{"type":"stun","chance":18.0,"power":1,"turns":1,"name_es":"Red de ruinas","name_en":"Ruins Web"}]},
		{"id":"rey_sin_memoria","name_es":"El Rey sin Memoria","name_en":"The Memoryless King","hp":9600,"damage":155,"gold":4300,"xp":4900,"abilities":[{"type":"lifedrain","chance":38.0,"power":36,"turns":1,"name_es":"Tributo de sangre","name_en":"Blood Tribute"},{"type":"curse","chance":34.0,"power":38,"turns":5,"name_es":"Corona del olvido","name_en":"Crown of Oblivion"}]}
	]
}

static func crear_oleada(zone_id: String, phase: int, difficulty: String, rng: RandomNumberGenerator) -> Array[Dictionary]:
	var zone: String = SistemaRegiones.normalizar_zona(zone_id)
	var phase_count: int = SistemaRegiones.obtener_fases(zone)
	var difficulty_data: Dictionary = SistemaDificultad.obtener_datos(difficulty)
	var secret_chance: float = float(difficulty_data.get("secret_boss_chance", 0.25))

	if phase >= 25 and phase < phase_count and phase % 10 != 0 and rng.randf_range(0.0, 100.0) < secret_chance:
		var secrets: Array = SECRET_BOSSES.get(zone, [])
		if not secrets.is_empty():
			var secret: Dictionary = (secrets[rng.randi_range(0, secrets.size() - 1)] as Dictionary).duplicate(true)
			secret["rank"] = "secret_boss"
			secret["secret_boss"] = true
			secret["guaranteed_rarity"] = "legendario"
			return [SistemaDificultad.aplicar_a_enemigo(completar_perfil_enemigo(secret), difficulty)]

	if phase == phase_count:
		var final_boss: Dictionary = _crear_jefe_final(zone)
		return [SistemaDificultad.aplicar_a_enemigo(completar_perfil_enemigo(final_boss), difficulty)]

	var base_count: int = 1
	if phase >= 10:
		base_count = 2
	if phase >= 30:
		base_count = 3
	if phase >= 60:
		base_count = 4
	if phase >= 85:
		base_count = 5
	base_count += int(difficulty_data.get("enemy_bonus", 0))
	base_count = clampi(base_count, 1, 5)
	if phase % 10 == 0:
		base_count = maxi(1, base_count - 1)

	var source: Array[Dictionary] = _obtener_fuente(zone)
	var wave: Array[Dictionary] = []
	for index: int in range(base_count):
		var selected_index: int = (phase + index * 3 - 1) % source.size()
		var enemy: Dictionary = source[selected_index].duplicate(true)
		var tier: int = int(floor(float(phase - 1) / 10.0))
		var zone_hp: int = 11
		var zone_damage: float = 0.30
		if zone == SistemaRegiones.ZONA_BRUMA:
			zone_hp = 20
			zone_damage = 0.42
		elif zone == SistemaRegiones.ZONA_ELARIS:
			zone_hp = 32
			zone_damage = 0.58
		enemy["hp"] = int(enemy.get("hp", 1)) + phase * zone_hp + tier * 50
		enemy["damage"] = int(enemy.get("damage", 1)) + int(floor(float(phase) * zone_damage)) + tier * 4
		enemy["gold"] = int(enemy.get("gold", 1)) + phase * (2 if zone == SistemaRegiones.ZONA_VALDORIA else 3) + tier * 8
		enemy["xp"] = int(enemy.get("xp", 1)) + phase * (2 if zone == SistemaRegiones.ZONA_VALDORIA else 3) + tier * 9
		enemy["rank"] = "elite" if phase % 10 == 0 else "normal"
		if enemy["rank"] == "elite":
			enemy["hp"] = int(enemy["hp"] * 1.65)
			enemy["damage"] = int(enemy["damage"] * 1.35)
			enemy["gold"] = int(enemy["gold"] * 1.70)
			enemy["xp"] = int(enemy["xp"] * 1.65)
			var elite_abilities: Array = enemy.get("abilities", [])
			if elite_abilities.is_empty():
				elite_abilities.append({"type":"armor_break","chance":20.0,"power":18,"turns":3,"name_es":"Golpe de élite","name_en":"Elite Strike"})
			enemy["abilities"] = elite_abilities
		wave.append(SistemaDificultad.aplicar_a_enemigo(completar_perfil_enemigo(enemy), difficulty))
	return wave

static func _obtener_fuente(zone: String) -> Array[Dictionary]:
	if zone == SistemaRegiones.ZONA_BRUMA:
		return BRUMA_ENEMIES
	if zone == SistemaRegiones.ZONA_ELARIS:
		return ELARIS_ENEMIES
	return VALDORIA_ENEMIES

static func _crear_jefe_final(zone: String) -> Dictionary:
	if zone == SistemaRegiones.ZONA_BRUMA:
		return {"id":"senor_del_velo","name_es":"Señor del Velo","name_en":"Lord of the Veil","rank":"boss","hp":5200,"damage":118,"gold":1800,"xp":2200,"abilities":[{"type":"curse","chance":35.0,"power":32,"turns":5,"name_es":"Dominio del velo","name_en":"Veil Dominion"},{"type":"stun","chance":14.0,"power":1,"turns":1,"name_es":"Campana de niebla","name_en":"Mist Bell"}]}
	if zone == SistemaRegiones.ZONA_ELARIS:
		return {"id":"corazon_elaris","name_es":"Corazón Corrupto de Elaris","name_en":"Corrupted Heart of Elaris","rank":"boss","hp":10500,"damage":170,"gold":3600,"xp":4700,"abilities":[{"type":"poison","chance":42.0,"power":22,"turns":6,"name_es":"Sangre tóxica","name_en":"Toxic Blood"},{"type":"lifedrain","chance":30.0,"power":40,"turns":1,"name_es":"Latido devorador","name_en":"Devouring Pulse"},{"type":"curse","chance":32.0,"power":40,"turns":5,"name_es":"Eco de la Fractura","name_en":"Fracture Echo"}]}
	return {"id":"guardian_valdoria","name_es":"Guardián de Valdoria","name_en":"Guardian of Valdoria","rank":"boss","hp":2600,"damage":76,"gold":900,"xp":1100,"abilities":[{"type":"armor_break","chance":28.0,"power":24,"turns":4,"name_es":"Golpe del guardián","name_en":"Guardian Strike"}]}

static func completar_perfil_enemigo(enemy: Dictionary) -> Dictionary:
	var result: Dictionary = enemy.duplicate(true)
	var enemy_id: String = str(result.get("id", "")).to_lower()
	var ranged_ids: Array[String] = [
		"arquero_errante", "cultista_hiedra", "espectro_bruma", "monje_sin_rostro",
		"vigia_niebla", "sacerdote_fractura", "oraculo_ciego", "madre_niebla",
		"corazon_elaris"
	]
	var fast_ids: Array[String] = [
		"lobo_valdoria", "arana_prado", "acechador_cueva", "merodeador_velo",
		"arana_piedra", "arana_plaga_elaris", "acechador_obsidiana"
	]
	var slow_ids: Array[String] = [
		"golem_musgo", "centinela_derruido", "guardian_runico", "coloso_elaris",
		"guardian_valdoria", "senor_del_velo", "corazon_elaris"
	]
	result["attack_range"] = "ranged" if ranged_ids.has(enemy_id) else "melee"
	var speed: int = 24
	if fast_ids.has(enemy_id):
		speed = 42
	elif slow_ids.has(enemy_id):
		speed = 10
	elif str(result.get("rank", "normal")) in ["boss", "secret_boss"]:
		speed = 16
	result["speed"] = int(result.get("speed", speed))
	result["interval"] = float(result.get("interval", 1.62 if result["attack_range"] == "melee" else 1.78))
	return result

static func nombre_enemigo(enemy: Dictionary, language_code: String) -> String:
	return str(enemy.get("name_en" if language_code.to_lower().begins_with("en") else "name_es", enemy.get("id", "Enemigo")))

static func nombre_habilidad_enemiga(ability: Dictionary, language_code: String) -> String:
	return str(ability.get("name_en" if language_code.to_lower().begins_with("en") else "name_es", ability.get("type", "Habilidad")))

static func perfil_heroe(hero_id: String, level: int, equipment_stats: Dictionary) -> Dictionary:
	var safe_level: int = maxi(1, level)
	var profile: Dictionary
	match hero_id:
		"arquero_bosque":
			profile = {
				"name_es":"Arquero del Bosque", "name_en":"Forest Archer", "short":"ARQ",
				"max_hp":78 + safe_level * 12, "damage":8 + safe_level * 2,
				"defense":3 + safe_level, "speed":44 + safe_level, "magic":0,
				"interval":1.08, "attack_range":"ranged", "formation_priority":30,
				"skill":"triple_shot", "skill_cooldown":8.0, "accent":Color("#73D982")
			}
		"arcanista_estelar":
			profile = {
				"name_es":"Arcanista Estelar", "name_en":"Stellar Arcanist", "short":"ARC",
				"max_hp":70 + safe_level * 10, "damage":7 + safe_level * 2,
				"defense":2 + int(floor(float(safe_level) * 0.8)), "speed":27 + int(floor(float(safe_level) * 0.6)), "magic":10 + safe_level * 3,
				"interval":1.28, "attack_range":"ranged", "formation_priority":40,
				"skill":"arcane_rain", "skill_cooldown":10.0, "accent":Color("#B985FF")
			}
		_:
			profile = {
				"name_es":"Paladín del Alba", "name_en":"Dawn Paladin", "short":"PAL",
				"max_hp":108 + safe_level * 17, "damage":9 + safe_level * 2,
				"defense":9 + safe_level * 2, "speed":18 + int(floor(float(safe_level) * 0.5)), "magic":4 + safe_level,
				"interval":1.22, "attack_range":"melee", "formation_priority":10,
				"skill":"holy_aegis", "skill_cooldown":12.0, "accent":Color("#72B7FF")
			}
	profile["max_hp"] = int(profile.get("max_hp", 1)) + int(equipment_stats.get("vida", 0))
	profile["damage"] = int(profile.get("damage", 1)) + int(equipment_stats.get("daño", 0)) + int(round(float(equipment_stats.get("magia", 0)) / 2.0))
	profile["defense"] = int(profile.get("defense", 0)) + int(equipment_stats.get("def", 0))
	profile["speed"] = int(profile.get("speed", 0)) + int(equipment_stats.get("vel", 0))
	profile["magic"] = int(profile.get("magic", 0)) + int(equipment_stats.get("magia", 0))
	return profile
