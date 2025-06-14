extends Node2D

var state = "close"
var player_in_area = false

var items = preload("res://SCENES/chest_collectable.tscn")

@export var item1: InvItem
@export var item2: InvItem

var player = null

func _ready():
	pass
		
func _process(delta):
	if player_in_area and Input.is_action_just_pressed("interact"):
		if state == "close":
			state = "open"
			drop_items()
	
	if state == "close":
		$AnimatedSprite2D.play("close")
	elif state == "open":
		$AnimatedSprite2D.play("open")

func _on_pickable_area_body_entered(body: PhysicsBody2D):
	if body.has_method("player"):
		player_in_area = true
		player = body



func _on_pickable_area_body_exited(body: PhysicsBody2D):
	if body.has_method("player"):
		player_in_area = false
	
		
func drop_items():
	for i in range(5):
		await get_tree().create_timer(0.0).timeout
		var item1_instance = items.instantiate()
		item1_instance.rotation = rotation
		item1_instance.global_position = $Marker2D.global_position
		get_parent().add_child(item1_instance)
		player.collect(item1)
	
	await get_tree().create_timer(0.0).timeout
	var item2_instance = items.instantiate()
	item2_instance.rotation = rotation
	item2_instance.global_position = $Marker2D.global_position
	get_parent().add_child(item2_instance)
	player.collect(item2)
