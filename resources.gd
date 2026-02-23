extends MarginContainer

@export var ship = RigidBody2D

@onready var carbonHUD = $VBoxContainer/Carbon
@onready var BiomassHUD = $VBoxContainer/Biomass
@onready var MineralHUD = $VBoxContainer/Minerals


func _process(delta: float) -> void:
	var inventory = ship.inventory
	carbonHUD.max_value = inventory.max_carbon
	carbonHUD.value = inventory.carbon_stores
	
	BiomassHUD.value = inventory.biomass_stores
	
