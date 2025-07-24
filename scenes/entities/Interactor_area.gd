extends Area2D

#https://youtu.be/AiRQV0QMhVY
@export var interactor: Node2D
@export var interaction_action: StringName = "interact"

var selected_Interactable: Interactable
var nearby_Interactables: Array[Interactable]


# Called when the node enters the scene tree for the first time.
func _ready():
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _input(event : InputEvent):
	if(event.is_action_pressed(interaction_action)):
		if(selected_Interactable != null):
			selected_Interactable.interact(interactor)

func _on_area_entered(area: Area2D):
	if(area is Interactable):
		nearby_Interactables.push_back(area)
		
		if(selected_Interactable == null):
			selected_Interactable = nearby_Interactables[0]

func _on_area_exited(area: Area2D):
	if(area is Interactable):
		nearby_Interactables.erase(area)
		
		selected_Interactable.stop_interaction(interactor)
		
		if(nearby_Interactables.size() > 0):
			selected_Interactable = nearby_Interactables[0]
		
