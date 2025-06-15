extends CharacterBody2D

@export var damage_amount: int = 5 # Damage this mini worm deals to player

var max_health: int = 30 # Max health for the mini worm
var current_health: int = 30 # Current health for the mini worm
var is_alive: bool = true

func _ready():
	# IMPORTANT: Ensure your Mini Worm scene has an Area2D child (e.g., named "HitboxArea")
	# and that this Area2D node is added to the "enemy_hitbox" group in the editor.
	# The Arrow script looks for this group to detect enemies.
	pass

func _on_body_entered(body): # This is mini worm's hitbox for attacking player
	# Check if the body is the player and has the take_damage method
	if body.has_method("take_damage"):
		body.take_damage(damage_amount) # Pass the damage amount

# New function: This mini worm receives damage from the player's attacks (e.g., arrows)
func take_damage(damage_taken: int):
	if !is_alive: return # Don't take damage if already dead

	current_health -= damage_taken
	current_health = max(0, current_health) # Health can't go below 0
	print("Mini Worm health: ", current_health) # For debugging purposes

	if current_health <= 0:
		mini_worm_death()

func mini_worm_death():
	is_alive = false
	print("Mini Worm defeated!")
	# You can add a death animation here before queue_free()
	queue_free() # Remove the mini worm from the scene
