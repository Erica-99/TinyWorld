extends Node2D

@export var max_carbon: int = 500
@export var max_mineral: int = 500

@export var carbon_stores: int = 0:
	set(value):
		carbon_stores = clampi(value, 0, max_carbon)
@export var biomass_stores: int = 0
@export var mineral_stores: int = 0:
	set(value):
		mineral_stores = clampi(value, 0, max_mineral)
@export var nanotech_stores: int = 0
