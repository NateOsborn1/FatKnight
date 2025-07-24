extends Area2D

const FILE_BEGIN = "res://scenes/levels/level_"
var changing_scene : bool = false
#var new_health : int
#var player_health = GameManager.current_health
var player_health = GameManager.health

func _on_body_entered(body):
	if body.is_in_group("Player"):
		changing_scene = true
		#GameManager.current_health = new_health
		##GameManager.current_health = GameManager.get_player_health()
		call_deferred("change_level")
		#var current_scene_file = get_tree().current_scene.scene_file_path
		#var next_level_number = current_scene_file.to_int() + 1
		#print(body)
#
		#var next_level_path = FILE_BEGIN + str(next_level_number) + ".tscn"
		#get_tree().change_scene_to_file(next_level_path)
		#GameManager.level += 1

func transfer_data_between_scenes(old_scene, new_scene):
	new_scene.player_health = old_scene.player_health
	print("changed scenes and updated old scene and new scene health")

func change_level():
	GameManager.level += 1
	#GameManager.current_health = GameManager.level_change_health #this just makes it 0/int #GameManager.get_player_health()
	var current_scene_file = get_tree().current_scene.scene_file_path
	var next_level_number = current_scene_file.to_int() + 1
	
## automates the level change system as long as next level is +1 from the previous file name
	var next_level_path = FILE_BEGIN + str(next_level_number) + ".tscn"
	get_tree().change_scene_to_file(next_level_path)
	print("changed level")
	print(GameManager.health)
	#print(GameManager.current_health)
	#transfer_data_between_scenes(current_level, next_level)
	
	
	
#error
#this function can't be used during the in/out signal.
#removing a collisionobject node during a physics callback is not allowed and will cause undesired behavior. Remove with call_deferred() instead.
#
