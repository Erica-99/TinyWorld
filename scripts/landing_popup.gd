extends Control

var playerdead = false

func _on_ship_player_mode_changed(new_mode: ENUMS.PlayerMovementMode, previous_mode: ENUMS.PlayerMovementMode) -> void:
	if playerdead:
		return
		
	match new_mode:
		ENUMS.PlayerMovementMode.DEFAULT:
			visible = false
		ENUMS.PlayerMovementMode.READY_TO_LAND:
			$Label.text = "Press [Space] to enter landing mode"
			visible = true
		ENUMS.PlayerMovementMode.LANDING:
			$Label.text = "Press [Space] to cancel landing"
			visible = true
		ENUMS.PlayerMovementMode.EATING:
			visible = false


func _on_ship_player_died() -> void:
	playerdead = true
	visible = false
