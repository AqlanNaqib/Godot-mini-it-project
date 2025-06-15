extends State2

func enter():
	super.enter()
	animation_player.play("melee_attack")
	# The damage is now handled by a "Call Method Track" in the animation itself.
	# So, you don't need to put the damage line here anymore.
	await animation_player.animation_finished

func transition():
	if owner.direction.length() > 30:
		get_parent().change_state("Follow")
