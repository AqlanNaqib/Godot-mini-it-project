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
	# Reset inventory slots
	inv.clear()

	# --- FIX: Explicitly reset Global player stats and properties ---
	Globals.player_current_health = Globals.player_max_health
	Globals.player_current_arrows = Globals.player_max_arrows
	Globals.player_alive = true
	Globals.player_score = 0
	print("Globals: Player stats reset for restart.")

	# --- Emit signals to update HUDs with new values ---
	# This is crucial because Globals._ready() doesn't rerun on scene change.
	Globals.health_changed.emit(Globals.player_current_health, Globals.player_max_health)
	Globals.arrows_changed.emit(Globals.player_current_arrows, Globals.player_max_arrows)
	print("Globals: Health and arrows signals emitted for HUD update.")
	# --- End FIX ---

	# Reset scene manager flags
	SceneManager.game_first_loadin = true
	SceneManager.going_left = false
	SceneManager.going_right = false
	SceneManager.going_secret = false
	SceneManager.going_house1 = false
	
	# Reload scene
	get_tree().paused = false
	get_tree().change_scene_to_file("res://SCENES/WORLD_REAL.tscn")
