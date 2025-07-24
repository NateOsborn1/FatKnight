extends State


@onready var animation_player = $"../../AnimationPlayer"
@onready var collision = $"../../CollisionShape2D"
@onready var damageable = $"../../Damageable"
@export var dead_animation_name : String = "dead"


func Enter():
	super.Enter()
	#collision.set_deferred("monitoring", false)
	animation_player.play("dead")
	await animation_player.animation_finished
	damageable._on_animation_tree_animation_finished(dead_animation_name)
	#var green_soul = preload("res://scenes/collectable/green_soul.tscn")
	#var new_green_soul_object = green_soul.instantiate()
	#get_tree().current_scene.add_child(new_green_soul_object)
	#new_green_soul_object.global_position = global_position #+ Vector2(22, 45)
	#collision.set_deferred("monitoring", false)
	#collision.queue_free()
	#await get_tree().process_frame
	#get_parent().queue_free()
	
	#get_node("Police").queue_free()
	#maybe get an onready var for Boss position, if he dies too far away, then spawn the drop lower, or add gravity to the area2d
	

#signal Transitioned
#signal interupt_state(new_state : State)
#
#@export var can_move : bool = true
#var character : CharacterBody2D
#var next_state : State
#var playback : AnimationNodeStateMachinePlayback
#
#func state_input(event : InputEvent):
	#pass
#
#func Enter():
	#pass
#
#func Exit():
	#pass
#
#func Update(_delta: float):
	#pass
#
#func Physics_Update(_delta: float):
	#pass
#
#func state_process(delta):
	#pass
#

#
#func enter():
	#super.enter()
	#timer.start()
	#animation_player.play("death")
	#collision.queue_free()
#
#func boss_slain():
	#animation_player.play("Boss Slain")
	#await animation_player.animation_finished
	#get_parent().queue_free()
#
#
#func _on_loot_drop_timeout():
	#var green_soul = preload("res://scenes/collectable/green_soul.tscn")
	#var new_green_soul_object = green_soul.instantiate()
	#get_tree().current_scene.add_child(new_green_soul_object)
	#new_green_soul_object.global_position = global_position + Vector2(22, 45)
	##maybe get an onready var for Boss position, if he dies too far away, then spawn the drop lower, or add gravity to the area2d
