extends Node2D

var enabled := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func enable() -> void:
	enabled = true
	print("turret enabled")


# Called by the parent when the turret is damaged
func disable() -> void:
	enabled = false
	pass


# Triggers when player enters aggro range
func _on_aggro_range_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
