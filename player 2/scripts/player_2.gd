extends CharacterBody2D

class_name Player

@onready var gun = $Gun
@onready var bullet_spawn_point = $CenterMarker

var bow_equipped = false
var bow_cooldown = true
var arrow = preload("res://SCENES/arrow.tscn")
signal healthChanged

# Arrow system
var max_arrows = 5
var current_arrows = 5
signal arrowsChanged(count: int)

var enemy_inattack_range = false
var enemy_attack_cooldown = true
var health = 100
var player_alive = true
var speed = 80
var current_dir = "none"

var mouse_loc_from_player = null
var player_state = "idle"

func _ready():
	$AnimatedSprite2D.play("front idle")

func _physics_process(delta):
	if health <= 0 and player_alive:
		player_death()
		return
		
	mouse_loc_from_player = get_global_mouse_position() - self.position
	player_movement(delta)
	
	enemy_attack()
	
	if Input.is_action_pressed("attack"):
		gun.setup_direction(get_shooting_direction())
		gun.shoot()

	if Input.is_action_just_pressed("b"):
		bow_equipped = !bow_equipped

	var mouse_pos = get_global_mouse_position()
	$Marker2D.look_at(mouse_pos)

	if Input.is_action_just_pressed("left_mouse") and bow_equipped and bow_cooldown and current_arrows > 0:
		shoot_arrow()

func player_death():
	player_alive = false
	$AnimatedSprite2D.play("death_animation")  # Make sure you have a death animation
	await get_tree().create_timer(1.0).timeout
	get_tree().reload_current_scene()

func shoot_arrow():
	bow_cooldown = false
	current_arrows -= 1
	arrowsChanged.emit(current_arrows)  # Update HUD
	# ... rest of your shooting code ...
	var arrow_instance = arrow.instantiate()
	arrow_instance.rotation = $Marker2D.rotation
	arrow_instance.global_position = $Marker2D.global_position
	add_child(arrow_instance)
	await get_tree().create_timer(0.4).timeout
	bow_cooldown = true

func add_arrows(amount: int):
	current_arrows = min(current_arrows + amount, max_arrows)
	arrowsChanged.emit(current_arrows)  # Update HUD
	print("Arrows replenished. Total: ", current_arrows)

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
	
	input_vector.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	input_vector.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		player_state = "walking"
		
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
			match dir:
				"up":
					anim.play("n_idle")
				"down":
					anim.play("s_idle")
				"right":
					anim.play("se_idle")
				"left":
					anim.play("sw_idle")
	else:
		speed = 0
		
		if mouse_loc_from_player.x >= -25 and mouse_loc_from_player.x <= 25 and mouse_loc_from_player.y <= 0:
			anim.play("n_shoot")
		elif mouse_loc_from_player.y >= -25 and mouse_loc_from_player.y <= 25 and mouse_loc_from_player.x > 0:
			anim.play("e_shoot")
		elif mouse_loc_from_player.x >= -25 and mouse_loc_from_player.x <= 25 and mouse_loc_from_player.y > 0:
			anim.play("s_shoot")
		elif mouse_loc_from_player.y >= -25 and mouse_loc_from_player.y <= 25 and mouse_loc_from_player.x < 0:
			anim.play("w_shoot")
		elif mouse_loc_from_player.x >= 25 and mouse_loc_from_player.y <= -25:
			anim.play("ne_shoot")
		elif mouse_loc_from_player.x >= 0.5 and mouse_loc_from_player.y >= 25:
			anim.play("se_shoot")
		elif mouse_loc_from_player.x <= -0.5 and mouse_loc_from_player.y >= 25:
			anim.play("sw_shoot")
		elif mouse_loc_from_player.x <= -25 and mouse_loc_from_player.y <= -25:
			anim.play("nw_shoot")
	
	if player_state == "walking" and not bow_equipped:
		if dir == "up":
			anim.play("n_walk")
		elif dir == "right":
			anim.play("e_walk")
		elif dir == "down":
			anim.play("s_walk")
		elif dir == "left":
			anim.play("w_walk")
		elif dir.x > 0.5 and dir.y < -0.5:
			anim.play("ne_walk")
		elif dir.x > 0.5 and dir.y > 0.5:
			anim.play("se_walk")
		elif dir.x < -0.5 and dir.y > 0.5:
			anim.play("sw_walk")
		elif dir.x < -0.5 and dir.y < -0.5:
			anim.play("nw_walk")
func player():
	pass

func _on_player_hitbox_body_entered(body):
	if body.has_method("enemy"):
		enemy_inattack_range = true

func _on_player_hitbox_body_exited(body):
	if body.has_method("enemy"):
		enemy_inattack_range = false

func enemy_attack():
	if enemy_inattack_range and enemy_attack_cooldown:
		health -= 20
		health = max(0, health)
		healthChanged.emit()
		enemy_attack_cooldown = false
		$attack_cooldown.start()
		print(health)

func _on_attack_cooldown_timeout() -> void:
	enemy_attack_cooldown = true
