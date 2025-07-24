extends Area2D

@export var itemRes: InventoryItem

func collect(inventory: Inventory):
	#add fx
	var vanish = preload("res://scenes/collectable/vanish.tscn")
	var new_vanish_object = vanish.instantiate()
	get_tree().current_scene.add_child(new_vanish_object)
	new_vanish_object.global_position = global_position
	
	inventory.insert(itemRes)
	queue_free()
	
#https://www.youtube.com/watch?v=9CEUurKqfLQ&ab_channel=MakerTech
