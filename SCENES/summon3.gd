extends State3
 
@export var skeleton_node: PackedScene
var can_transition : bool
 
 
func enter():
	super.enter()
	can_transition = false
 
	animation_player.play("summon")
	await animation_player.animation_finished 
 
	can_transition = true
 
func spawn():
	var skeleton = skeleton_node.instantiate()
 
	skeleton.position = global_position + Vector2(40,40)
 
	get_tree().current_scene.call_deferred("add_child",skeleton)
 
func transition():
	if can_transition:
		get_parent().change_state("Attack")
