extends CharacterBody2D

# Movement settings
const WALK_SPEED = 100
const ATTACK_MOVE_SPEED = 50  # Reduced speed during attack

# Animation states
enum PlayerState { IDLE, WALKING, ATTACKING }
var current_state = PlayerState.IDLE
var current_direction = "down"

func _physics_process(delta):
	handle_movement()
	handle_attack_input()
	handle_attack_cancel()
	move_and_slide()
	update_animation()

func handle_movement():
	var input_vector = Vector2.ZERO
	
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	# Update direction only if moving
	if input_vector != Vector2.ZERO:
		if input_vector.x > 0:
			current_direction = "right"
		elif input_vector.x < 0:
			current_direction = "left"
		elif input_vector.y > 0:
			current_direction = "down"
		elif input_vector.y < 0:
			current_direction = "up"
	
	# Set velocity based on state
	if current_state == PlayerState.ATTACKING:
		velocity = input_vector * ATTACK_MOVE_SPEED
	else:
		velocity = input_vector * WALK_SPEED
	
	# Update state (only if not attacking)
	if current_state != PlayerState.ATTACKING:
		current_state = PlayerState.WALKING if input_vector != Vector2.ZERO else PlayerState.IDLE

func handle_attack_input():
	if Input.is_action_just_pressed("attack") and current_state != PlayerState.ATTACKING:
		start_attack()

func handle_attack_cancel():
	if Input.is_action_just_pressed("cancel_attack") and current_state == PlayerState.ATTACKING:
		cancel_attack()

func start_attack():
	current_state = PlayerState.ATTACKING
	
	var anim = $AnimatedSprite2D
	anim.stop()  # Stop current animation
	
	match current_direction:
		"right":
			anim.flip_h = false
			anim.play("side_attack")
		"left":
			anim.flip_h = true
			anim.play("side_attack")
		"up":
			anim.flip_h = false
			anim.play("back_attack")
		"down":
			anim.flip_h = false
			anim.play("front_attack")
	
	# Connect animation finished signal
	anim.animation_finished.connect(_on_attack_finished, CONNECT_ONE_SHOT)

func cancel_attack():
	$AnimatedSprite2D.stop()
	current_state = PlayerState.IDLE
	update_animation()

func _on_attack_finished():
	if $AnimatedSprite2D.animation.ends_with("attack"):
		current_state = PlayerState.IDLE
		update_animation()

func update_animation():
	var anim = $AnimatedSprite2D
	
	# Don't update animation if we're attacking
	if current_state == PlayerState.ATTACKING:
		return
	
	match current_state:
		PlayerState.IDLE:
			match current_direction:
				"right":
					anim.flip_h = false
					anim.play("side_idle")
				"left":
					anim.flip_h = true
					anim.play("side_idle")
				"up":
					anim.flip_h = false
					anim.play("back_idle")
				"down":
					anim.flip_h = false
					anim.play("front_idle")
		
		PlayerState.WALKING:
			match current_direction:
				"right":
					anim.flip_h = false
					anim.play("side_walk")
				"left":
					anim.flip_h = true
					anim.play("side_walk")
				"up":
					anim.flip_h = false
					anim.play("back_walk")
				"down":
					anim.flip_h = false
					anim.play("front_walk")

func _ready():
	# Set up cancel_attack input (S key)
	if not InputMap.has_action("cancel_attack"):
		InputMap.add_action("cancel_attack")
		var key = InputEventKey.new()
		key.keycode = KEY_S
		InputMap.action_add_event("cancel_attack", key)
	
	update_animation()
