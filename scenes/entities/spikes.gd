extends Node2D
signal damage_to_player

#@onready var PlayerDamageHandler = $PlayerDamageHandler
var on_spikes = false

func _on_area_2d_area_entered(area):
	if area.get_parent() is Player:
		on_spikes = true
		#var data = "Physical"
		#var atk = 1
		emit_signal("damage_to_player")
		#print("hurt")
#		emit_signal("trap_damage", damage)
		
		
		
		
		#GameManager.kill_player()
		#if event.is_action_pressed("ground pound"):
		#get_node("/root/scenes/entities/nitefsm/PlayerDamageHandler").take_damage(1)
		#Player.get_tree().get_child("PlayerDamageHandler").take_damage(1) #says to create an instance of it instead.
		
		#an alternative is to have a signal trigger to take damage for the player.
		
		

