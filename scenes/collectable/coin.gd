extends Area2D

class_name Coin

func collected():
	var vanish = preload("res://scenes/collectable/vanish.tscn")
	var new_vanish_object = vanish.instantiate()
	get_tree().current_scene.add_child(new_vanish_object)
	new_vanish_object.global_position = global_position
	#global_position refers to the position of Coin, and the first global_position refers to the position of vanish
	GameManager.score += 1
	
	
func _on_body_entered(body):
	if body.is_in_group("Player"):
		collected()
		queue_free()
		#queue free removes it from the node tree

