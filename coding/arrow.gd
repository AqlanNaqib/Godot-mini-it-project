extends Area2D

var speed = 300
var damage = 50

func _ready():
	set_as_top_level(true)
	# Connect the area_entered signal to detect collisions
	connect("area_entered", Callable(self, "_on_area_entered"))

func _process(delta):
	position += (Vector2.RIGHT * speed).rotated(rotation) * delta

func arrow_deal_damage():
	return damage

func _on_visible_on_screen_enabler_2d_screen_exited():
	queue_free()

func _on_area_entered(area):
	# Check if the area we hit is an enemy's hitbox
	if area.is_in_group("enemy_hitbox"):
		queue_free()  # Make arrow disappear when hitting enemy
