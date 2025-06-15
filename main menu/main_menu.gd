class_name MainMenu
extends Control

@onready var start_button = $MarginContainer/HBoxContainer/VBoxContainer/Start_Button as Button
@onready var exit_button = $MarginContainer/HBoxContainer/VBoxContainer/Exit_Button as Button
@onready var options_button = $MarginContainer/HBoxContainer/VBoxContainer/Options_Button as Button
@onready var options_menu = $Options_Menu as OptionMenu
@onready var margin_container = $MarginContainer as MarginContainer
@onready var sfx_click: AudioStreamPlayer2D = $sfx_click
@onready var menu_music: AudioStreamPlayer = $"menu music"

func _ready():
	handle_connecting_signals()
	menu_music.play()
	# Ensure the game is unpaused when entering the main menu, just in case
	get_tree().paused = false 

func on_button_down() -> void:
	pass
	
func on_start_pressed():
	sfx_click.play()
	
	# Reset global game state and unpause the game before starting
	Globals.reset_game_state()
	# Ensure the game is unpaused when starting a new game
	get_tree().paused = false 
	
	# Reset SceneManager flags for a fresh start.
	# Assuming SceneManager is also an Autoload (Singleton).
	# If SceneManager is not an Autoload, you'll need a different way to access/reset it.
	SceneManager.game_first_loadin = true
	SceneManager.going_left = false
	SceneManager.going_right = false
	SceneManager.going_secret = false
	SceneManager.going_house1 = false
	print("SceneManager flags reset for new game.")

	# Proceed to character selection or directly to game scene
	get_tree().change_scene_to_file("res://character_selection.tscn")
	pass

func on_options_pressed() -> void:
	margin_container.visible = false
	options_menu.set_process(true)
	options_menu.visible = true
	sfx_click.play()
	
func on_exit_pressed() -> void: 
	get_tree().quit() 
	sfx_click.play()

func on_exit_options_menu() -> void:
	margin_container.visible = true
	options_menu.visible = false
	sfx_click.play()
	
func handle_connecting_signals() -> void:
	start_button.button_down.connect(on_start_pressed)
	options_button.button_down.connect(on_options_pressed)
	exit_button.button_down.connect(on_exit_pressed)
	options_menu.exit_options_menu.connect(on_exit_options_menu)

func _change_scene(path: String):
	# This function seems to be intended for scene changes but is not currently used by start_button.
	# If you want to use this for fade out, ensure start_button calls _change_scene
	# instead of directly changing the scene.
	$AnimationPlayer.play("fade_out")
	await $AnimationPlayer.animation_finished
	get_tree().change_scene_to_file(path) # Use the passed path
