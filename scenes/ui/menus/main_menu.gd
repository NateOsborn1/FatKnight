extends Control

signal start_game()
@onready var buttons_v_box = %ButtonsVbox

func _ready() -> void:
	focus_button()

func _on_start_game_button_pressed() -> void:
	start_game.emit()
	hide()
	start_game.emit()
	hide()
	get_tree().change_scene_to_file("res://scenes/levels/level_1.tscn")
	
func _on_quit_game_button_pressed() -> void:
	get_tree().quit()

func _on_visibility_changed() -> void:
	if visible:
		focus_button()
		
		
func focus_button() -> void:
	if buttons_v_box: 
		var button: Button = buttons_v_box.get_child(0)
		if button is Button:
		#	button.grab
			pass


#https://youtu.be/EfJ_k-yy1xc 10:46
#https://www.youtube.com/watch?v=EfJ_k-yy1xc&ab_channel=GameDevArtisan


#func _on_start_game() -> void:
	#start_game.emit()
	#get_tree().change_scene_to_file("res://scenes/World.tscn")
	
