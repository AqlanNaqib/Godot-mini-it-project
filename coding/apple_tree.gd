extends Node2D

var state = "no_apples"
var player_in_area = false

var apple = preload("res://SCENES/apple_collectable.tscn")

@export var item: InvItem # This should be the InvItem resource for the apple
var player = null

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
		player = body

func _on_pickable_area_body_exited(body: PhysicsBody2D):
	if body.has_method("player"):
		player_in_area = false

func _on_growth_timer_timeout():
	if state == "no_apples":
		state = "apples"

func drop_apple():
	# You're instantiating an apple_collectable.tscn, which presumably has a Collectable.gd script.
	# The Collectable.gd script has a 'collect' method that takes an 'Inv' object.
	# So, when the apple_instance is created, it should then be added to the scene,
	# and the player's collision with it will trigger its 'collect' method
	# which will then add it to the inventory.
	# So, player.collect(item) here is likely redundant or incorrect if apple_collectable.tscn
	# handles its own collection via its Area2D.

	# It seems like you want the apple to be instantly collected by the player when dropped.
	# In that case, instead of instantiating the scene and letting it be picked up,
	# you can directly add the 'item' (InvItem resource) to the inventory.

	# Option 1: Instantly add to inventory without visual drop
	if Globals.player_inventory:
		Globals.player_inventory.insert(item)
		print("+1 ", item.name)
		state = "no_apples" # Reset state immediately
		$growth_timer.start() # Restart growth timer immediately
	else:
		printerr("Globals.player_inventory is null! Cannot add item from AppleTree.")
		
	# Option 2 (if you want the visual drop AND collection):
	# The apple_collectable.tscn should have an Area2D and a script (like Collectable.gd)
	# that handles adding itself to the inventory when the player touches it.
	# In this case, you would NOT call player.collect(item) here, but rather
	# just instantiate and place the apple_instance.

	# For now, let's go with Option 1 for simplicity and direct collection:
	# If you want the visual drop, you'll need to make sure the apple_collectable.tscn
	# handles its own collection logic (e.g., has an Area2D and a script like Collectable.gd
	# that triggers on player body_entered and calls inv.insert then queue_free).
	# If that's the case, remove the Globals.player_inventory.insert(item) from here.

	# Assuming you want immediate collection by the player script:
	# This part of the code is simplified to directly add to inventory.
	# If you want the apple to physically drop and then be picked up,
	# remove this `Globals.player_inventory.insert(item)` and make sure your
	# `apple_collectable.tscn` has its own `Area2D` and `collect` script.
	
	# After dropping, always start the timer for regrowth.
	await get_tree().create_timer(0.0).timeout # Small delay for consistency
	if Globals.player_inventory:
		Globals.player_inventory.insert(item) # This item is the InvItem resource linked to the AppleTree
		print("+1 ", item.name)
	else:
		printerr("Globals.player_inventory is null! Cannot add item from AppleTree.")
	
	# The rest of your fall_from_tree logic is for the visual of the dropped item,
	# which might be on the apple_collectable.tscn itself.
	# For the tree, we just reset its state and timer.
	await get_tree().create_timer(3).timeout # Wait for growth time
	$growth_timer.start() # Restart growth timer for next apple
