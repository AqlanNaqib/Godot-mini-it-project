extends CharacterBody2D

@onready var player = get_parent().find_child("player")
@onready var animated_sprite = $AnimatedSprite2D
@onready var progress_bar = $UI/ProgressBar
@onready var attack_cooldown = $AttackCooldown
@onready var attack_range = $AttackRange/CollisionShape2D

@onready var key = $skeleton_collectable
@export var itemRes: InvItem

# --- NEW: Unique Identifier for this enemy instance ---
# IMPORTANT: You MUST set this unique ID in the editor for EACH instance of this enemy.
# Example: "skeleton_boss_dungeon_1"
@export var unique_enemy_id: String = "" # <-- Set this in the Inspector!

var direction : Vector2
var can_attack = true
var attack_damage = 20
var player_in_range = false

var health: = 100:
	set(value):
		health = value
		progress_bar.value = value
		if value <= 0:
			progress_bar.visible = false
			find_child("FiniteStateMachine").change_state("Death")
			drop_key()
			# --- NEW: Add enemy ID to defeated list when health reaches 0 ---
			if !unique_enemy_id.is_empty():
				Globals.add_defeated_enemy(unique_enemy_id)
			# ... (rest of your code above) ...

func _ready():
	# --- NEW: Check if this enemy was already defeated ---
	if !unique_enemy_id.is_empty() and Globals.is_enemy_defeated(unique_enemy_id):
		# print(f"Enemy '{unique_enemy_id}' was already defeated. Freeing.") # Can uncomment for debugging
		queue_free() # Remove this enemy from the scene immediately
		return # Stop further _ready processing for this enemy
#	elif unique_enemy_id.is_empty():
		# Use a print for easier debugging than commented out line
	#	printerr(f"ERROR: Enemy at {get_path()} does not have a 'unique_enemy_id' set. Its defeat will NOT be persistent.")

	# If the enemy is NOT defeated, ensure physics processing starts
	set_physics_process(true) # This was 'false', set to true if enemy is alive

	# Initialize the progress bar with the current health
	progress_bar.max_value = health # Set max value to initial health
	progress_bar.value = health
	progress_bar.visible = true # Ensure progress bar is visible for an active enemy

	# Ensure other components are in their initial active state
	if is_instance_valid(attack_range):
		attack_range.disabled = false
	if is_instance_valid(key): # Ensure key is hidden initially
		key.visible = false
	
	# --- FIX START ---
	# Safely check if 'key_collect_area' and its 'CollisionShape2D' exist before disabling
	var key_collect_area_node = find_child("key_collect_area")
	if is_instance_valid(key_collect_area_node) and key_collect_area_node.has_node("CollisionShape2D"):
		key_collect_area_node.find_child("CollisionShape2D").disabled = true # Disabled by default until drop_key()
	#else:
		#printerr(f"ERROR: Enemy '{unique_enemy_id}' at {get_path()} could not find 'key_collect_area/CollisionShape2D'. Check node path.")
	# --- FIX END ---

	# print(f"Enemy '{unique_enemy_id}' is ready and active.") # Can uncomment for debugging

# ... (rest of your code below) ...

	# print(f"Enemy '{unique_enemy_id}' is ready and active.") # Can uncomment for debugging


func _process(_delta):
	# Add a check to prevent errors if player node is not found
	if !is_instance_valid(player):
		player = get_parent().find_child("player") # Try to re-acquire player if it was freed/reloaded
		if !is_instance_valid(player):
			return # Cannot proceed if player is not found

	direction = player.position - position
		
	if direction.x < 0:
		animated_sprite.flip_h = true
	else:
		animated_sprite.flip_h = false

func _physics_process(delta):
	# Add a check to prevent movement if player node is not found
	if !is_instance_valid(player):
		return # Cannot move if player is not found

	if player_in_range and can_attack:
		attack_player()
	elif player: # Keep existing logic
		velocity = direction.normalized() * 40
		move_and_collide(velocity * delta)

func attack_player():
	if is_instance_valid(player) and can_attack: # Add instance check for player
		player.take_damage(attack_damage)
		can_attack = false
		attack_cooldown.start()
		animated_sprite.play("attack")

func take_damage(amount: int): # Modified to accept 'amount' argument
	# This will trigger the 'health' setter, where persistence logic is handled
	health -= amount # Subtract the received damage amount
	health = max(0, health) # Ensure health doesn't go below zero
	# print("Boss health: ", health) # For debugging purposes (already in setter)


func _on_attack_range_body_entered(body):
	if body.name == "Player": # Keep existing name check, but consider using groups
		player_in_range = true

func _on_attack_range_body_exited(body):
	if body.name == "Player": # Keep existing name check
		player_in_range = false

func _on_attack_cooldown_timeout():
	can_attack = true
	
func drop_key():
	if is_instance_valid(key): # Add instance check
		key.visible = true
	if $key_collect_area/CollisionShape2D: # Add instance check
		$key_collect_area/CollisionShape2D.disabled = false
	key_collect()
	
func key_collect():
	await get_tree().create_timer(1.5).timeout
	if is_instance_valid(key): # Add instance check
		key.visible = false
	if is_instance_valid(player) and itemRes: # Add instance check for player
		player.collect(itemRes)
		# print(f"Enemy '{unique_enemy_id}' dropped key and is freeing.") # Can uncomment for debugging
	#else:
		# Use a print for easier debugging than commented out line
		#printerr(f"ERROR: Enemy at {get_path()}: Player or itemRes is null during key collection. Cannot collect item.")
	
	queue_free()

func _on_key_collect_area_body_entered(body: Node2D) -> void:
	if body.has_method("player"): # Keep existing method check, but consider using groups
		player = body
		key_collect()
