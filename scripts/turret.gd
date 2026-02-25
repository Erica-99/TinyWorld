extends Area2D

@export var child_collider: CollisionShape2D

var damaged = false

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# The only thing that can be detected by the area is the player's surge
func _on_area_entered(area: Area2D) -> void:
	print("hit")
	damaged = true
	sprite.play("Damaged")
	child_collider.set_deferred("disabled", true)
