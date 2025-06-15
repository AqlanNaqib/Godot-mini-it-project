extends CharacterBody2D

# Movement and stats
var speed = 50
var health = 50
var dead = false
var player_in_area = false
var player = null # This will hold a reference to the player node
var last_direction = Vector2.DOWN    # Track last movement direction for idle animations
var is_attacking = false
var attack_cooldown = false

@onready var slime = $slime_collectable # This might be the node for the visual slime collectible
@export var itemRes: InvItem # This is the inventory item resource to drop

# --- IMPORTANT: Unique Identifier for this enemy instance ---
# You MUST set this unique ID in the editor for EACH enemy instance
# in your scenes. If you have multiple enemies of the same type,
# they need different unique_ids (e.g., "goblin_1_level_1", "goblin_2_level_1", "goblin_1_level_2", etc.).
# Make sure this is a descriptive and unique string for each enemy.
@export var unique_slime: String = "" # Set this in the Inspector for each enemy!


func _ready():
	# --- Check if this enemy was already defeated ---
	# It's good practice to always enable logging for important checks during development.
   # if unique_slime.is_empty():
	 #   printerr(f"Enemy at {get_path()} does not have a 'unique_slime' ID set. Its defeat will NOT be persistent across scenes.")
		# We don't queue_free here, so it will still be present and potentially move
		# but its state won't be saved if defeated.

	if !unique_slime.is_empty() and Globals.is_enemy_defeated(unique_slime):
	  #  print(f"Enemy '{unique_slime}' was already defeated. Freeing.")
		queue_free() # Remove this enemy from the scene immediately
		return # Stop further _ready processing for this enemy
	
	# If the enemy is NOT defeated, ensure it's initialized for active gameplay
	dead = false 
	# Make sure relevant collision shapes are enabled by default for an active enemy
	# These might be disabled in the editor for an "inactive" enemy, but should be enabled
	# once it's determined to be an active part of the game.
	$CollisionShape2D.disabled = false
	$hitbox/CollisionShape2D.disabled = false
	$detection_area/CollisionShape2D.disabled = false
	
  #  print(f"Enemy '{unique_slime}' is ready and active.") # Re-enabled for debugging


func _physics_process(delta):
	# This check is good: if dead, stop processing movement
	if dead:
		return
	
	# This line below ($detection_area/CollisionShape2D.disabled = false)
	# is redundant if you set it in _ready and only disable it on death.
	# Keeping it here won't hurt, but it's not strictly necessary in every frame.
	# $detection_area/CollisionShape2D.disabled = false 
	
	if player_in_area and player != null:
		var direction = (player.position - position).normalized()
		
		# Check if player is in attack range
		if position.distance_to(player.position) < 30 and !attack_cooldown:
			is_attacking = true
			play_attack_animation(direction)
			attack_cooldown = true
			await get_tree().create_timer(1.0).timeout      # Attack duration
			is_attacking = false
			await get_tree().create_timer(0.5).timeout      # Cooldown before next attack
			attack_cooldown = false
		elif !is_attacking:
			velocity = direction * speed
			move_and_slide()
			update_movement_animation(direction)
			last_direction = direction
	else:
		# Only play idle animation if not attacking and player not in area
		if not is_attacking:
			play_idle_animation()

func play_attack_animation(direction: Vector2):
	# ... (no changes here, logic is fine) ...
	if abs(direction.x) > abs(direction.y):
		if direction.x > 0:
			$AnimatedSprite2D.play("right_attack")
		else:
			$AnimatedSprite2D.play("left_attack")
	else:
		if direction.y > 0:
			$AnimatedSprite2D.play("front_attack")
		else:
			$AnimatedSprite2D.play("back_attack")
	
	last_direction = direction

func update_movement_animation(direction: Vector2):
	if is_attacking:
		return
	# ... (no changes here, logic is fine) ...
	if abs(direction.x) > abs(direction.y):
		if direction.x > 0:
			$AnimatedSprite2D.play("right_walk")
		else:
			$AnimatedSprite2D.play("left_walk")
	else:
		if direction.y > 0:
			$AnimatedSprite2D.play("front_walk")
		else:
			$AnimatedSprite2D.play("back_walk")

func play_idle_animation():
	if is_attacking:
		return
	# ... (no changes here, logic is fine) ...
	if abs(last_direction.x) > abs(last_direction.y):
		if last_direction.x > 0:
			$AnimatedSprite2D.play("right_idle")
		else:
			$AnimatedSprite2D.play("left_idle")
	else:
		if last_direction.y > 0:
			$AnimatedSprite2D.play("front_idle")
		else:
			$AnimatedSprite2D.play("back_idle")

func play_death_animation():
	# ... (no changes here, logic is fine) ...
	if abs(last_direction.x) > abs(last_direction.y):
		if last_direction.x > 0:
			$AnimatedSprite2D.play("right_death")
		else:
			$AnimatedSprite2D.play("left_death")
	else:
		if last_direction.y > 0:
			$AnimatedSprite2D.play("front_death")
		else:
			$AnimatedSprite2D.play("back_death")

func _on_detection_area_body_entered(body: Node2D) -> void:
	# This is critical for movement: ensuring 'player_in_area' and 'player' are set
	if body.is_in_group("player"): # Ensure your player node is in the "player" group!
		player_in_area = true
		player = body
	  #  print(f"Enemy '{unique_slime}': Player entered detection area. Chasing.")
	# Add a print here to see if other bodies are entering, which might be unintended
	# else:
	#   print(f"Enemy '{unique_slime}': Non-player body entered detection area: {body.name}")

func _on_detection_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_area = false
		player = null
		velocity = Vector2.ZERO # Stop movement immediately when player exits
		#rint(f"Enemy '{unique_slime}': Player exited detection area. Stopping chase.")

func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.has_method("arrow_deal_damage"):
		var damage = area.arrow_deal_damage()
		take_damage(damage)
		area.queue_free()

func take_damage(damage):
	health -= damage
	print("Enemy took ", damage, " damage. Health: ", health)
	
	if health <= 0 and !dead:
		if !unique_slime.is_empty():
			Globals.add_defeated_enemy(unique_slime)
	   # else: # Re-enabled for clearer debugging
		#    printerr(f"Enemy at {get_path()} died but does NOT have a unique_slime ID set. Its defeat will NOT be persistent.")
		
		death()

func death():
	dead = true
	$CollisionShape2D.set_deferred("disabled", true) # Disable main collision
	$hitbox/CollisionShape2D.disabled = true # Disable hitbox collision
	$detection_area/CollisionShape2D.disabled = true # Disable detection area collision

	play_death_animation()

	await get_tree().create_timer(1.0).timeout
	
	drop_collectable()
	
func drop_collectable():
	if slime:
		slime.visible = true
	if $meat_collect_area/CollisionShape2D:
		$meat_collect_area/CollisionShape2D.disabled = false
	
	await get_tree().create_timer(1.5).timeout
	
	collect_and_free()
	
func collect_and_free():
	if player and itemRes:
		for i in range(1):
			player.collect(itemRes)
		#print(f"Enemy '{unique_slime}' dropped item and is freeing.") # Re-enabled for clearer debugging
	#else: # Re-enabled for clearer debugging
		#printerr(f"Enemy '{unique_slime}': Player or itemRes is null during collection. Cannot collect item.")
	
	queue_free()

func enemy():
	pass

func _on_meat_collect_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"): # Use group check for robustness
		player = body
		collect_and_free()
