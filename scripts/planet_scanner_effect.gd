extends Node2D


@export var ship: RigidBody2D
@export var dist_from_ship: float = 50

@onready var polygon = $PlanetScannerPolygon

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (ship.landing_target == null or ship.movement_mode == ENUMS.PlayerMovementMode.LANDING 
	or ship.movement_mode == ENUMS.PlayerMovementMode.EATING):
		visible = false
	elif ship.get_distance_to_planet_surface(ship.landing_target) > dist_from_ship:
		visible = true
		polygon.polygon = get_new_coordinates()


func get_new_coordinates() -> PackedVector2Array:
	# Point 1
	var ship_to_planet: Vector2 = (ship.landing_target.global_position - ship.global_position).normalized()
	var point_1_worldspace = ship.global_position + (ship_to_planet*dist_from_ship)
	
	# Points 2 + 3
	var px = point_1_worldspace.x
	var py = point_1_worldspace.y
	var cx = ship.landing_target.global_position.x
	var cy = ship.landing_target.global_position.y
	var a = ship.landing_target.scale.x * 5
	
	var b = sqrt((px - cx)**2 + (py - cy)**2)
	var th = acos(a/b)
	var d = atan2(py - cy, px - cx)
	var d1 = d + th # Direction of angle of point T1 from C
	var d2 = d - th # Direction of angle of point T2 from C
	
	var T1x = cx + a * cos(d1)
	var T1y = cy + a * sin(d1)
	var T2x = cx + a * cos(d2)
	var T2y = cy + a * sin(d2)
	
	var point_2_worldspace := Vector2(T1x, T1y)
	var point_3_worldspace := Vector2(T2x, T2y)
	
	var vec2array: Array[Vector2] = [point_1_worldspace, point_2_worldspace, point_3_worldspace]
	return PackedVector2Array(vec2array)
