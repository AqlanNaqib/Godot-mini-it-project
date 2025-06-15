extends Area2D
 
var player
var direction
var speed = 250
var damage = 25 # NEW: Damage this projectile deals to the player
 
func _ready():
	player = get_parent().find_child("player")
	
	# Only set direction if player is found to prevent errors
	if player:
		direction = (player.position - position).normalized()
	else:
		# If player is not found, maybe just despawn or log an error
		print("Boss Projectile: Player not found!")
		queue_free()
		return

	# Connect the body_entered signal to detect player collision
	# Make sure the player's CharacterBody2D has a collision_layer that
	# this Area2D's collision_mask is set to detect.
	connect("body_entered", Callable(self, "_on_body_entered"))
	
	# Set as top level if it's meant to fly freely in the world
	set_as_top_level(true) 
 
func _physics_process(delta):
	# Ensure 'direction' is valid before moving
	if direction != null:
		position += direction * speed * delta
 
func _on_body_entered(body):
	# Check if the body that entered is the player or has a take_damage method
	# You can check by name ("Player") or by method existence
	if body.name == "Player" or body.has_method("take_damage"):
		body.take_damage(damage) # Call the player's take_damage method
		queue_free() # Destroy projectile after hitting player
	# Optional: Add conditions to destroy projectile if it hits other objects like walls
	# elif body.is_in_group("environment") or body.is_in_group("wall"):
	#	queue_free()
 
func _on_screen_exited(): # This signal usually comes from a VisibleOnScreenNotifier2D child
	queue_free()
