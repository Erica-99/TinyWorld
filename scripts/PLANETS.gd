extends Object
class_name PLANETS

static func get_settings(biome: ENUMS.PlanetType) -> PlanetSettings:
	var gravity_modifier: float
	var test_color: Color
	var health: int
	var carbon_density: int
	var biomass_density: int
	var mineral_density: int
	
	match biome:
		ENUMS.PlanetType.METEOR:
			gravity_modifier = 0
			test_color = Color(0.259, 0.259, 0.259, 1.0)
			health = 10
			carbon_density = 3
			biomass_density = 0
			mineral_density = 0
		ENUMS.PlanetType.BARREN:
			gravity_modifier = 1
			test_color = Color(0.435, 0.35, 0.169, 1.0)
			health = 10
			carbon_density = 1
			biomass_density = 0
			mineral_density = 3
		ENUMS.PlanetType.HEALTHY:
			gravity_modifier = 1
			test_color = Color(0.28, 0.436, 0.19, 1.0)
			health = 10
			carbon_density = 1
			biomass_density = 4
			mineral_density = 1
		ENUMS.PlanetType.ECUMENOPOLIS:
			gravity_modifier = 1
			test_color = Color(0.147, 0.2, 0.447, 1.0)
			health = 10
			carbon_density = 5
			biomass_density = 2
			mineral_density = 1
	
	var settings := PlanetSettings.new()
	settings.gravity_modifier = gravity_modifier
	settings.test_color = test_color
	settings.health = health
	settings.carbon_density = carbon_density
	settings.biomass_density = biomass_density
	settings.mineral_density = mineral_density
	
	return settings

static func get_size(biome: ENUMS.PlanetType) -> float:
	var size: float
	
	match biome:
		ENUMS.PlanetType.METEOR:
			var average_size = 25
			var standard_deviation = 5
			size = randfn(average_size, standard_deviation)
		ENUMS.PlanetType.BARREN:
			var average_size = 200
			var standard_deviation = 30
			size = randfn(average_size, standard_deviation)
		ENUMS.PlanetType.HEALTHY:
			var average_size = 280
			var standard_deviation = 40
			size = randfn(average_size, standard_deviation)
		ENUMS.PlanetType.ECUMENOPOLIS:
			var average_size = 370
			var standard_deviation = 30
			size = randfn(average_size, standard_deviation)
	
	return size

static func get_dist_range(biome: ENUMS.PlanetType) -> Vector2:
	var min_dist: float
	var max_dist: float
	
	match biome:
		ENUMS.PlanetType.METEOR:
			min_dist = 0
			max_dist = 1
		ENUMS.PlanetType.BARREN:
			min_dist = 0.1
			max_dist = 0.7
		ENUMS.PlanetType.HEALTHY:
			min_dist = 0.4
			max_dist = 1
		ENUMS.PlanetType.ECUMENOPOLIS:
			min_dist = 0.7
			max_dist = 1
	
	return Vector2(min_dist, max_dist)
	
