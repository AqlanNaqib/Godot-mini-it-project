extends Node2D

var state = "no_apples"
var player_in_area = false

var apple = preload("res://SCENES/apple_collectable.tscn")

func _ready():
	if state == "no_apples":
		$growth_timer.start()
		
func _process(delta):
	if state == "no_apples":
		$AnimatedSprite2D.play("no_apples")
	elif state == "apples":
		$AnimatedSprite2D.play("apples")
		if player_in_area:
			if Input.is_action_just_pressed("interact"):
				state = "no_apples"
				drop_apple()

func _on_pickable_area_body_entered(body: PhysicsBody2D):
	if body.has_method("player"):
		player_in_area = true

func _on_pickable_area_body_exited(body: PhysicsBody2D):
	if body.has_method("player"):
		player_in_area = false

func _on_growth_timer_timeout():
	if state == "no_apples":
		state = "apples"

func drop_apple():
	var apple_intance = apple.instantiate()
	apple_intance.global_position = $Marker2D.global_position
	get_parent().add_child(apple_intance)
	
	await get_tree().create_timer(3).timeout
	$growth_timer.start()
