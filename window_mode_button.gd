extends Control

@onready var option_button: OptionButton = $HBoxContainer/OptionButton

const WINDOW_MODE_ARRAY: Array[String] = [
	"Full-screen",
	"Window Mode",
	"Borderless Window",
	"Borderless Full-screen"
]

var changing_mode := false

func _ready():
	option_button.clear()
	add_window_mode_items()
	sync_current_window_mode()
	option_button.item_selected.connect(on_window_mode_selected)

func sync_current_window_mode():
	var current_mode = DisplayServer.window_get_mode()
	var is_borderless = DisplayServer.window_get_flag(DisplayServer.WINDOW_FLAG_BORDERLESS)
	
	var selected_index = 1  # Default to Window Mode
	match [current_mode, is_borderless]:
		[DisplayServer.WINDOW_MODE_FULLSCREEN, false]: selected_index = 0
		[DisplayServer.WINDOW_MODE_WINDOWED, false]: selected_index = 1
		[DisplayServer.WINDOW_MODE_WINDOWED, true]: selected_index = 2
		[DisplayServer.WINDOW_MODE_FULLSCREEN, true]: selected_index = 3
	
	option_button.select(selected_index)

func add_window_mode_items() -> void:
	for window_mode in WINDOW_MODE_ARRAY:
		option_button.add_item(window_mode)

func on_window_mode_selected(index: int) -> void:
	if changing_mode:
		return
	
	changing_mode = true
	option_button.disabled = true
	
	match index:
		0: # Fullscreen
			await set_window_mode(
				DisplayServer.WINDOW_MODE_FULLSCREEN,
				DisplayServer.WINDOW_FLAG_BORDERLESS, false
			)
		1: # Window Mode
			await set_window_mode(
				DisplayServer.WINDOW_MODE_WINDOWED,
				DisplayServer.WINDOW_FLAG_BORDERLESS, false
			)
		2: # Borderless Window
			await set_window_mode(
				DisplayServer.WINDOW_MODE_WINDOWED,
				DisplayServer.WINDOW_FLAG_BORDERLESS, true
			)
		3: # Borderless FullScreen
			await set_window_mode(
				DisplayServer.WINDOW_MODE_FULLSCREEN,
				DisplayServer.WINDOW_FLAG_BORDERLESS, true
			)
	
	changing_mode = false
	option_button.disabled = false

func set_window_mode(mode: DisplayServer.WindowMode, flag: DisplayServer.WindowFlags, value: bool) -> void:
	# Set borderless flag first if changing to/from borderless
	if flag == DisplayServer.WINDOW_FLAG_BORDERLESS:
		DisplayServer.window_set_flag(flag, value)
		await get_tree().process_frame
	
	# Then change window mode
	DisplayServer.window_set_mode(mode)
	await get_tree().process_frame
	
	# Center window if in windowed mode
	if mode == DisplayServer.WINDOW_MODE_WINDOWED:
		await get_tree().create_timer(0.1).timeout
		var window_size = DisplayServer.window_get_size()
		var screen_size = DisplayServer.screen_get_size()
		DisplayServer.window_set_position((screen_size - window_size) / 2)
