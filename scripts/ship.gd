extends RigidBody2D

signal player_ready_to_land
signal player_not_ready_to_land
signal player_landing

@export var thrust: float = 1
@export var turning_torque: float = 10
@export var linear_damper_strength: float = 5
@export var angular_damper_strength: float = 5
@export var max_range_for_landing: int = 1000

var nearby_planets: Array[Area2D] = []
var ready_to_land: bool = false
var landing_target: Area2D = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if nearby_planets.size() > 0:
		var nearest_planet = get_nearest_planet()
		if get_distance_to_planet_surface(nearest_planet) < max_range_for_landing:
			ready_to_land = true
			player_ready_to_land.emit()
		else:
			ready_to_land = false
			player_not_ready_to_land.emit()
	else:
		ready_to_land = false
		player_not_ready_to_land.emit()


func _physics_process(delta: float) -> void:
	if landing_target != null:
		landing_mode(landing_target)
	else:
		process_movement_input(delta)


## Processes input and moves the ship
func process_movement_input(delta: float) -> void:
	var thrust_input := Input.get_axis("Reverse", "Forward")
	var rotation_input := Input.get_axis("Left", "Right")
	
	var facing = Vector2(cos(rotation-PI/2), sin(rotation-PI/2)) # Rotated to use up as forward
	var movement_force = facing.normalized() * thrust * thrust_input
	
	var rotation_torque = turning_torque * rotation_input
	
	apply_central_force(movement_force)
	apply_torque(rotation_torque)


func landing_mode(target: Area2D) -> void:
	var target_angle = global_position.angle_to_point(target.global_position)
	var angle_diff = wrapf(target_angle - rotation - PI/2, -PI, PI)
	apply_torque(angle_diff * 5000)
	
	


func _unhandled_input(event):
	if event.is_action_pressed("Fire Dampers"):
		linear_damp = linear_damper_strength
		angular_damp = angular_damper_strength
		
	if event.is_action_released("Fire Dampers"):
		linear_damp = 0
		angular_damp = 2
	
	if event.is_action_pressed("Landing Mode"):
		if ready_to_land == true and landing_target == null:
			landing_target = get_nearest_planet()
		elif ready_to_land == true and landing_target != null:
			player_landing.emit()


func add_near_planet(planet: Area2D) -> void:
	nearby_planets.append(planet)

func remove_near_planet(planet: Area2D) -> void:
	if planet in nearby_planets:
		nearby_planets.erase(planet)
	if landing_target == planet:
		landing_target = null

func get_nearest_planet() -> Area2D:
	var min_dist = INF
	var target: Area2D
	for planet in nearby_planets:
		var dist = get_distance_to_planet_surface(planet)
		if dist < min_dist:
			min_dist = dist
			target = planet
	return target


func get_distance_to_planet_surface(planet: Area2D) -> float:
	return (global_position - planet.global_position).length() - (planet.scale.x*5)
