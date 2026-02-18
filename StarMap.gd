extends Node2D



@onready var planet = preload("res://planetBox.tscn")
@onready var planetlist = $Planets
@onready var SpaceChecker = $SpaceChecker
@export var planetcount = 1000
var Spacefree = true

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

	Spacefree = true
	var newPlanet = planet.instantiate()
	var angle := randf_range(0, TAU)
	var distance: float = randf_range(10,1000)
	var random_offset: Vector2 = Vector2.RIGHT.rotated(angle) * distance
	checkspace(random_offset)
	if Spacefree == true:
		newPlanet.position = self.position + random_offset
		planetlist.add_child(newPlanet)
	pass


func _on_space_checker_area_entered(area: Area2D) -> void:
	print('Entered!')
	Spacefree = false
	pass # Replace with function body.
