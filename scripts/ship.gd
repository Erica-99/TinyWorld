extends RigidBody2D

signal player_ready_to_land
signal player_not_ready_to_land
signal player_landing

@export var thrust: float = 1
@export var turning_torque: float = 10
@export var linear_damper_strength: float = 5
@export var angular_damper_strength: float = 5
@export var max_range_for_landing: int = 1000
@export var landing_thruster_strength: float = 100
@export var max_velocity_for_landing: float = 100

var nearby_planets: Array[Area2D] = []
var ready_to_land: bool = false
var landing_target: Area2D = null
var in_landing_mode: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Check if there are any nearby planets
	if nearby_planets.size() > 0:
		# Check if conditions met to ready landing
		var nearest_planet = get_nearest_planet()
		if get_distance_to_planet_surface(nearest_planet) < max_range_for_landing and linear_velocity.length() < max_velocity_for_landing:
			if not ready_to_land:
				ready_to_land = true
				player_ready_to_land.emit()
		else:
			if ready_to_land:
				ready_to_land = false
				if in_landing_mode:
					clear_landing_mode()
				player_not_ready_to_land.emit()
	else:
		if ready_to_land:
			ready_to_land = false
			player_not_ready_to_land.emit()


func _physics_process(delta: float) -> void:
	if in_landing_mode:
		process_landing_mode_movement(landing_target)
	else:
		process_movement(delta)


## Processes input and moves the ship in normal mode
func process_movement(delta: float) -> void:
	var thrust_input := Input.get_axis("Reverse", "Forward")
	var rotation_input := Input.get_axis("Left", "Right")
	
	var facing = Vector2(cos(rotation-PI/2), sin(rotation-PI/2)) # Rotated to use up as forward
	var movement_force = facing.normalized() * thrust * thrust_input
	
	var rotation_torque = turning_torque * rotation_input
	
	apply_central_force(movement_force)
	apply_torque(rotation_torque)

## Processes input and moves the ship in landing mode
func process_landing_mode_movement(target: Area2D) -> void:
	# Straightening
	var target_angle = global_position.angle_to_point(target.global_position)
	var angle_diff = wrapf(target_angle - rotation - PI/2, -PI, PI)
	apply_torque(angle_diff * 5000)
	
	# Input detection
	var thrust_input := Input.is_action_pressed("Forward")
	var side_movement_input := Input.get_axis("Left", "Right")
	
	# Allow thrusting off the planet
	if thrust_input:
		var facing = Vector2(cos(rotation-PI/2), sin(rotation-PI/2)) # Rotated to use up as forward
		var forward_force = facing.normalized() * thrust
		apply_central_force(forward_force)
	
	# Left/right movement
	var right_facing = Vector2(cos(rotation), sin(rotation))
	var movement_force = right_facing.normalized() * landing_thruster_strength * side_movement_input
	apply_central_force(movement_force)
	
	# Fall to planet gently
	var force_direction = (target.global_position - global_position).normalized()
	var force_amount = get_distance_to_planet_surface(target) * 2
	var total_falling_force = force_direction * force_amount
	apply_central_force(total_falling_force)

## One-off inputs (dampers, landing mode)
func _unhandled_input(event):
	if not in_landing_mode:
		if event.is_action_pressed("Fire Dampers"):
			linear_damp = linear_damper_strength
			angular_damp = angular_damper_strength
			
		if event.is_action_released("Fire Dampers"):
			linear_damp = 0
			angular_damp = 2
			
		if event.is_action_pressed("Landing Mode"):
			if ready_to_land:
				landing_target = get_nearest_planet()
				prepare_landing_mode()
			
	elif in_landing_mode:
		if event.is_action_pressed("Landing Mode"):
			if ready_to_land:
				player_ready_to_land.emit()
				clear_landing_mode()


func add_near_planet(planet: Area2D) -> void:
	nearby_planets.append(planet)

func remove_near_planet(planet: Area2D) -> void:
	if planet in nearby_planets:
		nearby_planets.erase(planet)
	if landing_target == planet:
		clear_landing_mode()


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


func prepare_landing_mode() -> void:
	linear_damp = 3
	angular_damp = 2
	player_landing.emit()
	landing_target.call("ignore_gravity_for_object", self)
	in_landing_mode = true


func clear_landing_mode() -> void:
	linear_damp = 0
	angular_damp = 2
	landing_target.call("return_gravity_for_object", self)
	landing_target = null
	in_landing_mode = false
	
