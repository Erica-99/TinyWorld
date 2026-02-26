extends GPUParticles2D


func _on_finished() -> void:
	queue_free()
	pass # Replace with function body.

func emit(planet: Area2D) -> void:
	amount_ratio = planet.size/200
	speed_scale = planet.size/200
	
	emitting = true
