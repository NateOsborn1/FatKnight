extends State
class_name PlayerMove

@export var stateOwner: CharacterBody2D
@export var move_speed := 50.0
@export var sprint_speed_multiplier = 1.3  # 30% increase in speed when sprinting
@export var jump_velocity = -260.0
@export var acceleration : float = 15.0

var player: Player
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func Enter():
	player = get_tree().get_first_node_in_group("Player")

func Update(delta: float):
	#if wander_time > 0:
		#wander_time -= delta
	#else:
		#randomize_wander()
	pass

func Physics_Update(delta):
	var direction = Input.get_axis("left", "right")
	# Add the gravity.
	#if not is_on_floor():
	#	velocity.y += gravity * delta
