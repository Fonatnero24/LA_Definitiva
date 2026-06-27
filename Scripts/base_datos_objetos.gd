extends RefCounted
class_name BaseDatosObjetos

const RAREZA_COMUN := "comun"
const RAREZA_POCO_COMUN := "poco_comun"
const RAREZA_RARO := "raro"
const RAREZA_EPICO := "epico"
const RAREZA_LEGENDARIO := "legendario"
const RAREZA_MITICO := "mitico"
const RAREZA_ANCESTRAL := "ancestral"
const RAREZA_UNICO := "unico"

const PROBABILIDAD_UNICO_PORCENTAJE: float = 0.01

const ZONA_VALDORIA: String = SistemaRegiones.ZONA_VALDORIA
const ZONA_BRUMA: String = SistemaRegiones.ZONA_BRUMA
const ZONA_ELARIS: String = SistemaRegiones.ZONA_ELARIS

const ORDEN_RAREZAS: Array[String] = [
	RAREZA_COMUN,
	RAREZA_POCO_COMUN,
	RAREZA_RARO,
	RAREZA_EPICO,
	RAREZA_LEGENDARIO,
	RAREZA_MITICO,
	RAREZA_ANCESTRAL,
	RAREZA_UNICO
]

const RAREZAS_PERMITIDAS_TIENDA: Array[String] = [
	RAREZA_COMUN,
	RAREZA_POCO_COMUN,
	RAREZA_RARO,
	RAREZA_EPICO
]

const NOMBRES_RAREZA: Dictionary = {
	RAREZA_COMUN: "COMÚN",
	RAREZA_POCO_COMUN: "POCO COMÚN",
	RAREZA_RARO: "RARO",
	RAREZA_EPICO: "ÉPICO",
	RAREZA_LEGENDARIO: "LEGENDARIO",
	RAREZA_MITICO: "MÍTICO",
	RAREZA_ANCESTRAL: "ANCESTRAL",
	RAREZA_UNICO: "ÚNICO"
}

const ENGLISH_RARITY_NAMES: Dictionary = {
	RAREZA_COMUN: "COMMON",
	RAREZA_POCO_COMUN: "UNCOMMON",
	RAREZA_RARO: "RARE",
	RAREZA_EPICO: "EPIC",
	RAREZA_LEGENDARIO: "LEGENDARY",
	RAREZA_MITICO: "MYTHIC",
	RAREZA_ANCESTRAL: "ANCESTRAL",
	RAREZA_UNICO: "UNIQUE"
}

const ENGLISH_ITEM_TEXTS: Dictionary = {
	"espada_hierro": {
		"name": "Iron Sword",
		"description": "A simple and reliable blade."
	},
	"casco_viajero": {
		"name": "Traveler's Helmet",
		"description": "Basic protection for the road."
	},
	"coraza_cuero": {
		"name": "Leather Cuirass",
		"description": "Flexible and light."
	},
	"guantes_soldado": {
		"name": "Soldier's Gloves",
		"description": "They improve the wielder's grip."
	},
	"botas_caminante": {
		"name": "Walker's Boots",
		"description": "Worn by countless roads."
	},
	"escudo_roble": {
		"name": "Oak Shield",
		"description": "Humble, heavy and sturdy."
	},
	"amuleto_cobre": {
		"name": "Copper Amulet",
		"description": "It wards off a small measure of bad luck."
	},
	"pocion_menor": {
		"name": "Minor Health Potion",
		"description": "Restores a small amount of health."
	},
	"fragmento_hierro": {
		"name": "Iron Fragment",
		"description": "A common blacksmithing material."
	},
	"sable_explorador": {
		"name": "Explorer's Sabre",
		"description": "Balanced for long expeditions."
	},
	"yelmo_guardabosques": {
		"name": "Ranger's Helm",
		"description": "Light and reinforced with steel leaves."
	},
	"malla_valdoria": {
		"name": "Valdorian Mail",
		"description": "Rings tempered in the region's ancient forges."
	},
	"botas_rastreador": {
		"name": "Tracker's Boots",
		"description": "Silent over earth and stone."
	},
	"anillo_jade": {
		"name": "Jade Ring",
		"description": "A green gem that preserves vigor."
	},
	"pocion_vigor": {
		"name": "Vigor Potion",
		"description": "Restores strength to the traveler."
	},
	"espada_valdoria": {
		"name": "Sword of Valdoria",
		"description": "Blue steel forged beside the ancient ruins."
	},
	"yelmo_esmeralda": {
		"name": "Emerald Helm",
		"description": "Its central gem seems to watch the battle."
	},
	"coraza_runica": {
		"name": "Runic Cuirass",
		"description": "Protective runes flow across its plates."
	},
	"guantes_cazador": {
		"name": "Hunter's Gloves",
		"description": "Precision even while moving."
	},
	"escudo_lunar": {
		"name": "Lunar Shield",
		"description": "It reflects a moon that does not exist."
	},
	"amuleto_bruma": {
		"name": "Mist Amulet",
		"description": "Mist coils around its gem."
	},
	"cristal_azur": {
		"name": "Azure Crystal",
		"description": "A rare material charged with energy."
	},
	"hoja_tormenta": {
		"name": "Stormblade",
		"description": "The edge hums before every bolt of lightning."
	},
	"yelmo_centella": {
		"name": "Lightning Helm",
		"description": "Bolts race across its engravings."
	},
	"armadura_grifo": {
		"name": "Gryphon Armor",
		"description": "Crafted for champions of the heights."
	},
	"botas_portal": {
		"name": "Portal Boots",
		"description": "Every step seems to shorten the road."
	},
	"anillo_eclipse": {
		"name": "Eclipse Ring",
		"description": "Light and shadow pulse within the gem."
	},
	"espada_rey_dorado": {
		"name": "Sword of the Golden King",
		"description": "A relic of Valdoria's first crown."
	},
	"coraza_sol_inmortal": {
		"name": "Cuirass of the Immortal Sun",
		"description": "Its plates hold the warmth of an eternal dawn."
	},
	"escudo_ultimo_bastion": {
		"name": "Shield of the Last Bastion",
		"description": "It has never yielded before an enemy."
	},
	"amuleto_fenix": {
		"name": "Phoenix Amulet",
		"description": "An impossible ember sleeps within."
	},
	"filo_fractura": {
		"name": "Fracture Edge",
		"description": "It cuts matter and the echo left behind."
	},
	"armadura_dragon_celeste": {
		"name": "Celestial Dragon Armor",
		"description": "Scales born above the clouds."
	},
	"corona_vacio": {
		"name": "Crown of the Void",
		"description": "It whispers names the world forgot."
	},
	"anillo_mil_estrellas": {
		"name": "Ring of a Thousand Stars",
		"description": "A tiny firmament turns within its gem."
	},
	"reliquia_primer_paladin": {
		"name": "Relic of the First Paladin",
		"description": "It preserves the Dawn's oldest oath."
	},
	"mandoble_titan": {
		"name": "Greatsword of the Sleeping Titan",
		"description": "Its weight recalls a mountain."
	},
	"manto_era_perdida": {
		"name": "Mantle of the Lost Age",
		"description": "Woven before Valdoria had a name."
	},
	"juramento_eterno": {
		"name": "Eternal Oath",
		"description": "Only one exists. The light recognizes its bearer."
	},
	"corazon_valdoria": {
		"name": "Heart of Valdoria",
		"description": "The region's pulse shaped into a relic."
	},
	"anillo_sin_nombre": {
		"name": "The Nameless Ring",
		"description": "Its true story has yet to be written."
	},
	"arco_fresno": {
		"name": "Ashwood Bow",
		"description": "A simple bow for learning the craft."
	},
	"arco_rastreador": {
		"name": "Tracker's Bow",
		"description": "Light and silent among the trees."
	},
	"arco_esmeralda": {
		"name": "Emerald Bow",
		"description": "Its arrows leave a green trail."
	},
	"arco_tormenta": {
		"name": "Storm Bow",
		"description": "Its string trembles like distant thunder."
	},
	"arco_sol_dorado": {
		"name": "Bow of the Golden Sun",
		"description": "It fires light shaped into arrows."
	},
	"arco_fractura": {
		"name": "Fracture Bow",
		"description": "Its shots pierce echoes of space."
	},
	"arco_bosque_primordial": {
		"name": "Bow of the Primeval Forest",
		"description": "Carved before roads existed."
	},
	"saeta_eterna": {
		"name": "Eternal Arrow",
		"description": "The unique bow that never misses twice."
	},
	"baston_aprendiz": {
		"name": "Apprentice Staff",
		"description": "Channels small sparks of magic."
	},
	"vara_bruma": {
		"name": "Mist Rod",
		"description": "Condenses mist into arcane energy."
	},
	"orbe_azur": {
		"name": "Azure Orb",
		"description": "A tiny sky turns within."
	},
	"baculo_celestial": {
		"name": "Celestial Staff",
		"description": "Summons fragments of fallen stars."
	},
	"cetro_fenix": {
		"name": "Phoenix Scepter",
		"description": "It burns without ever being consumed."
	},
	"grimorio_vacio": {
		"name": "Grimoire of the Void",
		"description": "Its pages answer with ancient voices."
	},
	"baston_era_perdida": {
		"name": "Staff of the Lost Age",
		"description": "It remembers spells forgotten by the world."
	},
	"codex_valdoria": {
		"name": "Codex of Valdoria",
		"description": "The region's magic bound into a single volume."
	},
	"daga_hierro": {
		"name": "Iron Dagger",
		"description": "Small, fast and easy to conceal."
	},
	"dagas_callejon": {
		"name": "Alley Daggers",
		"description": "Twin blades used by thieves of the capital."
	},
	"daga_lunar": {
		"name": "Lunar Dagger",
		"description": "It shines only before striking."
	},
	"cuchillas_eclipse": {
		"name": "Eclipse Blades",
		"description": "Two sharpened shadows that extinguish light."
	},
	"dagas_rey_sombra": {
		"name": "Daggers of the Shadow King",
		"description": "No one remembers the monarch who wielded them."
	},
	"dagas_estelares": {
		"name": "Stellar Daggers",
		"description": "Each cut leaves a broken constellation."
	},
	"cuchillas_tiempo": {
		"name": "Blades of Broken Time",
		"description": "They strike a fraction of a second before moving."
	},
	"noche_sin_nombre": {
		"name": "Nameless Night",
		"description": "A unique pair of daggers that cast no shadow."
	},
	"capa_caminante_bruma": {
		"name": "Mistwalker's Cloak",
		"description": "Its wet fabric muffles every step through the secret pass."
	},
	"botas_paso_oculto": {
		"name": "Hidden Pass Boots",
		"description": "Their soles remember roads erased by the mist."
	},
	"fragmento_estatua_paladin": {
		"name": "Fragment of the Fallen Paladin",
		"description": "A piece of sacred stone taken from a shattered guardian."
	},
	"anillo_eco_niebla": {
		"name": "Ring of the Mist Echo",
		"description": "It repeats a vow spoken centuries ago."
	},
	"hoja_guardacaminos": {
		"name": "Waywarden Blade",
		"description": "Forged for those who defended the pass before it vanished."
	},
	"mandoble_paladin_derruido": {
		"name": "Greatsword of the Fallen Paladin",
		"description": "Its broken edge still carries the weight of a sacred oath."
	},
	"coraza_guardian_bruma": {
		"name": "Cuirass of the Mist Guardian",
		"description": "Ancient plates shaped to endure the pressure of the veil."
	},
	"yelmo_vigia_velado": {
		"name": "Helm of the Veiled Watcher",
		"description": "The visor sees movement through the thickest fog."
	},
	"escudo_puerta_niebla": {
		"name": "Shield of the Mist Gate",
		"description": "A fortress door reduced to a shield, yet no less unyielding."
	},
	"amuleto_paso_secreto": {
		"name": "Amulet of the Secret Pass",
		"description": "Its pale gem points toward paths hidden from ordinary eyes."
	},
	"alma_paladin_derruido": {
		"name": "Soul of the Fallen Paladin",
		"description": "The final light of the guardian whose statue watches the pass."
	}
}

const COLORES_RAREZA: Dictionary = {
	RAREZA_COMUN: Color("#C7CCD4"),
	RAREZA_POCO_COMUN: Color("#55D978"),
	RAREZA_RARO: Color("#4FA4FF"),
	RAREZA_EPICO: Color("#B66CFF"),
	RAREZA_LEGENDARIO: Color("#FFAD45"),
	RAREZA_MITICO: Color("#FF4F7B"),
	RAREZA_ANCESTRAL: Color("#55F2E1"),
	RAREZA_UNICO: Color("#58FFB5")
}

const MULTIPLICADORES_RAREZA: Dictionary = {
	RAREZA_COMUN: 1.00,
	RAREZA_POCO_COMUN: 1.20,
	RAREZA_RARO: 1.50,
	RAREZA_EPICO: 1.90,
	RAREZA_LEGENDARIO: 2.50,
	RAREZA_MITICO: 3.20,
	RAREZA_ANCESTRAL: 4.15,
	RAREZA_UNICO: 6.00
}

