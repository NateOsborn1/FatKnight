extends Node2D
#FOR PRINT IN GAME 

#1 damage is default, 1 defense is immune
#refactoring to replace all ATK with atk, pass it as a parameter through defense, and remove input function since it can be called from weapons

#define attack and modifier properties
#@export_range(0,1) var ATK: int = 1
@export_range(0,1) var DEF: int = 1

@export_range(0,1) var elemental_modifier: int = 0
#@export_range(0,1) var crit_chance: float = 0

@export_enum("None", "Physical", "Soul", "Spell") var type_resistance
@export_enum("None", "Physical", "Soul", "Spell") var type_effective
#0 = None, 1 = Physical, 2 = Soul, 3 = Spell
@export var floating_number : PackedScene


func defense(atk) -> int:
	if atk == 0 and DEF == 0:
		return 0#.0
	
	return ( atk / (atk + DEF) )
	
func elemental_damage(data) -> int:
	if data == type_resistance:
		$AnimationPlayer.play("resistant")
		elemental_modifier = 1
	else: 
		elemental_modifier = 0
	return (1 - elemental_modifier)

#NOT SURE IF I WANT EFFECTIVENESS IN GAME.
func effectiveness(data):
	if data == type_effective:
		$AnimationPlayer.play("effective")
		return 1
	else:
		return 1

func spawn_floating_number(damage):
	var number = floating_number.instantiate()
	number.position = global_position
	
	number.find_child("Label").text = "%.f" % damage    #"%.2f" % damage or "%.f" % damage
	number.find_child("AnimationPlayer").play("normal")
	get_tree().current_scene.add_child(number)

func effective_damage(data, atk) -> int:
	var damage: int = atk * defense(atk) * elemental_damage(data) * effectiveness(data)
	
	spawn_floating_number(damage)
	return damage
