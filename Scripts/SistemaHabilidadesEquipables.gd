extends RefCounted
class_name SistemaHabilidadesEquipables

const TYPE_ACTIVE: String = "active"
const TYPE_PASSIVE: String = "passive"
const MAX_ACTIVE_SLOTS: int = 2
const MAX_PASSIVE_SLOTS: int = 3

const SKILLS: Dictionary = {
	"pal_destello_sagrado": {"class":"paladin","type":TYPE_ACTIVE,"tier":1,"unlock_node":"paladin_active","name_es":"Destello Sagrado","name_en":"Holy Flash","desc_es":"Golpea con luz, causa daño adicional y marca al enemigo para recibir más daño.","desc_en":"Strikes with light, deals bonus damage and marks the enemy to take more damage.","cooldown":8.0,"multiplier":1.55,"status":"light_mark","status_chance":100.0,"status_power":18,"status_turns":3,"symbol":"✦","accent":"#FFE58A"},
	"pal_veredicto_solar": {"class":"paladin","type":TYPE_ACTIVE,"tier":2,"unlock_node":"paladin_active","name_es":"Veredicto Solar","name_en":"Solar Verdict","desc_es":"Un golpe de área que incendia de luz a todos los enemigos.","desc_en":"An area strike that burns every enemy with light.","cooldown":12.0,"multiplier":1.80,"area":true,"status":"light_mark","status_chance":70.0,"status_power":22,"status_turns":3,"symbol":"☀","accent":"#FFD15C"},
	"pal_santuario": {"class":"paladin","type":TYPE_ACTIVE,"tier":3,"unlock_node":"paladin_active","name_es":"Santuario del Alba","name_en":"Dawn Sanctuary","desc_es":"Crea un gran escudo y restaura parte de la vida del grupo.","desc_en":"Creates a large shield and restores part of the party's health.","cooldown":18.0,"multiplier":0.75,"shield":90,"heal_percent":8.0,"symbol":"◆","accent":"#8ED9FF"},
	"pal_aura_luz": {"class":"paladin","type":TYPE_PASSIVE,"tier":1,"unlock_node":"paladin_passive","name_es":"Aura de Luz","name_en":"Aura of Light","desc_es":"Tus ataques infligen un 12% de daño sagrado adicional.","desc_en":"Your attacks deal 12% additional holy damage.","holy_damage_percent":12.0,"symbol":"✧","accent":"#FFF0A0"},
	"pal_juramento_vital": {"class":"paladin","type":TYPE_PASSIVE,"tier":2,"unlock_node":"paladin_passive","name_es":"Juramento Vital","name_en":"Vital Oath","desc_es":"Recuperas un 3% del daño que causas.","desc_en":"Recover 3% of the damage you deal.","lifesteal_percent":3.0,"symbol":"♥","accent":"#FF9FA8"},
	"pal_bastion_radiante": {"class":"paladin","type":TYPE_PASSIVE,"tier":3,"unlock_node":"paladin_passive","name_es":"Bastión Radiante","name_en":"Radiant Bastion","desc_es":"Reduce veneno y sangrado un 45% y concede escudo al lanzar una habilidad.","desc_en":"Reduces poison and bleeding by 45% and grants shield when casting a skill.","dot_resistance_percent":45.0,"shield_on_skill":35,"symbol":"⬟","accent":"#A8E5FF"},

	"arc_flecha_hemorragica": {"class":"arquero","type":TYPE_ACTIVE,"tier":1,"unlock_node":"archer_active","name_es":"Flecha Hemorrágica","name_en":"Hemorrhaging Arrow","desc_es":"Una flecha serrada que aplica sangrado.","desc_en":"A serrated arrow that applies bleeding.","cooldown":7.0,"multiplier":1.40,"status":"bleed","status_chance":100.0,"status_power":6,"status_turns":4,"symbol":"➶","accent":"#FF7A7A"},
	"arc_salva_toxica": {"class":"arquero","type":TYPE_ACTIVE,"tier":2,"unlock_node":"archer_active","name_es":"Salva Tóxica","name_en":"Toxic Volley","desc_es":"Dispara a todos los enemigos y puede envenenarlos.","desc_en":"Fires at every enemy and may poison them.","cooldown":11.0,"multiplier":1.25,"area":true,"status":"poison","status_chance":75.0,"status_power":7,"status_turns":4,"symbol":"☣","accent":"#82E66A"},
	"arc_lluvia_tormenta": {"class":"arquero","type":TYPE_ACTIVE,"tier":3,"unlock_node":"archer_active","name_es":"Lluvia de Tormenta","name_en":"Storm Rain","desc_es":"Una lluvia de flechas golpea varias veces a toda la oleada.","desc_en":"A rain of arrows strikes the whole wave several times.","cooldown":16.0,"multiplier":2.10,"area":true,"symbol":"⚡","accent":"#8FDFFF"},
	"arc_maestria_sangrado": {"class":"arquero","type":TYPE_PASSIVE,"tier":1,"unlock_node":"archer_passive","name_es":"Maestría del Sangrado","name_en":"Bleeding Mastery","desc_es":"El sangrado dura un turno más e inflige un 25% más de daño.","desc_en":"Bleeding lasts one extra turn and deals 25% more damage.","bleed_bonus_percent":25.0,"bleed_extra_turns":1,"symbol":"滴","accent":"#FF6E78"},
	"arc_alquimista_venenos": {"class":"arquero","type":TYPE_PASSIVE,"tier":2,"unlock_node":"archer_passive","name_es":"Alquimista de Venenos","name_en":"Venom Alchemist","desc_es":"El veneno inflige un 30% más de daño.","desc_en":"Poison deals 30% more damage.","poison_bonus_percent":30.0,"symbol":"☠","accent":"#8AE26D"},
	"arc_ojo_cazador": {"class":"arquero","type":TYPE_PASSIVE,"tier":3,"unlock_node":"archer_passive","name_es":"Ojo del Cazador","name_en":"Hunter's Eye","desc_es":"Aumenta un 7% el crítico y un 20% el daño contra enemigos debilitados.","desc_en":"Increases critical chance by 7% and damage against weakened enemies by 20%.","critical_chance":7.0,"execution_percent":20.0,"symbol":"◉","accent":"#F3E38C"},

	"mag_orbe_vampirico": {"class":"arcanista","type":TYPE_ACTIVE,"tier":1,"unlock_node":"arcanist_active","name_es":"Orbe Vampírico","name_en":"Vampiric Orb","desc_es":"Drena vida del enemigo y cura al grupo.","desc_en":"Drains the enemy's life and heals the party.","cooldown":8.0,"multiplier":1.50,"lifesteal_percent":35.0,"symbol":"●","accent":"#D66BFF"},
	"mag_nova_arcana": {"class":"arcanista","type":TYPE_ACTIVE,"tier":2,"unlock_node":"arcanist_active","name_es":"Nova Arcana","name_en":"Arcane Nova","desc_es":"Explosión de área que maldice a los enemigos.","desc_en":"An area explosion that curses enemies.","cooldown":12.0,"multiplier":1.70,"area":true,"status":"curse","status_chance":80.0,"status_power":18,"status_turns":4,"symbol":"✹","accent":"#C993FF"},
	"mag_colapso_estelar": {"class":"arcanista","type":TYPE_ACTIVE,"tier":3,"unlock_node":"arcanist_active","name_es":"Colapso Estelar","name_en":"Stellar Collapse","desc_es":"Un impacto estelar devastador contra toda la oleada.","desc_en":"A devastating stellar impact against the entire wave.","cooldown":18.0,"multiplier":2.55,"area":true,"symbol":"✺","accent":"#A6B7FF"},
	"mag_vampirismo_arcano": {"class":"arcanista","type":TYPE_PASSIVE,"tier":1,"unlock_node":"arcanist_passive","name_es":"Vampirismo Arcano","name_en":"Arcane Vampirism","desc_es":"Curas un 5% del daño mágico que causas.","desc_en":"Heal 5% of magical damage dealt.","lifesteal_percent":5.0,"symbol":"◆","accent":"#E18CFF"},
	"mag_eco_mistico": {"class":"arcanista","type":TYPE_PASSIVE,"tier":2,"unlock_node":"arcanist_passive","name_es":"Eco Místico","name_en":"Mystic Echo","desc_es":"Las habilidades tienen un 18% menos de enfriamiento.","desc_en":"Abilities have 18% less cooldown.","cooldown_reduction_percent":18.0,"symbol":"∞","accent":"#B5A5FF"},
	"mag_barrera_astral": {"class":"arcanista","type":TYPE_PASSIVE,"tier":3,"unlock_node":"arcanist_passive","name_es":"Barrera Astral","name_en":"Astral Barrier","desc_es":"Cada habilidad concede escudo y reduce las maldiciones recibidas.","desc_en":"Each skill grants shield and reduces incoming curses.","shield_on_skill":45,"curse_resistance_percent":50.0,"symbol":"✦","accent":"#9CD9FF"}
}

