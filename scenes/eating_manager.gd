extends Node2D


@export var consumption_rate: float = 10 # In item/sec

var actor: RigidBody2D
var time_until_next_eat: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	actor = get_parent()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	pass

func consume_items():
	pass
