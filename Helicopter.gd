extends Area2D

@export var flip_time = 6
@export var speed = 0.1
@export var acceleration : float = 5.0
var direction = 1

enum state {IDLE, ATTACK, HURT}

var anim_state = state.IDLE

func update_state():
	if anim_state == state.HURT:
		return
	


# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.wait_time = flip_time


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	translate(Vector2.RIGHT * direction * speed)
	$AnimatedSprite2D.flip_h = direction > 0
	

func _on_timer_timeout():
	direction *= -1

