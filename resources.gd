extends MarginContainer

@export var ship = RigidBody2D

@onready var carbonHUD = $HBoxContainer/VBoxContainer/Carbon
@onready var BiomassHUD = $HBoxContainer/VBoxContainer/Biomass
@onready var MineralHUD = $HBoxContainer/VBoxContainer/Minerals


func _process(delta: float) -> void:
	var inventory = ship.inventory
	carbonHUD.max_value = inventory.max_carbon
	carbonHUD.value = inventory.carbon_stores
	
	BiomassHUD.value = inventory.biomass_stores
	
