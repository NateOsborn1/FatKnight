extends State
class_name EnemyIdle

@export var enemy: CharacterBody2D
@export var move_speed := 10.0


var move_direction: Vector2
var wander_time: float

var player: Player

func randomize_wander():
	# Generate a random value for horizontal movement only
	var horizontal_direction = randf_range(-1, 1)
	
	# Set move_direction with only the x-component randomized
	move_direction = Vector2(horizontal_direction, 0).normalized()
	wander_time = randf_range(1, 3)

func Enter():
	player = get_tree().get_first_node_in_group("Player")
	randomize_wander()

func Update(delta: float):
	if wander_time > 0:
		wander_time -= delta
	else:
		randomize_wander()

func Physics_Update(delta: float):
	if enemy:
		# Only apply movement along the x-axis
		enemy.velocity.x = move_direction.x * move_speed
	var direction = player.global_position - enemy.global_position
	
	
	if direction.length() < 30:
		Transitioned.emit(self,"Follow")
		#https://youtu.be/ow_Lum-Agbs?t=412
		
	if enemy.velocity.length() > 0:
		#add a walk animation for police and change idle to move
		$"../../AnimationPlayer".play("idle")

func _on_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		Transitioned.emit(self, "Follow")
		print("entered")

func _on_area_2d_body_exited(body):
	if body.is_in_group("Player"):
		Transitioned.emit(self, "Idle")
		print("exited")
