extends Area2D

@export var turrets: Array[Area2D]

@onready var EnemyAnims = $SpritePivot/EnemyAnims

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
	EnemyAnims.play("Death")
	print("dead")



func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	print('Visible')
	EnemyAnims.play("Spawn")
	pass # Replace with function body.


func _on_enemy_anims_animation_finished(anim_name: StringName) -> void:
	if anim_name == 'Death':
		queue_free()
	pass # Replace with function body.
