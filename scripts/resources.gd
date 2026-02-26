extends MarginContainer

@export var ship = RigidBody2D

@onready var carbonHUD = $VBoxContainer/Carbon
@onready var BiomassHUD = $VBoxContainer/Biomass
@onready var SurgeHUD = $VBoxContainer/Surgecounter
@onready var inventory = ship.inventory


@onready var nanotechIcon = $VBoxContainer/Carbon/MarginContainer/AnimatedSprite2D2
@onready var Biomasslabel = $VBoxContainer/Biomass/MarginContainer/HBoxContainer/biomasstext
@onready var Carbonlabel = $VBoxContainer/Carbon/MarginContainer/HBoxContainer/carbontext

var SurgeReadyMat = Color(0.0, 1.0, 0.0, 1.0)
var SurgeUsedMat = Color(1.0, 0.0, 0.0, 1.0)

func _process(delta: float) -> void:
	carbonHUD.max_value = inventory.max_carbon
	carbonHUD.value = inventory.carbon_stores

	
	Biomasslabel.text = 'Biomass: ' +str(inventory.biomass_stores)
	Carbonlabel.text = 'Carbon ' +str(inventory.carbon_stores) + ' / ' + str(inventory.max_carbon)
	if inventory.nanotech_stores != 0:
		nanotechIcon.visible = true
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
