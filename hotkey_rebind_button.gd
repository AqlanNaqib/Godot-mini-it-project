class_name HotkeyRebindButton
extends Control

signal rebind_started
signal rebind_cancelled
signal rebind_completed

@onready var label: Label = $HBoxContainer/Label
@onready var button: Button = $HBoxContainer/Button

@export var action_name: String = "move_left"

var is_rebinding: bool = false

func _ready():
	# Add the entire control to the group
	add_to_group("rebind_buttons")
	set_process_unhandled_input(false)  # Changed from set_process_unhandled_key_input
	set_action_name()
	set_text_for_key()
	
	button.toggled.connect(_on_button_toggled)

func set_action_name() -> void:
	label.text = "Unassigned"
	
	match action_name:
		"move_left":
			label.text = "Move Left"
		"move_right":
			label.text = "Move Right"
		"jump":
			label.text = "Jump"
		"move_up":
			label.text = "Move Up"
		"move_down":
			label.text = "Move Down"
		"attack":
			label.text = "Attack"

func set_text_for_key() -> void:
	var action_events = InputMap.action_get_events(action_name)
	
	if action_events.is_empty():
		button.text = "Unassigned"
		return
	
	var action_event = action_events[0]
	
	if action_event is InputEventKey:
		button.text = OS.get_keycode_string(action_event.physical_keycode)
	elif action_event is InputEventMouseButton:
		match action_event.button_index:
			MOUSE_BUTTON_LEFT:
				button.text = "Left Click"
			MOUSE_BUTTON_RIGHT:
				button.text = "Right Click"
			MOUSE_BUTTON_MIDDLE:
				button.text = "Middle Click"
		
		button.text = "Mouse %d" % action_event.button_index
	else:
		button.text = action_event.as_text()



func _unhandled_key_input(event: InputEvent) -> void:
	if !is_rebinding:
		return
		
	# Ignore modifier keys pressed alone
	if event is InputEventKey and event.is_pressed() and !event.is_echo():
		if event.keycode != KEY_ESCAPE:
			# Clear existing inputs
			InputMap.action_erase_events(action_name)
			InputMap.action_add_event(action_name, event)
			button.text = OS.get_keycode_string(event.keycode)
			rebind_completed.emit()
		else:
			set_text_for_key()
			rebind_cancelled.emit()
		
		set_process_unhandled_input(false)
		is_rebinding = false
		get_viewport().set_input_as_handled()
	
	# Handle mouse buttons
	elif event is InputEventMouseButton and event.is_pressed():
		if event.button_index != MOUSE_BUTTON_RIGHT:  # Optional: exclude right click
			InputMap.action_erase_events(action_name)
			InputMap.action_add_event(action_name, event)
			button.text = "Mouse %d" % event.button_index
			rebind_completed.emit()
			
			set_process_unhandled_input(false)
			is_rebinding = false
			get_viewport().set_input_as_handled()

func disable() -> void:
	button.disabled = true

func enable() -> void:
	button.disabled = false

func _on_button_toggled(toggled_on: bool) -> void:
	if is_rebinding:
		return
		
	is_rebinding = true
	button.text = "Press any key..."
	set_process_unhandled_key_input(true)
	rebind_started.emit()

func set_default_controls():
	# Left mouse button for attack
	var mouse_event = InputEventMouseButton.new()
	mouse_event.button_index = MOUSE_BUTTON_LEFT
	InputMap.action_add_event("attack", mouse_event)
