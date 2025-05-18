extends CharacterBody2D

class_name Player

@onready var gun = $Gun
@onready var healthbar: ProgressBar = $healthbar
@onready var bullet_spawn_point = $CenterMarker

var bow_equipped = false
var bow_cooldown = true
var arrow = preload("res://SCENES/arrow.tscn")

var speed = 80
var current_dir = "none"
var health = 100
var mouse_loc_from_player = null
var player_state = "idle"

func _ready():
	$AnimatedSprite2D.play("front idle")

func _physics_process(delta):
	mouse_loc_from_player = get_global_mouse_position() - self.position
	player_movement(delta)
	update_health()

	if Input.is_action_pressed("attack"):
		gun.setup_direction(get_shooting_direction())
		gun.shoot()

	if Input.is_action_just_pressed("b"):
		bow_equipped = !bow_equipped

	var mouse_pos = get_global_mouse_position()
	$Marker2D.look_at(mouse_pos)

	if Input.is_action_just_pressed("left_mouse") and bow_equipped and bow_cooldown:
		bow_cooldown = false
		var arrow_instance = arrow.instantiate()
		arrow_instance.rotation = $Marker2D.rotation
		arrow_instance.global_position = $Marker2D.global_position
		add_child(arrow_instance)
		await get_tree().create_timer(0.4).timeout
		bow_cooldown = true

func get_shooting_direction() -> Vector2:
	match current_dir:
		"right":
			return Vector2.RIGHT
		"left":
			return Vector2.LEFT
		"up":
			return Vector2.UP
		"down":
			return Vector2.DOWN
		_:
			return Vector2.RIGHT

func player_movement(delta):
	var input_vector = Vector2.ZERO
	
	# Using your custom input actions
	input_vector.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	input_vector.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		player_state = "walking"
		
		# Update direction based on input
		if abs(input_vector.x) > abs(input_vector.y):
			current_dir = "right" if input_vector.x > 0 else "left"
		else:
			current_dir = "down" if input_vector.y > 0 else "up"
			
		velocity = input_vector * speed
	else:
		player_state = "idle"
		velocity = Vector2.ZERO
	
	play_anim(1 if input_vector != Vector2.ZERO else 0)
	move_and_slide()

func play_anim(movement):
	var dir = current_dir
	var anim = $AnimatedSprite2D
	
	if !bow_equipped:
		speed = 80
		if player_state == "idle":
		# Directional idle animations
			match dir:
				"up":
					anim.play("back-idle")
				"down":
					anim.play("front-idle")
				"right":
					anim.play("se-idle")  # Make sure you have this animation
				"left":
					anim.play("sw-idle")   # Make sure you have this animation
	if bow_equipped:
		speed = 0
		
	
		if mouse_loc_from_player.x >= -25 and mouse_loc_from_player.x <= 25 and mouse_loc_from_player.y <= 0:
			$AnimatedSprite2D.play("n-attack")
		if mouse_loc_from_player.y >= -25 and mouse_loc_from_player.y <= 25 and mouse_loc_from_player.x > 0:
			$AnimatedSprite2D.play("e-attack")
		if mouse_loc_from_player.x >= -25 and mouse_loc_from_player.x <= 25 and mouse_loc_from_player.y > 0:
			$AnimatedSprite2D.play("s-attack")
		if mouse_loc_from_player.y >= -25 and mouse_loc_from_player.y <= 25 and mouse_loc_from_player.x < 0:
			$AnimatedSprite2D.play("w-attack")
		if mouse_loc_from_player.x >= 25 and mouse_loc_from_player.y <= -25:
			$AnimatedSprite2D.play("me-attack")
		if mouse_loc_from_player.x >= 0.5 and mouse_loc_from_player.y >= 25:
			$AnimatedSprite2D.play("se-attack")
		if mouse_loc_from_player.x <= -0.5 and mouse_loc_from_player.y >= 25:
			$AnimatedSprite2D.play("sw-attack")
		if mouse_loc_from_player.x <= -25 and mouse_loc_from_player.y <= -25:
			$AnimatedSprite2D.play("mw-attack")


		
	elif player_state == "walking":
		# Directional walk animations
		if dir == "up":
			anim.play("n-walk")
		elif dir == "right":
			anim.play("e-walk")
		elif dir == "down":
			anim.play("s-walk")
		elif dir == "left":
			anim.play("w-walk")
		elif dir.x > 0.5 and dir.y < -0.5:
			anim.play("ne-walk")
		elif dir.x > 0.5 and dir.y > 0.5:
			anim.play("se-walk")
		elif dir.x < -0.5 and dir.y > 0.5:
			anim.play("sw-walk")
		elif dir.x < -0.5 and dir.y < -0.5:
			anim.play("nw-walk")

func update_health():
	healthbar.value = health

func _on_regen_timer_timeout():
	if health < 100:
		health += 20
		if health > 100:
			health = 100
		if health <= 0:
			health = 0
			
			
			
		
func player():
	pass
