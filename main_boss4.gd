extends CharacterBody2D

@onready var animation_player = $AnimationPlayer
@export var damage_amount: int = 10 # Damage this worm deals to player

# --- NEW: Unique Identifier for this enemy instance ---
# IMPORTANT: You MUST set this unique ID in the editor for EACH instance of this enemy.
# Example: "worm_cave_entrance_1"
@export var unique_enemy_id: String = "" # <-- Set this in the Inspector!

var max_health: int = 100 # Max health for the worm
var current_health: int = 50 # Current health for the worm
var is_alive: bool = true

func _ready():
	# --- NEW: Check if this enemy was already defeated ---
	if !unique_enemy_id.is_empty() and Globals.is_enemy_defeated(unique_enemy_id):
		# print(f"Enemy '{unique_enemy_id}' was already defeated. Freeing.") # Can uncomment for debugging
		queue_free() # Remove this enemy from the scene immediately
		return # Stop further _ready processing for this enemy
	#elif unique_enemy_id.is_empty():
		#printerr(f"ERROR: Enemy at {get_path()} does not have a 'unique_enemy_id' set. Its defeat will NOT be persistent across scenes.")

	# IMPORTANT: Ensure your Worm scene has an Area2D child (e.g., named "HitboxArea")
	# and that this Area2D node is added to the "enemy_hitbox" group in the editor.
	# The Arrow script looks for this group to detect enemies.
	
	# Ensure the worm is considered alive initially
	is_alive = true
	current_health = max_health # Reset health if it's a new instance


	# print(f"Enemy '{unique_enemy_id}' is ready and active.") # Can uncomment for debugging


func _on_animation_finished(_anim_name):
	animation_player.play("idle")

func _on_player_entered(_body):
	animation_player.play("attack")

func _on_hit_box_entered(body): # This is the worm's hitbox for attacking player
	# Check if the body is the player and has the take_damage method
	if body.has_method("take_damage"):
		body.take_damage(damage_amount) # Pass the damage amount

# New function: This worm receives damage from the player's attacks (e.g., arrows)
func take_damage(damage_taken: int):
	if !is_alive: return # Don't take damage if already dead

	current_health -= damage_taken
	current_health = max(0, current_health) # Health can't go below 0
	print("Worm health: ", current_health) # For debugging purposes

	if current_health <= 0:
		worm_death()

func worm_death():
	is_alive = false
	print("Worm defeated!")
	# --- NEW: Add enemy ID to defeated list on death ---
	if !unique_enemy_id.is_empty():
		Globals.add_defeated_enemy(unique_enemy_id)
	#else:
		#printerr(f"ERROR: Worm at {get_path()} died but does NOT have a unique_enemy_id set. Its defeat will NOT be persistent.")
	
	# You can add a death animation here before queue_free()
	queue_free() # Remove the worm from the scene
