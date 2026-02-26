extends Area2D

@export var physical_shield: StaticBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_entered(area: Area2D) -> void:
	if area.get_parent().inventory.nanotech_stores > 0:
		print("nanotech")
		physical_shield.queue_free()
		queue_free()
