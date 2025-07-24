extends State
class_name GroundState
#https://youtu.be/fuGiJdMrCAk?t=1375



@export var attack_state : State
@export var attack1_animation: String = "attack1"
@export var air_state : State
@export var jump_velocity = -260.0
@export var jump_animation : String = "jump"
@onready var buffer_timer : Timer = $BufferTimer

func state_process(delta):
	if(!character.is_on_floor() && buffer_timer.is_stopped()):
		next_state = air_state
		
func state_input(event : InputEvent):
	if(event.is_action_pressed("jump")):
		jump()
	
	if(event.is_action_pressed("Attack 1")):
		attack()

func jump():
	character.velocity.y = jump_velocity
	next_state = air_state
	playback.travel(jump_animation)

func attack():
	next_state = attack_state
	
	
