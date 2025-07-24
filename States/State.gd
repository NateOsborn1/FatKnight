extends Node2D
class_name State

signal Transitioned
signal interupt_state(new_state : State)

@export var can_move : bool = true
var character : CharacterBody2D
var next_state : State
var playback : AnimationNodeStateMachinePlayback

func state_input(event : InputEvent):
	pass

func Enter():
	pass

func Exit():
	pass

func Update(_delta: float):
	pass

func Physics_Update(_delta: float):
	pass

func state_process(delta):
	pass

