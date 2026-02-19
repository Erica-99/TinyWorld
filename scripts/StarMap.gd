extends Node2D

@export var max_distance: float = 20000

@export_category("Planet Counts")
@export var max_cities: int = 10
@export var max_healthy: int = 80
@export var max_barren: int = 100
@export var max_meteor: int = 1000

@onready var planet = preload("res://scenes/planetBox.tscn")
@onready var planetlist = $Planets
@onready var SpaceChecker = $SpaceChecker

func _ready() -> void:
	generatemap()


func wipemap():
	for child in planetlist.get_children():
		child.queue_free()


func generatemap():
	wipemap()
	for i in range(max_cities):
		createplanet(ENUMS.PlanetType.ECUMENOPOLIS)
	for i in range(max_healthy):
		createplanet(ENUMS.PlanetType.HEALTHY)
	for i in range(max_barren):
		createplanet(ENUMS.PlanetType.BARREN)
	for i in range(max_meteor):
		createplanet(ENUMS.PlanetType.METEOR)


func createplanet(biome: ENUMS.PlanetType):
	var newPlanet = planet.instantiate()
	var size := PLANETS.get_size(biome)
	
	var check_size = size
	if biome == ENUMS.PlanetType.METEOR:
		check_size = check_size * 2
	
	var location := get_location(check_size, biome)
	if location[1]:
		newPlanet.global_position = location[0]
		planetlist.add_child(newPlanet)
		newPlanet.call("setup_planet", biome, size)


func get_location(size: float, biome: ENUMS.PlanetType) -> Array:
	var location_found := false
	var iterations = 0
	
	while (not location_found) and iterations < 10:
		iterations += 1
		var angle := randf_range(0, TAU)
		var dist_range = PLANETS.get_dist_range(biome)
		var distance := randf_range(dist_range.x * max_distance, dist_range.y * max_distance)
		var random_offset: Vector2 = Vector2.RIGHT.rotated(angle) * distance
		
		SpaceChecker.global_position = random_offset
		SpaceChecker.scale = Vector2(size/20, size/20)
		SpaceChecker.force_shapecast_update()
		if not SpaceChecker.is_colliding():
			location_found = true
	
	return [SpaceChecker.position, location_found]
