extends Area2D

@export var flip_time = 1
@export var speed = 0.1
@export var acceleration : float = 5.0
var direction = 1

enum state {Crow_idle, ATTACK, HURT}

var anim_state = state.Crow_idle

func update_state():
	if anim_state == state.HURT:
		return
	


# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.wait_time = flip_time


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	translate(Vector2.RIGHT * direction * speed)
	$AnimatedSprite2D.flip_h = direction < 0
	

func _on_timer_timeout():
	direction *= -1
