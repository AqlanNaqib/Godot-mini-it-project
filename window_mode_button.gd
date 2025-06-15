extends Control

@onready var option_button: OptionButton = $HBoxContainer/OptionButton

const WINDOW_MODES = [
	{"name": "Full-screen", "mode": DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN, "borderless": false},
	{"name": "Window Mode", "mode": DisplayServer.WINDOW_MODE_WINDOWED, "borderless": false},
	{"name": "Borderless Window", "mode": DisplayServer.WINDOW_MODE_WINDOWED, "borderless": true},
	{"name": "Borderless Full-screen", "mode": DisplayServer.WINDOW_MODE_FULLSCREEN, "borderless": true}
]

var is_changing := false

func _ready():
	option_button.clear()
	for mode in WINDOW_MODES:
		option_button.add_item(mode.name)
	sync_current_mode()
	option_button.item_selected.connect(on_window_mode_selected)

func sync_current_mode():
	var current_mode = DisplayServer.window_get_mode()
	var is_borderless = DisplayServer.window_get_flag(DisplayServer.WINDOW_FLAG_BORDERLESS)
	
	for i in range(WINDOW_MODES.size()):
		if WINDOW_MODES[i].mode == current_mode and WINDOW_MODES[i].borderless == is_borderless:
			option_button.select(i)
			return
	
	# Fallback for exclusive fullscreen (which might report as regular fullscreen)
	if current_mode == DisplayServer.WINDOW_MODE_FULLSCREEN and not is_borderless:
		option_button.select(0)
	else:
		option_button.select(1)  # Default to Window Mode

func on_window_mode_selected(index: int):
	if is_changing or index < 0 or index >= WINDOW_MODES.size():
		return
	
	is_changing = true
	option_button.disabled = true
	
	var selected_mode = WINDOW_MODES[index]
	
	print("Attempting to change to: ", selected_mode.name)
	
	# First set borderless flag if needed
	if selected_mode.borderless != DisplayServer.window_get_flag(DisplayServer.WINDOW_FLAG_BORDERLESS):
		DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, selected_mode.borderless)
		await get_tree().process_frame
	
	# Then set window mode
	DisplayServer.window_set_mode(selected_mode.mode)
	await get_tree().process_frame
	
	# Special handling for windowed modes
	if selected_mode.mode == DisplayServer.WINDOW_MODE_WINDOWED:
		# Set a reasonable default size
		var target_size = Vector2i(1280, 720)
		DisplayServer.window_set_size(target_size)
		await get_tree().process_frame
		center_window()
	
	print("New mode: ", DisplayServer.window_get_mode())
	print("Borderless: ", DisplayServer.window_get_flag(DisplayServer.WINDOW_FLAG_BORDERLESS))
	
	is_changing = false
	option_button.disabled = false

func center_window():
	await get_tree().process_frame
	var screen_size = DisplayServer.screen_get_size()
	var window_size = DisplayServer.window_get_size()
	DisplayServer.window_set_position((screen_size - window_size) / 2)
