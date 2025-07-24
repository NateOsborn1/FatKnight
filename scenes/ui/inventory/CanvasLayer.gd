extends CanvasLayer

@onready var inventory = $"Inventory Gui"

func _ready():
	inventory.close()
	
# Called when the node enters the scene tree for the first time.
func _input(event):
	if event.is_action_pressed("toggle_inventory"):
		if inventory.isOpen:
			inventory.close()
		else:
			inventory.open()
