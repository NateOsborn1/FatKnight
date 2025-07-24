extends State
class_name EnemyAttack

@export var enemy: CharacterBody2D
@export var attack_range := 50.0
@export var shooting_interval: float = 0.35  # Duration of the shooting animation

var Bullet = preload("res://scenes/entities/bullet_1.tscn")
var player = null
#var player: Player
var animation_player: AnimationPlayer

var reloaded = true
var can_shoot = true
@export var max_ammo: int = 6
var current_ammo: int = max_ammo
signal out_of_ammo

#connect position to script with onready var, apply to police

func _on_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		player = body

func Enter():
	player = get_tree().get_first_node_in_group("Player")
	animation_player = get_parent().get_node("../AnimationPlayer")
	#if can_shoot:
		#animation_player.play("shooting")  # Play the shooting animation
	shoot()
	$"../../Timer".start()
	#shoot()

func Update(delta: float):
	animation_player = get_parent().get_node("../AnimationPlayer")
	animation_player.play("shooting")  # Play the shooting animation
	
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

#this will let us set can_shoot to true
func _on_timer_timeout():
	can_shoot = true
	#detect if player is there
	if player != null:
		shoot()

func shoot():
	if can_shoot and reloaded and current_ammo != 0:
		#make an instance of bullet
		var bullet = Bullet.instantiate()
		# Set the bullet's position relative to the NPC which is previously set relative to the Player's position
		bullet.position = get_global_position()
		#bullet.global_position = spawnpos.position
		if $"../../AnimatedSprite2D".flip_h:
			# NPC is flipped, spawn bullet offset to the right
			#bullet.global_position = spawnpos.position #+ Vector2(9, 0) 
			bullet.direction = Vector2(1,0)
		else:
			# NPC is not flipped, spawn bullet offset to the left
			#bullet.global_position = spawnpos.position #- Vector2(6, 0)
			bullet.direction = Vector2(-1,0)
		#add bullet to the scene
		current_ammo -= 1
		if current_ammo == 0:
			out_of_ammo.emit()
			Transitioned.emit(self, "Reload")
			
		get_tree().get_root().call_deferred("add_child", bullet)
		#get_parent().add_child(bullet)
		
		
		#reset timer and disable shooting
		$"../../Timer".start()
		can_shoot = false
	else:
		return
#func reload():
	#current_ammo = max_ammo
	#reloaded = true
	#print(current_ammo)
	

#func _on_out_of_ammo():
	#reloaded = false
	#$"../../Timer".stop()
	#$"../../Reloading".start()
	#animation_player.play("reloading")
	#print(current_ammo)


#func _on_reload_timeout():
	#$"../../Reloading".stop()
	#reload()
