extends Label

@onready var AnimPlayer = $AnimationPlayer


# Called when it's loaded for the first time
func _ready():
	text = "WELCOME TO LEVEL: " + str(GameManager.level)
	AnimPlayer.play("WelcomeLevel")

#func _process(delta):
	#self.rect_global_position = ( (Player.get_global_position()/2) + Vector2(0,-150) )
	##wanted to set the position dynamically to the player's location, but not necessary if node is under player tree
