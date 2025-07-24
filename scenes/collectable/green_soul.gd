extends Area2D

@export var itemRes: InventoryItem

#func _physics_process(delta):
	#position.y = delta * -9.81
	
func collect(inventory: Inventory):
	#add fx
	var vanish = preload("res://scenes/collectable/vanish.tscn")
	var new_vanish_object = vanish.instantiate()
	get_tree().current_scene.add_child(new_vanish_object)
	new_vanish_object.global_position = global_position
	GameManager.soul_count += 1
	inventory.insert(itemRes)
	queue_free()
	
#func _physics_process(delta):
#	velocity.y += gravity * 1.25 * delta

	#move_and_slide()
#https://www.youtube.com/watch?v=9CEUurKqfLQ&ab_channel=MakerTech
