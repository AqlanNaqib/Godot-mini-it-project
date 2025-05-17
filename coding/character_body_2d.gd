extends CharacterBody2D

@export var speed : float = 300.0
@onready var gun = $Gun
@onready var sprite = $Sprite2D

func _physics_process(delta):
	# Movement input
	var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	# Normalize diagonal movement
	if input_direction.length() > 0:
		input_direction = input_direction.normalized()
	
	# Attack input - changed to is_action_pressed for spamming
	if Input.is_action_pressed("attack"):
		gun.shoot()  # This will now fire continuously while E is held
	
	# Apply movement
	velocity = input_direction * speed
	
	# Flip sprite
	if input_direction.x != 0:
		sprite.flip_h = input_direction.x < 0
	
	move_and_slide()
