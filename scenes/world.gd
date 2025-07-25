extends Node2D

#var level_parameters := {
	#"player_current_health": 0#GameManager.current_health
#}
#
#func load_level_parameters(new_level_parameters, Dictionary):
	#level_parameters = new_level_parameters

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_inventory_gui_closed():
	get_tree().paused = false
	

func _on_inventory_gui_opened():
	get_tree().paused = true
	
