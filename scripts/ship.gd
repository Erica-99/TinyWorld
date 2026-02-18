extends RigidBody2D

@export var thrust: float = 1
@export var turning_torque: float = 10
@export var linear_damper_strength: float = 5
@export var angular_damper_strength: float = 5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
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


func _unhandled_input(event):
	if event.is_action_pressed("Fire Dampers"):
		linear_damp = linear_damper_strength
		angular_damp = angular_damper_strength
	elif event.is_action_released("Fire Dampers"):
		linear_damp = 0
		angular_damp = 2
