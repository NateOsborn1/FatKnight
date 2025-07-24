extends State1
@onready var collision = $"../../CollisionShape2D"
@onready var timer : Timer = $"Loot drop"
@onready var damage_handler = $"../../DamageHandler"
@export var dead_animation_name : String = "death"

signal on_boss_slain
# Called when the node enters the scene tree for the first time.
func enter():
	super.enter()
	timer.start()
	remove_collision()
	animation_player.play("death")
	#collision.queue_free()
	await animation_player.animation_finished
	damage_handler._on_animation_tree_animation_finished(dead_animation_name)
	

func remove_collision():
	#collision.disabled = true
	collision.queue_free()

func boss_slain():
	animation_player.play("Boss Slain")
	on_boss_slain.emit()
	print("onbossslain emit")
	await animation_player.animation_finished
	get_parent().queue_free()


func _on_loot_drop_timeout():
	var green_soul = preload("res://scenes/collectable/green_soul.tscn")
	var new_green_soul_object = green_soul.instantiate()
	get_tree().current_scene.add_child(new_green_soul_object)
	new_green_soul_object.global_position = global_position + Vector2(22, 45)
	#maybe get an onready var for Boss position, if he dies too far away, then spawn the drop lower, or add gravity to the area2d


##func Enter():
	#super.Enter()
	##collision.set_deferred("monitoring", false)
	#animation_player.play("dead")
	#damageable._on_animation_tree_animation_finished(dead_animation_name)
