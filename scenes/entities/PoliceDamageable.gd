extends Node2D
class_name PoliceDamageable


signal on_hit(node : Node2D, damage_taken : int, knockback_direction : Vector2)

@export var health : float = 20 :
	get: 
		return health
	set(value):
		GameManager.emit_signal("on_health_changed", get_parent(), value - health)
		health = value

@export var dead_animation_name : String = "dead"

func hit(damage : int, knockback_direction : Vector2):
	health -= damage
	
	emit_signal("on_hit", get_parent(), damage, knockback_direction)
	#if(health <= 0):
		#get_parent().call_deferred(hit(damage)).queue_free()
		#get_parent().queue_free()


func _on_animation_player_animation_finished(anim_name):
	if(anim_name == dead_animation_name): #&& health <= 0):
		#instantiate soul when char dies on their position
		var green_soul = preload("res://scenes/collectable/green_soul.tscn")
		var new_green_soul_object = green_soul.instantiate()
		get_tree().current_scene.add_child(new_green_soul_object)
		new_green_soul_object.global_position = global_position
		# character is finished dying, remove from game
		get_parent().queue_free()
		

	#if(health <= 0):
		#get_parent().call_deferred(hit(damage)).queue_free()
		#get_parent().queue_free()





