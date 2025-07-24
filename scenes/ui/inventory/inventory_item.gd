extends Resource
#https://youtu.be/HzkRw1Sc1Dg?t=967
class_name InventoryItem 

@export var name: String = ""
@export var texture: Texture2D
@export var maxAmount : int

#@export var stackSize: int
#@export var maxAmount = stackSize
func use(player: Player) -> void:
	pass
#dont add anything here because not all of our items will work the same

func can_be_used(player: Player) -> bool:
	return true
	#item can always be used unless modified in the item script
