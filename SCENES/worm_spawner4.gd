extends Node2D
 
@onready var player = owner.get_parent().find_child("player")
@export var mini_worm_node : PackedScene
 
func _on_timer_timeout():
	spawn()
 
func spawn():
	var mini_worm = mini_worm_node.instantiate()
	mini_worm.position = player.position
	get_tree().current_scene.call_deferred("add_child", mini_worm)
