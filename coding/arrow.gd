extends Area2D

var speed = 300
var damage = 15 # This will be the damage the arrow deals

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
		# Try to call a method on the parent of the hitbox (which should be the enemy/boss)
		if area.get_parent().has_method("take_damage"):
			area.get_parent().take_damage(damage) # Pass the arrow's damage
		queue_free() # Make arrow disappear when hitting enemy
	
func add_arrow(new_arrow):
	pass
