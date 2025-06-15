extends Control

@onready var option_button: OptionButton = $HBoxContainer/OptionButton

const RESOLUTIONS = {
	"1920x1080 (Native)": Vector2i(1920, 1080),
	"1600x900": Vector2i(1600, 900),
	"1280x720": Vector2i(1280, 720),
	"1152x648": Vector2i(1152, 648)
}

var is_changing := false

func _ready():
	option_button.clear()
	
	# Add all resolutions (filtering happens in sync)
	for res_name in RESOLUTIONS:
		option_button.add_item(res_name)
	
	sync_current_resolution()
	option_button.item_selected.connect(on_resolution_selected)

func sync_current_resolution():
	var current_size = DisplayServer.window_get_size()
	var current_mode = DisplayServer.window_get_mode()
	
	# Disable resolution dropdown in fullscreen modes
	option_button.disabled = current_mode != DisplayServer.WINDOW_MODE_WINDOWED
	
	# Find matching resolution
	for i in range(option_button.item_count):
		var res = RESOLUTIONS[option_button.get_item_text(i)]
		if res == current_size:
			option_button.select(i)
			return
	
	# Find closest match
	var closest_index = 0
	var smallest_diff = INF
	for i in range(option_button.item_count):
		var res = RESOLUTIONS[option_button.get_item_text(i)]
		var diff = abs(res.x - current_size.x) + abs(res.y - current_size.y)
		if diff < smallest_diff:
			smallest_diff = diff
			closest_index = i
	
	option_button.select(closest_index)

func on_resolution_selected(index: int):
	if is_changing or index < 0:
		return
	
	var current_mode = DisplayServer.window_get_mode()
	if current_mode != DisplayServer.WINDOW_MODE_WINDOWED:
		sync_current_resolution()  # Reset to current if in fullscreen
		return
	
	is_changing = true
	option_button.disabled = true
	
	var res_name = option_button.get_item_text(index)
	var new_size = RESOLUTIONS[res_name]
	
	DisplayServer.window_set_size(new_size)
	await get_tree().process_frame
	center_window()
	
	is_changing = false
	option_button.disabled = false

func center_window():
	await get_tree().process_frame
	var screen_size = DisplayServer.screen_get_size()
	var window_size = DisplayServer.window_get_size()
	DisplayServer.window_set_position((screen_size - window_size) / 2)
