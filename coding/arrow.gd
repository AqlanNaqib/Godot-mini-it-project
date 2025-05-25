extends Area2D

var speed = 300
var damage = 50  # Added damage variable

func _ready():
	set_as_top_level(true)

func _process(delta):
	position += (Vector2.RIGHT * speed).rotated(rotation) * delta

func arrow_deal_damage():  # Fixed typo in function name
	return damage  # Now returns damage value instead of pass

func _on_visible_on_screen_enabler_2d_screen_exited():
	queue_free()  # Removed incorrect colon
