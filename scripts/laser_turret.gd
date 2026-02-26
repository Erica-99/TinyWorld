extends Node2D

@export var ship_parent: Node2D
@export var lock_on_time: float = 2
@export var firing_delay: float = 0.15
@export var laser_linger_time: float = 0.2
@export var cooldown: float = 3
@export var damage: int = 100

@onready var aiming_raycast: RayCast2D = $AimingRaycast
@onready var aiming_line: Line2D = $AimingLaser
@onready var damage_shapecast: ShapeCast2D = $DamageShapecast
@onready var damage_line: Line2D = $DamageLaser

var enabled := false
var target_ship: RigidBody2D = null
var locked_on = false
var lock_on_point: Vector2
var current_hit_point: Vector2
var lock_on_timer_started = false
var started_firing = false
var active = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
	if not enabled:
		return
	if target_ship != null and active:
		if not locked_on:
			aiming_raycast.enabled = true
			aiming_raycast.target_position = target_ship.global_position - aiming_raycast.global_position
			if aiming_raycast.is_colliding():
				lock_on_point = aiming_raycast.get_collision_point()
				current_hit_point = lock_on_point
			else:
				lock_on_point = ((target_ship.global_position - aiming_raycast.global_position).normalized() * 2000) + aiming_raycast.global_position
				current_hit_point = lock_on_point
			
			aiming_line.visible = true
			aiming_line.points = PackedVector2Array([Vector2.ZERO, (lock_on_point-aiming_line.global_position)/ship_parent.scale])
			
			if not lock_on_timer_started:
				start_lock_on_timer()
		else:
			aiming_raycast.enabled = true
			aiming_line.visible = true
			aiming_raycast.target_position = (lock_on_point - aiming_raycast.global_position).normalized() * 2000
			if aiming_raycast.is_colliding():
				current_hit_point = aiming_raycast.get_collision_point()
			else:
				current_hit_point = ((lock_on_point - aiming_raycast.global_position).normalized() * 2000) + aiming_raycast.global_position
			
			aiming_line.points = PackedVector2Array([Vector2.ZERO, (current_hit_point-aiming_line.global_position)/ship_parent.scale])
			
			if not started_firing:
				fire(current_hit_point)
			
	pass

func start_lock_on_timer() -> void:
	lock_on_timer_started = true
	await get_tree().create_timer(lock_on_time).timeout
	if enabled and target_ship != null:
		locked_on = true


func fire(point: Vector2) -> void:
	started_firing = true
	await get_tree().create_timer(firing_delay).timeout
	if enabled:
		aiming_line.visible = false
		damage_line.points = PackedVector2Array([Vector2.ZERO, (current_hit_point-damage_line.global_position).normalized()*2000])
		damage_line.visible = true
		damage_shapecast.enabled = true
		damage_shapecast.target_position = (current_hit_point - damage_shapecast.global_position).normalized()*2000
		damage_shapecast.force_shapecast_update()
		if damage_shapecast.is_colliding():
			var hit_object = damage_shapecast.get_collider(0)
			if hit_object.name == "Ship":
				damage_player(hit_object)
		active = false
		linger()


func damage_player(ship: RigidBody2D) -> void:
	ship.take_damage(damage)
	pass


func linger() -> void:
	await get_tree().create_timer(laser_linger_time).timeout
	damage_shapecast.enabled = false
	damage_line.visible = false
	await get_tree().create_timer(0.1).timeout
	aiming_raycast.enabled = false
	aiming_line.visible = false
	await get_tree().create_timer(cooldown).timeout
	reset_aiming()


func enable() -> void:
	enabled = true


# Called by the parent when the turret is damaged
func disable() -> void:
	enabled = false
	target_ship = null
	aiming_raycast.enabled = false
	aiming_line.visible = false
	damage_shapecast.enabled = false
	damage_line.visible = false
	locked_on = false
	lock_on_timer_started = false
	started_firing = false


func reset_aiming() -> void:
	active = true
	aiming_raycast.enabled = false
	aiming_line.visible = false
	damage_shapecast.enabled = false
	damage_line.visible = false
	locked_on = false
	lock_on_timer_started = false
	started_firing = false


# Triggers when player enters aggro range
func _on_aggro_range_body_entered(body: Node2D) -> void:
	target_ship = body as RigidBody2D


func _on_aggro_range_body_exited(body: Node2D) -> void:
	target_ship = null
	reset_aiming()
