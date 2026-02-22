extends Node2D

@export var consumption_rate: float = 100 # In item/sec

var actor: RigidBody2D
var time_passed_since_eating: float = 0
var inventory: Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	actor = get_parent()
	inventory = $Inventory


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var time_between_eats: float = 1/consumption_rate
	
	if actor.landing_target != null:
		if time_passed_since_eating >= time_between_eats:
			var stacked_time: float = time_passed_since_eating/time_between_eats
			# Eat in order of carbon -> biomass -> minerals -> nanotech
			print(actor.landing_target.remaining_resource_quantity)
			if actor.landing_target.carbon > 0:
				actor.landing_target.carbon -= int(stacked_time)
				if actor.landing_target.carbon < 0:
					stacked_time = stacked_time + actor.landing_target.carbon
					actor.landing_target.carbon = 0
				actor.landing_target.remaining_resource_quantity -= int(stacked_time)
				inventory.carbon_stores += int(stacked_time)
			elif actor.landing_target.biomass > 0:
				actor.landing_target.biomass -= int(stacked_time)
				if actor.landing_target.biomass < 0:
					stacked_time = stacked_time + actor.landing_target.biomass
					actor.landing_target.biomass = 0
				actor.landing_target.remaining_resource_quantity -= int(stacked_time)
				inventory.biomass_stores += int(stacked_time)
			elif actor.landing_target.minerals > 0:
				actor.landing_target.minerals -= int(stacked_time)
				if actor.landing_target.minerals < 0:
					stacked_time = stacked_time + actor.landing_target.minerals
					actor.landing_target.minerals = 0
				actor.landing_target.remaining_resource_quantity -= int(stacked_time)
				inventory.mineral_stores += int(stacked_time)
			elif actor.landing_target.nanotech > 0:
				actor.landing_target.nanotech -= int(stacked_time)
				if actor.landing_target.nanotech < 0:
					stacked_time = stacked_time + actor.landing_target.nanotech
					actor.landing_target.nanotech = 0
				actor.landing_target.remaining_resource_quantity -= int(stacked_time)
				inventory.nanotech_stores += int(stacked_time)
			else:
				print("planet killed")
				reset_eating()
				actor.enter_default_mode()
			
			time_passed_since_eating -= int(stacked_time)*time_between_eats
		time_passed_since_eating += delta
	else:
		reset_eating()
		actor.enter_default_mode()

func consume_items():
	pass


func reset_eating() -> void:
	time_passed_since_eating = 0
