extends CharacterBody2D
var player = null
var Bullet = preload("res://scenes/entities/bullet_1.tscn")
@export var speed = 10
var can_shoot = true

#connect position to script with onready var, apply to police
@onready var spawnpos = $Spawnpos

func _on_detection_body_entered(body):
	if body.is_in_group("Player"):
		player = body

func _physics_process(delta):
	var movement = 1
	
	if player:
		movement = position.direction_to(player.position) * speed
		
	move_and_slide()

#this will let us set can_shoot to true
func _on_timer_timeout():
	can_shoot = true
	#detect if player is there
	if player != null:
		shoot()
		
func shoot():
	if can_shoot:
		#make an instance of bullet
		var bullet = Bullet.instantiate()
		bullet.position = spawnpos.global_position
		#add bullet to the scene
		get_parent().add_child(bullet)
		
		$Shootspeed.start()
		can_shoot = false