const OBJETOS: Array = [

	{"id":"espada_hierro","name":"Espada de Hierro","description":"Una hoja sencilla y fiable.","rarity":RAREZA_COMUN,"category":"equipo","equip_slot":"arma","min_level":1,"base_stats":{"daño":4}},
	{"id":"casco_viajero","name":"Casco del Viajero","description":"Protección básica para los caminos.","rarity":RAREZA_COMUN,"category":"equipo","equip_slot":"casco","min_level":1,"base_stats":{"vida":5,"def":2}},
	{"id":"coraza_cuero","name":"Coraza de Cuero","description":"Flexible y ligera.","rarity":RAREZA_COMUN,"category":"equipo","equip_slot":"armadura","min_level":1,"base_stats":{"vida":9,"def":3}},
	{"id":"guantes_soldado","name":"Guantes de Soldado","description":"Mejoran el agarre del arma.","rarity":RAREZA_COMUN,"category":"equipo","equip_slot":"guantes","min_level":1,"base_stats":{"daño":2,"def":1}},
	{"id":"botas_caminante","name":"Botas del Caminante","description":"Curtidas por incontables senderos.","rarity":RAREZA_COMUN,"category":"equipo","equip_slot":"botas","min_level":1,"base_stats":{"vel":2}},
	{"id":"escudo_roble","name":"Escudo de Roble","description":"Humilde, pesado y resistente.","rarity":RAREZA_COMUN,"category":"equipo","equip_slot":"escudo","min_level":1,"base_stats":{"vida":3,"def":4}},
	{"id":"amuleto_cobre","name":"Amuleto de Cobre","description":"Aleja una pequeña parte de la mala fortuna.","rarity":RAREZA_COMUN,"category":"equipo","equip_slot":"amuleto","min_level":1,"base_stats":{"vida":4,"magia":1}},
	{"id":"pocion_menor","name":"Poción Menor de Vida","description":"Recupera una pequeña cantidad de vida.","rarity":RAREZA_COMUN,"category":"objetos","equip_slot":"","min_level":1,"stackable":true,"consumable":true,"quantity_min":1,"quantity_max":3,"effect":{"heal":25},"base_stats":{}},
	{"id":"fragmento_hierro","name":"Fragmento de Hierro","description":"Material común de herrería.","rarity":RAREZA_COMUN,"category":"materiales","equip_slot":"","min_level":1,"stackable":true,"quantity_min":1,"quantity_max":4,"base_stats":{}},
	{"id":"sable_explorador","name":"Sable del Explorador","description":"Equilibrado para largas expediciones.","rarity":RAREZA_POCO_COMUN,"category":"equipo","equip_slot":"arma","min_level":3,"base_stats":{"daño":6,"vel":1}},
	
	{"id":"yelmo_guardabosques","name":"Yelmo del Guardabosques","description":"Ligero y reforzado con hojas de acero.","rarity":RAREZA_POCO_COMUN,"category":"equipo","equip_slot":"casco","min_level":3,"base_stats":{"vida":7,"def":4}},
	{"id":"malla_valdoria","zones":[ZONA_VALDORIA],"name":"Malla de Valdoria","description":"Anillas templadas en los hornos de la región.","rarity":RAREZA_POCO_COMUN,"category":"equipo","equip_slot":"armadura","min_level":4,"base_stats":{"vida":13,"def":6}},
	{"id":"botas_rastreador","name":"Botas del Rastreador","description":"Silenciosas sobre tierra y piedra.","rarity":RAREZA_POCO_COMUN,"category":"equipo","equip_slot":"botas","min_level":4,"base_stats":{"vel":4,"def":1}},
	{"id":"anillo_jade","name":"Anillo de Jade","description":"Una gema verde que conserva el vigor.","rarity":RAREZA_POCO_COMUN,"category":"equipo","equip_slot":"anillo_1","min_level":4,"base_stats":{"vida":6,"magia":2}},
	{"id":"pocion_vigor","name":"Poción de Vigor","description":"Devuelve fuerzas al viajero.","rarity":RAREZA_POCO_COMUN,"category":"objetos","equip_slot":"","min_level":3,"stackable":true,"consumable":true,"quantity_min":1,"quantity_max":2,"effect":{"heal":45},"base_stats":{}},

	{"id":"espada_valdoria","zones":[ZONA_VALDORIA],"name":"Espada de Valdoria","description":"Acero azul forjado junto a las antiguas ruinas.","rarity":RAREZA_RARO,"category":"equipo","equip_slot":"arma","min_level":6,"base_stats":{"daño":9,"vel":2}},
	{"id":"yelmo_esmeralda","name":"Yelmo Esmeralda","description":"Su gema central parece observar el combate.","rarity":RAREZA_RARO,"category":"equipo","equip_slot":"casco","min_level":8,"base_stats":{"vida":10,"def":7}},
	{"id":"coraza_runica","name":"Coraza Rúnica","description":"Runas protectoras recorren sus placas.","rarity":RAREZA_RARO,"category":"equipo","equip_slot":"armadura","min_level":10,"base_stats":{"vida":18,"def":9,"magia":2}},
	{"id":"guantes_cazador","name":"Guantes del Cazador","description":"Precisión incluso en movimiento.","rarity":RAREZA_RARO,"category":"equipo","equip_slot":"guantes","min_level":8,"base_stats":{"daño":6,"vel":4}},
	{"id":"escudo_lunar","name":"Escudo Lunar","description":"Refleja una luna que no existe.","rarity":RAREZA_RARO,"category":"equipo","equip_slot":"escudo","min_level":12,"base_stats":{"vida":12,"def":12,"magia":3}},
	{"id":"amuleto_bruma","zones":[ZONA_BRUMA],"name":"Amuleto de la Bruma","description":"La niebla se arremolina alrededor de su gema.","rarity":RAREZA_RARO,"category":"equipo","equip_slot":"amuleto","min_level":12,"base_stats":{"vida":8,"magia":9}},
	{"id":"cristal_azur","name":"Cristal Azur","description":"Material raro cargado de energía.","rarity":RAREZA_RARO,"category":"materiales","equip_slot":"","min_level":8,"stackable":true,"quantity_min":1,"quantity_max":2,"base_stats":{}},

	{"id":"hoja_tormenta","name":"Hoja de la Tormenta","description":"El filo vibra antes de cada relámpago.","rarity":RAREZA_EPICO,"category":"equipo","equip_slot":"arma","min_level":18,"base_stats":{"daño":15,"vel":6}},
	{"id":"yelmo_centella","name":"Yelmo de la Centella","description":"Los rayos recorren sus grabados.","rarity":RAREZA_EPICO,"category":"equipo","equip_slot":"casco","min_level":20,"base_stats":{"vida":18,"def":12,"magia":5}},
	{"id":"armadura_grifo","name":"Armadura del Grifo","description":"Creada para los campeones de las alturas.","rarity":RAREZA_EPICO,"category":"equipo","equip_slot":"armadura","min_level":22,"base_stats":{"vida":30,"def":17,"vel":4}},
	{"id":"botas_portal","zones":[ZONA_BRUMA],"name":"Botas del Portal","description":"Cada paso parece acortar el camino.","rarity":RAREZA_EPICO,"category":"equipo","equip_slot":"botas","min_level":20,"base_stats":{"vel":12,"magia":5}},
	{"id":"anillo_eclipse","zones":[ZONA_BRUMA],"name":"Anillo del Eclipse","description":"Luz y sombra laten dentro de la gema.","rarity":RAREZA_EPICO,"category":"equipo","equip_slot":"anillo_2","min_level":24,"base_stats":{"daño":8,"magia":12}},

	{"id":"espada_rey_dorado","zones":[ZONA_VALDORIA],"name":"Espada del Rey Dorado","description":"Una reliquia hallada entre las antiguas coronas de Valdoria.","rarity":RAREZA_LEGENDARIO,"category":"equipo","equip_slot":"arma","min_level":30,"base_stats":{"daño":24,"vida":12,"def":6}},
	{"id":"coraza_sol_inmortal","zones":[ZONA_VALDORIA],"name":"Coraza del Sol Inmortal","description":"Sus placas guardan el calor de un amanecer eterno.","rarity":RAREZA_LEGENDARIO,"category":"equipo","equip_slot":"armadura","min_level":32,"base_stats":{"vida":46,"def":25,"magia":8}},
	{"id":"escudo_ultimo_bastion","zones":[ZONA_VALDORIA],"name":"Escudo del Último Bastión","description":"Nunca ha retrocedido ante un enemigo.","rarity":RAREZA_LEGENDARIO,"category":"equipo","equip_slot":"escudo","min_level":34,"base_stats":{"vida":34,"def":31}},
	{"id":"amuleto_fenix","zones":[ZONA_VALDORIA],"name":"Amuleto del Fénix","description":"Una brasa imposible duerme en su interior.","rarity":RAREZA_LEGENDARIO,"category":"equipo","equip_slot":"amuleto","min_level":36,"base_stats":{"vida":24,"magia":22,"daño":7}},

	{"id":"capa_caminante_bruma","zones":[ZONA_BRUMA],"name":"Capa del Caminante de Bruma","description":"Su tejido húmedo amortigua cada paso por la ruta secreta.","rarity":RAREZA_POCO_COMUN,"category":"equipo","equip_slot":"armadura","min_level":12,"base_stats":{"vida":15,"def":7,"vel":3}},
	{"id":"botas_paso_oculto","zones":[ZONA_BRUMA],"name":"Botas del Paso Oculto","description":"Sus suelas recuerdan senderos borrados por la niebla.","rarity":RAREZA_RARO,"category":"equipo","equip_slot":"botas","min_level":16,"base_stats":{"vel":9,"def":5,"vida":8}},
	{"id":"fragmento_estatua_paladin","zones":[ZONA_BRUMA],"name":"Fragmento del Paladín Derruido","description":"Piedra sagrada desprendida del antiguo guardián del paso.","rarity":RAREZA_RARO,"category":"materiales","equip_slot":"","min_level":14,"stackable":true,"quantity_min":1,"quantity_max":2,"base_stats":{}},
	{"id":"anillo_eco_niebla","zones":[ZONA_BRUMA],"name":"Anillo del Eco de Niebla","description":"Repite un juramento pronunciado siglos atrás.","rarity":RAREZA_EPICO,"category":"equipo","equip_slot":"anillo_2","min_level":22,"base_stats":{"vida":14,"magia":16,"vel":7}},
	{"id":"hoja_guardacaminos","zones":[ZONA_BRUMA],"name":"Hoja del Guardacaminos","description":"Forjada para quienes protegían el paso antes de desaparecer.","rarity":RAREZA_EPICO,"category":"equipo","equip_slot":"arma","weapon_type":"espada","allowed_classes":["paladin","caballero"],"min_level":24,"base_stats":{"daño":18,"def":8,"vel":5}},

	{"id":"mandoble_paladin_derruido","zones":[ZONA_BRUMA],"name":"Mandoble del Paladín Derruido","description":"Su filo quebrado todavía sostiene el peso de un juramento sagrado.","rarity":RAREZA_LEGENDARIO,"category":"equipo","equip_slot":"arma","weapon_type":"mandoble","allowed_classes":["paladin","caballero"],"min_level":28,"base_stats":{"daño":29,"vida":24,"def":12}},
	{"id":"coraza_guardian_bruma","zones":[ZONA_BRUMA],"name":"Coraza del Guardián de Bruma","description":"Placas antiguas creadas para resistir la presión del velo.","rarity":RAREZA_LEGENDARIO,"category":"equipo","equip_slot":"armadura","min_level":30,"base_stats":{"vida":52,"def":28,"magia":12}},
	{"id":"yelmo_vigia_velado","zones":[ZONA_BRUMA],"name":"Yelmo del Vigía Velado","description":"La visera distingue movimiento incluso dentro de la niebla más espesa.","rarity":RAREZA_LEGENDARIO,"category":"equipo","equip_slot":"casco","min_level":30,"base_stats":{"vida":28,"def":21,"magia":14}},
	{"id":"escudo_puerta_niebla","zones":[ZONA_BRUMA],"name":"Escudo de la Puerta de Niebla","description":"Una puerta de fortaleza convertida en escudo, igual de implacable.","rarity":RAREZA_LEGENDARIO,"category":"equipo","equip_slot":"escudo","allowed_classes":["paladin"],"min_level":32,"base_stats":{"vida":40,"def":35,"magia":8}},
	{"id":"amuleto_paso_secreto","zones":[ZONA_BRUMA],"name":"Amuleto del Paso Secreto","description":"Su gema pálida señala caminos ocultos para los ojos comunes.","rarity":RAREZA_LEGENDARIO,"category":"equipo","equip_slot":"amuleto","min_level":31,"base_stats":{"vida":26,"daño":9,"vel":9,"magia":24}},

	{"id":"filo_fractura","zones":[ZONA_BRUMA],"name":"Filo de la Fractura","description":"Corta la materia y el eco que deja atrás.","rarity":RAREZA_MITICO,"category":"equipo","equip_slot":"arma","min_level":45,"base_stats":{"daño":36,"vel":12,"magia":14}},
	{"id":"armadura_dragon_celeste","name":"Armadura del Dragón Celeste","description":"Escamas nacidas por encima de las nubes.","rarity":RAREZA_MITICO,"category":"equipo","equip_slot":"armadura","min_level":48,"base_stats":{"vida":70,"def":38,"magia":16}},
	{"id":"corona_vacio","zones":[ZONA_BRUMA],"name":"Corona del Vacío","description":"Susurra nombres que el mundo olvidó.","rarity":RAREZA_MITICO,"category":"equipo","equip_slot":"casco","min_level":50,"base_stats":{"vida":30,"def":20,"magia":35}},
	{"id":"anillo_mil_estrellas","name":"Anillo de las Mil Estrellas","description":"Un pequeño firmamento gira en su gema.","rarity":RAREZA_MITICO,"category":"equipo","equip_slot":"anillo_1","min_level":52,"base_stats":{"daño":16,"vel":12,"magia":28}},

	{"id":"reliquia_primer_paladin","name":"Reliquia del Primer Paladín","description":"Conserva el juramento más antiguo del Alba.","rarity":RAREZA_ANCESTRAL,"category":"equipo","equip_slot":"estandarte","min_level":65,"base_stats":{"vida":80,"daño":25,"def":35,"magia":28}},
	{"id":"mandoble_titan","name":"Mandoble del Titán Dormido","description":"Su peso recuerda a una montaña.","rarity":RAREZA_ANCESTRAL,"category":"equipo","equip_slot":"arma","min_level":70,"base_stats":{"daño":58,"vida":40,"def":15}},
	{"id":"manto_era_perdida","name":"Manto de la Era Perdida","description":"Tejido antes de que Valdoria tuviera nombre.","rarity":RAREZA_ANCESTRAL,"category":"equipo","equip_slot":"armadura","min_level":72,"base_stats":{"vida":105,"def":52,"vel":18,"magia":35}},

	{"id":"juramento_eterno","name":"Juramento Eterno","description":"Solo existe uno. La luz reconoce a su portador.","rarity":RAREZA_UNICO,"category":"equipo","equip_slot":"arma","min_level":1,"base_stats":{"vida":90,"daño":75,"def":45,"vel":25,"magia":55},"passive":{"type":"periodic_shield","name":"Égida del Juramento","shield":180,"cooldown":55.0}},
	{"id":"corazon_valdoria","zones":[ZONA_VALDORIA],"name":"Corazón de Valdoria","description":"El pulso de la región convertido en reliquia.","rarity":RAREZA_UNICO,"category":"equipo","equip_slot":"estandarte","min_level":1,"base_stats":{"vida":140,"daño":40,"def":65,"vel":30,"magia":80},"passive":{"type":"periodic_shield","name":"Pulso Protector","shield":220,"cooldown":65.0}},
	{"id":"alma_paladin_derruido","zones":[ZONA_BRUMA],"name":"Alma del Paladín Derruido","description":"La última luz del guardián cuya estatua vigila el paso.","rarity":RAREZA_UNICO,"category":"equipo","equip_slot":"estandarte","min_level":1,"base_stats":{"vida":155,"daño":52,"def":72,"vel":28,"magia":92},"passive":{"type":"periodic_shield","name":"Vigilia de la Estatua","shield":260,"cooldown":60.0}},
	{"id":"anillo_sin_nombre","name":"El Anillo Sin Nombre","description":"Su verdadera historia aún no ha sido escrita.","rarity":RAREZA_UNICO,"category":"equipo","equip_slot":"anillo_2","min_level":1,"base_stats":{"vida":65,"daño":48,"def":40,"vel":42,"magia":70},"passive":{"type":"periodic_shield","name":"Velo Innominado","shield":120,"cooldown":50.0}},

	{"id":"arco_fresno","name":"Arco de Fresno","description":"Un arco sencillo para aprender el oficio.","rarity":RAREZA_COMUN,"category":"equipo","equip_slot":"arma","weapon_type":"arco","allowed_classes":["arquero"],"min_level":1,"base_stats":{"daño":4,"vel":2}},
	{"id":"arco_rastreador","name":"Arco del Rastreador","description":"Ligero y silencioso entre los árboles.","rarity":RAREZA_POCO_COMUN,"category":"equipo","equip_slot":"arma","weapon_type":"arco","allowed_classes":["arquero"],"min_level":4,"base_stats":{"daño":7,"vel":4}},
	{"id":"arco_esmeralda","name":"Arco Esmeralda","description":"Sus flechas dejan una estela verde.","rarity":RAREZA_RARO,"category":"equipo","equip_slot":"arma","weapon_type":"arco","allowed_classes":["arquero"],"min_level":10,"base_stats":{"daño":12,"vel":7}},
	{"id":"arco_tormenta","name":"Arco de la Tormenta","description":"Cada cuerda vibra como un trueno lejano.","rarity":RAREZA_EPICO,"category":"equipo","equip_slot":"arma","weapon_type":"arco","allowed_classes":["arquero"],"min_level":22,"base_stats":{"daño":20,"vel":11}},
	{"id":"arco_sol_dorado","name":"Arco del Sol Dorado","description":"Dispara luz convertida en flecha.","rarity":RAREZA_LEGENDARIO,"category":"equipo","equip_slot":"arma","weapon_type":"arco","allowed_classes":["arquero"],"min_level":34,"base_stats":{"daño":31,"vel":16,"magia":8}},
	{"id":"arco_fractura","name":"Arco de la Fractura","description":"Sus proyectiles atraviesan ecos del espacio.","rarity":RAREZA_MITICO,"category":"equipo","equip_slot":"arma","weapon_type":"arco","allowed_classes":["arquero"],"min_level":48,"base_stats":{"daño":44,"vel":22,"magia":14}},
	{"id":"arco_bosque_primordial","name":"Arco del Bosque Primordial","description":"Tallado antes de que existieran los caminos.","rarity":RAREZA_ANCESTRAL,"category":"equipo","equip_slot":"arma","weapon_type":"arco","allowed_classes":["arquero"],"min_level":70,"base_stats":{"daño":66,"vel":34,"vida":24}},
	{"id":"saeta_eterna","name":"Saeta Eterna","description":"El arco único que jamás falla dos veces.","rarity":RAREZA_UNICO,"category":"equipo","equip_slot":"arma","weapon_type":"arco","allowed_classes":["arquero"],"min_level":1,"base_stats":{"vida":55,"daño":88,"def":24,"vel":62,"magia":38},"passive":{"type":"periodic_shield","name":"Guardia del Viento","shield":110,"cooldown":55.0}},

	{"id":"baston_aprendiz","name":"Bastón de Aprendiz","description":"Canaliza pequeñas chispas de magia.","rarity":RAREZA_COMUN,"category":"equipo","equip_slot":"arma","weapon_type":"magia","allowed_classes":["arcanista","nigromante"],"min_level":1,"base_stats":{"daño":3,"magia":5}},
	{"id":"vara_bruma","zones":[ZONA_BRUMA],"name":"Vara de la Bruma","description":"Condensa la niebla en energía arcana.","rarity":RAREZA_POCO_COMUN,"category":"equipo","equip_slot":"arma","weapon_type":"magia","allowed_classes":["arcanista","nigromante"],"min_level":4,"base_stats":{"daño":5,"magia":9}},
	{"id":"orbe_azur","name":"Orbe Azur","description":"Un pequeño cielo gira en su interior.","rarity":RAREZA_RARO,"category":"equipo","equip_slot":"arma","weapon_type":"magia","allowed_classes":["arcanista","nigromante"],"min_level":10,"base_stats":{"daño":9,"magia":16}},
	{"id":"baculo_celestial","name":"Báculo Celestial","description":"Invoca fragmentos de estrellas caídas.","rarity":RAREZA_EPICO,"category":"equipo","equip_slot":"arma","weapon_type":"magia","allowed_classes":["arcanista","nigromante"],"min_level":22,"base_stats":{"daño":16,"magia":27}},
	{"id":"cetro_fenix","name":"Cetro del Fénix","description":"Arde sin consumirse jamás.","rarity":RAREZA_LEGENDARIO,"category":"equipo","equip_slot":"arma","weapon_type":"magia","allowed_classes":["arcanista","nigromante"],"min_level":34,"base_stats":{"daño":24,"magia":42,"vida":12}},
	{"id":"grimorio_vacio","zones":[ZONA_BRUMA],"name":"Grimorio del Vacío","description":"Sus páginas responden con voces antiguas.","rarity":RAREZA_MITICO,"category":"equipo","equip_slot":"arma","weapon_type":"magia","allowed_classes":["arcanista","nigromante"],"min_level":48,"base_stats":{"daño":35,"magia":60,"def":10}},
	{"id":"baston_era_perdida","name":"Bastón de la Era Perdida","description":"Recuerda hechizos olvidados por el mundo.","rarity":RAREZA_ANCESTRAL,"category":"equipo","equip_slot":"arma","weapon_type":"magia","allowed_classes":["arcanista","nigromante"],"min_level":70,"base_stats":{"daño":48,"magia":88,"vida":30}},
	{"id":"codex_valdoria","name":"Códice de Valdoria","description":"La magia de Valdoria escrita en un único volumen.","rarity":RAREZA_UNICO,"category":"equipo","equip_slot":"arma","weapon_type":"magia","allowed_classes":["arcanista","nigromante"],"min_level":1,"base_stats":{"vida":65,"daño":72,"def":30,"vel":28,"magia":110},"passive":{"type":"periodic_shield","name":"Barrera Arcana","shield":150,"cooldown":60.0}},

	{"id":"daga_hierro","name":"Daga de Hierro","description":"Pequeña, rápida y fácil de ocultar.","rarity":RAREZA_COMUN,"category":"equipo","equip_slot":"arma","weapon_type":"daga","allowed_classes":["asesino"],"min_level":1,"base_stats":{"daño":4,"vel":4}},
	{"id":"dagas_callejon","name":"Dagas del Callejón","description":"Dos hojas usadas por los ladrones de la capital.","rarity":RAREZA_POCO_COMUN,"category":"equipo","equip_slot":"arma","weapon_type":"daga","allowed_classes":["asesino"],"min_level":4,"base_stats":{"daño":7,"vel":7}},
	{"id":"daga_lunar","name":"Daga Lunar","description":"Brilla solo antes de atacar.","rarity":RAREZA_RARO,"category":"equipo","equip_slot":"arma","weapon_type":"daga","allowed_classes":["asesino"],"min_level":10,"base_stats":{"daño":12,"vel":11}},
	{"id":"cuchillas_eclipse","zones":[ZONA_BRUMA],"name":"Cuchillas del Eclipse","description":"Dos sombras afiladas que apagan la luz.","rarity":RAREZA_EPICO,"category":"equipo","equip_slot":"arma","weapon_type":"daga","allowed_classes":["asesino"],"min_level":22,"base_stats":{"daño":20,"vel":18}},
	{"id":"dagas_rey_sombra","name":"Dagas del Rey Sombra","description":"Nadie recuerda al monarca que las empuñó.","rarity":RAREZA_LEGENDARIO,"category":"equipo","equip_slot":"arma","weapon_type":"daga","allowed_classes":["asesino"],"min_level":34,"base_stats":{"daño":31,"vel":27,"magia":6}},
	{"id":"dagas_estelares","name":"Dagas Estelares","description":"Cada corte deja una constelación rota.","rarity":RAREZA_MITICO,"category":"equipo","equip_slot":"arma","weapon_type":"daga","allowed_classes":["asesino"],"min_level":48,"base_stats":{"daño":44,"vel":38,"magia":12}},
	{"id":"cuchillas_tiempo","name":"Cuchillas del Tiempo Roto","description":"Atacan una fracción de segundo antes de moverse.","rarity":RAREZA_ANCESTRAL,"category":"equipo","equip_slot":"arma","weapon_type":"daga","allowed_classes":["asesino"],"min_level":70,"base_stats":{"daño":64,"vel":55,"vida":18}},
	{"id":"noche_sin_nombre","name":"Noche Sin Nombre","description":"Un par de dagas únicas que no proyectan sombra.","rarity":RAREZA_UNICO,"category":"equipo","equip_slot":"arma","weapon_type":"daga","allowed_classes":["asesino"],"min_level":1,"base_stats":{"vida":44,"daño":94,"def":22,"vel":92,"magia":36},"passive":{"type":"periodic_shield","name":"Manto de Sombras","shield":100,"cooldown":50.0}},

	{"id":"valdoria_casco_01","name":"Capucha del Sendero","name_en":"Road Hood","description":"Reliquia regional de Valdoria, forjada para la etapa 0-1.","description_en":"A regional relic of Valdoria, forged for stage 0-1.","rarity":RAREZA_COMUN,"category":"equipo","equip_slot":"casco","allowed_classes":["paladin","arquero","arcanista"],"min_level":1,"base_stats":{"vida":8,"def":3},"icon_path":"res://Recursos/UI/Inventario/Slots/casco.png","zones":[ZONA_VALDORIA],"stage_special":true,"stage_index":1}
,
	{"id":"valdoria_casco_02","name":"Yelmo de Hiedra","name_en":"Ivy Helm","description":"Reliquia regional de Valdoria, forjada para la etapa 0-1.","description_en":"A regional relic of Valdoria, forged for stage 0-1.","rarity":RAREZA_POCO_COMUN,"category":"equipo","equip_slot":"casco","allowed_classes":["paladin","arquero","arcanista"],"min_level":6,"base_stats":{"vida":16,"def":6},"icon_path":"res://Recursos/UI/Inventario/Slots/casco.png","zones":[ZONA_VALDORIA],"stage_special":true,"stage_index":2}
,
	{"id":"valdoria_casco_03","name":"Casco del Guardarruinas","name_en":"Ruinguard Helm","description":"Reliquia regional de Valdoria, forjada para la etapa 0-1.","description_en":"A regional relic of Valdoria, forged for stage 0-1.","rarity":RAREZA_RARO,"category":"equipo","equip_slot":"casco","allowed_classes":["paladin","arquero","arcanista"],"min_level":14,"base_stats":{"vida":24,"def":9},"icon_path":"res://Recursos/UI/Inventario/Slots/casco.png","zones":[ZONA_VALDORIA],"stage_special":true,"stage_index":3}
,
	{"id":"valdoria_casco_04","name":"Corona del Grifo","name_en":"Gryphon Crown","description":"Reliquia regional de Valdoria, forjada para la etapa 0-1.","description_en":"A regional relic of Valdoria, forged for stage 0-1.","rarity":RAREZA_EPICO,"category":"equipo","equip_slot":"casco","allowed_classes":["paladin","arquero","arcanista"],"min_level":24,"base_stats":{"vida":32,"def":12},"icon_path":"res://Recursos/UI/Inventario/Slots/casco.png","zones":[ZONA_VALDORIA],"stage_special":true,"stage_index":4}
,
	{"id":"valdoria_casco_05","name":"Yelmo del Primer Alba","name_en":"Helm of the First Dawn","description":"Reliquia regional de Valdoria, forjada para la etapa 0-1.","description_en":"A regional relic of Valdoria, forged for stage 0-1.","rarity":RAREZA_LEGENDARIO,"category":"equipo","equip_slot":"casco","allowed_classes":["paladin","arquero","arcanista"],"min_level":38,"base_stats":{"vida":40,"def":15},"icon_path":"res://Recursos/UI/Inventario/Slots/casco.png","zones":[ZONA_VALDORIA],"stage_special":true,"stage_index":5}
,
	{"id":"valdoria_armadura_01","name":"Cuero de Caminante","name_en":"Wanderer Leather","description":"Reliquia regional de Valdoria, forjada para la etapa 0-1.","description_en":"A regional relic of Valdoria, forged for stage 0-1.","rarity":RAREZA_COMUN,"category":"equipo","equip_slot":"armadura","allowed_classes":["paladin","arquero","arcanista"],"min_level":1,"base_stats":{"vida":16,"def":5},"icon_path":"res://Recursos/UI/Inventario/Slots/armadura.png","zones":[ZONA_VALDORIA],"stage_special":true,"stage_index":6}
,
	{"id":"valdoria_armadura_02","name":"Malla de Valdoria","name_en":"Valdoria Mail","description":"Reliquia regional de Valdoria, forjada para la etapa 0-1.","description_en":"A regional relic of Valdoria, forged for stage 0-1.","rarity":RAREZA_POCO_COMUN,"category":"equipo","equip_slot":"armadura","allowed_classes":["paladin","arquero","arcanista"],"min_level":6,"base_stats":{"vida":32,"def":10},"icon_path":"res://Recursos/UI/Inventario/Slots/armadura.png","zones":[ZONA_VALDORIA],"stage_special":true,"stage_index":7}
,
	{"id":"valdoria_armadura_03","name":"Coraza de Roble Azul","name_en":"Blue Oak Cuirass","description":"Reliquia regional de Valdoria, forjada para la etapa 0-1.","description_en":"A regional relic of Valdoria, forged for stage 0-1.","rarity":RAREZA_RARO,"category":"equipo","equip_slot":"armadura","allowed_classes":["paladin","arquero","arcanista"],"min_level":14,"base_stats":{"vida":48,"def":15},"icon_path":"res://Recursos/UI/Inventario/Slots/armadura.png","zones":[ZONA_VALDORIA],"stage_special":true,"stage_index":8}
,
	{"id":"valdoria_armadura_04","name":"Armadura del León Solar","name_en":"Solar Lion Armor","description":"Reliquia regional de Valdoria, forjada para la etapa 0-1.","description_en":"A regional relic of Valdoria, forged for stage 0-1.","rarity":RAREZA_EPICO,"category":"equipo","equip_slot":"armadura","allowed_classes":["paladin","arquero","arcanista"],"min_level":24,"base_stats":{"vida":64,"def":20},"icon_path":"res://Recursos/UI/Inventario/Slots/armadura.png","zones":[ZONA_VALDORIA],"stage_special":true,"stage_index":9}
,
	{"id":"valdoria_armadura_05","name":"Armadura del Dragón Celeste","name_en":"Celestial Dragon Armor","description":"Reliquia regional de Valdoria, forjada para la etapa 0-1.","description_en":"A regional relic of Valdoria, forged for stage 0-1.","rarity":RAREZA_MITICO,"category":"equipo","equip_slot":"armadura","allowed_classes":["paladin","arquero","arcanista"],"min_level":50,"base_stats":{"vida":80,"def":25},"icon_path":"res://Recursos/UI/Inventario/Slots/armadura.png","zones":[ZONA_VALDORIA],"stage_special":true,"stage_index":10}
,
	{"id":"valdoria_guantes_01","name":"Guantes de Senda","name_en":"Road Gloves","description":"Reliquia regional de Valdoria, forjada para la etapa 0-1.","description_en":"A regional relic of Valdoria, forged for stage 0-1.","rarity":RAREZA_COMUN,"category":"equipo","equip_slot":"guantes","allowed_classes":["paladin","arquero","arcanista"],"min_level":1,"base_stats":{"daño":3,"vel":2},"icon_path":"res://Recursos/UI/Inventario/Slots/guantes.png","zones":[ZONA_VALDORIA],"stage_special":true,"stage_index":11}
,
	{"id":"valdoria_guantes_02","name":"Guanteletes de Fresno","name_en":"Ashwood Gauntlets","description":"Reliquia regional de Valdoria, forjada para la etapa 0-1.","description_en":"A regional relic of Valdoria, forged for stage 0-1.","rarity":RAREZA_POCO_COMUN,"category":"equipo","equip_slot":"guantes","allowed_classes":["paladin","arquero","arcanista"],"min_level":6,"base_stats":{"daño":6,"vel":4},"icon_path":"res://Recursos/UI/Inventario/Slots/guantes.png","zones":[ZONA_VALDORIA],"stage_special":true,"stage_index":12}
,
	{"id":"valdoria_guantes_03","name":"Manoplas del Cazador Verde","name_en":"Green Hunter Grips","description":"Reliquia regional de Valdoria, forjada para la etapa 0-1.","description_en":"A regional relic of Valdoria, forged for stage 0-1.","rarity":RAREZA_RARO,"category":"equipo","equip_slot":"guantes","allowed_classes":["paladin","arquero","arcanista"],"min_level":14,"base_stats":{"daño":9,"vel":6},"icon_path":"res://Recursos/UI/Inventario/Slots/guantes.png","zones":[ZONA_VALDORIA],"stage_special":true,"stage_index":13}
,
	{"id":"valdoria_guantes_04","name":"Guantes de Tormenta","name_en":"Storm Gloves","description":"Reliquia regional de Valdoria, forjada para la etapa 0-1.","description_en":"A regional relic of Valdoria, forged for stage 0-1.","rarity":RAREZA_EPICO,"category":"equipo","equip_slot":"guantes","allowed_classes":["paladin","arquero","arcanista"],"min_level":24,"base_stats":{"daño":12,"vel":8},"icon_path":"res://Recursos/UI/Inventario/Slots/guantes.png","zones":[ZONA_VALDORIA],"stage_special":true,"stage_index":14}
,
	{"id":"valdoria_guantes_05","name":"Puños del Rey Dorado","name_en":"Golden King Fists","description":"Reliquia regional de Valdoria, forjada para la etapa 0-1.","description_en":"A regional relic of Valdoria, forged for stage 0-1.","rarity":RAREZA_LEGENDARIO,"category":"equipo","equip_slot":"guantes","allowed_classes":["paladin","arquero","arcanista"],"min_level":38,"base_stats":{"daño":15,"vel":10},"icon_path":"res://Recursos/UI/Inventario/Slots/guantes.png","zones":[ZONA_VALDORIA],"stage_special":true,"stage_index":15}
,
	{"id":"valdoria_botas_01","name":"Botas de Prado","name_en":"Meadow Boots","description":"Reliquia regional de Valdoria, forjada para la etapa 0-1.","description_en":"A regional relic of Valdoria, forged for stage 0-1.","rarity":RAREZA_COMUN,"category":"equipo","equip_slot":"botas","allowed_classes":["paladin","arquero","arcanista"],"min_level":1,"base_stats":{"vel":3,"def":2},"icon_path":"res://Recursos/UI/Inventario/Slots/botas.png","zones":[ZONA_VALDORIA],"stage_special":true,"stage_index":16}
,
	{"id":"valdoria_botas_02","name":"Botas del Rastreador","name_en":"Tracker Boots","description":"Reliquia regional de Valdoria, forjada para la etapa 0-1.","description_en":"A regional relic of Valdoria, forged for stage 0-1.","rarity":RAREZA_POCO_COMUN,"category":"equipo","equip_slot":"botas","allowed_classes":["paladin","arquero","arcanista"],"min_level":6,"base_stats":{"vel":6,"def":4},"icon_path":"res://Recursos/UI/Inventario/Slots/botas.png","zones":[ZONA_VALDORIA],"stage_special":true,"stage_index":17}
,
	{"id":"valdoria_botas_03","name":"Grebas de la Antigua Ruta","name_en":"Ancient Route Greaves","description":"Reliquia regional de Valdoria, forjada para la etapa 0-1.","description_en":"A regional relic of Valdoria, forged for stage 0-1.","rarity":RAREZA_RARO,"category":"equipo","equip_slot":"botas","allowed_classes":["paladin","arquero","arcanista"],"min_level":14,"base_stats":{"vel":9,"def":6},"icon_path":"res://Recursos/UI/Inventario/Slots/botas.png","zones":[ZONA_VALDORIA],"stage_special":true,"stage_index":18}
,
	{"id":"valdoria_botas_04","name":"Pasos del Portal Verde","name_en":"Green Portal Steps","description":"Reliquia regional de Valdoria, forjada para la etapa 0-1.","description_en":"A regional relic of Valdoria, forged for stage 0-1.","rarity":RAREZA_EPICO,"category":"equipo","equip_slot":"botas","allowed_classes":["paladin","arquero","arcanista"],"min_level":24,"base_stats":{"vel":12,"def":8},"icon_path":"res://Recursos/UI/Inventario/Slots/botas.png","zones":[ZONA_VALDORIA],"stage_special":true,"stage_index":19}
,
	{"id":"valdoria_botas_05","name":"Botas de la Era Perdida","name_en":"Boots of the Lost Age","description":"Reliquia regional de Valdoria, forjada para la etapa 0-1.","description_en":"A regional relic of Valdoria, forged for stage 0-1.","rarity":RAREZA_ANCESTRAL,"category":"equipo","equip_slot":"botas","allowed_classes":["paladin","arquero","arcanista"],"min_level":65,"base_stats":{"vel":15,"def":10},"icon_path":"res://Recursos/UI/Inventario/Slots/botas.png","zones":[ZONA_VALDORIA],"stage_special":true,"stage_index":20}
,
	{"id":"valdoria_espada_01","name":"Espada de Guardia","name_en":"Guard Sword","description":"Reliquia regional de Valdoria, forjada para la etapa 0-1.","description_en":"A regional relic of Valdoria, forged for stage 0-1.","rarity":RAREZA_COMUN,"category":"equipo","equip_slot":"arma","allowed_classes":["paladin","caballero"],"min_level":1,"base_stats":{"daño":7,"def":2},"icon_path":"res://Recursos/UI/Inventario/Slots/espada.png","zones":[ZONA_VALDORIA],"stage_special":true,"stage_index":21,"weapon_type":"espada"}
,
	{"id":"valdoria_espada_02","name":"Sable de la Ruta","name_en":"Route Sabre","description":"Reliquia regional de Valdoria, forjada para la etapa 0-1.","description_en":"A regional relic of Valdoria, forged for stage 0-1.","rarity":RAREZA_POCO_COMUN,"category":"equipo","equip_slot":"arma","allowed_classes":["paladin","caballero"],"min_level":6,"base_stats":{"daño":14,"def":4},"icon_path":"res://Recursos/UI/Inventario/Slots/espada.png","zones":[ZONA_VALDORIA],"stage_special":true,"stage_index":22,"weapon_type":"espada"}
,
	{"id":"valdoria_espada_03","name":"Hoja Esmeralda","name_en":"Emerald Blade","description":"Reliquia regional de Valdoria, forjada para la etapa 0-1.","description_en":"A regional relic of Valdoria, forged for stage 0-1.","rarity":RAREZA_RARO,"category":"equipo","equip_slot":"arma","allowed_classes":["paladin","caballero"],"min_level":14,"base_stats":{"daño":21,"def":6},"icon_path":"res://Recursos/UI/Inventario/Slots/espada.png","zones":[ZONA_VALDORIA],"stage_special":true,"stage_index":23,"weapon_type":"espada"}
,
	{"id":"valdoria_espada_04","name":"Filo del Sol Dorado","name_en":"Golden Sun Edge","description":"Reliquia regional de Valdoria, forjada para la etapa 0-1.","description_en":"A regional relic of Valdoria, forged for stage 0-1.","rarity":RAREZA_EPICO,"category":"equipo","equip_slot":"arma","allowed_classes":["paladin","caballero"],"min_level":24,"base_stats":{"daño":28,"def":8},"icon_path":"res://Recursos/UI/Inventario/Slots/espada.png","zones":[ZONA_VALDORIA],"stage_special":true,"stage_index":24,"weapon_type":"espada"}
,
	{"id":"valdoria_espada_05","name":"Juramento Eterno de Valdoria","name_en":"Eternal Oath of Valdoria","description":"Reliquia regional de Valdoria, forjada para la etapa 0-1.","description_en":"A regional relic of Valdoria, forged for stage 0-1.","rarity":RAREZA_UNICO,"category":"equipo","equip_slot":"arma","allowed_classes":["paladin","caballero"],"min_level":45,"base_stats":{"daño":35,"def":10},"icon_path":"res://Recursos/UI/Inventario/Slots/espada.png","zones":[ZONA_VALDORIA],"stage_special":true,"stage_index":25,"weapon_type":"espada","passive":{"type":"periodic_shield","name":"Juramento Regional","shield":190,"cooldown":38.0}}
,
	{"id":"valdoria_arco_01","name":"Arco de Fresno","name_en":"Ashwood Bow","description":"Reliquia regional de Valdoria, forjada para la etapa 0-1.","description_en":"A regional relic of Valdoria, forged for stage 0-1.","rarity":RAREZA_COMUN,"category":"equipo","equip_slot":"arma","allowed_classes":["arquero"],"min_level":1,"base_stats":{"daño":6,"vel":4},"icon_path":"res://Recursos/UI/Inventario/Slots/arco.png","zones":[ZONA_VALDORIA],"stage_special":true,"stage_index":26,"weapon_type":"arco"}
,
	{"id":"valdoria_arco_02","name":"Arco del Rastreador","name_en":"Tracker Bow","description":"Reliquia regional de Valdoria, forjada para la etapa 0-1.","description_en":"A regional relic of Valdoria, forged for stage 0-1.","rarity":RAREZA_POCO_COMUN,"category":"equipo","equip_slot":"arma","allowed_classes":["arquero"],"min_level":6,"base_stats":{"daño":12,"vel":8},"icon_path":"res://Recursos/UI/Inventario/Slots/arco.png","zones":[ZONA_VALDORIA],"stage_special":true,"stage_index":27,"weapon_type":"arco"}
,
	{"id":"valdoria_arco_03","name":"Arco Esmeralda","name_en":"Emerald Bow","description":"Reliquia regional de Valdoria, forjada para la etapa 0-1.","description_en":"A regional relic of Valdoria, forged for stage 0-1.","rarity":RAREZA_RARO,"category":"equipo","equip_slot":"arma","allowed_classes":["arquero"],"min_level":14,"base_stats":{"daño":18,"vel":12},"icon_path":"res://Recursos/UI/Inventario/Slots/arco.png","zones":[ZONA_VALDORIA],"stage_special":true,"stage_index":28,"weapon_type":"arco"}
,
	{"id":"valdoria_arco_04","name":"Arco de Tormenta","name_en":"Storm Bow","description":"Reliquia regional de Valdoria, forjada para la etapa 0-1.","description_en":"A regional relic of Valdoria, forged for stage 0-1.","rarity":RAREZA_EPICO,"category":"equipo","equip_slot":"arma","allowed_classes":["arquero"],"min_level":24,"base_stats":{"daño":24,"vel":16},"icon_path":"res://Recursos/UI/Inventario/Slots/arco.png","zones":[ZONA_VALDORIA],"stage_special":true,"stage_index":29,"weapon_type":"arco"}
,
	{"id":"valdoria_arco_05","name":"Saeta Eterna del Bosque","name_en":"Eternal Forest Arrow","description":"Reliquia regional de Valdoria, forjada para la etapa 0-1.","description_en":"A regional relic of Valdoria, forged for stage 0-1.","rarity":RAREZA_UNICO,"category":"equipo","equip_slot":"arma","allowed_classes":["arquero"],"min_level":45,"base_stats":{"daño":30,"vel":20},"icon_path":"res://Recursos/UI/Inventario/Slots/arco.png","zones":[ZONA_VALDORIA],"stage_special":true,"stage_index":30,"weapon_type":"arco","passive":{"type":"periodic_shield","name":"Vigilia del Cazador","shield":190,"cooldown":38.0}}
,
	{"id":"valdoria_vara_01","name":"Vara de Brote","name_en":"Sprout Wand","description":"Reliquia regional de Valdoria, forjada para la etapa 0-1.","description_en":"A regional relic of Valdoria, forged for stage 0-1.","rarity":RAREZA_COMUN,"category":"equipo","equip_slot":"arma","allowed_classes":["arcanista","nigromante"],"min_level":1,"base_stats":{"magia":8,"daño":4},"icon_path":"res://Recursos/UI/Inventario/Slots/vara.png","zones":[ZONA_VALDORIA],"stage_special":true,"stage_index":31,"weapon_type":"magia"}
,
	{"id":"valdoria_vara_02","name":"Bastón de Savia Azul","name_en":"Blue Sap Staff","description":"Reliquia regional de Valdoria, forjada para la etapa 0-1.","description_en":"A regional relic of Valdoria, forged for stage 0-1.","rarity":RAREZA_POCO_COMUN,"category":"equipo","equip_slot":"arma","allowed_classes":["arcanista","nigromante"],"min_level":6,"base_stats":{"magia":16,"daño":8},"icon_path":"res://Recursos/UI/Inventario/Slots/vara.png","zones":[ZONA_VALDORIA],"stage_special":true,"stage_index":32,"weapon_type":"magia"}
,
	{"id":"valdoria_vara_03","name":"Orbe de las Ruinas","name_en":"Orb of the Ruins","description":"Reliquia regional de Valdoria, forjada para la etapa 0-1.","description_en":"A regional relic of Valdoria, forged for stage 0-1.","rarity":RAREZA_RARO,"category":"equipo","equip_slot":"arma","allowed_classes":["arcanista","nigromante"],"min_level":14,"base_stats":{"magia":24,"daño":12},"icon_path":"res://Recursos/UI/Inventario/Slots/vara.png","zones":[ZONA_VALDORIA],"stage_special":true,"stage_index":33,"weapon_type":"magia"}
,
	{"id":"valdoria_vara_04","name":"Báculo Celestial","name_en":"Celestial Staff","description":"Reliquia regional de Valdoria, forjada para la etapa 0-1.","description_en":"A regional relic of Valdoria, forged for stage 0-1.","rarity":RAREZA_EPICO,"category":"equipo","equip_slot":"arma","allowed_classes":["arcanista","nigromante"],"min_level":24,"base_stats":{"magia":32,"daño":16},"icon_path":"res://Recursos/UI/Inventario/Slots/vara.png","zones":[ZONA_VALDORIA],"stage_special":true,"stage_index":34,"weapon_type":"magia"}
,
	{"id":"valdoria_vara_05","name":"Codex Viviente de Valdoria","name_en":"Living Codex of Valdoria","description":"Reliquia regional de Valdoria, forjada para la etapa 0-1.","description_en":"A regional relic of Valdoria, forged for stage 0-1.","rarity":RAREZA_UNICO,"category":"equipo","equip_slot":"arma","allowed_classes":["arcanista","nigromante"],"min_level":45,"base_stats":{"magia":40,"daño":20},"icon_path":"res://Recursos/UI/Inventario/Slots/vara.png","zones":[ZONA_VALDORIA],"stage_special":true,"stage_index":35,"weapon_type":"magia","passive":{"type":"periodic_shield","name":"Barrera Arcana","shield":190,"cooldown":38.0}}
,
	{"id":"valdoria_escudo_01","name":"Escudo de Roble","name_en":"Oak Shield","description":"Reliquia regional de Valdoria, forjada para la etapa 0-1.","description_en":"A regional relic of Valdoria, forged for stage 0-1.","rarity":RAREZA_COMUN,"category":"equipo","equip_slot":"escudo","allowed_classes":["paladin"],"min_level":1,"base_stats":{"def":7,"vida":10},"icon_path":"res://Recursos/UI/Inventario/Slots/escudo.png","zones":[ZONA_VALDORIA],"stage_special":true,"stage_index":36}
,
	{"id":"valdoria_escudo_02","name":"Escudo del Camino","name_en":"Road Shield","description":"Reliquia regional de Valdoria, forjada para la etapa 0-1.","description_en":"A regional relic of Valdoria, forged for stage 0-1.","rarity":RAREZA_POCO_COMUN,"category":"equipo","equip_slot":"escudo","allowed_classes":["paladin"],"min_level":6,"base_stats":{"def":14,"vida":20},"icon_path":"res://Recursos/UI/Inventario/Slots/escudo.png","zones":[ZONA_VALDORIA],"stage_special":true,"stage_index":37}
,
	{"id":"valdoria_escudo_03","name":"Égida Lunar","name_en":"Lunar Aegis","description":"Reliquia regional de Valdoria, forjada para la etapa 0-1.","description_en":"A regional relic of Valdoria, forged for stage 0-1.","rarity":RAREZA_RARO,"category":"equipo","equip_slot":"escudo","allowed_classes":["paladin"],"min_level":14,"base_stats":{"def":21,"vida":30},"icon_path":"res://Recursos/UI/Inventario/Slots/escudo.png","zones":[ZONA_VALDORIA],"stage_special":true,"stage_index":38}
,
	{"id":"valdoria_escudo_04","name":"Escudo del Último Bastión","name_en":"Last Bastion Shield","description":"Reliquia regional de Valdoria, forjada para la etapa 0-1.","description_en":"A regional relic of Valdoria, forged for stage 0-1.","rarity":RAREZA_EPICO,"category":"equipo","equip_slot":"escudo","allowed_classes":["paladin"],"min_level":24,"base_stats":{"def":28,"vida":40},"icon_path":"res://Recursos/UI/Inventario/Slots/escudo.png","zones":[ZONA_VALDORIA],"stage_special":true,"stage_index":39}
,
	{"id":"valdoria_escudo_05","name":"Muralla del Primer Reino","name_en":"Wall of the First Kingdom","description":"Reliquia regional de Valdoria, forjada para la etapa 0-1.","description_en":"A regional relic of Valdoria, forged for stage 0-1.","rarity":RAREZA_ANCESTRAL,"category":"equipo","equip_slot":"escudo","allowed_classes":["paladin"],"min_level":65,"base_stats":{"def":35,"vida":50},"icon_path":"res://Recursos/UI/Inventario/Slots/escudo.png","zones":[ZONA_VALDORIA],"stage_special":true,"stage_index":40}
,
	{"id":"valdoria_amuleto_01","name":"Amuleto de Cobre Verde","name_en":"Green Copper Amulet","description":"Reliquia regional de Valdoria, forjada para la etapa 0-1.","description_en":"A regional relic of Valdoria, forged for stage 0-1.","rarity":RAREZA_COMUN,"category":"equipo","equip_slot":"amuleto","allowed_classes":["paladin","arquero","arcanista"],"min_level":1,"base_stats":{"magia":4,"vida":6},"icon_path":"res://Recursos/UI/Inventario/Slots/amuleto.png","zones":[ZONA_VALDORIA],"stage_special":true,"stage_index":41}
,
	{"id":"valdoria_amuleto_02","name":"Colgante de Jade","name_en":"Jade Pendant","description":"Reliquia regional de Valdoria, forjada para la etapa 0-1.","description_en":"A regional relic of Valdoria, forged for stage 0-1.","rarity":RAREZA_POCO_COMUN,"category":"equipo","equip_slot":"amuleto","allowed_classes":["paladin","arquero","arcanista"],"min_level":6,"base_stats":{"magia":8,"vida":12},"icon_path":"res://Recursos/UI/Inventario/Slots/amuleto.png","zones":[ZONA_VALDORIA],"stage_special":true,"stage_index":42}
,
	{"id":"valdoria_amuleto_03","name":"Amuleto del Grifo","name_en":"Gryphon Amulet","description":"Reliquia regional de Valdoria, forjada para la etapa 0-1.","description_en":"A regional relic of Valdoria, forged for stage 0-1.","rarity":RAREZA_RARO,"category":"equipo","equip_slot":"amuleto","allowed_classes":["paladin","arquero","arcanista"],"min_level":14,"base_stats":{"magia":12,"vida":18},"icon_path":"res://Recursos/UI/Inventario/Slots/amuleto.png","zones":[ZONA_VALDORIA],"stage_special":true,"stage_index":43}
,
	{"id":"valdoria_amuleto_04","name":"Corazón del Fénix","name_en":"Phoenix Heart","description":"Reliquia regional de Valdoria, forjada para la etapa 0-1.","description_en":"A regional relic of Valdoria, forged for stage 0-1.","rarity":RAREZA_EPICO,"category":"equipo","equip_slot":"amuleto","allowed_classes":["paladin","arquero","arcanista"],"min_level":24,"base_stats":{"magia":16,"vida":24},"icon_path":"res://Recursos/UI/Inventario/Slots/amuleto.png","zones":[ZONA_VALDORIA],"stage_special":true,"stage_index":44}
,
	{"id":"valdoria_amuleto_05","name":"Reliquia del Primer Paladín","name_en":"Relic of the First Paladin","description":"Reliquia regional de Valdoria, forjada para la etapa 0-1.","description_en":"A regional relic of Valdoria, forged for stage 0-1.","rarity":RAREZA_MITICO,"category":"equipo","equip_slot":"amuleto","allowed_classes":["paladin","arquero","arcanista"],"min_level":50,"base_stats":{"magia":20,"vida":30},"icon_path":"res://Recursos/UI/Inventario/Slots/amuleto.png","zones":[ZONA_VALDORIA],"stage_special":true,"stage_index":45}
,
	{"id":"valdoria_anillo_01","name":"Anillo del Caminante","name_en":"Wanderer Ring","description":"Reliquia regional de Valdoria, forjada para la etapa 0-1.","description_en":"A regional relic of Valdoria, forged for stage 0-1.","rarity":RAREZA_COMUN,"category":"equipo","equip_slot":"anillo_1","allowed_classes":["paladin","arquero","arcanista"],"min_level":1,"base_stats":{"daño":3,"magia":3,"vel":2},"icon_path":"res://Recursos/UI/Inventario/Slots/anillo.png","zones":[ZONA_VALDORIA],"stage_special":true,"stage_index":46}
,
	{"id":"valdoria_anillo_02","name":"Anillo de Jade","name_en":"Jade Ring","description":"Reliquia regional de Valdoria, forjada para la etapa 0-1.","description_en":"A regional relic of Valdoria, forged for stage 0-1.","rarity":RAREZA_POCO_COMUN,"category":"equipo","equip_slot":"anillo_1","allowed_classes":["paladin","arquero","arcanista"],"min_level":6,"base_stats":{"daño":6,"magia":6,"vel":4},"icon_path":"res://Recursos/UI/Inventario/Slots/anillo.png","zones":[ZONA_VALDORIA],"stage_special":true,"stage_index":47}
,
	{"id":"valdoria_anillo_03","name":"Sello de las Ruinas","name_en":"Seal of the Ruins","description":"Reliquia regional de Valdoria, forjada para la etapa 0-1.","description_en":"A regional relic of Valdoria, forged for stage 0-1.","rarity":RAREZA_RARO,"category":"equipo","equip_slot":"anillo_1","allowed_classes":["paladin","arquero","arcanista"],"min_level":14,"base_stats":{"daño":9,"magia":9,"vel":6},"icon_path":"res://Recursos/UI/Inventario/Slots/anillo.png","zones":[ZONA_VALDORIA],"stage_special":true,"stage_index":48}
,
	{"id":"valdoria_anillo_04","name":"Anillo del Eclipse Verde","name_en":"Green Eclipse Ring","description":"Reliquia regional de Valdoria, forjada para la etapa 0-1.","description_en":"A regional relic of Valdoria, forged for stage 0-1.","rarity":RAREZA_EPICO,"category":"equipo","equip_slot":"anillo_1","allowed_classes":["paladin","arquero","arcanista"],"min_level":24,"base_stats":{"daño":12,"magia":12,"vel":8},"icon_path":"res://Recursos/UI/Inventario/Slots/anillo.png","zones":[ZONA_VALDORIA],"stage_special":true,"stage_index":49}
,
	{"id":"valdoria_anillo_05","name":"Anillo de las Mil Estrellas","name_en":"Ring of a Thousand Stars","description":"Reliquia regional de Valdoria, forjada para la etapa 0-1.","description_en":"A regional relic of Valdoria, forged for stage 0-1.","rarity":RAREZA_LEGENDARIO,"category":"equipo","equip_slot":"anillo_1","allowed_classes":["paladin","arquero","arcanista"],"min_level":38,"base_stats":{"daño":15,"magia":15,"vel":10},"icon_path":"res://Recursos/UI/Inventario/Slots/anillo.png","zones":[ZONA_VALDORIA],"stage_special":true,"stage_index":50}
,
	{"id":"bruma_casco_01","name":"Capucha de Niebla","name_en":"Mist Hood","description":"Reliquia regional de la Bruma, forjada para la etapa 0-2.","description_en":"A regional relic of the Mist, forged for stage 0-2.","rarity":RAREZA_COMUN,"category":"equipo","equip_slot":"casco","allowed_classes":["paladin","arquero","arcanista"],"min_level":1,"base_stats":{"vida":8,"def":3},"icon_path":"res://Recursos/UI/Inventario/Slots/casco.png","zones":[ZONA_BRUMA],"stage_special":true,"stage_index":1}
,
	{"id":"bruma_casco_02","name":"Yelmo del Vigía","name_en":"Watcher Helm","description":"Reliquia regional de la Bruma, forjada para la etapa 0-2.","description_en":"A regional relic of the Mist, forged for stage 0-2.","rarity":RAREZA_POCO_COMUN,"category":"equipo","equip_slot":"casco","allowed_classes":["paladin","arquero","arcanista"],"min_level":6,"base_stats":{"vida":16,"def":6},"icon_path":"res://Recursos/UI/Inventario/Slots/casco.png","zones":[ZONA_BRUMA],"stage_special":true,"stage_index":2}
,
	{"id":"bruma_casco_03","name":"Casco de la Estatua Rota","name_en":"Broken Statue Helm","description":"Reliquia regional de la Bruma, forjada para la etapa 0-2.","description_en":"A regional relic of the Mist, forged for stage 0-2.","rarity":RAREZA_RARO,"category":"equipo","equip_slot":"casco","allowed_classes":["paladin","arquero","arcanista"],"min_level":14,"base_stats":{"vida":24,"def":9},"icon_path":"res://Recursos/UI/Inventario/Slots/casco.png","zones":[ZONA_BRUMA],"stage_special":true,"stage_index":3}
,
	{"id":"bruma_casco_04","name":"Corona del Velo","name_en":"Crown of the Veil","description":"Reliquia regional de la Bruma, forjada para la etapa 0-2.","description_en":"A regional relic of the Mist, forged for stage 0-2.","rarity":RAREZA_EPICO,"category":"equipo","equip_slot":"casco","allowed_classes":["paladin","arquero","arcanista"],"min_level":24,"base_stats":{"vida":32,"def":12},"icon_path":"res://Recursos/UI/Inventario/Slots/casco.png","zones":[ZONA_BRUMA],"stage_special":true,"stage_index":4}
,
	{"id":"bruma_casco_05","name":"Yelmo del Paladín Derruido","name_en":"Fallen Paladin Helm","description":"Reliquia regional de la Bruma, forjada para la etapa 0-2.","description_en":"A regional relic of the Mist, forged for stage 0-2.","rarity":RAREZA_LEGENDARIO,"category":"equipo","equip_slot":"casco","allowed_classes":["paladin","arquero","arcanista"],"min_level":38,"base_stats":{"vida":40,"def":15},"icon_path":"res://Recursos/UI/Inventario/Slots/casco.png","zones":[ZONA_BRUMA],"stage_special":true,"stage_index":5}
,
	{"id":"bruma_armadura_01","name":"Manto Húmedo","name_en":"Damp Mantle","description":"Reliquia regional de la Bruma, forjada para la etapa 0-2.","description_en":"A regional relic of the Mist, forged for stage 0-2.","rarity":RAREZA_COMUN,"category":"equipo","equip_slot":"armadura","allowed_classes":["paladin","arquero","arcanista"],"min_level":1,"base_stats":{"vida":16,"def":5},"icon_path":"res://Recursos/UI/Inventario/Slots/armadura.png","zones":[ZONA_BRUMA],"stage_special":true,"stage_index":6}
,
	{"id":"bruma_armadura_02","name":"Malla del Paso Oculto","name_en":"Hidden Pass Mail","description":"Reliquia regional de la Bruma, forjada para la etapa 0-2.","description_en":"A regional relic of the Mist, forged for stage 0-2.","rarity":RAREZA_POCO_COMUN,"category":"equipo","equip_slot":"armadura","allowed_classes":["paladin","arquero","arcanista"],"min_level":6,"base_stats":{"vida":32,"def":10},"icon_path":"res://Recursos/UI/Inventario/Slots/armadura.png","zones":[ZONA_BRUMA],"stage_special":true,"stage_index":7}
,
	{"id":"bruma_armadura_03","name":"Coraza del Guardián de Bruma","name_en":"Mist Guardian Cuirass","description":"Reliquia regional de la Bruma, forjada para la etapa 0-2.","description_en":"A regional relic of the Mist, forged for stage 0-2.","rarity":RAREZA_RARO,"category":"equipo","equip_slot":"armadura","allowed_classes":["paladin","arquero","arcanista"],"min_level":14,"base_stats":{"vida":48,"def":15},"icon_path":"res://Recursos/UI/Inventario/Slots/armadura.png","zones":[ZONA_BRUMA],"stage_special":true,"stage_index":8}
,
	{"id":"bruma_armadura_04","name":"Armadura de la Fortaleza Olvidada","name_en":"Forgotten Fortress Armor","description":"Reliquia regional de la Bruma, forjada para la etapa 0-2.","description_en":"A regional relic of the Mist, forged for stage 0-2.","rarity":RAREZA_EPICO,"category":"equipo","equip_slot":"armadura","allowed_classes":["paladin","arquero","arcanista"],"min_level":24,"base_stats":{"vida":64,"def":20},"icon_path":"res://Recursos/UI/Inventario/Slots/armadura.png","zones":[ZONA_BRUMA],"stage_special":true,"stage_index":9}
,
	{"id":"bruma_armadura_05","name":"Coraza del Juramento Roto","name_en":"Broken Oath Cuirass","description":"Reliquia regional de la Bruma, forjada para la etapa 0-2.","description_en":"A regional relic of the Mist, forged for stage 0-2.","rarity":RAREZA_MITICO,"category":"equipo","equip_slot":"armadura","allowed_classes":["paladin","arquero","arcanista"],"min_level":50,"base_stats":{"vida":80,"def":25},"icon_path":"res://Recursos/UI/Inventario/Slots/armadura.png","zones":[ZONA_BRUMA],"stage_special":true,"stage_index":10}
,
	{"id":"bruma_guantes_01","name":"Guantes del Eco","name_en":"Echo Gloves","description":"Reliquia regional de la Bruma, forjada para la etapa 0-2.","description_en":"A regional relic of the Mist, forged for stage 0-2.","rarity":RAREZA_COMUN,"category":"equipo","equip_slot":"guantes","allowed_classes":["paladin","arquero","arcanista"],"min_level":1,"base_stats":{"daño":3,"vel":2},"icon_path":"res://Recursos/UI/Inventario/Slots/guantes.png","zones":[ZONA_BRUMA],"stage_special":true,"stage_index":11}
,
	{"id":"bruma_guantes_02","name":"Manoplas de Cueva","name_en":"Cave Grips","description":"Reliquia regional de la Bruma, forjada para la etapa 0-2.","description_en":"A regional relic of the Mist, forged for stage 0-2.","rarity":RAREZA_POCO_COMUN,"category":"equipo","equip_slot":"guantes","allowed_classes":["paladin","arquero","arcanista"],"min_level":6,"base_stats":{"daño":6,"vel":4},"icon_path":"res://Recursos/UI/Inventario/Slots/guantes.png","zones":[ZONA_BRUMA],"stage_special":true,"stage_index":12}
,
	{"id":"bruma_guantes_03","name":"Guanteletes del Centinela","name_en":"Sentinel Gauntlets","description":"Reliquia regional de la Bruma, forjada para la etapa 0-2.","description_en":"A regional relic of the Mist, forged for stage 0-2.","rarity":RAREZA_RARO,"category":"equipo","equip_slot":"guantes","allowed_classes":["paladin","arquero","arcanista"],"min_level":14,"base_stats":{"daño":9,"vel":6},"icon_path":"res://Recursos/UI/Inventario/Slots/guantes.png","zones":[ZONA_BRUMA],"stage_special":true,"stage_index":13}
,
	{"id":"bruma_guantes_04","name":"Garras del Velo","name_en":"Veil Claws","description":"Reliquia regional de la Bruma, forjada para la etapa 0-2.","description_en":"A regional relic of the Mist, forged for stage 0-2.","rarity":RAREZA_EPICO,"category":"equipo","equip_slot":"guantes","allowed_classes":["paladin","arquero","arcanista"],"min_level":24,"base_stats":{"daño":12,"vel":8},"icon_path":"res://Recursos/UI/Inventario/Slots/guantes.png","zones":[ZONA_BRUMA],"stage_special":true,"stage_index":14}
,
	{"id":"bruma_guantes_05","name":"Puños de la Niebla Eterna","name_en":"Fists of Eternal Mist","description":"Reliquia regional de la Bruma, forjada para la etapa 0-2.","description_en":"A regional relic of the Mist, forged for stage 0-2.","rarity":RAREZA_LEGENDARIO,"category":"equipo","equip_slot":"guantes","allowed_classes":["paladin","arquero","arcanista"],"min_level":38,"base_stats":{"daño":15,"vel":10},"icon_path":"res://Recursos/UI/Inventario/Slots/guantes.png","zones":[ZONA_BRUMA],"stage_special":true,"stage_index":15}
,
	{"id":"bruma_botas_01","name":"Botas del Paso Secreto","name_en":"Secret Pass Boots","description":"Reliquia regional de la Bruma, forjada para la etapa 0-2.","description_en":"A regional relic of the Mist, forged for stage 0-2.","rarity":RAREZA_COMUN,"category":"equipo","equip_slot":"botas","allowed_classes":["paladin","arquero","arcanista"],"min_level":1,"base_stats":{"vel":3,"def":2},"icon_path":"res://Recursos/UI/Inventario/Slots/botas.png","zones":[ZONA_BRUMA],"stage_special":true,"stage_index":16}
,
	{"id":"bruma_botas_02","name":"Botas del Acechador","name_en":"Stalker Boots","description":"Reliquia regional de la Bruma, forjada para la etapa 0-2.","description_en":"A regional relic of the Mist, forged for stage 0-2.","rarity":RAREZA_POCO_COMUN,"category":"equipo","equip_slot":"botas","allowed_classes":["paladin","arquero","arcanista"],"min_level":6,"base_stats":{"vel":6,"def":4},"icon_path":"res://Recursos/UI/Inventario/Slots/botas.png","zones":[ZONA_BRUMA],"stage_special":true,"stage_index":17}
,
	{"id":"bruma_botas_03","name":"Grebas de Piedra Fría","name_en":"Cold Stone Greaves","description":"Reliquia regional de la Bruma, forjada para la etapa 0-2.","description_en":"A regional relic of the Mist, forged for stage 0-2.","rarity":RAREZA_RARO,"category":"equipo","equip_slot":"botas","allowed_classes":["paladin","arquero","arcanista"],"min_level":14,"base_stats":{"vel":9,"def":6},"icon_path":"res://Recursos/UI/Inventario/Slots/botas.png","zones":[ZONA_BRUMA],"stage_special":true,"stage_index":18}
,
	{"id":"bruma_botas_04","name":"Pasos Entre Mundos","name_en":"Steps Between Worlds","description":"Reliquia regional de la Bruma, forjada para la etapa 0-2.","description_en":"A regional relic of the Mist, forged for stage 0-2.","rarity":RAREZA_EPICO,"category":"equipo","equip_slot":"botas","allowed_classes":["paladin","arquero","arcanista"],"min_level":24,"base_stats":{"vel":12,"def":8},"icon_path":"res://Recursos/UI/Inventario/Slots/botas.png","zones":[ZONA_BRUMA],"stage_special":true,"stage_index":19}
,
	{"id":"bruma_botas_05","name":"Botas del Camino Borrado","name_en":"Boots of the Erased Road","description":"Reliquia regional de la Bruma, forjada para la etapa 0-2.","description_en":"A regional relic of the Mist, forged for stage 0-2.","rarity":RAREZA_ANCESTRAL,"category":"equipo","equip_slot":"botas","allowed_classes":["paladin","arquero","arcanista"],"min_level":65,"base_stats":{"vel":15,"def":10},"icon_path":"res://Recursos/UI/Inventario/Slots/botas.png","zones":[ZONA_BRUMA],"stage_special":true,"stage_index":20}
,
	{"id":"bruma_espada_01","name":"Espada Oxidada del Paso","name_en":"Rusty Pass Sword","description":"Reliquia regional de la Bruma, forjada para la etapa 0-2.","description_en":"A regional relic of the Mist, forged for stage 0-2.","rarity":RAREZA_COMUN,"category":"equipo","equip_slot":"arma","allowed_classes":["paladin","caballero"],"min_level":1,"base_stats":{"daño":7,"def":2},"icon_path":"res://Recursos/UI/Inventario/Slots/espada.png","zones":[ZONA_BRUMA],"stage_special":true,"stage_index":21,"weapon_type":"espada"}
,
	{"id":"bruma_espada_02","name":"Hoja Guardacaminos","name_en":"Waywarden Blade","description":"Reliquia regional de la Bruma, forjada para la etapa 0-2.","description_en":"A regional relic of the Mist, forged for stage 0-2.","rarity":RAREZA_POCO_COMUN,"category":"equipo","equip_slot":"arma","allowed_classes":["paladin","caballero"],"min_level":6,"base_stats":{"daño":14,"def":4},"icon_path":"res://Recursos/UI/Inventario/Slots/espada.png","zones":[ZONA_BRUMA],"stage_special":true,"stage_index":22,"weapon_type":"espada"}
,
	{"id":"bruma_espada_03","name":"Mandoble de la Estatua","name_en":"Statue Greatsword","description":"Reliquia regional de la Bruma, forjada para la etapa 0-2.","description_en":"A regional relic of the Mist, forged for stage 0-2.","rarity":RAREZA_RARO,"category":"equipo","equip_slot":"arma","allowed_classes":["paladin","caballero"],"min_level":14,"base_stats":{"daño":21,"def":6},"icon_path":"res://Recursos/UI/Inventario/Slots/espada.png","zones":[ZONA_BRUMA],"stage_special":true,"stage_index":23,"weapon_type":"espada"}
,
	{"id":"bruma_espada_04","name":"Filo del Velo","name_en":"Edge of the Veil","description":"Reliquia regional de la Bruma, forjada para la etapa 0-2.","description_en":"A regional relic of the Mist, forged for stage 0-2.","rarity":RAREZA_EPICO,"category":"equipo","equip_slot":"arma","allowed_classes":["paladin","caballero"],"min_level":24,"base_stats":{"daño":28,"def":8},"icon_path":"res://Recursos/UI/Inventario/Slots/espada.png","zones":[ZONA_BRUMA],"stage_special":true,"stage_index":24,"weapon_type":"espada"}
,
	{"id":"bruma_espada_05","name":"Alma del Paladín Derruido","name_en":"Soul of the Fallen Paladin","description":"Reliquia regional de la Bruma, forjada para la etapa 0-2.","description_en":"A regional relic of the Mist, forged for stage 0-2.","rarity":RAREZA_UNICO,"category":"equipo","equip_slot":"arma","allowed_classes":["paladin","caballero"],"min_level":45,"base_stats":{"daño":35,"def":10},"icon_path":"res://Recursos/UI/Inventario/Slots/espada.png","zones":[ZONA_BRUMA],"stage_special":true,"stage_index":25,"weapon_type":"espada","passive":{"type":"periodic_shield","name":"Juramento Regional","shield":190,"cooldown":38.0}}
,
	{"id":"bruma_arco_01","name":"Arco de Cuerda Húmeda","name_en":"Damp String Bow","description":"Reliquia regional de la Bruma, forjada para la etapa 0-2.","description_en":"A regional relic of the Mist, forged for stage 0-2.","rarity":RAREZA_COMUN,"category":"equipo","equip_slot":"arma","allowed_classes":["arquero"],"min_level":1,"base_stats":{"daño":6,"vel":4},"icon_path":"res://Recursos/UI/Inventario/Slots/arco.png","zones":[ZONA_BRUMA],"stage_special":true,"stage_index":26,"weapon_type":"arco"}
,
	{"id":"bruma_arco_02","name":"Arco del Vigía Velado","name_en":"Veiled Watcher Bow","description":"Reliquia regional de la Bruma, forjada para la etapa 0-2.","description_en":"A regional relic of the Mist, forged for stage 0-2.","rarity":RAREZA_POCO_COMUN,"category":"equipo","equip_slot":"arma","allowed_classes":["arquero"],"min_level":6,"base_stats":{"daño":12,"vel":8},"icon_path":"res://Recursos/UI/Inventario/Slots/arco.png","zones":[ZONA_BRUMA],"stage_special":true,"stage_index":27,"weapon_type":"arco"}
,
	{"id":"bruma_arco_03","name":"Arco de Hueso de Cueva","name_en":"Cavebone Bow","description":"Reliquia regional de la Bruma, forjada para la etapa 0-2.","description_en":"A regional relic of the Mist, forged for stage 0-2.","rarity":RAREZA_RARO,"category":"equipo","equip_slot":"arma","allowed_classes":["arquero"],"min_level":14,"base_stats":{"daño":18,"vel":12},"icon_path":"res://Recursos/UI/Inventario/Slots/arco.png","zones":[ZONA_BRUMA],"stage_special":true,"stage_index":28,"weapon_type":"arco"}
,
	{"id":"bruma_arco_04","name":"Arco del Silencio","name_en":"Bow of Silence","description":"Reliquia regional de la Bruma, forjada para la etapa 0-2.","description_en":"A regional relic of the Mist, forged for stage 0-2.","rarity":RAREZA_EPICO,"category":"equipo","equip_slot":"arma","allowed_classes":["arquero"],"min_level":24,"base_stats":{"daño":24,"vel":16},"icon_path":"res://Recursos/UI/Inventario/Slots/arco.png","zones":[ZONA_BRUMA],"stage_special":true,"stage_index":29,"weapon_type":"arco"}
,
	{"id":"bruma_arco_05","name":"Flecha que Cruza la Bruma","name_en":"Arrow Through the Mist","description":"Reliquia regional de la Bruma, forjada para la etapa 0-2.","description_en":"A regional relic of the Mist, forged for stage 0-2.","rarity":RAREZA_UNICO,"category":"equipo","equip_slot":"arma","allowed_classes":["arquero"],"min_level":45,"base_stats":{"daño":30,"vel":20},"icon_path":"res://Recursos/UI/Inventario/Slots/arco.png","zones":[ZONA_BRUMA],"stage_special":true,"stage_index":30,"weapon_type":"arco","passive":{"type":"periodic_shield","name":"Vigilia del Cazador","shield":190,"cooldown":38.0}}
,
	{"id":"bruma_vara_01","name":"Vara de Bruma","name_en":"Mist Wand","description":"Reliquia regional de la Bruma, forjada para la etapa 0-2.","description_en":"A regional relic of the Mist, forged for stage 0-2.","rarity":RAREZA_COMUN,"category":"equipo","equip_slot":"arma","allowed_classes":["arcanista","nigromante"],"min_level":1,"base_stats":{"magia":8,"daño":4},"icon_path":"res://Recursos/UI/Inventario/Slots/vara.png","zones":[ZONA_BRUMA],"stage_special":true,"stage_index":31,"weapon_type":"magia"}
,
	{"id":"bruma_vara_02","name":"Orbe del Eco","name_en":"Echo Orb","description":"Reliquia regional de la Bruma, forjada para la etapa 0-2.","description_en":"A regional relic of the Mist, forged for stage 0-2.","rarity":RAREZA_POCO_COMUN,"category":"equipo","equip_slot":"arma","allowed_classes":["arcanista","nigromante"],"min_level":6,"base_stats":{"magia":16,"daño":8},"icon_path":"res://Recursos/UI/Inventario/Slots/vara.png","zones":[ZONA_BRUMA],"stage_special":true,"stage_index":32,"weapon_type":"magia"}
,
	{"id":"bruma_vara_03","name":"Báculo de la Cueva Azul","name_en":"Blue Cave Staff","description":"Reliquia regional de la Bruma, forjada para la etapa 0-2.","description_en":"A regional relic of the Mist, forged for stage 0-2.","rarity":RAREZA_RARO,"category":"equipo","equip_slot":"arma","allowed_classes":["arcanista","nigromante"],"min_level":14,"base_stats":{"magia":24,"daño":12},"icon_path":"res://Recursos/UI/Inventario/Slots/vara.png","zones":[ZONA_BRUMA],"stage_special":true,"stage_index":33,"weapon_type":"magia"}
,
	{"id":"bruma_vara_04","name":"Cetro de la Fortaleza","name_en":"Fortress Scepter","description":"Reliquia regional de la Bruma, forjada para la etapa 0-2.","description_en":"A regional relic of the Mist, forged for stage 0-2.","rarity":RAREZA_EPICO,"category":"equipo","equip_slot":"arma","allowed_classes":["arcanista","nigromante"],"min_level":24,"base_stats":{"magia":32,"daño":16},"icon_path":"res://Recursos/UI/Inventario/Slots/vara.png","zones":[ZONA_BRUMA],"stage_special":true,"stage_index":34,"weapon_type":"magia"}
,
	{"id":"bruma_vara_05","name":"Ojo Arcano del Velo","name_en":"Arcane Eye of the Veil","description":"Reliquia regional de la Bruma, forjada para la etapa 0-2.","description_en":"A regional relic of the Mist, forged for stage 0-2.","rarity":RAREZA_UNICO,"category":"equipo","equip_slot":"arma","allowed_classes":["arcanista","nigromante"],"min_level":45,"base_stats":{"magia":40,"daño":20},"icon_path":"res://Recursos/UI/Inventario/Slots/vara.png","zones":[ZONA_BRUMA],"stage_special":true,"stage_index":35,"weapon_type":"magia","passive":{"type":"periodic_shield","name":"Barrera Arcana","shield":190,"cooldown":38.0}}
,
	{"id":"bruma_escudo_01","name":"Escudo de Piedra","name_en":"Stone Shield","description":"Reliquia regional de la Bruma, forjada para la etapa 0-2.","description_en":"A regional relic of the Mist, forged for stage 0-2.","rarity":RAREZA_COMUN,"category":"equipo","equip_slot":"escudo","allowed_classes":["paladin"],"min_level":1,"base_stats":{"def":7,"vida":10},"icon_path":"res://Recursos/UI/Inventario/Slots/escudo.png","zones":[ZONA_BRUMA],"stage_special":true,"stage_index":36}
,
	{"id":"bruma_escudo_02","name":"Escudo de la Puerta de Niebla","name_en":"Mist Gate Shield","description":"Reliquia regional de la Bruma, forjada para la etapa 0-2.","description_en":"A regional relic of the Mist, forged for stage 0-2.","rarity":RAREZA_POCO_COMUN,"category":"equipo","equip_slot":"escudo","allowed_classes":["paladin"],"min_level":6,"base_stats":{"def":14,"vida":20},"icon_path":"res://Recursos/UI/Inventario/Slots/escudo.png","zones":[ZONA_BRUMA],"stage_special":true,"stage_index":37}
,
	{"id":"bruma_escudo_03","name":"Égida del Centinela","name_en":"Sentinel Aegis","description":"Reliquia regional de la Bruma, forjada para la etapa 0-2.","description_en":"A regional relic of the Mist, forged for stage 0-2.","rarity":RAREZA_RARO,"category":"equipo","equip_slot":"escudo","allowed_classes":["paladin"],"min_level":14,"base_stats":{"def":21,"vida":30},"icon_path":"res://Recursos/UI/Inventario/Slots/escudo.png","zones":[ZONA_BRUMA],"stage_special":true,"stage_index":38}
,
	{"id":"bruma_escudo_04","name":"Bastión del Paso","name_en":"Pass Bastion","description":"Reliquia regional de la Bruma, forjada para la etapa 0-2.","description_en":"A regional relic of the Mist, forged for stage 0-2.","rarity":RAREZA_EPICO,"category":"equipo","equip_slot":"escudo","allowed_classes":["paladin"],"min_level":24,"base_stats":{"def":28,"vida":40},"icon_path":"res://Recursos/UI/Inventario/Slots/escudo.png","zones":[ZONA_BRUMA],"stage_special":true,"stage_index":39}
,
	{"id":"bruma_escudo_05","name":"Muro de la Estatua Eterna","name_en":"Wall of the Eternal Statue","description":"Reliquia regional de la Bruma, forjada para la etapa 0-2.","description_en":"A regional relic of the Mist, forged for stage 0-2.","rarity":RAREZA_ANCESTRAL,"category":"equipo","equip_slot":"escudo","allowed_classes":["paladin"],"min_level":65,"base_stats":{"def":35,"vida":50},"icon_path":"res://Recursos/UI/Inventario/Slots/escudo.png","zones":[ZONA_BRUMA],"stage_special":true,"stage_index":40}
,
	{"id":"bruma_amuleto_01","name":"Amuleto de Gota Fría","name_en":"Cold Drop Amulet","description":"Reliquia regional de la Bruma, forjada para la etapa 0-2.","description_en":"A regional relic of the Mist, forged for stage 0-2.","rarity":RAREZA_COMUN,"category":"equipo","equip_slot":"amuleto","allowed_classes":["paladin","arquero","arcanista"],"min_level":1,"base_stats":{"magia":4,"vida":6},"icon_path":"res://Recursos/UI/Inventario/Slots/amuleto.png","zones":[ZONA_BRUMA],"stage_special":true,"stage_index":41}
,
	{"id":"bruma_amuleto_02","name":"Colgante del Eco","name_en":"Echo Pendant","description":"Reliquia regional de la Bruma, forjada para la etapa 0-2.","description_en":"A regional relic of the Mist, forged for stage 0-2.","rarity":RAREZA_POCO_COMUN,"category":"equipo","equip_slot":"amuleto","allowed_classes":["paladin","arquero","arcanista"],"min_level":6,"base_stats":{"magia":8,"vida":12},"icon_path":"res://Recursos/UI/Inventario/Slots/amuleto.png","zones":[ZONA_BRUMA],"stage_special":true,"stage_index":42}
,
	{"id":"bruma_amuleto_03","name":"Amuleto del Paso Secreto","name_en":"Secret Pass Amulet","description":"Reliquia regional de la Bruma, forjada para la etapa 0-2.","description_en":"A regional relic of the Mist, forged for stage 0-2.","rarity":RAREZA_RARO,"category":"equipo","equip_slot":"amuleto","allowed_classes":["paladin","arquero","arcanista"],"min_level":14,"base_stats":{"magia":12,"vida":18},"icon_path":"res://Recursos/UI/Inventario/Slots/amuleto.png","zones":[ZONA_BRUMA],"stage_special":true,"stage_index":43}
,
	{"id":"bruma_amuleto_04","name":"Corazón de la Fortaleza","name_en":"Heart of the Fortress","description":"Reliquia regional de la Bruma, forjada para la etapa 0-2.","description_en":"A regional relic of the Mist, forged for stage 0-2.","rarity":RAREZA_EPICO,"category":"equipo","equip_slot":"amuleto","allowed_classes":["paladin","arquero","arcanista"],"min_level":24,"base_stats":{"magia":16,"vida":24},"icon_path":"res://Recursos/UI/Inventario/Slots/amuleto.png","zones":[ZONA_BRUMA],"stage_special":true,"stage_index":44}
,
	{"id":"bruma_amuleto_05","name":"Lágrima de la Madre Niebla","name_en":"Tear of the Mist Mother","description":"Reliquia regional de la Bruma, forjada para la etapa 0-2.","description_en":"A regional relic of the Mist, forged for stage 0-2.","rarity":RAREZA_MITICO,"category":"equipo","equip_slot":"amuleto","allowed_classes":["paladin","arquero","arcanista"],"min_level":50,"base_stats":{"magia":20,"vida":30},"icon_path":"res://Recursos/UI/Inventario/Slots/amuleto.png","zones":[ZONA_BRUMA],"stage_special":true,"stage_index":45}
,
	{"id":"bruma_anillo_01","name":"Anillo de Piedra Gris","name_en":"Grey Stone Ring","description":"Reliquia regional de la Bruma, forjada para la etapa 0-2.","description_en":"A regional relic of the Mist, forged for stage 0-2.","rarity":RAREZA_COMUN,"category":"equipo","equip_slot":"anillo_1","allowed_classes":["paladin","arquero","arcanista"],"min_level":1,"base_stats":{"daño":3,"magia":3,"vel":2},"icon_path":"res://Recursos/UI/Inventario/Slots/anillo.png","zones":[ZONA_BRUMA],"stage_special":true,"stage_index":46}
,
	{"id":"bruma_anillo_02","name":"Anillo del Eco de Niebla","name_en":"Mist Echo Ring","description":"Reliquia regional de la Bruma, forjada para la etapa 0-2.","description_en":"A regional relic of the Mist, forged for stage 0-2.","rarity":RAREZA_POCO_COMUN,"category":"equipo","equip_slot":"anillo_1","allowed_classes":["paladin","arquero","arcanista"],"min_level":6,"base_stats":{"daño":6,"magia":6,"vel":4},"icon_path":"res://Recursos/UI/Inventario/Slots/anillo.png","zones":[ZONA_BRUMA],"stage_special":true,"stage_index":47}
,
	{"id":"bruma_anillo_03","name":"Sello del Vigía","name_en":"Watcher Seal","description":"Reliquia regional de la Bruma, forjada para la etapa 0-2.","description_en":"A regional relic of the Mist, forged for stage 0-2.","rarity":RAREZA_RARO,"category":"equipo","equip_slot":"anillo_1","allowed_classes":["paladin","arquero","arcanista"],"min_level":14,"base_stats":{"daño":9,"magia":9,"vel":6},"icon_path":"res://Recursos/UI/Inventario/Slots/anillo.png","zones":[ZONA_BRUMA],"stage_special":true,"stage_index":48}
,
	{"id":"bruma_anillo_04","name":"Anillo del Velo Partido","name_en":"Split Veil Ring","description":"Reliquia regional de la Bruma, forjada para la etapa 0-2.","description_en":"A regional relic of the Mist, forged for stage 0-2.","rarity":RAREZA_EPICO,"category":"equipo","equip_slot":"anillo_1","allowed_classes":["paladin","arquero","arcanista"],"min_level":24,"base_stats":{"daño":12,"magia":12,"vel":8},"icon_path":"res://Recursos/UI/Inventario/Slots/anillo.png","zones":[ZONA_BRUMA],"stage_special":true,"stage_index":49}
,
	{"id":"bruma_anillo_05","name":"Anillo del Juramento Olvidado","name_en":"Forgotten Oath Ring","description":"Reliquia regional de la Bruma, forjada para la etapa 0-2.","description_en":"A regional relic of the Mist, forged for stage 0-2.","rarity":RAREZA_LEGENDARIO,"category":"equipo","equip_slot":"anillo_1","allowed_classes":["paladin","arquero","arcanista"],"min_level":38,"base_stats":{"daño":15,"magia":15,"vel":10},"icon_path":"res://Recursos/UI/Inventario/Slots/anillo.png","zones":[ZONA_BRUMA],"stage_special":true,"stage_index":50},
	{"id":"estandarte_lino_valdoria","name":"Estandarte de Lino de Valdoria","name_en":"Valdorian Linen Banner","description":"Un pendón humilde para quienes inician el camino.","description_en":"A humble banner for those beginning the road.","rarity":RAREZA_COMUN,"category":"equipo","equip_slot":"estandarte","allowed_classes":["paladin","arquero","arcanista","caballero","asesino","nigromante"],"min_level":1,"base_stats":{"vida":5,"def":2},"icon_path":"res://Recursos/UI/Inventario/Slots/estandarte.png","zones":[ZONA_VALDORIA],"extra_relic":true},
	{"id":"pendon_camino_verde","name":"Pendón del Camino Verde","name_en":"Green Road Pennant","description":"Marca las rutas seguras entre las ruinas.","description_en":"Marks safe routes among the ruins.","rarity":RAREZA_POCO_COMUN,"category":"equipo","equip_slot":"estandarte","allowed_classes":["paladin","arquero","arcanista","caballero","asesino","nigromante"],"min_level":5,"base_stats":{"vida":10,"vel":3},"icon_path":"res://Recursos/UI/Inventario/Slots/estandarte.png","zones":[ZONA_VALDORIA],"extra_relic":true},
	{"id":"estandarte_roble_guardian","name":"Estandarte del Roble Guardián","name_en":"Guardian Oak Banner","description":"Su emblema fortalece a quienes marchan bajo él.","description_en":"Its emblem strengthens those marching beneath it.","rarity":RAREZA_RARO,"category":"equipo","equip_slot":"estandarte","allowed_classes":["paladin","arquero","arcanista","caballero","asesino","nigromante"],"min_level":10,"base_stats":{"vida":18,"def":8},"icon_path":"res://Recursos/UI/Inventario/Slots/estandarte.png","zones":[ZONA_VALDORIA],"extra_relic":true},
	{"id":"bandera_guardia_valdoria","name":"Bandera de la Guardia de Valdoria","name_en":"Valdorian Guard Standard","description":"Antigua insignia de los protectores del camino.","description_en":"An old standard of the road's protectors.","rarity":RAREZA_RARO,"category":"equipo","equip_slot":"estandarte","allowed_classes":["paladin","arquero","arcanista","caballero","asesino","nigromante"],"min_level":14,"base_stats":{"daño":7,"def":10},"icon_path":"res://Recursos/UI/Inventario/Slots/estandarte.png","zones":[ZONA_VALDORIA],"extra_relic":true},
	{"id":"estandarte_grifo_dorado","name":"Estandarte del Grifo Dorado","name_en":"Golden Gryphon Banner","description":"El grifo bordado parece desplegar las alas.","description_en":"The embroidered gryphon seems to spread its wings.","rarity":RAREZA_EPICO,"category":"equipo","equip_slot":"estandarte","allowed_classes":["paladin","arquero","arcanista","caballero","asesino","nigromante"],"min_level":22,"base_stats":{"vida":28,"daño":11,"vel":6},"icon_path":"res://Recursos/UI/Inventario/Slots/estandarte.png","zones":[ZONA_VALDORIA],"extra_relic":true},
	{"id":"pendon_sol_inmortal","name":"Pendón del Sol Inmortal","name_en":"Immortal Sun Pennant","description":"Conserva la luz de un amanecer perdido.","description_en":"It keeps the light of a lost dawn.","rarity":RAREZA_EPICO,"category":"equipo","equip_slot":"estandarte","allowed_classes":["paladin","arquero","arcanista","caballero","asesino","nigromante"],"min_level":28,"base_stats":{"vida":35,"def":17,"magia":10},"icon_path":"res://Recursos/UI/Inventario/Slots/estandarte.png","zones":[ZONA_VALDORIA],"extra_relic":true},
	{"id":"estandarte_rey_dorado","name":"Estandarte del Rey Dorado","name_en":"Golden King's Standard","description":"Solo ondeaba cuando el antiguo rey entraba en batalla.","description_en":"It flew only when the ancient king entered battle.","rarity":RAREZA_LEGENDARIO,"category":"equipo","equip_slot":"estandarte","allowed_classes":["paladin","arquero","arcanista","caballero","asesino","nigromante"],"min_level":36,"base_stats":{"vida":52,"daño":18,"def":24},"icon_path":"res://Recursos/UI/Inventario/Slots/estandarte.png","zones":[ZONA_VALDORIA],"extra_relic":true},
	{"id":"bandera_primera_corona","name":"Bandera de la Primera Corona","name_en":"First Crown Banner","description":"Los juramentos de la primera corona siguen escritos en oro.","description_en":"The oaths of the first crown remain written in gold.","rarity":RAREZA_LEGENDARIO,"category":"equipo","equip_slot":"estandarte","allowed_classes":["paladin","arquero","arcanista","caballero","asesino","nigromante"],"min_level":42,"base_stats":{"vida":58,"def":29,"magia":18},"icon_path":"res://Recursos/UI/Inventario/Slots/estandarte.png","zones":[ZONA_VALDORIA],"extra_relic":true},
	{"id":"estandarte_titan_dormido","name":"Estandarte del Titán Dormido","name_en":"Sleeping Titan Banner","description":"Su tela pesa como una montaña dormida.","description_en":"Its cloth weighs like a sleeping mountain.","rarity":RAREZA_MITICO,"category":"equipo","equip_slot":"estandarte","allowed_classes":["paladin","arquero","arcanista","caballero","asesino","nigromante"],"min_level":52,"base_stats":{"vida":82,"daño":27,"def":38},"icon_path":"res://Recursos/UI/Inventario/Slots/estandarte.png","zones":[ZONA_VALDORIA],"extra_relic":true},
	{"id":"pendon_era_perdida","name":"Pendón de la Era Perdida","name_en":"Lost Age Pennant","description":"Fue tejido antes de que Valdoria tuviera nombre.","description_en":"It was woven before Valdoria had a name.","rarity":RAREZA_ANCESTRAL,"category":"equipo","equip_slot":"estandarte","allowed_classes":["paladin","arquero","arcanista","caballero","asesino","nigromante"],"min_level":65,"base_stats":{"vida":115,"daño":36,"def":52,"magia":35},"icon_path":"res://Recursos/UI/Inventario/Slots/estandarte.png","zones":[ZONA_VALDORIA],"extra_relic":true},
	{"id":"estandarte_tela_gris","name":"Estandarte de Tela Gris","name_en":"Greycloth Banner","description":"La niebla se aferra a sus bordes gastados.","description_en":"Mist clings to its worn edges.","rarity":RAREZA_COMUN,"category":"equipo","equip_slot":"estandarte","allowed_classes":["paladin","arquero","arcanista","caballero","asesino","nigromante"],"min_level":1,"base_stats":{"vida":6,"magia":3},"icon_path":"res://Recursos/UI/Inventario/Slots/estandarte.png","zones":[ZONA_BRUMA],"extra_relic":true},
	{"id":"pendon_estatua_rota","name":"Pendón de la Estatua Rota","name_en":"Broken Statue Pennant","description":"Recuperado junto al pedestal de un paladín derruido.","description_en":"Recovered beside a fallen paladin's pedestal.","rarity":RAREZA_POCO_COMUN,"category":"equipo","equip_slot":"estandarte","allowed_classes":["paladin","arquero","arcanista","caballero","asesino","nigromante"],"min_level":6,"base_stats":{"vida":12,"def":6},"icon_path":"res://Recursos/UI/Inventario/Slots/estandarte.png","zones":[ZONA_BRUMA],"extra_relic":true},
	{"id":"estandarte_vigia_niebla","name":"Estandarte del Vigía de Niebla","name_en":"Mist Watcher Banner","description":"Permite distinguir siluetas donde otros solo ven gris.","description_en":"Reveals silhouettes where others see only grey.","rarity":RAREZA_RARO,"category":"equipo","equip_slot":"estandarte","allowed_classes":["paladin","arquero","arcanista","caballero","asesino","nigromante"],"min_level":14,"base_stats":{"vel":8,"magia":10},"icon_path":"res://Recursos/UI/Inventario/Slots/estandarte.png","zones":[ZONA_BRUMA],"extra_relic":true},
	{"id":"bandera_fortaleza_olvidada","name":"Bandera de la Fortaleza Olvidada","name_en":"Forgotten Fortress Banner","description":"Aún conserva el sello de una guarnición desaparecida.","description_en":"It still bears the seal of a vanished garrison.","rarity":RAREZA_RARO,"category":"equipo","equip_slot":"estandarte","allowed_classes":["paladin","arquero","arcanista","caballero","asesino","nigromante"],"min_level":18,"base_stats":{"vida":22,"def":13},"icon_path":"res://Recursos/UI/Inventario/Slots/estandarte.png","zones":[ZONA_BRUMA],"extra_relic":true},
	{"id":"estandarte_velo_partido","name":"Estandarte del Velo Partido","name_en":"Split Veil Standard","description":"Su símbolo divide la niebla como una hoja.","description_en":"Its symbol splits the mist like a blade.","rarity":RAREZA_EPICO,"category":"equipo","equip_slot":"estandarte","allowed_classes":["paladin","arquero","arcanista","caballero","asesino","nigromante"],"min_level":24,"base_stats":{"daño":13,"vel":9,"magia":15},"icon_path":"res://Recursos/UI/Inventario/Slots/estandarte.png","zones":[ZONA_BRUMA],"extra_relic":true},
	{"id":"pendon_campana_silente","name":"Pendón de la Campana Silente","name_en":"Silent Bell Pennant","description":"Una campana bordada suena sin emitir ruido.","description_en":"An embroidered bell rings without sound.","rarity":RAREZA_EPICO,"category":"equipo","equip_slot":"estandarte","allowed_classes":["paladin","arquero","arcanista","caballero","asesino","nigromante"],"min_level":30,"base_stats":{"vida":34,"def":18,"magia":18},"icon_path":"res://Recursos/UI/Inventario/Slots/estandarte.png","zones":[ZONA_BRUMA],"extra_relic":true},
	{"id":"estandarte_senor_velo","name":"Estandarte del Señor del Velo","name_en":"Lord of the Veil Standard","description":"La fortaleza responde a quien porta este emblema.","description_en":"The fortress answers to whoever bears this emblem.","rarity":RAREZA_LEGENDARIO,"category":"equipo","equip_slot":"estandarte","allowed_classes":["paladin","arquero","arcanista","caballero","asesino","nigromante"],"min_level":38,"base_stats":{"vida":56,"daño":20,"magia":28},"icon_path":"res://Recursos/UI/Inventario/Slots/estandarte.png","zones":[ZONA_BRUMA],"extra_relic":true},
	{"id":"bandera_juramento_roto","name":"Bandera del Juramento Roto","name_en":"Broken Oath Banner","description":"Cada rasgadura recuerda una promesa incumplida.","description_en":"Every tear recalls a broken promise.","rarity":RAREZA_LEGENDARIO,"category":"equipo","equip_slot":"estandarte","allowed_classes":["paladin","arquero","arcanista","caballero","asesino","nigromante"],"min_level":44,"base_stats":{"vida":64,"def":32,"magia":25},"icon_path":"res://Recursos/UI/Inventario/Slots/estandarte.png","zones":[ZONA_BRUMA],"extra_relic":true},
	{"id":"estandarte_madre_niebla","name":"Estandarte de la Madre Niebla","name_en":"Mother of Mist Banner","description":"Respira lentamente cuando la niebla se vuelve espesa.","description_en":"It breathes slowly when the mist thickens.","rarity":RAREZA_MITICO,"category":"equipo","equip_slot":"estandarte","allowed_classes":["paladin","arquero","arcanista","caballero","asesino","nigromante"],"min_level":54,"base_stats":{"vida":90,"daño":29,"magia":46},"icon_path":"res://Recursos/UI/Inventario/Slots/estandarte.png","zones":[ZONA_BRUMA],"extra_relic":true},
	{"id":"pendon_paso_eterno","name":"Pendón del Paso Eterno","name_en":"Eternal Pass Pennant","description":"Señala un sendero que ningún mapa recuerda.","description_en":"It marks a path no map remembers.","rarity":RAREZA_ANCESTRAL,"category":"equipo","equip_slot":"estandarte","allowed_classes":["paladin","arquero","arcanista","caballero","asesino","nigromante"],"min_level":68,"base_stats":{"vida":125,"def":58,"vel":30,"magia":42},"icon_path":"res://Recursos/UI/Inventario/Slots/estandarte.png","zones":[ZONA_BRUMA],"extra_relic":true},
	{"id":"yelmo_hojas_azules","name":"Yelmo de Hojas Azules","name_en":"Blueleaf Helm","description":"Acero ligero cubierto por hojas esmaltadas.","description_en":"Light steel covered in enamelled leaves.","rarity":RAREZA_POCO_COMUN,"category":"equipo","equip_slot":"casco","allowed_classes":["paladin","arquero","arcanista","caballero","asesino","nigromante"],"min_level":6,"base_stats":{"vida":12,"def":7},"icon_path":"res://Recursos/UI/Inventario/Slots/casco.png","zones":[ZONA_VALDORIA],"extra_relic":true},
	{"id":"guantes_alba_errante","name":"Guantes del Alba Errante","name_en":"Wandering Dawn Gloves","description":"Mantienen firme el pulso durante largas marchas.","description_en":"They keep the hand steady through long marches.","rarity":RAREZA_RARO,"category":"equipo","equip_slot":"guantes","allowed_classes":["paladin","arquero","arcanista","caballero","asesino","nigromante"],"min_level":13,"base_stats":{"daño":8,"vel":5},"icon_path":"res://Recursos/UI/Inventario/Slots/guantes.png","zones":[ZONA_VALDORIA],"extra_relic":true},
	{"id":"botas_arco_roto","name":"Botas del Arco Roto","name_en":"Broken Arch Boots","description":"Talladas para recorrer ruinas sin hacer ruido.","description_en":"Made to cross ruins without a sound.","rarity":RAREZA_EPICO,"category":"equipo","equip_slot":"botas","allowed_classes":["paladin","arquero","arcanista","caballero","asesino","nigromante"],"min_level":25,"base_stats":{"vel":14,"def":8},"icon_path":"res://Recursos/UI/Inventario/Slots/botas.png","zones":[ZONA_VALDORIA],"extra_relic":true},
	{"id":"coraza_centinela_verde","name":"Coraza del Centinela Verde","name_en":"Green Sentinel Cuirass","description":"Una armadura ceremonial convertida en protección real.","description_en":"Ceremonial armor turned into true protection.","rarity":RAREZA_LEGENDARIO,"category":"equipo","equip_slot":"armadura","allowed_classes":["paladin","arquero","arcanista","caballero","asesino","nigromante"],"min_level":40,"base_stats":{"vida":60,"def":33,"daño":12},"icon_path":"res://Recursos/UI/Inventario/Slots/armadura.png","zones":[ZONA_VALDORIA],"extra_relic":true},
	{"id":"yelmo_rostro_velado","name":"Yelmo del Rostro Velado","name_en":"Veiled Face Helm","description":"Oculta al portador entre sombras de piedra.","description_en":"Hides its bearer among stone shadows.","rarity":RAREZA_POCO_COMUN,"category":"equipo","equip_slot":"casco","allowed_classes":["paladin","arquero","arcanista","caballero","asesino","nigromante"],"min_level":8,"base_stats":{"vida":14,"def":8,"magia":4},"icon_path":"res://Recursos/UI/Inventario/Slots/casco.png","zones":[ZONA_BRUMA],"extra_relic":true},
	{"id":"guantes_guardia_estatua","name":"Guantes de la Guardia de Piedra","name_en":"Stone Guard Gloves","description":"Sus placas imitan las manos de las estatuas.","description_en":"Their plates imitate the hands of statues.","rarity":RAREZA_RARO,"category":"equipo","equip_slot":"guantes","allowed_classes":["paladin","arquero","arcanista","caballero","asesino","nigromante"],"min_level":16,"base_stats":{"daño":9,"def":9},"icon_path":"res://Recursos/UI/Inventario/Slots/guantes.png","zones":[ZONA_BRUMA],"extra_relic":true},
	{"id":"botas_senda_borrada","name":"Botas de la Senda Borrada","name_en":"Erased Path Boots","description":"Cada pisada desaparece tras el viajero.","description_en":"Every footprint vanishes behind the traveler.","rarity":RAREZA_EPICO,"category":"equipo","equip_slot":"botas","allowed_classes":["paladin","arquero","arcanista","caballero","asesino","nigromante"],"min_level":27,"base_stats":{"vel":16,"magia":10},"icon_path":"res://Recursos/UI/Inventario/Slots/botas.png","zones":[ZONA_BRUMA],"extra_relic":true},
	{"id":"coraza_muro_niebla","name":"Coraza del Muro de Niebla","name_en":"Mistwall Cuirass","description":"Capas de metal oscuro resisten golpes y hechizos.","description_en":"Layers of dark metal resist blows and spells.","rarity":RAREZA_LEGENDARIO,"category":"equipo","equip_slot":"armadura","allowed_classes":["paladin","arquero","arcanista","caballero","asesino","nigromante"],"min_level":42,"base_stats":{"vida":68,"def":36,"magia":22},"icon_path":"res://Recursos/UI/Inventario/Slots/armadura.png","zones":[ZONA_BRUMA],"extra_relic":true},
	{"id":"reliquia_piedra_elaris","name":"Reliquia de Piedra de Elaris","name_en":"Elaris Stone Relic","description":"Una pieza sencilla de las ruinas. Sus vetas azules laten cuando comienza el combate.","description_en":"A simple piece from the ruins. Its blue veins pulse when battle begins.","rarity":RAREZA_COMUN,"category":"equipo","equip_slot":"reliquia","allowed_classes":["paladin","arquero","arcanista","caballero","asesino","nigromante"],"min_level":1,"base_stats":{"vida":8,"def":3,"magia":2},"icon_path":"res://Recursos/UI/Inventario/Slots/estandarte.png","zones":[ZONA_ELARIS],"extra_relic":true},
	{"id":"fragmento_elaris","name":"Fragmento de Elaris","name_en":"Elaris Fragment","description":"Piedra azul arrancada de una ruina que todavía recuerda su antiguo nombre.","description_en":"Blue stone taken from a ruin that still remembers its ancient name.","rarity":RAREZA_COMUN,"category":"materiales","min_level":1,"stackable":true,"quantity_min":1,"quantity_max":3,"icon_path":"res://Recursos/UI/Inventario/Slots/estandarte.png","zones":[ZONA_ELARIS],"extra_relic":true},
	{"id":"sello_ruinas_elaris","name":"Sello de las Ruinas de Elaris","name_en":"Seal of the Elaris Ruins","description":"Una reliquia sencilla que fortalece a quien no teme caminar entre tumbas.","description_en":"A simple relic that strengthens those unafraid to walk among tombs.","rarity":RAREZA_POCO_COMUN,"category":"equipo","equip_slot":"reliquia","allowed_classes":["paladin","arquero","arcanista","caballero","asesino","nigromante"],"min_level":8,"base_stats":{"vida":18,"def":8,"magia":5},"icon_path":"res://Recursos/UI/Inventario/Slots/estandarte.png","zones":[ZONA_ELARIS],"extra_relic":true},
	{"id":"anillo_colmillo_verde","name":"Anillo del Colmillo Verde","name_en":"Green Fang Ring","description":"Su gema conserva una gota de veneno que nunca llega a secarse.","description_en":"Its gem holds a drop of venom that never dries.","rarity":RAREZA_RARO,"category":"equipo","equip_slot":"anillo","allowed_classes":["paladin","arquero","arcanista","caballero","asesino","nigromante"],"min_level":18,"base_stats":{"daño":10,"vel":8,"magia":8},"icon_path":"res://Recursos/UI/Inventario/Slots/anillo.png","zones":[ZONA_ELARIS],"extra_relic":true},
	{"id":"reliquia_luz_quebrada","name":"Reliquia de la Luz Quebrada","name_en":"Relic of Broken Light","description":"La luz atraviesa sus grietas y convierte el dolor en fuerza.","description_en":"Light passes through its cracks and turns pain into strength.","rarity":RAREZA_EPICO,"category":"equipo","equip_slot":"reliquia","allowed_classes":["paladin","arquero","arcanista","caballero","asesino","nigromante"],"min_level":28,"base_stats":{"vida":42,"daño":16,"def":18,"magia":18},"icon_path":"res://Recursos/UI/Inventario/Slots/estandarte.png","zones":[ZONA_ELARIS],"extra_relic":true},
	{"id":"coraza_guardian_elaris","name":"Coraza del Guardián de Elaris","name_en":"Elaris Guardian Cuirass","description":"Placas antiguas marcadas por veneno, fuego y siglos de asedio.","description_en":"Ancient plates scarred by venom, fire and centuries of siege.","rarity":RAREZA_LEGENDARIO,"category":"equipo","equip_slot":"armadura","allowed_classes":["paladin","arquero","arcanista","caballero","asesino","nigromante"],"min_level":40,"base_stats":{"vida":78,"daño":20,"def":42,"magia":24},"icon_path":"res://Recursos/UI/Inventario/Slots/armadura.png","zones":[ZONA_ELARIS],"extra_relic":true},
	{"id":"reliquia_reina_aracnida","name":"Reliquia de la Reina Arácnida","name_en":"Spider Queen Relic","description":"Late como un segundo corazón cuando la sangre toca el suelo.","description_en":"It beats like a second heart whenever blood touches the ground.","rarity":RAREZA_MITICO,"category":"equipo","equip_slot":"reliquia","allowed_classes":["paladin","arquero","arcanista","caballero","asesino","nigromante"],"min_level":52,"base_stats":{"vida":102,"daño":32,"vel":24,"magia":48},"icon_path":"res://Recursos/UI/Inventario/Slots/estandarte.png","zones":[ZONA_ELARIS],"extra_relic":true},
	{"id":"corona_ultimo_archivo","name":"Corona del Último Archivo","name_en":"Crown of the Last Archive","description":"Contiene recuerdos de un reino borrado de todos los mapas.","description_en":"It holds memories of a kingdom erased from every map.","rarity":RAREZA_ANCESTRAL,"category":"equipo","equip_slot":"casco","allowed_classes":["paladin","arquero","arcanista","caballero","asesino","nigromante"],"min_level":66,"base_stats":{"vida":145,"def":62,"magia":55,"vel":22},"icon_path":"res://Recursos/UI/Inventario/Slots/casco.png","zones":[ZONA_ELARIS],"extra_relic":true},
	{"id":"eco_rey_sin_reino","name":"Eco del Rey sin Reino","name_en":"Echo of the King Without a Realm","description":"Una reliquia única. Absorbe parte de la vida arrebatada y la devuelve a su portador.","description_en":"A unique relic. It absorbs part of stolen life and returns it to its bearer.","rarity":RAREZA_UNICO,"category":"equipo","equip_slot":"reliquia","allowed_classes":["paladin","arquero","arcanista","caballero","asesino","nigromante"],"min_level":75,"base_stats":{"vida":190,"daño":60,"def":75,"magia":72,"vel":35},"passive":{"type":"periodic_shield","name":"Memoria de Elaris","shield":180,"cooldown":38.0,"description":"Cada 38 s obtienes un escudo nacido de los recuerdos de Elaris."},"icon_path":"res://Recursos/UI/Inventario/Slots/estandarte.png","zones":[ZONA_ELARIS],"stage_special":true,"extra_relic":true}
]

