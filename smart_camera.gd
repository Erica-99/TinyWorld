extends Camera2D

@export var target_object: Node2D
@export var tracking_speed: float = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if target_object != null:
		var position_to_move = lerp(position, target_object.position, tracking_speed*delta)
		position = position_to_move
	
	pass
