extends CharacterBody2D

@onready var player = get_parent().find_child("Nitefsm")
@onready var animation = $AnimatedSprite2D
@export var chase_speed : int = 50

func _ready():
	set_physics_process(false)
	await animation.animation_finished
	set_physics_process(true)
	animation.play("summonIdle")

func _physics_process(_delta):
	var direction = player.position - position #global_position
	velocity = direction.normalized() * 50
	move_and_slide()
	
func take_damage():
	#animation.play("death")
	animation.play("summonDeath")
	await animation.animation_finished
	
	var green_soul = preload("res://scenes/collectable/green_soul.tscn")
	var new_green_soul_object = green_soul.instantiate()
	get_tree().current_scene.add_child(new_green_soul_object)
	new_green_soul_object.global_position = global_position
		# character is finished dying, remove from game
	await get_tree().process_frame
	queue_free()
	
