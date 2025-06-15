extends State2

@export var bullet_node: PackedScene
var can_transition: bool = false

func enter():
	super.enter()
	animation_player.play("ranged_attack")
	await animation_player.animation_finished
	shoot()
	can_transition = true

func shoot():
	var bullet = bullet_node.instantiate()
	bullet.position = owner.position
	get_tree().current_scene.add_child(bullet)
	# THIS IS THE CRUCIAL LINE:
	if owner.player: # Ensure the enemy has a player reference
		bullet.set_target_player(owner.player) # Call the new function here!

func transition():
	if can_transition:
		can_transition = false
		get_parent().change_state("Dash")
