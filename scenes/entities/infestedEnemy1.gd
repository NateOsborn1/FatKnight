extends CharacterBody2D


@onready var healthBar : TextureProgressBar = $healthBar
@onready var DamageHandler : Node2D = $DamageHandler

func _ready():
	healthBar.max_value = DamageHandler.max_health
	#healthBar.value = DamageHandler.current_health * 100 / DamageHandler.max_health
	healthBar.value = DamageHandler.current_health

func _process(delta):
	healthBar.value = DamageHandler.current_health
	#healthBar.value = DamageHandler.current_health * 100 / DamageHandler.max_health
	#a little expensive, i could just have the "take damage emit a signal to update the healthbar"

#healthBar.value = DamageHandler.current_health * 100 / DamageHandler.maxHealth

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


#func _physics_process(delta):
	## Add the gravity.
	#if not is_on_floor():
		#velocity.y += gravity * delta
#
	## Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY
#
	## Get the input direction and handle the movement/deceleration.
	## As good practice, you should replace UI actions with custom gameplay actions.
	#var direction = Input.get_axis("ui_left", "ui_right")
	#if direction:
		#velocity.x = direction * SPEED
	#else:
		#velocity.x = move_toward(velocity.x, 0, SPEED)
#
	#move_and_slide()
