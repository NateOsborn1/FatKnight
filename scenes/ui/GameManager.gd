extends Node

var score = 0
var level = 1
#var demo = "demo"
var current_checkpoint : Checkpoint
var player : Player
var deaths = 0
var soul_count = 10
var max_health: int = 3
#var current_health = 3
var health : int 

#@onready var hunger_progress_bar : TextureProgressBar = player.get_tree().get_node("HungerBar")
#@onready var soul_progress_bar : TextureProgressBar = player.get_tree().get_node("SoulBar")

func _ready():
	#current_health = max_health
	health = 3

func set_player_health(amount: int): 
	pass
	#current_health = current_health + amount

func get_player_health() -> int:
	return health
	
func respawn_player():
	GameManager.deaths += 1
	health = max_health
	if current_checkpoint != null: 
		player.position = current_checkpoint.global_position

func kill_player():
	#current_health = max_health
	#player.hunger_progress_bar.value = current_health
	#player.soul_progress_bar.value = soul_count
	#print(current_health)
	respawn_player()

