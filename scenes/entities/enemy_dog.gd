extends CharacterBody2D

@export var flip_time = 2
#var direction = null
var direction = 1
const SPEED = 100.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

enum state {IDLE, ATTACK, HURT, WALK, DEATH}
var anim_state = state.IDLE

@onready var animator = $AnimatedSprite2D
@onready var animation_player = $AnimationPlayer

func update_animation(direction):
	if direction < 0:
		animator.flip_h = false
	elif direction > 0:
		animator.flip_h = true
		#may need to reverse the > and < signs
	match anim_state:
		state.IDLE:
			animation_player.play("idle")
		state.ATTACK:
			animation_player.play("attack")
		state.HURT:
			animation_player.play("hurt")
		state.WALK:
			animation_player.play("walk")
		state.DEATH:
			animation_player.play("death")


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	velocity.x = direction * SPEED
	move_and_slide()
	$AnimatedSprite2D.flip_h = direction < 0

func _ready():
	$Timer.wait_time = flip_time
	
func _on_timer_timeout():
	direction = direction * -1
