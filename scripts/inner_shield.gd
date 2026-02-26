extends StaticBody2D

@export var required_planets: Array[Area2D]


func _process(delta: float) -> void:
	if required_planets.all(is_null):
		queue_free()


func is_null(object) -> bool:
	return object == null
