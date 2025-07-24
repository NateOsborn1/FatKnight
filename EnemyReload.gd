extends State
class_name EnemyReload

@export var enemy: CharacterBody2D
@export var attack_range := 50.0

var Bullet = preload("res://scenes/entities/bullet_1.tscn")
var player = null
var animation_player: AnimationPlayer


func Enter():
	player = get_tree().get_first_node_in_group("Player")
	animation_player = get_parent().get_node("../AnimationPlayer")
	animation_player.play("reloading")  # Play the shooting animation
	#out_of_ammo.emit()
	$"../../Reloading".start()


func Update(delta: float):
	animation_player = get_parent().get_node("../AnimationPlayer")
	
	
	# Check distance between enemy and player
	var distance_to_player = enemy.global_position.distance_to(player.global_position)
	if distance_to_player > attack_range:
		# Player is out of attack range, transition back to Idle state
		$"../../Timer".stop()
		player = null
		Transitioned.emit(self, "Idle")


func Physics_Update(delta: float):
	var direction_x = player.global_position.x - enemy.global_position.x
	
	# Flip the enemy based on the direction to the player
	if direction_x < 0:
		$"../../AnimatedSprite2D".flip_h = false
	elif direction_x > 0:
		$"../../AnimatedSprite2D".flip_h = true


func reload():
	$"../Attack".current_ammo = $"../Attack".max_ammo
	$"../Attack".reloaded = true
	print($"../Attack".current_ammo)
	Transitioned.emit(self, "Attack")


func _on_attack_out_of_ammo():
	$"../Attack".reloaded = false
	$"../../Timer".stop()
	$"../../Reloading".start()
	#animation_player.play("reloading")
	print($"../Attack".current_ammo)


func _on_reloading_timeout():
	$"../../Reloading".stop()
	reload()