static func completar_objeto_guardado(item_data: Dictionary) -> Dictionary:

	var item: Dictionary = item_data.duplicate(true)
	var item_id: String = str(item.get("id", ""))
	var template: Dictionary = _buscar_plantilla_por_id(item_id)

	if not template.is_empty():
		for key in [
			"category",
			"equip_slot",
			"weapon_type",
			"allowed_classes",
			"consumable",
			"stackable",
			"effect",
			"zones",
			"min_level"
		]:
			if not item.has(key) and template.has(key):
				item[key] = template[key]

		item["name"] = str(
			template.get("name", item.get("name", ""))
		)
		item["description"] = str(
			template.get(
				"description",
				item.get("description", "")
			)
		)

	if not item.has("source_zone") and not template.is_empty():
		var template_zones_variant: Variant = template.get("zones", [])
		if template_zones_variant is Array:
			var template_zones: Array = template_zones_variant
			if template_zones.size() == 1:
				item["source_zone"] = SistemaRegiones.normalizar_zona(str(template_zones[0]))

	if item.has("source_zone"):
		var source_zone: String = SistemaRegiones.normalizar_zona(str(item.get("source_zone", ZONA_VALDORIA)))
		item["source_zone"] = source_zone
		item["region_name"] = SistemaRegiones.obtener_nombre(source_zone, TranslationServer.get_locale(), false)

	var rarity: String = str(
		item.get("rarity", item.get("rareza", RAREZA_COMUN))
	)
	item["rarity"] = rarity
	item["rareza"] = rarity
	item["rarity_name"] = obtener_nombre_rareza(rarity)
	item["rarity_color"] = obtener_color_rareza(rarity).to_html()

	if rarity == RAREZA_UNICO and not template.is_empty():
		var item_level: int = maxi(1, int(item.get("item_level", 1)))
		var passive_final: Dictionary = _crear_pasiva_final(
			template,
			item_level,
			rarity
		)
		if not passive_final.is_empty():
			item["passive"] = passive_final
	else:
		item.erase("passive")

	item["effect_description"] = construir_descripcion_efecto(item)
	return item

