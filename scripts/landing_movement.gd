extends Node2D


@export var thrust: float = 400
@export var landing_thruster_strength: float = 100

var actor: RigidBody2D

func _ready() -> void:
	actor = get_parent()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Check if there are any nearby planets
	if actor.landing_target == null:
		actor.enter_default_mode()
	elif (actor.get_distance_to_planet_surface(actor.landing_target) > actor.max_range_for_landing
	or actor.linear_velocity.length() > actor.max_velocity_for_landing):
		actor.enter_default_mode()


func _physics_process(delta: float) -> void:
	if actor.landing_target != null:
		process_landing_mode_movement(actor.landing_target)


## Processes input and moves the ship in landing mode
func process_landing_mode_movement(target: Area2D) -> void:
	# Straightening
	var target_angle = actor.global_position.angle_to_point(target.global_position)
	var angle_diff = wrapf(target_angle - actor.rotation - PI/2, -PI, PI)
	actor.apply_torque(angle_diff * 5000)
	
	# Input detection
	var thrust_input := Input.is_action_pressed("Forward")
	var side_movement_input := Input.get_axis("Left", "Right")
	
	# Allow thrusting off the planet
	if thrust_input:
		var facing = Vector2(cos(actor.rotation-PI/2), sin(actor.rotation-PI/2)) # Rotated to use up as forward
		var forward_force = facing.normalized() * thrust
		actor.apply_central_force(forward_force)
	
	# Left/right movement
	var right_facing = Vector2(cos(actor.rotation), sin(actor.rotation))
	var movement_force = right_facing.normalized() * landing_thruster_strength * side_movement_input
	actor.apply_central_force(movement_force)
	
	# Fall to planet gently
	var force_direction = (target.global_position - actor.global_position).normalized()
	var force_amount = actor.get_distance_to_planet_surface(target) * 2
	var total_falling_force = force_direction * force_amount
	actor.apply_central_force(total_falling_force)


func _on_eating_zone_body_entered(body: Node2D) -> void:
	if (actor.landing_target != null) and actor.landing_target == body.get_parent():
		actor.enter_eating_mode()
