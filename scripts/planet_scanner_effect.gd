extends Node2D


@export var ship: RigidBody2D
@export var dist_from_ship: float = 50

@onready var polygon = $PlanetScannerPolygon

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if ship.landing_target == null:
		visible = false
	else:
		visible = true
		polygon.polygon = get_new_coordinates()


func get_new_coordinates() -> PackedVector2Array:
	# Point 1
	var ship_to_planet: Vector2 = (ship.landing_target.global_position - ship.global_position).normalized()
	var ship_screen_pos = ship.get_global_transform_with_canvas().get_origin()
	var point_1 = ship_screen_pos + (ship_to_planet * dist_from_ship)
	
	# Points 2 + 3
	var planet_radius = ship.landing_target.scale * 5
	var point_2_dir = ship_to_planet.rotated(PI/2)
	var point_3_dir = ship_to_planet.rotated(-PI/2)
	
	var point_2_worldspace = (point_2_dir * planet_radius) + ship.landing_target.global_position
	var point_3_worldspace = (point_3_dir * planet_radius) + ship.landing_target.global_position
	var canvas_transform: Transform2D = get_viewport().get_canvas_transform()
	var point_2: Vector2 = canvas_transform * point_2_worldspace
	var point_3: Vector2 = canvas_transform * point_3_worldspace
	
	var vec2array: Array[Vector2] = [point_1, point_2, point_3]
	return PackedVector2Array(vec2array)
