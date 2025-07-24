class_name HealthItem extends InventoryItem
#https://youtu.be/HzkRw1Sc1Dg?t=1016 
@export var health_increase : int = 1

func use(player: Player) -> void:
	player.find_child("PlayerDamageHandler").increase_health(health_increase)
	#make sure to implement the new function in the player script too
	#if GameManager.health == GameManager.max_health:
		#health_increase = 0
func can_be_used(player: Player) -> bool:
	return GameManager.health < GameManager.max_health
	#if the player has taken damage, it cannot use health item
