extends Panel

#https://www.youtube.com/watch?v=HzkRw1Sc1Dg&ab_channel=MakerTech
#access player inventory resource
@onready var inventory: Inventory = preload("res://scenes/ui/inventory/items/playerInventory.tres")
@onready var slots: Array = $Container.get_children()
@onready var selector: Sprite2D = $Selector2
#$Old_Selector is not longer in use, only here in case i need old values or redo art

var currently_selected : int = 0

func _ready():
	visible = true
	update()
	inventory.updated.connect(update)

func update() -> void:
	for i in range(slots.size()):
		var inventory_slot: InventorySlot = inventory.slots[i]
		slots[i].update_to_slot(inventory_slot)

func move_selector_right() -> void:
	currently_selected = (currently_selected + 1) % slots.size()
	selector.global_position = slots[currently_selected].global_position

func move_selector_left() -> void:
	currently_selected = (currently_selected - 1) % slots.size()
	selector.global_position = slots[currently_selected].global_position

func _unhandled_input(event) -> void:
	if event.is_action_pressed("use_item"):
		inventory.use_item_at_index(currently_selected)
	
	if event.is_action_pressed("move_selector_right"):
		move_selector_right()
	
	if event.is_action_pressed("move_selector_left"):
		move_selector_left()
