extends StaticBody2D

class_name Door

@export var required_key_id: String = ""
@export var auto_use_key: bool = true
@export var locked_message: String = "This door is locked. You need a key."
@export var unlocked_message: String = "Door unlocked!"

@onready var collision_shape = $CollisionShape2D
@onready var animated_sprite = $AnimatedSprite2D
@onready var interaction_area = $InteractionArea
@onready var interaction_area_collision = $InteractionArea/CollisionShape2D
@export var next_scene: String = "res://victory.tscn"

var player_in_range: bool = false
var current_player: Player = null # Still good to store the player reference
var is_opening: bool = false
var is_closing: bool = false

signal door_opened
signal door_closed

func _ready():
	pass

func _input(event):
	if event.is_action_pressed("interact") and player_in_range and current_player:
		interact_with_door()

func _on_player_entered(body): 
	if body.has_method("player"): 
		player_in_range = true
		current_player = body as Player # Cast to Player type for better type safety
		

func _on_player_exited(body): 
	if body.has_method("player"):
		player_in_range = false
		current_player = null
		

func interact_with_door():
	if is_opening:
		return  # Already opening

	# The core change: Use Globals.player_inventory
	if try_unlock_with_key():
		open_door()
	


func try_unlock_with_key() -> bool:
	# Check if the global inventory is available
	if not Globals.player_inventory:
		printerr("Door: Globals.player_inventory is null! Cannot check for key.")
		# Do not show a 'locked' message here, it's a system error, not a player's fault.
		return false

	var key_slot_index = find_key_in_inventory() # This will now use Globals.player_inventory internally

	if key_slot_index >= 0: # Key found
		# Use the item through the global inventory
		Globals.player_inventory.use_item_atIndex(key_slot_index)
		# After using, print the unlocked message.
		print(unlocked_message)
		return true
	else:
		# Key not found, message already handled by the caller (interact_with_door) or find_key_in_inventory if you add it there
		return false

func find_key_in_inventory() -> int:
	# Ensure Globals.player_inventory is valid before iterating
	if not Globals.player_inventory:
		printerr("find_key_in_inventory: Globals.player_inventory is null!")
		return -1

	var inventory = Globals.player_inventory # Directly use the global inventory

	for i in range(inventory.slots.size()):
		var slot = inventory.slots[i]
		# Add robust null checks for slot and slot.item to prevent errors
		if slot != null and slot.item != null:
			if slot.item is Key: # Assuming your key items are instances of the 'Key' class
				var key = slot.item as Key
				if key.key_id == required_key_id:
					print("Door: Found required key: ", key.key_id, " at index ", i)
					return i
	print("Door: Required key (ID: ", required_key_id, ") not found in inventory.")
	return -1 # Key not found

func open_door():
	if is_opening:
		return

	is_opening = true
	print("Door opening...")

	if animated_sprite and animated_sprite.sprite_frames.has_animation("open"):
		animated_sprite.play("open")
		$CollisionShape2D.disabled = true

func close_door():
	if is_closing or not visible: # visible property might not be the best check for closing state
		return

	is_closing = true
	print("Door closing...")

	if animated_sprite and animated_sprite.sprite_frames.has_animation("close"):
		animated_sprite.play("close")


func _on_interaction_area_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player_in_range = true
		current_player = body as Player

func enter_door():
	if next_scene:
		get_tree().change_scene_to_file(next_scene)
	else:
		var victory_screen = preload("res://victory.tscn").instantiate()
		get_tree().current_scene.add_child(victory_screen)
		victory_screen.show_victory()
