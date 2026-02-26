extends Area2D

@export var biome: ENUMS.PlanetType
@export var size: float = 100
@export var health: int = 10
@export var gravity_strength: float = 1000

@export_group("Resources")
@export var biomass: int = 1
@export var carbon: int = 1
@export var minerals: int = 1
@export var nanotech: int = 0

@onready var planet_sprite = $AnimatedSprite2D
@onready var explode_VFX = preload("res://scenes/PlanetExplosion.tscn")


var total_resource_quantity: int
var remaining_resource_quantity: int:
	set(value):
		remaining_resource_quantity = clampi(value, 0, total_resource_quantity)
		if remaining_resource_quantity <= 0:
			destroy_planet()

var captured_objects: Array[RigidBody2D] = []
var gravity_ignore_list: Array[RigidBody2D] = []

var onscreen: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:

	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:

	pass


@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void:
	for rb in captured_objects:
		if rb not in gravity_ignore_list:
			var gravity_vector = global_position - rb.global_position
			var force_direction = gravity_vector.normalized()
			var distance = gravity_vector.length()
			var effectiveness = gravity_strength/((distance/100)**2) # Inverse square law
			rb.apply_central_force(force_direction * effectiveness)


func _on_body_entered(body: Node2D) -> void:
	if body is RigidBody2D:
		captured_objects.append(body as RigidBody2D)
		body.call("add_near_planet", self)


func _on_body_exited(body: Node2D) -> void:
	if body in captured_objects:
		captured_objects.erase(body)
		body.call("remove_near_planet", self)
		if body in gravity_ignore_list:
			gravity_ignore_list.erase(body)


# Cleanup incase planet is destroyed.
func _exit_tree() -> void:
	for body in captured_objects:
		body.call("remove_near_planet", self)


func setup_planet(set_biome: ENUMS.PlanetType, set_size: float) -> void:
	size = set_size
	biome = set_biome
	scale = Vector2(size, size)
	
	var settings = PLANETS.get_settings(biome)
	$MeshInstance2D.modulate = settings.test_color
	if biome == ENUMS.PlanetType.METEOR:
		planet_sprite.play("METEOR")
	if biome == ENUMS.PlanetType.BARREN:
		planet_sprite.play("BARREN")
	if biome == ENUMS.PlanetType.HEALTHY:
		planet_sprite.play("HEALTHY")
	if biome == ENUMS.PlanetType.ECUMENOPOLIS:
		planet_sprite.play("ECUMENOPOLIS")
	carbon = settings.carbon_density * size
	biomass = settings.biomass_density * size
	minerals = settings.mineral_density * size
	nanotech = settings.nanotech
	if settings.gravity_modifier == 0:
		$GravityWell.disabled = false
	gravity_strength = size * 100 * settings.gravity_modifier
	health = settings.health
	total_resource_quantity = carbon + biomass + minerals + nanotech
	remaining_resource_quantity = total_resource_quantity
	
	rotation = randf_range(0, 2*PI)


func ignore_gravity_for_object(body: RigidBody2D):
	if body in captured_objects:
		gravity_ignore_list.append(body)


func return_gravity_for_object(body: RigidBody2D):
	if body in gravity_ignore_list:
		gravity_ignore_list.erase(body)


func destroy_planet() -> void:
	var VFX = explode_VFX.instantiate()
	VFX.position = self.position
	add_sibling(VFX)
	queue_free()
	_exit_tree()


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	onscreen = true


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	onscreen = false
