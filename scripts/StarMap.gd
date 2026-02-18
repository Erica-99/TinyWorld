extends Node2D



@onready var planet = preload("res://scenes/planetBox.tscn")
@onready var planetlist = $Planets
@onready var SpaceChecker = $SpaceChecker
@export var planetcount = 1000
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

func checkspace(OffsetPosition):
	SpaceChecker.position = self.position + OffsetPosition


func createplanet():

	var newPlanet = planet.instantiate()
	var angle := randf_range(0, TAU)
	var distance: float = randf_range(2000,20000)
	var random_offset: Vector2 = Vector2.RIGHT.rotated(angle) * distance
	SpaceChecker.position = starmap.position + random_offset
	SpaceChecker.force_shapecast_update()
	if SpaceChecker.is_colliding() == false:
		newPlanet.position = self.position + random_offset
		planetlist.add_child(newPlanet)
	pass
