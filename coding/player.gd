extends CharacterBody2D

class_name PlayerController # Using a unique class name to avoid conflicts

# --- Movement Settings ---
const WALK_SPEED = 100
const ATTACK_MOVE_SPEED = 50 # Reduced speed during attack (optional, can be 0)

# --- Animation States ---
enum PlayerState { IDLE, WALKING, ATTACKING }
var current_state = PlayerState.IDLE
var current_direction = "down" # Initial facing direction

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready():
	# --- Input Map Setup ---
	# Ensure W, A, S, D are mapped to standard UI actions
	setup_movement_input_actions()
	# Ensure left mouse button is mapped to "attack"
	setup_attack_input_action()
	
	# Initial animation setup
	update_animation()

func _physics_process(delta):
	# Handle player movement based on input
	handle_movement()
	
	# Handle attack input (left mouse button)
	handle_attack_input()
	
	# Move the character based on its calculated velocity
	move_and_slide()
	
	# Update animation after all state changes for the current frame
	# Note: update_animation() will already return early if current_state is ATTACKING,
	# as attack animations manage their own state transition via signal.

# --- Input Setup Functions ---
func setup_movement_input_actions():
	# W key for "ui_up"
	if not InputMap.has_action("ui_up"):
		InputMap.add_action("ui_up")
		var key_w = InputEventKey.new()
		key_w.keycode = KEY_W
		InputMap.action_add_event("ui_up", key_w)
	
	# S key for "ui_down"
	if not InputMap.has_action("ui_down"):
		InputMap.add_action("ui_down")
		var key_s = InputEventKey.new()
		key_s.keycode = KEY_S
		InputMap.action_add_event("ui_down", key_s)
		
	# A key for "ui_left"
	if not InputMap.has_action("ui_left"):
		InputMap.add_action("ui_left")
		var key_a = InputEventKey.new()
		key_a.keycode = KEY_A
		InputMap.action_add_event("ui_left", key_a)
		
	# D key for "ui_right"
	if not InputMap.has_action("ui_right"):
		InputMap.add_action("ui_right")
		var key_d = InputEventKey.new()
		key_d.keycode = KEY_D
		InputMap.action_add_event("ui_right", key_d)

func setup_attack_input_action():
	# Left mouse button for "attack"
	if not InputMap.has_action("attack"):
		InputMap.add_action("attack")
		var mouse_button_event = InputEventMouseButton.new()
		mouse_button_event.button_index = MOUSE_BUTTON_LEFT
		InputMap.action_add_event("attack", mouse_button_event)

# --- Core Mechanics Functions ---
func handle_movement():
	var input_vector = Vector2.ZERO
	
	# Get raw input strength from W, A, S, D
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized() # Normalize to prevent faster diagonal movement
	
	# Update character's facing direction only if there's movement input
	if input_vector != Vector2.ZERO:
		if input_vector.x > 0:
			current_direction = "right"
		elif input_vector.x < 0:
			current_direction = "left"
		elif input_vector.y > 0: # Prioritize vertical if diagonal or only vertical
			current_direction = "down"
		elif input_vector.y < 0:
			current_direction = "up"
	
	# Set velocity based on current state (slower during attack)
	if current_state == PlayerState.ATTACKING:
		velocity = input_vector * ATTACK_MOVE_SPEED
	else:
		velocity = input_vector * WALK_SPEED
	
	# Update player state (IDLE or WALKING) if not currently attacking
	if current_state != PlayerState.ATTACKING:
		current_state = PlayerState.WALKING if input_vector != Vector2.ZERO else PlayerState.IDLE

func handle_attack_input():
	# If left mouse button is just pressed and player is not already attacking
	if Input.is_action_just_pressed("attack") and current_state != PlayerState.ATTACKING:
		start_attack()

func start_attack():
	current_state = PlayerState.ATTACKING
	
	# Stop any current animation to immediately start the attack animation
	animated_sprite.stop()
	
	# Play the correct attack animation based on current_direction
	match current_direction:
		"right":
			animated_sprite.flip_h = false # Not flipped for right
			animated_sprite.play("side_attack")
		"left":
			animated_sprite.flip_h = true # Flipped for left
			animated_sprite.play("side_attack")
		"up":
			animated_sprite.flip_h = false
			animated_sprite.play("back_attack") # Use 'back_attack' for up
		"down":
			animated_sprite.flip_h = false
			animated_sprite.play("front_attack") # Use 'front_attack' for down
	
	# Connect the animation_finished signal to transition back to IDLE/WALKING
	# CONNECT_ONE_SHOT ensures the connection is automatically disconnected after first use.
	if not animated_sprite.animation_finished.is_connected(_on_attack_finished):
		animated_sprite.animation_finished.connect(_on_attack_finished, CONNECT_ONE_SHOT)

func _on_attack_finished():
	# This function is called when an animation finishes.
	# We only care if the finished animation was an 'attack' animation.
	# We check if the current animation name ends with "_attack" to be sure.
	if animated_sprite.animation.ends_with("_attack"):
		current_state = PlayerState.IDLE # Go back to idle after attack
		update_animation() # Update to idle/walk animation

func update_animation():
	# If the player is currently attacking, let the attack animation play out.
	# The _on_attack_finished signal will handle the state transition back.
	if current_state == PlayerState.ATTACKING:
		return
	
	# Handle animations for IDLE and WALKING states
	match current_state:
		PlayerState.IDLE:
			match current_direction:
				"right":
					animated_sprite.flip_h = false
					animated_sprite.play("side_idle")
				"left":
					animated_sprite.flip_h = true
					animated_sprite.play("side_idle")
				"up":
					animated_sprite.flip_h = false
					animated_sprite.play("back_idle")
				"down":
					animated_sprite.flip_h = false
					animated_sprite.play("front_idle")
		
		PlayerState.WALKING:
			match current_direction:
				"right":
					animated_sprite.flip_h = false
					animated_sprite.play("side_walk")
				"left":
					animated_sprite.flip_h = true
					animated_sprite.play("side_walk")
				"up":
					animated_sprite.flip_h = false
					animated_sprite.play("back_walk")
				"down":
					animated_sprite.flip_h = false
					animated_sprite.play("front_walk")
