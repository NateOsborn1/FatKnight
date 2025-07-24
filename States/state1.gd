extends Node2D
class_name State1

@onready var debug = owner.find_child("debug")
@onready var player = owner.get_parent().find_child("Nitefsm")
@onready var animation_player = owner.find_child("AnimationPlayer")


# Called when the node enters the scene tree for the first time.
func _ready():
	set_physics_process(false)

func enter():
	set_physics_process(true)

func exit():
	set_physics_process(false)

func transition():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	transition()
	debug.text = name
