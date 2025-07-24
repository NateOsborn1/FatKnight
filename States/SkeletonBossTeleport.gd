extends State1

var can_transition: bool = false


func enter():
	super.enter()
	animation_player.play("skill1")
	await animation_player.animation_finished
	can_transition = true

func teleport():
	var direction : Vector2
	direction = player.position - global_position
	#owner.position = player.position + Vector2.RIGHT * 40 + Vector2.UP * 40
	if direction.x < 0:
		owner.position = player.position + Vector2.LEFT * 40 + Vector2.UP * 40
	else:
		owner.position = player.position + Vector2.RIGHT * 40 + Vector2.UP * 40

func transition():
	if can_transition:
		get_parent().change_state("Attack")
		can_transition = false
