extends Node2D
#class_name Bullet

@export var Bullet : PackedScene
@export var speed = 0.5
@export var acceleration : float = 15.0

func _physics_process(delta):
	position += transform.x * speed * delta
	
var shot = false
enum state {IDLE, HURT}
var anim_state = state.IDLE
var direction = -1

func update_state():
	if anim_state == state.HURT:
		return
	
func _on_area_2d_area_entered(area):
	if area.get_parent() is Player:
		shot = true
		update_state()
		GameManager.kill_player()
		print("You got shot")
		
func shoot():
	var b = Bullet.instantiate()
	owner.add_child(b)
	b.transform = $Muzzle.global_transform
	print("bullet shot")
	 
#func _process(delta):
	#translate(Vector2.RIGHT * direction * speed)
	


#when we flip the police we need to flip the bullet too
#direction *= -1
