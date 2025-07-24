extends CharacterBody2D

class_name Player
@export var speed = 50.0
@export var sprint_speed_multiplier = 1.3  # 30% increase in speed when sprinting
@export var acceleration : float = 15.0
@export var inventory: Inventory
var soul_count = GameManager.soul_count

@onready var soul_counter : Label = $UI/HungerBar/Sprite2D/SoulCounter
@onready var animation_tree : AnimationTree =  $AnimationTree 
@onready var sprite : Sprite2D = $Sprite2D
@onready var animation_player = $AnimationPlayer
@onready var character_state_machine : CharacterStateMachine = $CharacterStateMachine
@onready var punch : Node2D = $Weapon
@onready var base_enemy = get_tree().current_scene.find_child("BaseEnemy") #maybe a typo in BaseEnemy
@onready var PlayerDamageHandler = $PlayerDamageHandler

@export var base_bullet_node: PackedScene
@export  var fireball_node: PackedScene
@onready var hunger_progress_bar : TextureProgressBar = $UI/HungerBar
@onready var soul_progress_bar : TextureProgressBar = $UI/SoulBar
var fireball_rotation = 0

@export var damage_type: int = 2:
	set(value):
		damage_type = value
		$DamageType.text = ["Physical", "Soul", "Spell"][value - 1]

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	GameManager.player = self
	GameManager.get_player_health()
	#print(GameManager.get_player_health())
	#GameManager.player = self
	inventory.use_item.connect(use_item)
	animation_tree.active = true
	
func update_direction(direction):
	if direction > 0:
		sprite.flip_h = false
		punch.scale = Vector2(1,1)
			
	elif direction < 0:
		sprite.flip_h = true
		punch.scale = Vector2(-1,1)
		
func update_animation_parameters():
	var direction = Input.get_axis("left", "right")
	animation_tree.set("parameters/Walk/blend_position", direction)

func _physics_process(delta):
	var direction = Input.get_axis("left", "right")
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	#Dropping through a 1 way platform
	if Input.is_action_just_pressed("down") and is_on_floor():
		position.y += 1

# Get the input direction and handle the movement/deceleration.
	if direction && character_state_machine.check_if_can_move():
		if Input.is_action_pressed("sprint"):  # Check if sprint key (Shift) is pressed
			velocity.x = move_toward(velocity.x, direction * speed * sprint_speed_multiplier, acceleration)
		else:
			#increases speed when left or right
			velocity.x = move_toward(velocity.x, direction * speed, acceleration)
	else:
		#slows us down after inputting left or right
		velocity.x = move_toward(velocity.x, 0, acceleration/2)
	
	update_animation_parameters()
	move_and_slide()
	update_direction(direction)

func _process(delta):
	#hunger_progress_bar.value = PlayerDamageHandler.current_health
	hunger_progress_bar.value = GameManager.health
	soul_progress_bar.value = GameManager.soul_count
	soul_counter.text = str(GameManager.soul_count)
	
	#	text = "SCORE: " + str(GameManager.score)
	
	#higher the y pos, the farther the player can fall before death
	if position.y >= 650:
		GameManager.kill_player()


func _on_hurtbox_area_entered(area):
	if area.has_method("collect"):
		area.collect(inventory)

func cast_fireball():
	var fireball = fireball_node.instantiate()
	fireball.rotate(get_angle_to(get_global_mouse_position()))
	fireball.position = global_position
	fireball.direction = (get_global_mouse_position() - global_position).normalized()
	get_tree().current_scene.call_deferred("add_child", fireball)
	GameManager.soul_count -= 1
	#print(GameManager.soul_count)

func shoot():
	var bullet = base_bullet_node.instantiate()
	bullet.position = global_position
	bullet.rotate(get_angle_to(get_global_mouse_position()))
	bullet.damage_type = damage_type
	bullet.direction = (get_global_mouse_position() - global_position).normalized()
	get_tree().current_scene.call_deferred("add_child", bullet)
	
func _input(event):
	if event.is_action_pressed("Cast1"):
		if GameManager.soul_count > 0:
			cast_fireball()
		else:
			print("Out of Souls, current soul count = " + str(GameManager.soul_count))

	if event.is_action_pressed("Cast2"):
		if GameManager.soul_count > 0:
			shoot()
			GameManager.soul_count += 1
		else:
			print("Out of Souls, current soul count = " + str(GameManager.soul_count))
	#FOR TESTING REMOVE AFTER
	if event.is_action_pressed("ground pound"):
		PlayerDamageHandler.take_damage(1)
		#print_debug(PlayerDamageHandler.current_health)


#IF I WANT TO CHANGE DAMAGE TYPE WITH INPUT
#add in animation of label popping up and down
	if event is InputEventKey:
		if event.keycode == KEY_1:
			#.play("Physical")
			damage_type = 1
		if event.keycode == KEY_2:
			#.play("Soul")
			damage_type = 2
		if event.keycode == KEY_3:
			#.play("Spell")
			damage_type = 3

func add_soul():
	pass

func use_item(item: InventoryItem) -> void:
	if not item.can_be_used(self): return
	item.use(self)
	inventory.remove_last_used_item()
	

	#WIP
#func update_soul_count():
	#soul_count = 0
	#for item in inventory:
		#if item == green_soul:
			#soul_count += 1
	#print("Soul count updated: ", soul_count)


func _on_spikes_h_damage_to_player():
	PlayerDamageHandler.take_damage(1)


func _on_spikes_v_damage_to_player():
	PlayerDamageHandler.take_damage(1)