static func construir_descripcion_efecto(item: Dictionary) -> String:
	var lines: Array[String] = []
	var stats_variant: Variant = item.get("stats", {})
	if stats_variant is Dictionary:
		var stats: Dictionary = stats_variant
		for stat_name in ["vida", "daño", "def", "vel", "magia"]:
			var value: int = int(stats.get(stat_name, 0))
			if value == 0:
				continue
			lines.append("+%d %s" % [value, _nombre_stat(stat_name)])

	var effect_variant: Variant = item.get("effect", {})
	if effect_variant is Dictionary:
		var effect: Dictionary = effect_variant
		var healing: int = int(effect.get("heal", 0))
		if healing > 0:
			if _is_english():
				lines.append(
					"Restores %d health when used"
					% healing
				)
			else:
				lines.append(
					"Recupera %d de vida al usarlo"
					% healing
				)

	var rarity: String = str(
		item.get("rarity", item.get("rareza", RAREZA_COMUN))
	)
	var passive_variant: Variant = item.get("passive", {})
	if rarity == RAREZA_UNICO and passive_variant is Dictionary:
		var passive: Dictionary = passive_variant
		var passive_description: String = str(passive.get("description", ""))
		if not passive_description.is_empty():
			lines.append(passive_description)

	var source_zone: String = str(item.get("source_zone", "")).strip_edges()
	if not source_zone.is_empty():
		var region_name: String = SistemaRegiones.obtener_nombre(
			source_zone,
			TranslationServer.get_locale(),
			false
		)
		lines.append(
			("Origin: " if _is_english() else "Origen: ") + region_name
		)

	return " · ".join(lines)

