extends CharacterBody2D


@onready var animation_tree : AnimationTree = $AnimationTree
@onready var state_machine : CharacterStateMachine = $CharacterStateMachine
@export var starting_move_direction : Vector2 = Vector2.ZERO
@onready var sprite : Sprite2D = $Sprite2D
@export var movement_speed : float = 30
@export var hit_state : State
@onready var damageable : Damageable = $Damageable

#@export var health : float = 20 
	#get: 
		#return health
	#set(value):
		#GameManager.emit_signal("on_health_changed", get_parent(), value - health)
		#health = value
		#print(health)

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	animation_tree.active = true
	sprite.flip_h = true

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction : Vector2 = starting_move_direction
	if direction && state_machine.check_if_can_move():
		velocity.x = direction.x * movement_speed
	elif state_machine.current_state != hit_state:
		velocity.x = move_toward(velocity.x, 0, movement_speed)

	move_and_slide()

#func take_damage():
	#if health < 0:
		#health -= 0
	#else:
		#health -= 10

func take_damage():
	pass
	
func hit():
	pass

#func hit(damage : int, knockback_direction : Vector2):
	#damageable.hit(damage : int, knockback_direction : Vector2)
	#damageable.health -= damage

