class_name MainMenu
extends Control

@onready var start_button = $MarginContainer/HBoxContainer/VBoxContainer/Start_Button as Button
@onready var exit_button = $MarginContainer/HBoxContainer/VBoxContainer/Exit_Button as Button
@onready var options_button = $MarginContainer/HBoxContainer/VBoxContainer/Options_Button as Button
@onready var options_menu = $Options_Menu as OptionMenu
@onready var margin_container = $MarginContainer as MarginContainer
@onready var sfx_click: AudioStreamPlayer2D = $sfx_click

 


func _ready():
	handle_connecting_signals()


func on_start_pressed() -> void:
	sfx_click.play()
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
