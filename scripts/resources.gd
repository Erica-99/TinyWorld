extends MarginContainer

@export var ship = RigidBody2D

@onready var carbonHUD = $HBoxContainer/VBoxContainer/Carbon
@onready var BiomassHUD = $HBoxContainer/VBoxContainer/Biomass
@onready var MineralHUD = $HBoxContainer/VBoxContainer/Minerals
@onready var SurgeHUD = $HBoxContainer/Surgecounter
@onready var inventory = ship.inventory

var SurgeReadyMat = Color(0.0, 1.0, 0.0, 1.0)
var SurgeUsedMat = Color(1.0, 0.0, 0.0, 1.0)

func _process(delta: float) -> void:
	carbonHUD.max_value = inventory.max_carbon
	carbonHUD.value = inventory.carbon_stores
	BiomassHUD.value = inventory.biomass_stores
	
	for child in SurgeHUD.get_children():
		var nodename = str(child.get_name())
		var nodenumber = nodename.to_int()
		if nodenumber <= inventory.max_surges:
			child.visible = true
			if nodenumber <= inventory.ready_surges:
				child.modulate = SurgeReadyMat
			else:
				child.modulate = SurgeUsedMat
		else:
			child.visible = false
