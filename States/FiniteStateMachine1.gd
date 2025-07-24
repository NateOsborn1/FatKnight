extends Node2D

var current_state: State1
var previous_state: State1

func _ready():
	current_state = get_child(0) as State1
	previous_state = current_state
	current_state.enter()


func change_state(state):
	current_state = find_child(state) as State1
	current_state.enter()
	
	previous_state.exit()
	previous_state = current_state
