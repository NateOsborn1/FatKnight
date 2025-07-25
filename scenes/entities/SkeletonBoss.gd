extends CharacterBody2D
class_name SkeletonBoss

@onready var player = get_parent().find_child("Nitefsm")
@onready var animated_sprite = $AnimatedSprite2D
@onready var progress_bar = $UI/ProgressBar
@onready var slash : Node2D = $Weapons
#@onready var damageable : Damageable = $Damageable
#@onready var collision = $"../../PlayerDetection/CollisionShape2D"



#func _on_player_detection_body_entered(body):
	##if player enters, turn off detection and set progress bar as visible
	#if body is Player:
		#progress_bar.visible = true
		#get_tree().call_group("LockedDoor","Locked")


#@onready var collision = $CollisionShape2D
@export var speed : int = 50
var direction : Vector2
#var health = Damageable.health


#@export var health:= 100:
	#set(value):
		#health = value
		#progress_bar.value = value
		#if value <= 0:
			#progress_bar.visible = false
			#find_child("FiniteStateMachine1").change_state("Death")
			#queue_free()
			
func _on_death_on_boss_slain():
	print("boss slain")
	get_tree().call_group("LockedDoor","unlocked")

#func _on_player_detection_body_entered(body):
	##if player enters, turn off detection and set progress bar as visible
	#player_entered = true
	#progress_bar.visible = true
	#get_tree().call_group("LockedDoor","Locked")


#@export var health: = 100:
	#set(value):
		#health = value
		#progress_bar.value = value
		#if value <= 0:
			#progress_bar.visible = false
			#find_child("FiniteStateMachine1").change_state("Death")
			##queue_free()
			
			
			#var health: = 100:
	#set(value):
		#health = value
		#progress_bar.value = value
		#if value <= 0:
			#progress_bar.visible = false
			#find_child("FiniteStateMachine1").change_state("Death")

func _ready():
	set_physics_process(false)
	

func _process(_delta):
	direction = player.position - global_position
	
	if direction.x < 0:
		animated_sprite.flip_h = true
		slash.scale = Vector2(-1,1)
	else:
		animated_sprite.flip_h = false
		slash.scale = Vector2(1,1)

func _physics_process(delta):
	velocity = direction.normalized() * speed
	#move_and_collide(velocity * delta)
	
	#this will let the boss slide floor and stay ahead of player
	move_and_slide()
	
	#only applies damage from firebolt, for some reason does 90 damage too..
#func hit():
	#if damageable.health < 0:
		#health -= 0
	#else:
		#health -= 10
##
#func hit(damage : int, knockback_direction : Vector2):
	#health -= damage
	#
	##emit_signal("on_hit", get_parent(), damage, knockback_direction)
	#
#func take_damage():
	#if health < 0:
		#health -= 0
	#else:
		#health -= 10


#func on_damageable_hit(node : Node2D, damage_amount : int, knockback_direction : Vector2):
	#if(damageable.health > 0):
		#character.velocity = knockback_speed * knockback_direction
		#
#
#extends Node2D
#class_name Damageable
#
#
#signal on_hit(node : Node2D, damage_taken : int, knockback_direction : Vector2)
#
#@export var health : float = 20 :
	#get: 
		#return health
	#set(value):
		#GameManager.emit_signal("on_health_changed", get_parent(), value - health)
		#health = value
		#print(health)
#
#@export var dead_animation_name : String = "dead"
#
#func hit(damage : int, knockback_direction : Vector2):
	#health -= damage
	#
	#emit_signal("on_hit", get_parent(), damage, knockback_direction)
	##if(health <= 0):
		##get_parent().call_deferred(hit(damage)).queue_free()
		##get_parent().queue_free()
#
#
#func _on_animation_tree_animation_finished(anim_name):
	#if(anim_name == dead_animation_name): #&& health <= 0):
		##instantiate soul when char dies on their position
		#var green_soul = preload("res://scenes/collectable/green_soul.tscn")
		#var new_green_soul_object = green_soul.instantiate()
		#get_tree().current_scene.add_child(new_green_soul_object)
		#new_green_soul_object.global_position = global_position
		## character is finished dying, remove from game
		#get_parent().queue_free()
		#
	##if(health <= 0):
		##get_parent().call_deferred(hit(damage)).queue_free()
		##get_parent().queue_free()
#
#
##var health: = 100:
	##set(value):
		##health = value
		##progress_bar.value = value
		##if value <= 0:
			##progress_bar.visible = false
			##find_child("FiniteStateMachine1").change_state("Death")
			###queue_free()
