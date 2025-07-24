extends Area2D

@export_enum("None", "Physical", "Soul", "Spell") var damage_type
@export var ATK : int = 1

func _ready():
	monitoring = false

func _on_body_entered(body):
		# Check if the body has a DamageHandler child
	var damage_handler = body.get_node_or_null("DamageHandler")
	if damage_handler:
		damage_handler.effective_damage(damage_type, ATK)
		

