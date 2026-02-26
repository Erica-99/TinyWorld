extends Line2D

@export var connection_1: Node2D
@export var connection_2: Node2D

@export var disable_colour: Color


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if connection_1 == null or connection_2 == null:
		default_color = disable_colour
