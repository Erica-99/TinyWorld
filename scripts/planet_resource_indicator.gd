extends Control

@onready var carbon_items: Array[Control] = [$"PlanetResourcePanel/GridContainer/CarbonText", $"PlanetResourcePanel/GridContainer/CarbonAmount"]
@onready var biomass_items: Array[Control] = [$"PlanetResourcePanel/GridContainer/BiomassText", $"PlanetResourcePanel/GridContainer/BiomassAmount"]
@onready var mineral_items: Array[Control] = [$"PlanetResourcePanel/GridContainer/MineralsText", $"PlanetResourcePanel/GridContainer/MineralsAmount"]
@onready var nanotech_items: Array[Control] = [$"PlanetResourcePanel/GridContainer/NanotechText", $"PlanetResourcePanel/GridContainer/NanotechAmount"]

@export var ship: RigidBody2D
@export var distance_from_ship: float = 100

var last_set_planet: Area2D

func _process(delta: float) -> void:
	if ship.landing_target == null:
		visible = false
	else:
		visible = true
		if last_set_planet != ship.landing_target:
			last_set_planet = ship.landing_target
			set_visible_resources(last_set_planet.carbon, last_set_planet.biomass, last_set_planet.minerals, last_set_planet.nanotech)
		
		update_values(last_set_planet.carbon, last_set_planet.biomass, last_set_planet.minerals, last_set_planet.nanotech)
		
		var vector_away_from_planet: Vector2 = (ship.global_position - ship.landing_target.global_position)
		var flattened_vector := Vector2(vector_away_from_planet.x, 0).normalized()
		var ship_screen_pos: Vector2 = ship.get_global_transform_with_canvas().get_origin()
		var new_position = ship_screen_pos + (flattened_vector * distance_from_ship)
		position = new_position


func set_visible_resources(carbon: int, biomass: int, mineral: int, nanotech: int) -> void:
	if carbon:
		for e in carbon_items:
			e.visible = true
	else:
		for e in carbon_items:
			e.visible = false
	
	if biomass:
		for e in biomass_items:
			e.visible = true
	else:
		for e in biomass_items:
			e.visible = false
	
	if mineral:
		for e in mineral_items:
			e.visible = true
	else:
		for e in mineral_items:
			e.visible = false
	
	if nanotech:
		for e in nanotech_items:
			e.visible = true
	else:
		for e in nanotech_items:
			e.visible = false
	
	$PlanetResourcePanel.reset_size()


func update_values(carbon: int, biomass: int, mineral: int, nanotech: int) -> void:
	carbon_items[1].text = str(carbon)
	biomass_items[1].text = str(biomass)
	mineral_items[1].text = str(mineral)
	nanotech_items[1].text = str(nanotech)


func _on_ship_player_died() -> void:
	visible = false
	process_mode = Node.PROCESS_MODE_DISABLED