static func _crear_pasiva_final(
	template: Dictionary,
	item_level: int,
	rarity: String
) -> Dictionary:
	if rarity != RAREZA_UNICO:
		return {}

	var passive_variant: Variant = template.get("passive", {})
	if not (passive_variant is Dictionary):
		return {}

	var passive: Dictionary = (passive_variant as Dictionary).duplicate(true)
	if passive.is_empty():
		return {}

	passive["name"] = _localize_passive_name(
		str(passive.get("name", ""))
	)

	if str(passive.get("type", "")) == "periodic_shield":
		var base_shield: int = maxi(1, int(passive.get("shield", 1)))
		var level_multiplier: float = 1.0 + float(maxi(0, item_level - 1)) * 0.02
		var shield_value: int = maxi(
			1,
			int(round(float(base_shield) * level_multiplier))
		)
		var cooldown: float = maxf(5.0, float(passive.get("cooldown", 50.0)))
		passive["shield"] = shield_value
		passive["cooldown"] = cooldown
		if _is_english():
			passive["description"] = (
				"Every %d s, gain a blue shield worth %d points."
				% [int(round(cooldown)), shield_value]
			)
		else:
			passive["description"] = (
				"Cada %d s obtienes un escudo azul de %d puntos."
				% [int(round(cooldown)), shield_value]
			)

	return passive

