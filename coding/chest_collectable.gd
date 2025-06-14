extends StaticBody2D


func _ready():
	fall_from_chest()

func _physics_process(delta):
	pass

func fall_from_chest():
	$AnimationPlayer.play("come_out")
	$AnimationPlayer2.play("come_out")
	await get_tree().create_timer(1.5).timeout
	$AnimationPlayer.play("fade")
	$AnimationPlayer2.play("fade")
	await get_tree().create_timer(0.2).timeout
	queue_free()
