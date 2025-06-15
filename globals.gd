extends Node

# --- Player Stats (these will persist across scenes) ---
var player_max_health = 100
var player_current_health = 100
var player_alive = true

var player_max_arrows = 10
var player_current_arrows = 5

# --- Centralized Player Inventory ---
# Make sure playerInventory.tres exists at this path and is ASSIGNED IN THE EDITOR!
@export var player_inventory: Inv = preload("res://Inventory/playerInventory.tres")

# --- Signals to notify other scripts of changes ---
signal health_changed(new_health: int, max_health: int)
signal arrows_changed(new_count: int, max_count: int)
signal player_died # A global signal for game over

# --- Game State Variables ---
var player_score = 0

# --- NEW: Array to store unique IDs of defeated enemies ---
# This will persist as long as the Globals autoload is active.
# For true game-to-game persistence (saving/loading game files),
# you would need to save/load this array to/from disk.
var killed_enemies_ids: Array[String] = []


func _ready():
	print("Globals script ready and initialized!")
	
	player_died.connect(_on_player_died)
	
	# Emit initial values for HUDs
	health_changed.emit(player_current_health, player_max_health)
	arrows_changed.emit(player_current_arrows, player_max_arrows)
	
	if player_inventory:
		print("Globals: Player inventory loaded successfully.")
	else:
		printerr("Globals: player_inventory is NULL! Assign playerInventory.tres in Globals autoload settings.")

# --- NEW FUNCTION: Adds an enemy's ID to the defeated list ---
func add_defeated_enemy(enemy_id: String):
	if !killed_enemies_ids.has(enemy_id):
		killed_enemies_ids.append(enemy_id)
		#print(f"Globals: Added '{enemy_id}' to defeated enemies list. Total: {killed_enemies_ids.size()}")

# --- NEW FUNCTION: Checks if an enemy was previously defeated ---
func is_enemy_defeated(enemy_id: String) -> bool:
	return killed_enemies_ids.has(enemy_id)

# --- NEW FUNCTION: Resets defeated enemies list (for new game, etc.) ---
func clear_defeated_enemies():
	killed_enemies_ids.clear()
	print("Globals: Cleared defeated enemies list.")

# --- NEW FUNCTION: Resets all global game state variables ---
func reset_game_state():
	print("Globals: Resetting game state for new game.")
	player_current_health = player_max_health
	player_current_arrows = player_max_arrows
	player_alive = true
	player_score = 0
	
	# Also clear the inventory when starting a new game from scratch
	if player_inventory:
		player_inventory.clear() # Assumes Inv.clear() is implemented as discussed
	
	# --- IMPORTANT: Clear defeated enemies when starting a new game! ---
	clear_defeated_enemies()
	
	# Emit signals to ensure all HUDs and related systems update immediately
	health_changed.emit(player_current_health, player_max_health)
	arrows_changed.emit(player_current_arrows, player_max_arrows)
	print("Globals: Game state reset and signals emitted.")


func take_damage(amount: int):
	if !player_alive:
		return

	player_current_health -= amount
	if player_current_health <= 0:
		player_current_health = 0
		if player_alive:
			player_alive = false
			print("Player died! Game Over.")
			player_died.emit()
	
	health_changed.emit(player_current_health, player_max_health)

func increase_health(amount: int):
	player_current_health += amount
	if player_current_health > player_max_health:
		player_current_health = player_max_health
	
	health_changed.emit(player_current_health, player_max_health)

func shoot_arrow():
	if player_current_arrows > 0:
		player_current_arrows -= 1
		arrows_changed.emit(player_current_arrows, player_max_arrows)
		return true
	return false

func add_arrows(amount: int):
	player_current_arrows = min(player_current_arrows + amount, player_max_arrows)
	arrows_changed.emit(player_current_arrows, player_max_arrows)
	print("Arrows replenished. Total: ", player_current_arrows)

func _on_player_died():
	print("Changing to Game Over scene in 2 seconds...")
	# Ensure the game is not paused when going to game over screen,
	# as this might affect animations or transitions there.
	get_tree().paused = false
	await get_tree().create_timer(2.0).timeout
	get_tree().change_scene_to_file("res://game_over2.tscn") # This will eventually lead to main menu
