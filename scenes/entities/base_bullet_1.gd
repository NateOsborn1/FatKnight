extends Area2D

@export_enum("None", "Physical", "Fire", "Electric") var damage_type
@export var ATK : int = 200


func _physics_process(delta):
	position.x += 500 * delta

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func _on_body_entered(body):
	body.effective_damage(damage_type, ATK)
