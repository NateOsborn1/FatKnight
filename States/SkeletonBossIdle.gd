extends State1

@onready var collision = $"../../PlayerDetection/CollisionShape2D"
@onready var progress_bar : ProgressBar = $"../../UI/ProgressBar"
#@onready var progress_bar = $UI/ProgressBar


var player_entered: bool = false:
	set(value):
		player_entered = value
		collision.set_deferred("disabled", value)
		progress_bar.set_deferred("visibile", value)

func _on_player_detection_body_entered(body):
	#if player enters, turn off detection and set progress bar as visible
	player_entered = true
	progress_bar.visible = true
	get_tree().call_group("LockedDoor","Locked")
	print("door locked from boss")
	
func transition():
	if player_entered:
		get_parent().change_state("Follow")
