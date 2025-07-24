extends State

@export var return_state : State
@export var return_animation : String = "Walk"
@export var attack1_name : String = "attack1"
@export var attack2_name : String = "attack2"
@export var attack2_animation : String = "attack2"
@export var attack1_animation: String = "attack1"

@onready var timer : Timer = $Timer

func Enter():
	playback.travel(attack1_animation)
	
func state_input(event : InputEvent):
	if(event.is_action_pressed("Attack 1")):
		
		timer.start()

func _on_animation_tree_animation_finished(anim_name):
	if(anim_name == attack1_name):
		if(timer.is_stopped()):
			next_state = return_state
			playback.travel(return_animation)
		else:
			playback.travel(attack2_animation)
			
	if(anim_name == attack2_name):
		next_state = return_state
		playback.travel(return_animation)
