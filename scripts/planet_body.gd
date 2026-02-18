extends RigidBody2D

@export var biome: ENUMS.PlanetType
@export var size: float = 1
@export var health: int = 10

@export_group("Resources")
@export var biomass: int = 1
@export var carbon: int = 1
@export var minerals: int = 1


func set_biome_and_generate_stats(set_biome: ENUMS.PlanetType):
	biome = set_biome
	
	# Generate stats based on biome
	pass