static func obtener_habilidad(skill_id: String) -> Dictionary:
	var raw: Variant = SKILLS.get(skill_id, {})
	return (raw as Dictionary).duplicate(true) if raw is Dictionary else {}

static func obtener_nombre(skill_id: String, language_code: String = "es") -> String:
	var data: Dictionary = obtener_habilidad(skill_id)
	return str(data.get("name_en" if language_code.to_lower().begins_with("en") else "name_es", skill_id))

static func obtener_descripcion(skill_id: String, language_code: String = "es") -> String:
	var data: Dictionary = obtener_habilidad(skill_id)
	return str(data.get("desc_en" if language_code.to_lower().begins_with("en") else "desc_es", ""))

static func clase_desde_heroe(hero_id: String) -> String:
	match hero_id:
		"arquero_bosque":
			return "arquero"
		"arcanista_estelar":
			return "arcanista"
		_:
			return "paladin"

static func es_compatible(skill_id: String, hero_id: String) -> bool:
	var data: Dictionary = obtener_habilidad(skill_id)
	return not data.is_empty() and str(data.get("class", "")) == clase_desde_heroe(hero_id)

static func habilidades_desbloqueadas(skill_ranks: Dictionary, hero_id: String) -> Array[String]:
	var result: Array[String] = []
	var hero_class: String = clase_desde_heroe(hero_id)
	for skill_id: String in SKILLS.keys():
		var data: Dictionary = SKILLS[skill_id]
		if str(data.get("class", "")) != hero_class:
			continue
		var node_id: String = str(data.get("unlock_node", ""))
		var required_rank: int = maxi(1, int(data.get("tier", 1)))
		if int(skill_ranks.get(node_id, 0)) >= required_rank:
			result.append(skill_id)
	result.sort_custom(func(a: String, b: String) -> bool:
		var a_data: Dictionary = SKILLS[a]
		var b_data: Dictionary = SKILLS[b]
		if str(a_data.get("type", "")) != str(b_data.get("type", "")):
			return str(a_data.get("type", "")) < str(b_data.get("type", ""))
		return int(a_data.get("tier", 1)) < int(b_data.get("tier", 1))
	)
	return result

