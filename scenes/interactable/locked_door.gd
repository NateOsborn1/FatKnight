extends CharacterBody2D
class_name LockedDoor
@onready var collision = $CollisionShape2D
@onready var animation_player = $AnimationPlayer
@export var isLocked : bool = true


func locked():
	isLocked = true
	animation_player.play("Locked")
	print("Locked")

#Use for events to toggle unlocked/locked
#example on boss slain is:
#func _on_death_on_boss_slain():
	#print("boss slain")
	#get_tree().call_group("LockedDoor","unlocked")

func unlocked():
	isLocked = false
	print("unlocked func")

func _on_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		if !isLocked:
			print("unlocked and area entered")
			animation_player.play("Unlocked")
			await animation_player.animation_finished
			collision.set_deferred("disabled", true) 
		#Object.set_deferred()

func _on_area_2d_body_exited(body):
	if body.is_in_group("Player"):
		if !isLocked:
			animation_player.play("Locked")
			collision.set_deferred("disabled", false) 
