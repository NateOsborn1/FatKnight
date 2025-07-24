extends CharacterBody2D
#change class_name to Player and
#uncomment func ready
#add to groups Player

class_name Player1
@export var speed = 125.0
@export var sprint_speed_multiplier = 1.3  # 30% increase in speed when sprinting
@export var jump_velocity = -260.0
@export var acceleration : float = 15.0
@export var jump_counter = 1
@export var inventory: Inventory
#@export var double_jump = false

enum state {IDLE, RUNNING, JUMPUP, JUMPDOWN, HURT}
#puts states into dictionary form where IDLE = 1 and RUNNING = 2 i.e.

var anim_state = state.IDLE

@onready var animator = $AnimatedSprite2D
@onready var animation_player = $AnimationPlayer
#references animatedsprite2d on start

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	GameManager.player1 = self
	
func update_state():
	if anim_state == state.HURT:
		return
	if is_on_floor():
		if velocity == Vector2.ZERO:
			anim_state = state.IDLE
		elif velocity.x != 0:
			anim_state = state.RUNNING
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
		state.RUNNING:
			animation_player.play("run")
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
	
func die():
	GameManager.respawn_player()

func _on_hurtbox_area_entered(area):
	if area.has_method("collect"):
		area.collect(inventory)
