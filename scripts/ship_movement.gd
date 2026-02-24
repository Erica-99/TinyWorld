extends Node2D

@export var thrust: float = 400
@export var turning_torque: float = 10
@export var linear_damper_strength: float = 5
@export var angular_damper_strength: float = 5

var ready_to_land: bool = false

var actor: RigidBody2D
var surge_status: ENUMS.SurgeStatus = ENUMS.SurgeStatus.NONE

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	actor = get_parent()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Check if there are any nearby planets
	if actor.nearby_planets.size() > 0:
		# Check if conditions met to ready landing
		var nearest_planet = actor.get_nearest_planet()
		if (actor.get_distance_to_planet_surface(nearest_planet) < actor.max_range_for_landing
		and actor.linear_velocity.length() < actor.max_velocity_for_landing):
			actor.set_ready_to_land()
		else:
			actor.enter_default_mode()
	else:
		actor.enter_default_mode()


func _physics_process(delta: float) -> void:
	match actor.movement_mode:
		ENUMS.PlayerMovementMode.DEFAULT:
			process_movement(delta)
		ENUMS.PlayerMovementMode.READY_TO_LAND:
			process_movement(delta)
			


## Processes input and moves the ship in normal mode
func process_movement(delta: float) -> void:
	var thrust_input := Input.get_axis("Reverse", "Forward")
	var rotation_input := Input.get_axis("Left", "Right")
	
	var facing = Vector2(cos(actor.rotation-PI/2), sin(actor.rotation-PI/2)) # Rotated to use up as forward
	var movement_force = facing.normalized() * thrust * thrust_input
	
	var rotation_torque = turning_torque * rotation_input
	
	actor.apply_central_force(movement_force)
	actor.apply_torque(rotation_torque)


func aim_surge() -> void:
	pass

func fire_surge() -> void:
	pass

func cruise_surge() -> void:
	pass


## One-off inputs (dampers, landing mode)
func _unhandled_input(event):
	if event.is_action_pressed("Fire Dampers"):
		if surge_status == ENUMS.SurgeStatus.NONE:
			actor.linear_damp = linear_damper_strength
			actor.angular_damp = angular_damper_strength
		
	if event.is_action_released("Fire Dampers"):
		if surge_status == ENUMS.SurgeStatus.NONE:
			actor.linear_damp = 0
			actor.angular_damp = 2
	
	if event.is_action_pressed("Surge"):
		# Check if surges are available
		surge_status = ENUMS.SurgeStatus.AIMING
		
		
	if event.is_action_pressed("Surge"):
		if surge_status == ENUMS.SurgeStatus.AIMING:
			fire_surge()
