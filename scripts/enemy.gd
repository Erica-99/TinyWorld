extends Area2D

@export var turrets: Array[Area2D]

var alive = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if alive:
		var turret_still_alive = false
		for turret in turrets:
			if not turret.damaged:
				turret_still_alive = true
		
		if not turret_still_alive:
			explode()


func explode() -> void:
	alive = false
	print("dead")
