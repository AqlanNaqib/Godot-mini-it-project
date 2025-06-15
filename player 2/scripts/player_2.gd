extends CharacterBody2D

class_name Player

# DELETE THIS LINE: @export var inv: Inv
# The player no longer needs to directly manage an 'inv' instance.
# Inventory is now accessed globally via Globals.player_inventory

@onready var gun = $Gun
@onready var bullet_spawn_point = $CenterMarker

var bow_equipped = false
var bow_cooldown = true
var arrow = preload("res://SCENES/arrow.tscn")

var enemy_inattack_range = false
var enemy_attack_cooldown = true
var speed = 80
var current_dir = "none"

var mouse_loc_from_player = null
var player_state = "idle"

func _ready():
	# DELETE THIS LINE: inv.use_item.connect(use_item)
	# This connection is no longer needed as Inv.gd's use_item_atIndex directly
	# calls item.use(), and item.use() interacts with Globals.
	$AnimatedSprite2D.play("front idle")
	Globals.player_died.connect(player_death_visuals)

func _physics_process(delta):
	if not Globals.player_alive:
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

	if Input.is_action_just_pressed("left_mouse") and bow_equipped and bow_cooldown and Globals.player_current_arrows > 0:
		shoot_arrow()

func player_death_visuals():
	print("Player playing death animation...")
	$AnimatedSprite2D.play("death_animation")
	
	set_process(false)
	set_physics_process(false)
	set_process_input(false)
	
	await get_tree().create_timer(1.0).timeout

func shoot_arrow():
	bow_cooldown = false
	if Globals.shoot_arrow():
		var arrow_instance = arrow.instantiate()
		arrow_instance.rotation = $Marker2D.rotation
		arrow_instance.global_position = $Marker2D.global_position
		add_child(arrow_instance)
		await get_tree().create_timer(0.4).timeout
	bow_cooldown = true

func add_arrows(amount: int):
	Globals.add_arrows(amount)

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
		Globals.take_damage(20)
		enemy_attack_cooldown = false
		$attack_cooldown.start()
		print("Player current health: ", Globals.player_current_health)

func _on_attack_cooldown_timeout() -> void:
	enemy_attack_cooldown = true

func collect(item):
	# Directly use the global inventory for insertion
	Globals.player_inventory.insert(item)

func _on_pickable_area_area_entered(area):
	if area.has_method("collect"):
		# Pass the global inventory to the collectable item
		area.collect(Globals.player_inventory)

func increase_health(amount: int):
	Globals.increase_health(amount)
	print("Player current health: ", Globals.player_current_health)

# DELETE THIS ENTIRE FUNCTION:
# func use_item(item: InvItem):
# 	item.use()

func take_damage(damage_amount):
	Globals.take_damage(damage_amount)
