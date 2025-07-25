extends Control

@export var health_changed_label : PackedScene 
@export var damage_color : Color = Color.DARK_RED
@export var heal_color : Color = Color.DARK_GREEN
#aquamarine is good color for soul color

# Called when the node enters the scene tree for the first time.
func _ready():
	#GameManager.connect("on_health_changed", on_signal_health_changed)
	pass

func on_signal_health_changed(node : Node2D, amount_changed : int):
	var label_instance : Label = health_changed_label.instantiate()
	node.add_child(label_instance)
	label_instance.text = str(amount_changed)
	
	if(amount_changed >= 0):
		label_instance.modulate = heal_color
	else:
		label_instance.modulate = damage_color
