extends Node2D

var state = "close"
var player_in_area = false

var items = preload("res://SCENES/chest_collectable.tscn")

@export var pickup_scene: PackedScene  
@export var first_item: InvItem
@export var sec_item: InvItem
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

func drop_items():
	await get_tree().create_timer(0.0).timeout
	var first_item_instance = pickup_scene.instantiate()
	first_item_instance.rotation = rotation
	first_item_instance.global_position = $Marker2D.global_position
	get_parent().add_child(first_item_instance)

	
	var sec_item_instance = pickup_scene.instantiate()
	sec_item_instance.rotation = rotation
	sec_item_instance.global_position = $Marker2D.global_position
	get_parent().add_child(sec_item_instance)
	


func _on_pickable_area_body_entered(body: PhysicsBody2D):
	if body.has_method("player"):
		player_in_area = true
		player = body


func _on_pickable_area_body_exited(body: PhysicsBody2D):
	if body.has_method("player"):
		player_in_area = false
		player = false
