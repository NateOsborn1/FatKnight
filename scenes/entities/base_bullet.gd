extends Area2D

@export_enum("None", "Physical", "Soul", "Spell") var damage_type
@export var ATK : int = 1
var direction = Vector2.RIGHT
var speed : int = 300

func _physics_process(delta):
	position += direction * speed * delta

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func _on_body_entered(body):
		# Check if the body has a DamageHandler child
	var damage_handler = body.get_node_or_null("DamageHandler")
	if damage_handler:
		damage_handler.effective_damage(damage_type, ATK)
		
	queue_free()  # Remove the bullet after it hits something
	
	#alternate and untested way to check
#func _on_body_entered(body):
	#var child = body.get_child(0)  # get the first child
	#if child and child.has_method("effective_damage"):
		#child.effective_damage(damage_type, ATK)
	
	
	#if damagehandler script was in body then
	#body.effective_damage(damage_type, ATK)
