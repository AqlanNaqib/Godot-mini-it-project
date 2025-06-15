extends Node2D

var state = "close"
var player_in_area = false

var items = preload("res://SCENES/chest_collectable.tscn") # This is likely a visual template

@export var item1: InvItem # These should be the InvItem resources
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
	if !Globals.player_inventory:
		printerr("Globals.player_inventory is null! Cannot add items from Chest.")
		return

	# Assuming you want to add item1 to inventory 5 times
	for i in range(5):
		Globals.player_inventory.insert(item1)
		print("Added 1x ", item1.name, " from chest.")
		# If you want a visual instantiation and fall, this code belongs on the chest_collectable.tscn itself
		# and it would then handle its own collection via Area2D.
		# For now, immediate insertion into inventory.

	# Add item2 once
	Globals.player_inventory.insert(item2)
	print("Added 1x ", item2.name, " from chest.")

	# No need for these if items are instantly added to inventory
	# await get_tree().create_timer(0.0).timeout
	# var item2_instance = items.instantiate()
	# item2_instance.rotation = rotation
	# item2_instance.global_position = $Marker2D.global_position
	# get_parent().add_child(item2_instance)
	# player.collect(item2) # This would be redundant if added above
