extends CharacterBody2D
#@export var rate_of_fire = 0
@export var speed: float = 90
@export_enum("None", "Physical", "Soul", "Spell") var damage_type
@export var ATK : int = 1
#@export var Bullet : PackedScene
#var enemy: PoliceEnemy
#var player: Player
var move_direction: Vector2
var direction


func _physics_process(delta):
	velocity += direction * speed * delta
	move_and_collide(velocity)
	#move_and_slide()
	
	
func _on_character_body_2d_body_entered(body):
			## Check if the body has a DamageHandler child
	var damage_handler = body.get_node_or_null("PlayerDamageHandler")
	if damage_handler:
		damage_handler.effective_damage(damage_type, ATK)
		queue_free()
	if body.get_name() == "TileMap":
		print("tilemapname")
	if body.is_in_group("TileMap"):
		print("tilemapgroup")
	var tilemap = body.get_node_or_null("TileMap")
	if tilemap: 
		print("nodeornull") 
		queue_free()
	#if body.is_in_group("Player"):
		 ## Handle player damage or other effects
		#GameManager.kill_player()
		#queue_free()
	#if body.is_in_group("TileMap"):
	## Remove the bullet from the scene after collision
		#queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

#extends Area2D
#
#@export_enum("None", "Physical", "Soul", "Spell") var damage_type
#@export var ATK : int = 1
#var direction = Vector2.RIGHT
#var speed : int = 300
#
#func _physics_process(delta):
	#position += direction * speed * delta
#
#func _on_visible_on_screen_notifier_2d_screen_exited():
	#queue_free()
#
#
#func _on_body_entered(body):
		## Check if the body has a DamageHandler child
	#var damage_handler = body.get_node_or_null("DamageHandler")
	#if damage_handler:
		#damage_handler.effective_damage(damage_type, ATK)
		#
	#queue_free()  # Remove the bullet after it hits something
