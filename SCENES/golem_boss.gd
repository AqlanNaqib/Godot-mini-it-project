extends CharacterBody2D

@onready var player = get_parent().find_child("player")
@onready var sprite = $Sprite2D
@onready var progress_bar = $UI/ProgressBar
@onready var laser_damage_area = $LaserDamageArea # Already there

@onready var key = $skeleton_collectable
@export var itemRes: InvItem

# --- NEW: Unique Identifier for this enemy instance ---
# IMPORTANT: You MUST set this unique ID in the editor for EACH instance of this enemy.
# Example: "laser_enemy_zone_a_1"
@export var unique_enemy_id: String = "" # <-- Set this in the Inspector!

var direction : Vector2
var DEF = 0 # Defense stat
var is_dead = false # NEW: Track death state for _physics_process

var health = 160:
	set(value):
		health = value
		progress_bar.value = value
		if value <= 0:
			progress_bar.visible = false
			find_child("FiniteStateMachine").change_state("Death")
			# --- NEW: Add enemy ID to defeated list when health reaches 0 ---
			if !is_dead: # Ensure this only runs once on death
				is_dead = true
				if !unique_enemy_id.is_empty():
					Globals.add_defeated_enemy(unique_enemy_id)
					drop_key()
				#else:
					#printerr(f"ERROR: Enemy at {get_path()} died but does NOT have a unique_enemy_id set. Its defeat will NOT be persistent.")
		elif value <= progress_bar.max_value / 2 and DEF == 0:
			DEF = 5 # Increase defense when health is half or less
			find_child("FiniteStateMachine").change_state("ArmorBuff") # Transition to ArmorBuff state


func _ready():
	# --- NEW: Check if this enemy was already defeated ---
	if !unique_enemy_id.is_empty() and Globals.is_enemy_defeated(unique_enemy_id):
		# print(f"Enemy '{unique_enemy_id}' was already defeated. Freeing.") # Can uncomment for debugging
		queue_free() # Remove this enemy from the scene immediately
		return # Stop further _ready processing for this enemy
	#elif unique_enemy_id.is_empty():
		#printerr(f"ERROR: Enemy at {get_path()} does not have a 'unique_enemy_id' set. Its defeat will NOT be persistent across scenes.")

	# If the enemy is NOT defeated, ensure physics processing starts
	set_physics_process(true) # This was 'false', set to true if enemy is alive

	progress_bar.max_value = health
	progress_bar.value = health
	progress_bar.visible = true # Ensure progress bar is visible for an active enemy

	if laser_damage_area: # Ensure this check if you might not have the node
		laser_damage_area.monitoring = false # Keep original state
		laser_damage_area.monitorable = false # Keep original state
		laser_damage_area.body_entered.connect(_on_laser_damage_area_body_entered)

	# print(f"Enemy '{unique_enemy_id}' is ready and active.") # Can uncomment for debugging


func _process(_delta):
	# Add a check to prevent errors if player node is not found
	if !is_instance_valid(player):
		player = get_parent().find_child("player") # Try to re-acquire player if it was freed/reloaded
		if !is_instance_valid(player):
			return # Cannot proceed if player is not found

	direction = player.position - position

	if direction.x < 0:
		sprite.flip_h = true
	else:
		sprite.flip_h = false

func _physics_process(delta):
	# NEW: Don't move if dead
	if is_dead:
		return

	# Add a check to prevent movement if player node is not found
	if !is_instance_valid(player):
		return # Cannot move if player is not found

	velocity = direction.normalized() * 40
	move_and_collide(velocity * delta)

func take_damage(amount: int):
	var final_damage = max(0, amount - DEF)
	# This will trigger the 'health' setter, where persistence logic is handled
	health -= final_damage
	health = max(0, health)
	# print("Boss health: ", health) # Already in setter


func _on_laser_damage_area_body_entered(body):
	if body == player: # Keep existing check
		player.take_damage(10)

# --- NEW FUNCTION FOR MELEE DAMAGE ---
func deal_melee_damage_to_player():
	if is_instance_valid(player): # Add instance check for player
		if player.global_position.distance_to(self.global_position) < 70: # Adjust range as needed
			player.take_damage(20) # Adjust damage amount as needed (e.g., 20 damage)
			# print("Player hit by melee attack! Health: ", player.health) # Can uncomment for debugging
			
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