static func _buscar_plantilla_por_id(item_id: String) -> Dictionary:
	if item_id.is_empty():
		return {}

	for raw_template in OBJETOS:
		if str(raw_template.get("id", "")) == item_id:
			return _enriquecer_plantilla(raw_template)

	return {}

static func _is_english() -> bool:
	return TranslationServer.get_locale().to_lower().begins_with(
		"en"
	)

static func _localize_passive_name(
	spanish_name: String
) -> String:
	if not _is_english():
		return spanish_name

	var passive_names: Dictionary = {
		"Égida del Juramento": "Aegis of the Oath",
		"Pulso Protector": "Protective Pulse",
		"Velo Innominado": "Nameless Veil",
		"Guardia del Viento": "Wind Guard",
		"Barrera Arcana": "Arcane Barrier",
		"Manto de Sombras": "Mantle of Shadows",
		"Vigilia de la Estatua": "Statue's Vigil",
		"Memoria de Elaris": "Memory of Elaris"
	}
	return str(
		passive_names.get(spanish_name, spanish_name)
	)

static func _localize_template(
	template: Dictionary
) -> Dictionary:
	if not _is_english():
		return template
	if template.has("name_en"):
		template["name"] = str(template.get("name_en", template.get("name", "")))
	if template.has("description_en"):
		template["description"] = str(template.get("description_en", template.get("description", "")))

	var item_id: String = str(template.get("id", ""))
	var localized_variant: Variant = ENGLISH_ITEM_TEXTS.get(
		item_id,
		{}
	)

	if localized_variant is Dictionary:
		var localized: Dictionary = localized_variant
		if not localized.is_empty():
			template["name"] = str(
				localized.get(
					"name",
					template.get("name", "")
				)
			)
			template["description"] = str(
				localized.get(
					"description",
					template.get("description", "")
				)
			)

	return template

