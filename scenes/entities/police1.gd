extends CharacterBody2D
class_name PoliceEnemy
#@onready var spawnpos = $"../../Muzzle"
@export var hit_state : State
@onready var animation_tree : AnimationTree = $AnimationTree
#@onready var character_state_machine : CharacterStateMachine = $StateMachine

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
#@export var Bullet : PackedScene

func _ready():
	animation_tree.active = true
	
func _physics_process(delta):

	if not is_on_floor():
		velocity.y += gravity * 1.25 * delta

	if velocity.x < 0:
		$AnimatedSprite2D.flip_h = false
	else:
		$AnimatedSprite2D.flip_h = true
		# Add the gravity.
	#if not is_on_floor() and not is_on_ceiling():
		#velocity.y += gravity * delta
	move_and_slide()
	
func take_damage():
	pass
		
	#if velocity.length() > 0:
		#add a walk animation for police and change idle to move
		#$AnimationPlayer.play("idle")
	
	# Get the player's position and flip the npc add this to the state of chase or attack
	#var player = GameManager.player
	#if player:
	#	flip_npc(player.global_position)


#func flip_npc(player_position):
#	if player_position.x > position.x:
#		$AnimatedSprite2D.flip_h = true  # Flip the NPC horizontally
#	else:
#		$AnimatedSprite2D.flip_h = false  # Reset the NPC's flip


