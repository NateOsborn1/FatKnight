extends State
class_name HitState

@onready var timer : Timer = $Timer

@export var damageable : Damageable
#@export var character_state_machine : CharacterStateMachine
@export var dead_state : State
@export var dead_animation : String = "dead animation"
@export var hit_animation : String = "hit animation"
@export var knockback_speed : float = 100.0
@export var return_state : State  

func _ready():
	damageable.connect("on_hit", on_damageable_hit)

func Enter():
	timer.start()

func Exit():
	character.velocity = Vector2.ZERO

func on_damageable_hit(node : Node2D, damage_amount : int, knockback_direction : Vector2):
	if(damageable.health > 0):
		character.velocity = knockback_speed * knockback_direction
		emit_signal("interupt_state", self)
		playback.travel(hit_animation)
	else:
		emit_signal("interupt_state", dead_state)
		playback.travel(dead_animation)
		
				#$"../../AnimationPlayer".play("hit")
	#else:
		#emit_signal("interupt_state", dead_state)
		#$"../../AnimationPlayer".play("dead")

func _on_timer_timeout():
	next_state = return_state