static func _nombre_stat(stat_name: String) -> String:
	if _is_english():
		match stat_name:
			"vida":
				return "Maximum health"
			"daño":
				return "Damage"
			"def":
				return "Defense"
			"vel":
				return "Speed"
			"magia":
				return "Magic power"
			_:
				return stat_name.capitalize()

	match stat_name:
		"vida":
			return "Vida máxima"
		"daño":
			return "Daño"
		"def":
			return "Defensa"
		"vel":
			return "Velocidad"
		"magia":
			return "Poder mágico"
		_:
			return stat_name.capitalize()

static func obtener_nombre_rareza(rareza: String) -> String:
	if _is_english():
		return str(
			ENGLISH_RARITY_NAMES.get(rareza, "COMMON")
		)

	return str(NOMBRES_RAREZA.get(rareza, "COMÚN"))

static func obtener_color_rareza(rareza: String) -> Color:
	return COLORES_RAREZA.get(rareza, COLORES_RAREZA[RAREZA_COMUN])

static func obtener_probabilidades(
	nivel_jugador: int,
	rango_enemigo: String = "normal",
	bonus_suerte_porcentaje: float = 0.0,
	zona_id: String = ZONA_VALDORIA
) -> Dictionary:
	var nivel: int = maxi(1, nivel_jugador)
	var progreso: float = clampf(float(nivel - 1) / 99.0, 0.0, 1.0)

	var pesos: Dictionary = {
		RAREZA_COMUN: lerpf(70.0, 20.0, progreso),
		RAREZA_POCO_COMUN: lerpf(22.0, 25.0, progreso),
		RAREZA_RARO: lerpf(6.5, 25.0, progreso),
		RAREZA_EPICO: lerpf(1.35, 17.0, progreso),
		RAREZA_LEGENDARIO: lerpf(0.13, 9.0, progreso),
		RAREZA_MITICO: lerpf(0.015, 3.0, progreso),
		RAREZA_ANCESTRAL: lerpf(0.005, 1.0, progreso)
	}

	var rango: String = rango_enemigo.to_lower()
	if rango == "elite":
		pesos[RAREZA_COMUN] = float(pesos[RAREZA_COMUN]) * 0.78
		pesos[RAREZA_POCO_COMUN] = float(pesos[RAREZA_POCO_COMUN]) * 0.92
		pesos[RAREZA_RARO] = float(pesos[RAREZA_RARO]) * 1.22
		pesos[RAREZA_EPICO] = float(pesos[RAREZA_EPICO]) * 1.35
		pesos[RAREZA_LEGENDARIO] = float(pesos[RAREZA_LEGENDARIO]) * 1.45
		pesos[RAREZA_MITICO] = float(pesos[RAREZA_MITICO]) * 1.55
		pesos[RAREZA_ANCESTRAL] = float(pesos[RAREZA_ANCESTRAL]) * 1.65
	elif rango == "boss":
		pesos[RAREZA_COMUN] = float(pesos[RAREZA_COMUN]) * 0.50
		pesos[RAREZA_POCO_COMUN] = float(pesos[RAREZA_POCO_COMUN]) * 0.76
		pesos[RAREZA_RARO] = float(pesos[RAREZA_RARO]) * 1.45
		pesos[RAREZA_EPICO] = float(pesos[RAREZA_EPICO]) * 1.75
		pesos[RAREZA_LEGENDARIO] = float(pesos[RAREZA_LEGENDARIO]) * 2.05
		pesos[RAREZA_MITICO] = float(pesos[RAREZA_MITICO]) * 2.30
		pesos[RAREZA_ANCESTRAL] = float(pesos[RAREZA_ANCESTRAL]) * 2.60

	var luck: float = clampf(bonus_suerte_porcentaje, 0.0, 100.0)
	if luck > 0.0:
		pesos[RAREZA_COMUN] = float(pesos[RAREZA_COMUN]) * maxf(0.25, 1.0 - luck / 135.0)
		pesos[RAREZA_POCO_COMUN] = float(pesos[RAREZA_POCO_COMUN]) * (1.0 + luck / 260.0)
		pesos[RAREZA_RARO] = float(pesos[RAREZA_RARO]) * (1.0 + luck / 100.0)
		pesos[RAREZA_EPICO] = float(pesos[RAREZA_EPICO]) * (1.0 + luck / 82.0)
		pesos[RAREZA_LEGENDARIO] = float(pesos[RAREZA_LEGENDARIO]) * (1.0 + luck / 68.0)
		pesos[RAREZA_MITICO] = float(pesos[RAREZA_MITICO]) * (1.0 + luck / 56.0)
		pesos[RAREZA_ANCESTRAL] = float(pesos[RAREZA_ANCESTRAL]) * (1.0 + luck / 46.0)

	var total_pesos: float = 0.0
	for rareza in pesos.keys():
		total_pesos += maxf(0.0, float(pesos[rareza]))

	var normalized_zone: String = SistemaRegiones.normalizar_zona(zona_id)
	var unique_probability: float = SistemaRegiones.obtener_probabilidad_unico(normalized_zone)
	if rango == "elite":
		unique_probability *= 2.0
	elif rango == "boss":
		unique_probability *= 5.0
	unique_probability = clampf(unique_probability, 0.0, 0.25)

	var porcentaje_repartible: float = 100.0 - unique_probability
	var resultado: Dictionary = {}

	for rareza in ORDEN_RAREZAS:
		if rareza == RAREZA_UNICO:
			continue
		var peso: float = maxf(0.0, float(pesos.get(rareza, 0.0)))
		resultado[rareza] = porcentaje_repartible * peso / maxf(total_pesos, 0.000001)

	resultado[RAREZA_UNICO] = unique_probability
	return resultado

