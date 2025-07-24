extends State
class_name EnemyWindup

@export var enemy: CharacterBody2D
@export var move_speed := 30.0  # Adjust the slower speed as needed
@export var wind_up_duration := 0.75  # Duration of the wind-up animation

#var direction: Vector2
var player: Player
var wind_up_timer := 0.0
var animation_player: AnimationPlayer

func Enter():
	player = get_tree().get_first_node_in_group("Player")
	wind_up_timer = wind_up_duration
	
	# Access the AnimationPlayer node using the correct path
	animation_player = get_parent().get_node("../AnimationPlayer")
	animation_player.play("wind_up")  # Start the wind-up animation

func Update(delta: float):
	# Update the wind-up timer
	wind_up_timer -= delta

	# Follow the player at a slower speed
	
	var direction_x = player.global_position.x - enemy.global_position.x
	# Create a Vector2 using only the X-component of the direction
	var direction = Vector2(direction_x, 0)
	# Normalize the direction vector
	direction = direction.normalized()
	# Set the enemy's velocity using the normalized direction and move speed
	enemy.velocity = direction * move_speed

	
	#var direction = player.global_position - enemy.global_position
	#var direction = player.position - position
	#enemy.velocity = direction.normalized() * move_speed
	
	#BUG sometimes the police will quickly flip when player stands on top of police, maybe add a buffer for flipping, may just have the player kill police
	#when jumping on them
	
	#if enemy.velocity.x < 0:
	if direction_x < 0:
		$"../../AnimatedSprite2D".flip_h = false
	#else:
	elif direction_x > 0.5:
		$"../../AnimatedSprite2D".flip_h = true
	

	# If the wind-up animation finishes and the player is still within range, transition to attack state
	if wind_up_timer <= 0.0 and direction.length() <= 50:
		Transitioned.emit(self, "Attack")
		
		
func Physics_Update(delta: float):
	# Your physics update logic here
	var direction = player.global_position - enemy.global_position
	if direction.length() > 70:
		Transitioned.emit(self, "Idle")
