extends CharacterBody2D

class_name Player2
@export var speed = 125.0
@export var sprint_speed_multiplier = 1.3  # 30% increase in speed when sprinting
@export var jump_velocity = -260.0
@export var acceleration : float = 15.0
@export var jump_counter = 1
@export var inventory: Inventory
@export var glide_fall = 60

#@export var double_jump = false

enum state {IDLE, HOPPING, JUMPUP, JUMPDOWN, GLIDE, HURT}
#puts states into dictionary form where IDLE = 1 and RUNNING = 2 i.e.

var anim_state = state.IDLE

@onready var animator = $AnimatedSprite2D
@onready var animation_player = $AnimationPlayer
#references animatedsprite2d on start

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	GameManager.player2 = self
	
func update_state():
	if anim_state == state.HURT:
		return
	if is_on_floor():
		if velocity == Vector2.ZERO:
			anim_state = state.IDLE
		elif velocity.x != 0:
			anim_state = state.HOPPING
	else:
		if velocity.y < 0:
			anim_state = state.JUMPUP
		else:
			anim_state = state.JUMPDOWN

func update_animation(direction):
	if direction > 0:
		animator.flip_h = false
	elif direction < 0:
		animator.flip_h = true
	match anim_state:
		state.IDLE:
			animation_player.play("idle")
		state.HOPPING:
			animation_player.play("hop")
		state.HURT:
			animation_player.play("hurt")
		state.JUMPDOWN:
			animation_player.play("jump_down")
		state.JUMPUP:
			animation_player.play("jump_up")

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		
# Handle jump.
	#if Input.is_action_just_pressed("jump"):
	#^ to remove jump limit restriction
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
	
	if Input.is_action_pressed("sprint") and !is_on_floor():
		_glide_state(delta)
	
	#Dropping through a 1 way platform
	if Input.is_action_just_pressed("down") and is_on_floor():
		position.y += 1

# Get the input direction and handle the movement/deceleration.
	var direction = Input.get_axis("left", "right")
	if direction:
		if Input.is_action_pressed("sprint"):  # Check if sprint key (Shift) is pressed
			velocity.x = move_toward(velocity.x, direction * speed * sprint_speed_multiplier, acceleration)
		else:
			velocity.x = move_toward(velocity.x, direction * speed, acceleration)
	else:
		velocity.x = move_toward(velocity.x, 0, acceleration/2)

	update_state()
	update_animation(direction)
	move_and_slide()
	
	#higher the y pos, the farther the player can fall before death
	if position.y >= 650:
		die()

func _glide_state(delta):
	var direction = Input.get_axis("left", "right")
	animation_player.play("glide")
	velocity.y += gravity * delta
	
	if velocity.y >= glide_fall:
		velocity.y = glide_fall 
		velocity.x = speed * direction * 0.75
	
func die():
	GameManager.respawn_player()

func _on_hurtbox_area_entered(area):
	if area.has_method("collect"):
		area.collect(inventory)