static func generar_objeto_aleatorio(
	nivel_jugador: int,
	rango_enemigo: String = "normal",
	personaje_id: String = "",
	bonus_suerte_porcentaje: float = 0.0,
	zona_id: String = ZONA_VALDORIA
) -> Dictionary:
	var rng := RandomNumberGenerator.new()
	rng.randomize()

	var nivel: int = maxi(1, nivel_jugador)
	var normalized_zone: String = SistemaRegiones.normalizar_zona(zona_id)
	var rareza: String = _sortear_rareza(
		rng,
		nivel,
		rango_enemigo,
		bonus_suerte_porcentaje,
		normalized_zone
	)
	var grupo_clase: String = obtener_grupo_clase(personaje_id)
	var candidatos: Array[Dictionary] = _obtener_candidatos(
		rareza,
		nivel,
		grupo_clase,
		normalized_zone
	)

	if candidatos.is_empty():
		var indice_rareza: int = ORDEN_RAREZAS.find(rareza)
		for indice in range(indice_rareza - 1, -1, -1):
			candidatos = _obtener_candidatos(
				ORDEN_RAREZAS[indice],
				nivel,
				grupo_clase,
				normalized_zone
			)
			if not candidatos.is_empty():
				rareza = ORDEN_RAREZAS[indice]
				break

	if candidatos.is_empty():
		return {}

	var plantilla: Dictionary = _enriquecer_plantilla(
		candidatos[rng.randi_range(0, candidatos.size() - 1)].duplicate(true)
	)
	var bonus_rango: int = 0
	if rango_enemigo.to_lower() == "elite":
		bonus_rango = 1
	elif rango_enemigo.to_lower() == "boss":
		bonus_rango = 3

	var nivel_objeto: int = maxi(1, nivel + rng.randi_range(-2, 2) + bonus_rango)
	var multiplicador_rareza: float = float(MULTIPLICADORES_RAREZA.get(rareza, 1.0))
	var multiplicador_nivel: float = 1.0 + float(nivel_objeto - 1) * 0.055
	var stats_finales: Dictionary = {}
	var stats_base: Dictionary = plantilla.get("base_stats", {})

	for stat_name in stats_base.keys():
		var valor_base: float = float(stats_base[stat_name])
		stats_finales[stat_name] = maxi(
			1,
			int(round(valor_base * multiplicador_rareza * multiplicador_nivel))
		)

	var cantidad_min: int = int(plantilla.get("quantity_min", 1))
	var cantidad_max: int = int(plantilla.get("quantity_max", cantidad_min))

	plantilla["rarity"] = rareza
	plantilla["rareza"] = rareza
	plantilla["rarity_name"] = obtener_nombre_rareza(rareza)
	plantilla["rarity_color"] = obtener_color_rareza(rareza).to_html()
	plantilla["item_level"] = nivel_objeto
	plantilla["stats"] = stats_finales
	plantilla["quantity"] = rng.randi_range(cantidad_min, maxi(cantidad_min, cantidad_max))
	plantilla["icon_path"] = str(plantilla.get("icon_path", ""))
	plantilla["source_zone"] = normalized_zone
	plantilla["region_name"] = SistemaRegiones.obtener_nombre(
		normalized_zone,
		TranslationServer.get_locale(),
		false
	)
	plantilla["unique_drop_chance"] = float(
		obtener_probabilidades(
			nivel,
			rango_enemigo,
			bonus_suerte_porcentaje,
			normalized_zone
		).get(RAREZA_UNICO, 0.0)
	)

	var passive_final: Dictionary = _crear_pasiva_final(
		plantilla,
		nivel_objeto,
		rareza
	)
	if passive_final.is_empty():
		plantilla.erase("passive")
	else:
		plantilla["passive"] = passive_final

	plantilla["effect_description"] = construir_descripcion_efecto(plantilla)
	plantilla.erase("base_stats")
	plantilla.erase("quantity_min")
	plantilla.erase("quantity_max")
	return plantilla

static func _obtener_candidatos(
	rareza: String,
	nivel: int,
	grupo_clase: String = "",
	zona_id: String = ZONA_VALDORIA
) -> Array[Dictionary]:
	var candidatos: Array[Dictionary] = []
	for raw_template in OBJETOS:
		var template: Dictionary = _enriquecer_plantilla(raw_template)
		if str(template.get("rarity", RAREZA_COMUN)) != rareza:
			continue
		if int(template.get("min_level", 1)) > nivel:
			continue
		if not _template_pertenece_a_zona(template, zona_id, rareza == RAREZA_UNICO):
			continue

		var allowed_variant: Variant = template.get("allowed_classes", [])
		if not grupo_clase.is_empty() and allowed_variant is Array:
			var allowed_classes: Array = allowed_variant
			if not allowed_classes.is_empty() and not allowed_classes.has(grupo_clase):
				continue

		candidatos.append(template)
	return candidatos

static func _template_pertenece_a_zona(
	template: Dictionary,
	zona_id: String,
	requerir_region_explicita: bool = false
) -> bool:
	var normalized_zone: String = SistemaRegiones.normalizar_zona(zona_id)
	var zones_variant: Variant = template.get("zones", [])

	if not (zones_variant is Array):
		return not requerir_region_explicita

	var zones: Array = zones_variant
	if zones.is_empty():
		return not requerir_region_explicita

	for raw_zone in zones:
		if SistemaRegiones.normalizar_zona(str(raw_zone)) == normalized_zone:
			return true

	return false

static func obtener_grupo_clase(personaje_id: String) -> String:
	match personaje_id.to_lower().strip_edges():
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
			return ""

static func _enriquecer_plantilla(raw_template: Dictionary) -> Dictionary:
	var template: Dictionary = raw_template.duplicate(true)
	var equip_slot: String = str(template.get("equip_slot", ""))
	var identity: String = (
		str(template.get("id", ""))
		+ " "
		+ str(template.get("name", ""))
	).to_lower()

	if not template.has("allowed_classes"):
		template["allowed_classes"] = []

	if equip_slot == "escudo":
		template["allowed_classes"] = ["paladin"]

	if equip_slot == "arma" and not template.has("weapon_type"):
		var weapon_type: String = "generica"
		if identity.contains("arco") or identity.contains("saeta"):
			weapon_type = "arco"
		elif (
			identity.contains("baston")
			or identity.contains("bastón")
			or identity.contains("baculo")
			or identity.contains("báculo")
			or identity.contains("varita")
			or identity.contains("orbe")
			or identity.contains("grimorio")
			or identity.contains("cetro")
			or identity.contains("codice")
			or identity.contains("códice")
		):
			weapon_type = "magia"
		elif (
			identity.contains("daga")
			or identity.contains("puñal")
			or identity.contains("cuchilla")
		):
			weapon_type = "daga"
		elif identity.contains("mandoble"):
			weapon_type = "mandoble"
		elif (
			identity.contains("espada")
			or identity.contains("sable")
			or identity.contains("hoja")
			or identity.contains("filo")
			or identity.contains("juramento")
		):
			weapon_type = "espada"
		template["weapon_type"] = weapon_type

	if equip_slot == "arma" and (template["allowed_classes"] as Array).is_empty():
		match str(template.get("weapon_type", "generica")):
			"arco":
				template["allowed_classes"] = ["arquero"]
			"magia":
				template["allowed_classes"] = ["arcanista", "nigromante"]
			"daga":
				template["allowed_classes"] = ["asesino"]
			"espada", "mandoble", "generica":
				template["allowed_classes"] = ["paladin", "caballero"]

	if str(template.get("id", "")) == "reliquia_primer_paladin":
		template["allowed_classes"] = ["paladin"]

	if str(template.get("rarity", RAREZA_COMUN)) != RAREZA_UNICO:
		template.erase("passive")

	return _localize_template(template)

static func _sortear_rareza(
	rng: RandomNumberGenerator,
	nivel_jugador: int,
	rango_enemigo: String,
	bonus_suerte_porcentaje: float = 0.0,
	zona_id: String = ZONA_VALDORIA
) -> String:
	var probabilidades: Dictionary = obtener_probabilidades(
		nivel_jugador,
		rango_enemigo,
		bonus_suerte_porcentaje,
		zona_id
	)
	var tirada: float = rng.randf_range(0.0, 100.0)
	var acumulado: float = 0.0

	for rareza in ORDEN_RAREZAS:
		acumulado += float(probabilidades.get(rareza, 0.0))
		if tirada <= acumulado:
			return rareza

	return RAREZA_COMUN

static func generar_arma_forjada(
	rareza_objetivo: String,
	nivel_objetivo: int,
	personaje_id: String = "",
	zona_id: String = ZONA_VALDORIA
) -> Dictionary:
	var rng: RandomNumberGenerator = RandomNumberGenerator.new()
	rng.randomize()

	var rarity_index: int = ORDEN_RAREZAS.find(rareza_objetivo)
	if rarity_index < 0:
		rarity_index = ORDEN_RAREZAS.find(RAREZA_POCO_COMUN)

	var grupo_clase: String = obtener_grupo_clase(personaje_id)
	var candidatos: Array[Dictionary] = []
	var selected_rarity: String = ORDEN_RAREZAS[rarity_index]

	for search_index in range(rarity_index, -1, -1):
		selected_rarity = ORDEN_RAREZAS[search_index]
		candidatos.clear()

		for raw_template in OBJETOS:
			var candidate_template: Dictionary = _enriquecer_plantilla(raw_template)
			if str(candidate_template.get("equip_slot", "")) != "arma":
				continue
			if str(candidate_template.get("rarity", RAREZA_COMUN)) != selected_rarity:
				continue
			if not _template_pertenece_a_zona(candidate_template, zona_id):
				continue

			var allowed_variant: Variant = candidate_template.get("allowed_classes", [])
			if not grupo_clase.is_empty() and allowed_variant is Array:
				var allowed_classes: Array = allowed_variant
				if not allowed_classes.is_empty() and not allowed_classes.has(grupo_clase):
					continue

			candidatos.append(candidate_template)

		if not candidatos.is_empty():
			break

	if candidatos.is_empty():
		return {}

	var forged_template: Dictionary = candidatos[
		rng.randi_range(0, candidatos.size() - 1)
	].duplicate(true)

	var minimum_level: int = int(forged_template.get("min_level", 1))
	var item_level: int = maxi(
		minimum_level,
		maxi(1, nivel_objetivo + rng.randi_range(-1, 3))
	)
	var rarity_multiplier: float = float(
		MULTIPLICADORES_RAREZA.get(selected_rarity, 1.0)
	)
	var level_multiplier: float = 1.0 + float(item_level - 1) * 0.055
	var final_stats: Dictionary = {}
	var base_stats: Dictionary = forged_template.get("base_stats", {})

	for stat_name in base_stats.keys():
		var base_value: float = float(base_stats[stat_name])
		final_stats[stat_name] = maxi(
			1,
			int(round(base_value * rarity_multiplier * level_multiplier))
		)

	forged_template["rarity"] = selected_rarity
	forged_template["rareza"] = selected_rarity
	forged_template["rarity_name"] = obtener_nombre_rareza(selected_rarity)
	forged_template["rarity_color"] = obtener_color_rareza(selected_rarity).to_html()
	forged_template["item_level"] = item_level
	forged_template["stats"] = final_stats
	forged_template["quantity"] = 1
	forged_template["stackable"] = false
	forged_template["icon_path"] = str(forged_template.get("icon_path", ""))
	forged_template["source_zone"] = SistemaRegiones.normalizar_zona(zona_id)
	forged_template["region_name"] = SistemaRegiones.obtener_nombre(
		zona_id,
		TranslationServer.get_locale(),
		false
	)

	var passive_final: Dictionary = _crear_pasiva_final(
		forged_template,
		item_level,
		selected_rarity
	)
	if passive_final.is_empty():
		forged_template.erase("passive")
	else:
		forged_template["passive"] = passive_final

	forged_template["effect_description"] = construir_descripcion_efecto(forged_template)
	forged_template.erase("base_stats")
	forged_template.erase("quantity_min")
	forged_template.erase("quantity_max")
	return forged_template

static func generar_objeto_forjado(
	rareza_objetivo: String,
	nivel_objetivo: int,
	personaje_id: String = "",
	categoria_preferida: String = "",
	hueco_preferido: String = "",
	zona_id: String = ZONA_VALDORIA
) -> Dictionary:
	var rng: RandomNumberGenerator = RandomNumberGenerator.new()
	rng.randomize()

	var rarity_index: int = ORDEN_RAREZAS.find(rareza_objetivo)
	if rarity_index < 0:
		return {}

	var selected_rarity: String = ORDEN_RAREZAS[rarity_index]
	var grupo_clase: String = obtener_grupo_clase(personaje_id)
	var candidatos: Array[Dictionary] = []

	for filter_mode in [1, 2, 3]:
		candidatos.clear()

		for raw_template in OBJETOS:
			var candidate_template: Dictionary = _enriquecer_plantilla(raw_template)
			if str(candidate_template.get("rarity", RAREZA_COMUN)) != selected_rarity:
				continue
			if not _template_pertenece_a_zona(candidate_template, zona_id):
				continue

			var category: String = str(candidate_template.get("category", ""))
			var equip_slot: String = str(candidate_template.get("equip_slot", ""))

			if filter_mode == 1:
				if not categoria_preferida.is_empty() and category != categoria_preferida:
					continue
				if not hueco_preferido.is_empty() and equip_slot != hueco_preferido:
					continue
			elif filter_mode == 2:
				if not categoria_preferida.is_empty() and category != categoria_preferida:
					continue

			if category == "equipo":
				var allowed_variant: Variant = candidate_template.get("allowed_classes", [])
				if not grupo_clase.is_empty() and allowed_variant is Array:
					var allowed_classes: Array = allowed_variant
					if not allowed_classes.is_empty() and not allowed_classes.has(grupo_clase):
						continue

			candidatos.append(candidate_template)

		if not candidatos.is_empty():
			break

	if candidatos.is_empty():
		return {}

	var forged_template: Dictionary = candidatos[
		rng.randi_range(0, candidatos.size() - 1)
	].duplicate(true)

	var minimum_level: int = int(forged_template.get("min_level", 1))
	var item_level: int = maxi(
		minimum_level,
		maxi(1, nivel_objetivo + rng.randi_range(-1, 3))
	)
	var rarity_multiplier: float = float(
		MULTIPLICADORES_RAREZA.get(selected_rarity, 1.0)
	)
	var level_multiplier: float = 1.0 + float(item_level - 1) * 0.055
	var final_stats: Dictionary = {}
	var base_stats: Dictionary = forged_template.get("base_stats", {})

	for stat_name in base_stats.keys():
		var base_value: float = float(base_stats[stat_name])
		final_stats[stat_name] = maxi(
			1,
			int(round(base_value * rarity_multiplier * level_multiplier))
		)

	forged_template["rarity"] = selected_rarity
	forged_template["rareza"] = selected_rarity
	forged_template["rarity_name"] = obtener_nombre_rareza(selected_rarity)
	forged_template["rarity_color"] = obtener_color_rareza(selected_rarity).to_html()
	forged_template["item_level"] = item_level
	forged_template["stats"] = final_stats
	forged_template["quantity"] = 1
	forged_template["icon_path"] = str(forged_template.get("icon_path", ""))
	forged_template["source_zone"] = SistemaRegiones.normalizar_zona(zona_id)
	forged_template["region_name"] = SistemaRegiones.obtener_nombre(
		zona_id,
		TranslationServer.get_locale(),
		false
	)

	var passive_final: Dictionary = _crear_pasiva_final(
		forged_template,
		item_level,
		selected_rarity
	)
	if passive_final.is_empty():
		forged_template.erase("passive")
	else:
		forged_template["passive"] = passive_final

	forged_template["effect_description"] = construir_descripcion_efecto(forged_template)
	forged_template.erase("base_stats")
	forged_template.erase("quantity_min")
	forged_template.erase("quantity_max")
	return forged_template

static func obtener_objetos_especiales_zona(zona_id: String) -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	var normalized: String = SistemaRegiones.normalizar_zona(zona_id)
	for raw_template in OBJETOS:
		var template: Dictionary = raw_template
		if not bool(template.get("stage_special", false)):
			continue
		if _template_pertenece_a_zona(template, normalized, true):
			result.append(_enriquecer_plantilla(template))
	return result

static func obtener_total_objetos_especiales_zona(zona_id: String) -> int:
	return obtener_objetos_especiales_zona(zona_id).size()

static func generar_objeto_forzado(
	rareza_objetivo: String,
	nivel_objetivo: int,
	personaje_id: String = "",
	zona_id: String = ZONA_VALDORIA
) -> Dictionary:
	var rarity: String = rareza_objetivo.to_lower().strip_edges()
	if not ORDEN_RAREZAS.has(rarity):
		rarity = RAREZA_COMUN

	# Los cofres sorpresa pueden elegir un grado superior al nivel actual.
	# Se usa un nivel de generación mínimo para que siempre exista un premio
	# exacto de la rareza sorteada; el propio objeto conserva ese requisito.
	var minimum_generation_levels: Dictionary = {
		RAREZA_COMUN: 1,
		RAREZA_POCO_COMUN: 8,
		RAREZA_RARO: 18,
		RAREZA_EPICO: 28,
		RAREZA_LEGENDARIO: 42,
		RAREZA_MITICO: 55,
		RAREZA_ANCESTRAL: 68,
		RAREZA_UNICO: 75
	}
	var generation_level: int = maxi(
		maxi(1, nivel_objetivo),
		int(minimum_generation_levels.get(rarity, 1))
	)
	return generar_objeto_forjado(
		rarity,
		generation_level,
		personaje_id,
		"equipo",
		"",
		SistemaRegiones.normalizar_zona(zona_id)
	)

static func rareza_permitida_en_tienda(rareza: String) -> bool:
	return RAREZAS_PERMITIDAS_TIENDA.has(rareza.to_lower().strip_edges())

static func generar_objeto_tienda(
	rareza_objetivo: String,
	nivel_objetivo: int,
	personaje_id: String = "",
	zona_id: String = ZONA_VALDORIA
) -> Dictionary:
	var normalized_rarity: String = rareza_objetivo.to_lower().strip_edges()
	if not rareza_permitida_en_tienda(normalized_rarity):
		return {}

	return generar_objeto_forjado(
		normalized_rarity,
		maxi(1, nivel_objetivo),
		personaje_id,
		"equipo",
		"",
		SistemaRegiones.normalizar_zona(zona_id)
	)
