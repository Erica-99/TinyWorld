extends Control


func _on_ship_player_ready_to_land() -> void:
	$Label.text = "Press [Space] to enter landing mode"
	visible = true


func _on_ship_player_not_ready_to_land() -> void:
	$Label.text = "Press [Space] to enter landing mode"
	visible = false


func _on_ship_player_landing() -> void:
	$Label.text = "Press [Space] to cancel landing"
