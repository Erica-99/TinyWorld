extends Node2D


@export var planetcount = 1000
@export var min_planet_size: float = 100
@export var max_planet_size: float = 200

@onready var planet = preload("res://scenes/planetBox.tscn")
@onready var planetlist = $Planets
@onready var SpaceChecker = $SpaceChecker
@onready var starmap = $"."

func _ready() -> void:
	generatemap()

func wipemap():
	for child in planetlist.get_children():
		child.queue_free()

func generatemap():
	wipemap()
	for i in range(planetcount):
		createplanet()

func createplanet():
	var newPlanet = planet.instantiate()
	var angle := randf_range(0, TAU)
	var distance: float = randf_range(2000,20000)
	var random_offset: Vector2 = Vector2.RIGHT.rotated(angle) * distance
	
	var size := randf_range(min_planet_size, max_planet_size)
	
	SpaceChecker.position = starmap.position + random_offset
	SpaceChecker.scale = Vector2(size/20, size/20)
	SpaceChecker.force_shapecast_update()
	if SpaceChecker.is_colliding() == false:
		newPlanet.position = self.position + random_offset
		planetlist.add_child(newPlanet)
		newPlanet.call("setup_planet", ENUMS.PlanetType.HEALTHY, size)
