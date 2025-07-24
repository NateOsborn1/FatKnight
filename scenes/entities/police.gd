extends CharacterBody2D
class_name Police

@export var time_idle = 3

enum state {IDLE, WIND_UP, ATTACK, HURT}
# puts states into dictionary form where IDLE = 1 and RUNNING = 2 i.e.

var anim_state = state.IDLE

@onready var animator = $AnimatedSprite2D
@onready var animation_player = $AnimationPlayer
@onready var attack_area = $Area2D  # Reference to the Area2D node for player detection
@onready var bullet_scene = preload("res://scenes/entities/bullet_1.tscn")  # Path to your bullet scene




func update_state():
	if anim_state == state.HURT:
		return
	if is_on_floor():
		if velocity == Vector2.ZERO:
			anim_state = state.IDLE
	if anim_state == state.WIND_UP:
		animation_player.play("wind_up")
		print("Wind up state entered")
		anim_state == state.ATTACK
	if anim_state == state.ATTACK:
		animation_player.play("shooting")
		print("Attack state entered")
	
	
# Function to flip the NPC based on the player's position
func flip_npc(player_position):
	if player_position.x > position.x:
		animator.flip_h = true  # Flip the NPC horizontally
	else:
		animator.flip_h = false  # Reset the NPC's flip

# Function to start attacking the player
#func start_wind_up():
	#anim_state = state.WIND_UP
	#animation_player.play("attack")
	#animation_player.play("wind_up")
	
#func start_attack():
	#anim_state = state.ATTACK
	#animation_player.play("attack")
	#animation_player.play("shooting")
	
func stop_attack():
	anim_state = state.IDLE
	animation_player.play("idle")

# Function to spawn bullets towards the player
#func spawn_bullet():
	#var bullet_instance = bullet_scene.instance()
	#bullet_instance.global_position = position  # Set the bullet's position to NPC's position
	#bullet_instance.set_direction(animator.flip_h)  # Set bullet direction based on NPC's flip
	#get_parent().add_child(bullet_instance)  # Add the bullet to the scene
	#print("make bullet")

# right now the direction of police flip is based around pressing 'o' and 'p' keys
func update_animation():
#func update_animation(direction):
	match anim_state:
		state.IDLE:
			animation_player.play("idle")
		state.WIND_UP:
			#animation_player.play("attack")
			animation_player.play("wind_up")
		state.ATTACK:
			#animation_player.play("attack")
			animation_player.play("shooting")
		state.HURT:
			animation_player.play("hurt")


func _physics_process(delta):
	# Add the gravity. 
	#constantly checks
	# Get the gravity from the project settings to be synced with RigidBody nodes.
	var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
	if not is_on_floor():
		velocity.y += gravity * delta

	#var direction = Input.get_axis("obstacle_left", "obstacle_right"), police isnt a playable char

	
	# update_state()
	#update_animation(direction)
	update_animation()
	move_and_slide()
	

	# Get the player's position and flip the npc
	var player = GameManager.player
	if player:
		flip_npc(player.global_position)

func _ready():
	pass

func _on_area_2d_area_entered(area):
	if area.get_parent() is Player:
		anim_state == state.WIND_UP
		#instead of starting functions, let's change states.
		#start_wind_up()
		#start_attack()
		update_state()
#add a signal for the timer for shoot time for police

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "shooting":
		#spawn_bullet()
		print("spawn bullet")


func _on_area_2d_area_exited(area):
	if area.get_parent() is Player:
		stop_attack()


func _on_animated_sprite_2d_animation_looped():
	pass


func _on_animation_player_animation_started(anim_name):
	#if anim_name == "shooting":
		#var b = bullet_scene.instantiate()
		#get_tree().root.add_child(b)
		#b.start(position)
	pass

func _on_timer_timeout(anim_name):
	if anim_name == "shooting":
		var b = bullet_scene.instantiate()
		get_tree().root.add_child(b)
		b.start(position)

