extends Node2D

@export var max_carbon: int = 100

@export var carbon_stores: int = 0:
	set(value):
		carbon_stores = clampi(value, 0, max_carbon)
@export var biomass_stores: int = 0
@export var mineral_stores: int = 0
@export var nanotech_stores: int = 0
