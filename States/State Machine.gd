extends Node2D

@export var initial_state: State
@export var character : CharacterBody2D
var current_state: State
var states: Dictionary = {}

func _ready():
	#loop over all the children
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.Transitioned.connect(on_child_transition)
			child.character = character
			#Connect to interrupt signal
			child.connect("interupt_state", on_state_interrupt_state)
			#
		else:
			push_warning("Child" + child.name + "is not a State for StateMachine")
			
	if initial_state:
		initial_state.Enter()
		current_state = initial_state
		
		
		#func _ready():
	#for child in get_children():
		#if(child is State):
			#states.append(child)
			#
				##Set the states up with what they need to function
			#child.character = character
			#child.playback = animation_tree["parameters/playback"]
			#
			## Connect to interrupt signal
			#child.connect("interupt_state", on_state_interrupt_state)
			#
		#else:
			#push_warning("Child" + child.name + "is not a State for CharacterStateMachine")

func _process(delta):
	if current_state:
		current_state.Update(delta)

func _physics_process(delta):
	if current_state:
		current_state.Physics_Update(delta)
		
#takes in the State that called it, and the new state it wants to transition to
func on_child_transition(state, new_state_name):
	#check if the state calling it is not the current state
	if state != current_state:
		return
	
	#grab new state from states dictionary
	var new_state = states.get(new_state_name.to_lower())
	#make sure it exists
	if !new_state:
		return
	
	if current_state:
		current_state.Exit()
		
	new_state.Enter()
	current_state = new_state
	
func switch_states(new_state : State):
	if(current_state != null):
		current_state.Exit()
		current_state.next_state = null
		
	current_state = new_state

	current_state.Enter()

func _input(event : InputEvent):
	current_state.state_input(event)
	
func on_state_interrupt_state(new_state : State):
	switch_states(new_state)
