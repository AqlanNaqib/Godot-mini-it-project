extends Control

@onready var option_button: OptionButton = $HBoxContainer/OptionButton

const RESOLUTION_DICTIONARY: Dictionary = {
	"1920 x 1080": Vector2i(1920, 1080),
	"1280 x 720": Vector2i(1280, 720),
	"1152 x 648": Vector2i(1152, 648)
}

var changing_resolution := false

func _ready():
	option_button.clear()
	add_resolution_items()
	sync_current_resolution()
	option_button.item_selected.connect(on_resolution_selected)

func sync_current_resolution():
	var current_size = DisplayServer.window_get_size()
	for i in range(RESOLUTION_DICTIONARY.size()):
		if RESOLUTION_DICTIONARY.values()[i] == current_size:
			option_button.select(i)
			return
	
	# Find closest resolution if no exact match
	var closest_index = 0
	var smallest_diff = INF
	for i in range(RESOLUTION_DICTIONARY.size()):
		var diff = (RESOLUTION_DICTIONARY.values()[i] - current_size).length()
		if diff < smallest_diff:
			smallest_diff = diff
			closest_index = i
	option_button.select(closest_index)

func add_resolution_items() -> void:
	var screen_size = DisplayServer.screen_get_size()
	for resolution_text in RESOLUTION_DICTIONARY:
		var resolution = RESOLUTION_DICTIONARY[resolution_text]
		if resolution.x <= screen_size.x and resolution.y <= screen_size.y:
			option_button.add_item(resolution_text)

func on_resolution_selected(index: int) -> void:
	if changing_resolution:
		return
	
	changing_resolution = true
	option_button.disabled = true
	
	var new_size = RESOLUTION_DICTIONARY.values()[index]
	
	# Only change resolution in windowed modes
	if DisplayServer.window_get_mode() != DisplayServer.WINDOW_MODE_FULLSCREEN:
		await set_resolution(new_size)
	
	changing_resolution = false
	option_button.disabled = false

func set_resolution(new_size: Vector2i) -> void:
	DisplayServer.window_set_size(new_size)
	await get_tree().process_frame
	
	# Center window after resize
	await get_tree().create_timer(0.1).timeout
	var screen_size = DisplayServer.screen_get_size()
	DisplayServer.window_set_position((screen_size - new_size) / 2)
