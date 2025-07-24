extends Node2D
#FOR PRINT IN GAME 

#1 damage is default, 1 defense is immune
#@onready var death_state : State = $"../FiniteStateMachine1/Death"
@onready var progress_bar = $"../UI/ProgressBar"
@onready var FSM = $"../FiniteStateMachine1"
@export var max_health: int = 25
var current_health: int
#define attack and modifier properties
@export var animation_player : AnimationPlayer
@export_range(0,1) var DEF: int = 0
@export_range(0,1) var elemental_modifier: int = 0

enum DamageType {None, Physical, Soul, Spell}
#enum DamageType {"None", }
@export var type_resistance: DamageType
@export var type_effective: DamageType
#@export_enum("None", "Physical", "Soul", "Spell") var type_resistance
#@export_enum("None", "Physical", "Soul", "Spell") var type_effective
#0 = None, 1 = Physical, 2 = Soul, 3 = Spell
@export var floating_number : PackedScene
@export var dead_animation_name : String = "death"

func _ready():
	current_health = max_health  # Initialize current health to max health

func _process(delta):
	progress_bar.value = current_health * 4

func defense(atk) -> float:
	if atk == 0 and DEF == 0:
		return 0.0
	
	return ( atk / (atk + DEF) )
	
func elemental_damage(data) -> int:
	if data == type_resistance:
		animation_player.play("resistant")
		elemental_modifier = 1
	else: 
		elemental_modifier = 0
	return (1 - elemental_modifier)

#NOT SURE IF I WANT EFFECTIVENESS IN GAME.
func effectiveness(data):
	if data == type_effective:
		animation_player.play("effective")
		return 1
	else:
		return 1

func spawn_floating_number(damage):
	var number = floating_number.instantiate()
	number.position = global_position
	
	number.find_child("Label").text = "%.f" % damage    #"%.2f" % damage or "%.f" % damage
	number.find_child("AnimationPlayer").play("normal")
	get_tree().current_scene.add_child(number)

#Overrides defense if enemy is type_effective to the same damage_type
func effective_damage(data, atk) -> int:
	var damage: int
	if data == type_effective:
		damage = min(atk, 1)  # Limit damage to a maximum of 1
	else:
		damage = atk * defense(atk) * elemental_damage(data)
	#receive_damage(data, atk)
	take_damage(damage)
	return damage

#func effective_damage(data, atk) -> int:
	#var damage: int = atk * defense(atk) * elemental_damage(data) * effectiveness(data)
	#take_damage(damage)
	#return damage

func take_damage(damage: int):
	current_health -= damage
	spawn_floating_number(damage)
	if current_health <= 0:
		FSM.change_state("Death")
		progress_bar.visible = false
		#await find_child("FiniteStateMachine1").change_state("Death")
		#find_child("FiniteStateMachine1").change_state("Death")


#func receive_damage(attack_type: DamageType, atk: int) -> int:
	#var damage = 0;
	#if attack_type == type_effective:
		#damage = min(atk, 1)
	#if attack_type == type_resistance:
		#elemental_modifier = 1
	#else: 
		#elemental_modifier = 0
	#return (1 - elemental_modifier);
	#
	#current_health -= damage
	#spawn_floating_number(damage)
	#if current_health <= 0:
		#die()

	
func _on_animation_tree_animation_finished(anim_name):
	if(anim_name == dead_animation_name): #&& health <= 0):
		#instantiate soul when char dies on their position
		var green_soul = preload("res://scenes/collectable/green_soul.tscn")
		var new_green_soul_object = green_soul.instantiate()
		#set deferred so that it can change scenes without still flushing queries
		#collision.set_deferred("monitoring", false)
		##collision.queue_free()
		await get_tree().process_frame
	#	get_parent().queue_free()
		
		get_tree().current_scene.add_child(new_green_soul_object)
		new_green_soul_object.global_position = global_position
		# character is finished dying, remove from game
		#get_parent().queue_free()
	
	#
	#
	##BASE HOLDER OF DIE FUNCTION, WHEN EXTENDING, CHANGE DEATH LOGIC, LIKE STATE TRANSITION, ANIMATION, SFX
	##instantiate soul when char dies on their position
	#var green_soul = preload("res://scenes/collectable/green_soul.tscn")
	#var new_green_soul_object = green_soul.instantiate()
#
	#await get_tree().process_frame
	#get_tree().current_scene.add_child(new_green_soul_object)
	#new_green_soul_object.global_position = global_position
		## character is finished dying, remove from game
	#get_parent().queue_free()
	##queue_free()  # Remove the entity from the scene
	## Play death animation or sound here if needed
