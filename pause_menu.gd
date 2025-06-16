extends Control

@onready var animation_player = $AnimationPlayer
@onready var inv : Inv = preload("res://Inventory/playerInventory.tres")

func _ready():
	hide() # Ensure hidden at start
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
		if visible: # If menu is currently showing
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
	# --- FIX: Call the comprehensive reset_game_state function ---
	# This function already handles:
	# - Player health, arrows, alive status, score reset
	# - Inventory clear (inv.clear())
	# - Clearing the Globals.killed_enemies_ids list
	Globals.reset_game_state()
	print("Globals: Game state reset via Pause Menu restart.")

	# SceneManager flags reset (keep these as they are specific to scene transitions)
	SceneManager.game_first_loadin = true
	SceneManager.going_left = false
	SceneManager.going_right = false
	SceneManager.going_secret = false
	SceneManager.going_house1 = false
	
	# Reload scene
	get_tree().paused = false
	get_tree().change_scene_to_file("res://SCENES/WORLD_REAL.tscn")
