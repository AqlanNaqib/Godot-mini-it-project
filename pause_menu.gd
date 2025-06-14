extends Control

@onready var animation_player = $AnimationPlayer

func _ready():
	hide()  # Ensure hidden at start
	# Optional: animation_player.play("RESET")

func resume():
	get_tree().paused = false
	hide()
	if animation_player.has_animation("blur"):
		animation_player.play_backwards("blur")

func pause():
	get_tree().paused = true
	show()
	if animation_player.has_animation("blur"):
		animation_player.play("blur")

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		if visible:  # If menu is currently showing
			resume()
		else:
			pause()
		get_tree().root.set_input_as_handled()
		

# Button signals
func _on_resume_pressed():
	resume()

func _on_quit_pressed():
	get_tree().quit()

func _on_restart_pressed():
	# Reset inventory slots (adjust size based on your hotbar)
	var inventory = preload("res://Inventory/playerInventory.tres")
	inventory.slots = []
	for i in range(3):  # Replace 3 with your actual slot count
		inventory.slots.append(InvSlot.new())
	
	# Reset scene manager flags
	SceneManager.game_first_loadin = true
	SceneManager.going_left = false
	SceneManager.going_right = false
	SceneManager.going_secret = false
	SceneManager.going_house1 = false
	
	# Reload scene
	get_tree().paused = false
	get_tree().change_scene_to_file("res://SCENES/WORLD_REAL.tscn")
