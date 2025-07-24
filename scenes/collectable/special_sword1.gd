class_name special_sword1 
extends InventoryItem

#this script is moved to the resource for the item, not for the root node
@export var abc : String

func use(player: Player) -> void:
	player.punch.ATK = 2
	print(player.punch.ATK)
	#if i wanted the player to equip a weapon, i would have to have a func in player script and instantiate it, and i would use the use func here\
	#to send a signal or to call that method
