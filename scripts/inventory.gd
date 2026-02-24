extends Node2D

@export var max_carbon: int = 500
@export var max_surges: int = 5
@export var minerals_per_surge: int = 100

@export var carbon_stores: int = 0:
	set(value):
		carbon_stores = clampi(value, 0, max_carbon)
@export var biomass_stores: int = 0
@export var mineral_stores: int = 0:
	set(value):
		mineral_stores = clampi(value, 0, max_surges * minerals_per_surge)
@export var nanotech_stores: int = 0

var ready_surges: int:
	get():
		return int(mineral_stores/minerals_per_surge)


func use_surge() -> void:
	mineral_stores -= minerals_per_surge
	mineral_stores = clampi(mineral_stores, 0, max_surges * minerals_per_surge)
