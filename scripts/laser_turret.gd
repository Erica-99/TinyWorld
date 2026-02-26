extends Node2D

@onready var aiming_raycast: RayCast2D = $AimingRaycast
@onready var aiming_line: Line2D = $AimingLaser
@onready var damage_shapecast: ShapeCast2D = $DamageShapecast
@onready var damage_line: Line2D = $DamageLaser

var enabled := false
var target_ship: RigidBody2D = null
var locked_on = false
var lock_on_point: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
	if not enabled:
		return
	if target_ship != null:
		if not locked_on:
			aiming_raycast.target_position = target_ship.global_position - aiming_raycast.global_position
			if aiming_raycast.is_colliding():
				var hit_point = aiming_raycast.get_collision_point()
	pass



func enable() -> void:
	enabled = true
	print("turret enabled")


# Called by the parent when the turret is damaged
func disable() -> void:
	enabled = false
	pass


func reset_aiming() -> void:
	target_ship = null
	pass


# Triggers when player enters aggro range
func _on_aggro_range_body_entered(body: Node2D) -> void:
	target_ship = body as RigidBody2D


func _on_aggro_range_body_exited(body: Node2D) -> void:
	reset_aiming()