static func crear_carga_vacia() -> Dictionary:
	return {"active":["", ""], "passive":["", "", ""]}

static func normalizar_carga(raw_loadout: Variant, hero_id: String, unlocked_skills: Array[String]) -> Dictionary:
	var result: Dictionary = crear_carga_vacia()
	if raw_loadout is Dictionary:
		for type_id: String in [TYPE_ACTIVE, TYPE_PASSIVE]:
			var limit: int = MAX_ACTIVE_SLOTS if type_id == TYPE_ACTIVE else MAX_PASSIVE_SLOTS
			var raw_array: Variant = (raw_loadout as Dictionary).get(type_id, [])
			if raw_array is Array:
				var clean: Array[String] = []
				for index: int in range(limit):
					var skill_id: String = str((raw_array as Array)[index]) if index < (raw_array as Array).size() else ""
					var data: Dictionary = obtener_habilidad(skill_id)
					if skill_id.is_empty() or not unlocked_skills.has(skill_id) or not es_compatible(skill_id, hero_id) or str(data.get("type", "")) != type_id or clean.has(skill_id):
						skill_id = ""
					clean.append(skill_id)
				result[type_id] = clean
	return result

static func obtener_pasivas(loadout: Dictionary) -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	var raw: Variant = loadout.get(TYPE_PASSIVE, [])
	if raw is Array:
		for skill_id_raw: Variant in raw:
			var data: Dictionary = obtener_habilidad(str(skill_id_raw))
			if not data.is_empty():
				result.append(data)
	return result

static func obtener_activas(loadout: Dictionary) -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	var raw: Variant = loadout.get(TYPE_ACTIVE, [])
	if raw is Array:
		for skill_id_raw: Variant in raw:
			var data: Dictionary = obtener_habilidad(str(skill_id_raw))
			if not data.is_empty():
				data["id"] = str(skill_id_raw)
				result.append(data)
	return result
