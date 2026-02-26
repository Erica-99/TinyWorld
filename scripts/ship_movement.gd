extends Node2D

@export var thrust: float = 400
@export var turning_torque: float = 10
@export var linear_damper_strength: float = 5
@export var angular_damper_strength: float = 5
@export var surge_strength: float = 2000

var ready_to_land: bool = false

var actor: RigidBody2D
var surge_status: ENUMS.SurgeStatus = ENUMS.SurgeStatus.NONE

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	actor = get_parent()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if surge_status == ENUMS.SurgeStatus.NONE:
		if actor.linear_velocity.length() < 100:
			actor.sprites.play("Idle")
		else:
			actor.sprites.play("Flying")
		
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
	match surge_status:
		ENUMS.SurgeStatus.NONE:
			process_movement(delta)
		ENUMS.SurgeStatus.AIMING:
			aim_surge()
		ENUMS.SurgeStatus.FLYING:
			cruise_surge()


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
	var mouse_pos = get_global_mouse_position()
	var target_angle = actor.global_position.angle_to_point(mouse_pos)
	var angle_diff = wrapf(target_angle - actor.rotation + PI/2, -PI, PI)
	actor.apply_torque(angle_diff * 200000)

func fire_surge() -> void:
	# Code to fire impulse
	actor.linear_damp = 2
	actor.angular_damp = 10
	
	actor.sprites.play("Idle")
	actor.surge_collider.set_deferred("disabled", false)
	
	var surge_direction_vector = (get_global_mouse_position() - actor.global_position).normalized()
	actor.apply_impulse(surge_direction_vector * surge_strength, Vector2.ZERO)
	
	actor.inventory.use_surge()
	surge_status = ENUMS.SurgeStatus.FLYING

func cruise_surge() -> void:
	# Lock up input for a second or so after surging or until you hit something
	if actor.linear_velocity.length() < 300:
		return_to_no_surge()


func set_surge_aiming() -> void:
	actor.linear_damp = 10
	actor.angular_damp = 10
	
	actor.sprites.play("ChargingSurge")
	
	surge_status = ENUMS.SurgeStatus.AIMING


func return_to_no_surge() -> void:
	actor.linear_damp = 0
	actor.angular_damp = 2
	
	actor.sprites.play("Flying")
	actor.surge_collider.set_deferred("disabled", true)
	
	surge_status = ENUMS.SurgeStatus.NONE


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
		if actor.inventory.ready_surges:
			set_surge_aiming()
		
	if event.is_action_released("Surge"):
		if surge_status == ENUMS.SurgeStatus.AIMING:
			fire_surge()


func _on_surge_area_area_entered(area: Area2D) -> void:
	actor.set_deferred("linear_velocity", actor.linear_velocity/10)
	return_to_no_surge()
