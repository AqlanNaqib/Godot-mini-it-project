extends CanvasLayer

@onready var queen: AudioStreamPlayer = $queen




func _ready():
	queen.play()

func _on_exit_pressed() -> void:
	get_tree().change_scene_to_file("res://main menu/main_menu.tscn")
