extends Node2D

var state = "close"
var player_in_area = false

var items = preload("res://SCENES/chest_collectable.tscn")

@export var item1: InvItem
@export var item2: InvItem
@export var item3: InvItem
@export var item4: InvItem
@export var item5: InvItem
@export var item6: InvItem
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
	
	await get_tree().create_timer(0.0).timeout
	var item3_instance = items.instantiate()
	item3_instance.rotation = rotation
	item3_instance.global_position = $Marker2D.global_position
	get_parent().add_child(item3_instance)
	player.collect(item3)
	
	await get_tree().create_timer(0.0).timeout
	var item4_instance = items.instantiate()
	item4_instance = rotation
	item4_instance.global_position = $Marker2D.global_position
	get_parent().add_child(item4_instance)
	player.collect(item4)
	
	await get_tree().create_timer(0.0).timeout
	var item5_instance = items.instantiate()
	item5_instance = rotation
	item5_instance.global_position = $Marker2D.global_position
	get_parent().add_child(item5_instance)
	player.collect(item5)
	
	await get_tree().create_timer(0.0).timeout
	var item6_instance = items.instantiate()
	item6_instance = rotation
	item6_instance.global_position = $Marker2D.global_position
	get_parent().add_child(item6_instance)
	player.collect(item6)
