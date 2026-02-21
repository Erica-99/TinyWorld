extends Node2D


@export var consumption_rate: float = 10 # In item/sec

var actor: RigidBody2D
var time_passed_since_eating: float = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	actor = get_parent()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var time_between_eats: float = 1/consumption_rate
	
	if actor.landing_target != null:
		if time_passed_since_eating >= time_between_eats:
			# Eat in order of carbon -> biomass -> minerals -> nanotech
			if actor.landing_target.carbon > 0:
				actor.landing_target.carbon -= 1
				actor.landing_target.remaining_resource_quantity -= 1
			elif actor.landing_target.biomass > 0:
				actor.landing_target.biomass -= 1
				actor.landing_target.remaining_resource_quantity -= 1
			elif actor.landing_target.minerals > 0:
				actor.landing_target.minerals -= 1
				actor.landing_target.remaining_resource_quantity -= 1
			elif actor.landing_target.nanotech > 0:
				actor.landing_target.nanotech -= 1
				actor.landing_target.remaining_resource_quantity -= 1
			else:
				print("planet killed")
				reset_eating()
				actor.enter_default_mode()
			
			time_passed_since_eating -= time_between_eats
		time_passed_since_eating += delta
	else:
		reset_eating()
		actor.enter_default_mode()

func consume_items():
	pass


func reset_eating() -> void:
	time_passed_since_eating = 0
