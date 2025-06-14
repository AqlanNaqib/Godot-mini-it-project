extends StaticBody2D

class_name Door

@export var required_key_id: String = ""  
@export var interaction_prompt: String = "Press C to interact"
@export var auto_use_key: bool = true  
@export var locked_message: String = "This door is locked. You need a key."
@export var unlocked_message: String = "Door unlocked!"

@onready var collision_shape = $CollisionShape2D
@onready var animated_sprite = $AnimatedSprite2D
@onready var interaction_area = $InteractionArea
@onready var interaction_area_collision = $InteractionArea/CollisionShape2D
@export var next_scene: String = "res://victory.tscn"  # Leave empty for victory screen

var player_in_range: bool = false
var current_player: Player = null
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
		current_player = body
		show_interaction_prompt()

func _on_player_exited(body):
	if body.has_method("player"):
		player_in_range = false
		current_player = null
		hide_interaction_prompt()

func interact_with_door():
	if is_opening:
		return  # Already opening
	
	if try_unlock_with_key():
		open_door()

func try_unlock_with_key() -> bool:
	if not current_player or not current_player.inv:
		show_locked_message()
		return false
	
	# Look for the required key in player's inventory
	var key_slot_index = find_key_in_inventory()
	
	if key_slot_index >= 0:
		# Found the key! Use it
		current_player.inv.use_item_atIndex(key_slot_index)
		return true
	else:
		show_locked_message()
		return false

func find_key_in_inventory() -> int:
	var inventory = current_player.inv
	
	for i in range(inventory.slots.size()):
		var slot = inventory.slots[i]
		if slot.item and slot.item is Key:
			var key = slot.item as Key
			if key.key_id == required_key_id:
				return i
	
	return -1  # Key not found


func open_door():
	if is_opening:
		return
	
	is_opening = true
	print("Door opening...")
	
	# Play opening animation
	if animated_sprite and animated_sprite.sprite_frames.has_animation("open"):
		animated_sprite.play("open")
		$CollisionShape2D.disabled = true
	

func close_door():
	if is_closing or not visible:
		return
	
	is_closing = true
	print("Door closing...")
	
	# Play closing animation
	if animated_sprite and animated_sprite.sprite_frames.has_animation("close"):
		animated_sprite.play("close")


func show_interaction_prompt():
	# You can implement UI prompt here
	print(interaction_prompt)

func hide_interaction_prompt():
	# Hide UI prompt here
	pass

func show_locked_message():
	# You can implement UI message here
	print(locked_message)


func _on_interaction_area_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player_in_range = true
		current_player = body


func enter_door():
	if next_scene:
		get_tree().change_scene_to_file(next_scene)
	else:
		# Show victory screen
		var victory_screen = preload("res://victory.tscn").instantiate()
		get_tree().current_scene.add_child(victory_screen)
		victory_screen.show_victory()
