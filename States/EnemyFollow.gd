extends State
class_name EnemyFollow

@export var enemy: CharacterBody2D
@export var move_speed := 40.0
@export var acceleration : float = 20.0
var player: Player

func Enter():
	player = get_tree().get_first_node_in_group("Player")

func Physics_Update(delta: float):
	#var direction = player.global_position - enemy.global_position

	var direction_x = player.global_position.x - enemy.global_position.x
	# Create a Vector2 using only the X-component of the direction
	var direction = Vector2(direction_x, 0)
	# Normalize the direction vector
	direction = direction.normalized()
	# Set the enemy's velocity using the normalized direction and move speed
	enemy.velocity = direction * move_speed * acceleration
	
	if direction_x < 0:
		$"../../AnimatedSprite2D".flip_h = false
	#else:
	elif direction_x > 0.5:
		$"../../AnimatedSprite2D".flip_h = true

#if outside some difference, move the enemy to the player
	if direction.length() > 10:
		enemy.velocity = direction.normalized() * move_speed
	else:
		enemy.velocity.x = 0
	# Move only if the player is far enough
	if direction.length() < 50:
		#print("windup transition")
		Transitioned.emit(self,"EnemyWindup")
	
	#if abs(direction.x) > 15:
		#enemy.velocity.x = horizontal_direction * move_speed
	#else:
		#enemy.velocity.x = 0
	if direction.length() > 60:
		Transitioned.emit(self,"idle")

	# Transition to "idle" state if the player is close enough
	#if abs(direction.x) <= 5:
		#Transitioned.emit(self, "idle")
