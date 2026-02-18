extends Area2D

@export var gravity_strength: float = 1000
var captured_objects: Array[RigidBody2D] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setup_planet(ENUMS.PlanetType.METEOR,30)
	pass
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
	for rb in captured_objects:
		var gravity_vector = global_position - rb.global_position
		var force_direction = gravity_vector.normalized()
		var distance = gravity_vector.length()
		var effectiveness = gravity_strength/((distance/100)**2) # Inverse square law
		rb.apply_central_force(force_direction * effectiveness)
		
		var target_angle = rb.global_position.angle_to_point(global_position)
		var angle_diff = wrapf(target_angle - rb.rotation - PI/2, -PI, PI)
		rb.apply_torque(angle_diff * 50 * effectiveness)


func _on_body_entered(body: Node2D) -> void:
	if body is RigidBody2D:
		captured_objects.append(body as RigidBody2D)


func _on_body_exited(body: Node2D) -> void:
	if body in captured_objects:
		captured_objects.erase(body)


func setup_planet(biome: ENUMS.PlanetType, size: float) -> void:
	scale = Vector2(size, size)
	gravity_strength = size * 100
	rotation = randf_range(0, 2*PI)
	$PlanetBody.size = size
	$PlanetBody.set_biome_and_generate_stats(biome)
