extends Area2D

@export_enum("None", "Physical", "Soul", "Spell") var damage_type
@export var ATK : int = 1
var direction = Vector2.RIGHT
var speed : int = 300


#signal on_hit(node : Node2D, damage_taken : int, knockback_direction : Vector2)

func _physics_process(delta):
	position += direction * speed * delta
	
#FUNCTIONAL CODE
func _on_body_entered(body):
		# Check if the body has a DamageHandler child
	var damage_handler = body.get_node_or_null("DamageHandler")
	if damage_handler:
		damage_handler.effective_damage(damage_type, ATK)
		
	queue_free()  # Remove the bullet after it hits something
	
	
	
	
	
	
	
	##body.take_damage()
	#if body.has_method("take_damage"):
		#body.take_damage()
		#print(damage)
		##apply_damage(body)
	#else:
		#for child in body.get_children():
			#if child.has_method("hit"):
					#var direction_to_damageable = (child.global_position - get_parent().global_position)
					#var direction_sign = sign(direction_to_damageable.x)
	#
	#
					#if(direction_sign > 0):
						#child.hit(damage, Vector2.RIGHT)
					#elif(direction_sign <0):
						#child.hit(damage, Vector2.LEFT)
					#else:
						#child.hit(damage, Vector2.ZERO)
					#print(damage)
				#
				#
				##apply_damage(child)
				##break

#func apply_damage(target):
	##function hit isn't on base of these characterbody2ds
	#var direction_to_damageable = (target.global_position - get_parent().global_position)
	#var direction_sign = sign(direction_to_damageable.x)
	#
	#
	#if(direction_sign > 0):
		#target.hit(damage, Vector2.RIGHT)
	#elif(direction_sign <0):
		#target.hit(damage, Vector2.LEFT)
	#else:
		#target.hit(damage, Vector2.ZERO)
	#print(damage)

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()






##CODE TAKES DAMAGE BUT SKELETON BOSS TAKES 10 DAMAGE PER NODE IN SCRIPT
#func _on_body_entered(body):
	##body.take_damage()
	#for child in body.get_children():
		#if child is Damageable:# or body.take_damage():
			##get direction from sword to the body
			#var direction_to_damageable = (body.global_position - get_parent().global_position)
			#var direction_sign = sign(direction_to_damageable.x)
			#
			#if(direction_sign > 0):
				#child.hit(damage, Vector2.RIGHT)
			#elif(direction_sign <0):
				#child.hit(damage, Vector2.LEFT)
			#else:
				#child.hit(damage, Vector2.ZERO)
		#elif !child is Damageable:
			#body.take_damage()
#
		#print(damage)
