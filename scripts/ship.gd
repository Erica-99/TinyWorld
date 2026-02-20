extends RigidBody2D

signal player_mode_changed(new_mode: ENUMS.PlayerMovementMode, previous_mode: ENUMS.PlayerMovementMode)

@export var max_range_for_landing: int = 1000
@export var max_velocity_for_landing: float = 1000

var nearby_planets: Array[Area2D] = []
var landing_target: Area2D = null

var movement_mode := ENUMS.PlayerMovementMode.DEFAULT


func _ready() -> void:
	enter_default_mode()


func add_near_planet(planet: Area2D) -> void:
	nearby_planets.append(planet)


func remove_near_planet(planet: Area2D) -> void:
	if planet in nearby_planets:
		nearby_planets.erase(planet)
	if landing_target == planet:
		enter_default_mode()


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


func set_ready_to_land():
	if movement_mode != ENUMS.PlayerMovementMode.READY_TO_LAND:
		player_mode_changed.emit(ENUMS.PlayerMovementMode.READY_TO_LAND, movement_mode)
		movement_mode = ENUMS.PlayerMovementMode.READY_TO_LAND
		swap_to_node(movement_mode)


func enter_landing_mode() -> void:
	if not movement_mode == ENUMS.PlayerMovementMode.READY_TO_LAND:
		return
	linear_damp = 3
	angular_damp = 1.5
	landing_target = get_nearest_planet()
	landing_target.call("ignore_gravity_for_object", self)
	player_mode_changed.emit(ENUMS.PlayerMovementMode.LANDING, movement_mode)
	movement_mode = ENUMS.PlayerMovementMode.LANDING
	swap_to_node(movement_mode)


func enter_default_mode() -> void:
	if not movement_mode == ENUMS.PlayerMovementMode.DEFAULT:
		linear_damp = 0
		angular_damp = 2
		if landing_target != null:
			landing_target.call("return_gravity_for_object", self)
			landing_target = null
		player_mode_changed.emit(ENUMS.PlayerMovementMode.DEFAULT, movement_mode)
		movement_mode = ENUMS.PlayerMovementMode.DEFAULT
		swap_to_node(movement_mode)


func swap_to_node(new_mode: ENUMS.PlayerMovementMode) -> void:
	match new_mode:
		ENUMS.PlayerMovementMode.DEFAULT:
			$MovementManager.process_mode = Node.PROCESS_MODE_INHERIT
			$LandingManager.process_mode = Node.PROCESS_MODE_DISABLED
			$EatingManager.process_mode = Node.PROCESS_MODE_DISABLED
		ENUMS.PlayerMovementMode.READY_TO_LAND:
			$MovementManager.process_mode = Node.PROCESS_MODE_INHERIT
			$LandingManager.process_mode = Node.PROCESS_MODE_DISABLED
			$EatingManager.process_mode = Node.PROCESS_MODE_DISABLED
		ENUMS.PlayerMovementMode.LANDING:
			$MovementManager.process_mode = Node.PROCESS_MODE_DISABLED
			$LandingManager.process_mode = Node.PROCESS_MODE_INHERIT
			$EatingManager.process_mode = Node.PROCESS_MODE_DISABLED
		ENUMS.PlayerMovementMode.LATCHED:
			$MovementManager.process_mode = Node.PROCESS_MODE_DISABLED
			$LandingManager.process_mode = Node.PROCESS_MODE_DISABLED
			$EatingManager.process_mode = Node.PROCESS_MODE_INHERIT

## One-off inputs (dampers, landing mode)
func _unhandled_input(event):
	if movement_mode == ENUMS.PlayerMovementMode.READY_TO_LAND:
		if event.is_action_pressed("Landing Mode"):
			enter_landing_mode()
			
	elif movement_mode == ENUMS.PlayerMovementMode.LANDING:
		if event.is_action_pressed("Landing Mode"):
			enter_default_mode()
