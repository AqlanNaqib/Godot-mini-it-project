extends StaticBody2D


func _ready():
	fall_from_tree()

func _physics_process(delta):
	pass

func fall_from_tree():
	$AnimationPlayer.play("falling_from_tree")
	await get_tree().create_timer(1.5).timeout
	$AnimationPlayer.play("fade")
	print("+1 apples")
	await get_tree().create_timer(0.2).timeout
	queue_free()
