extends CharacterBody2D

# Movement and stats
var speed = 50
var health = 130
var dead = false
var player_in_area = false
var player = null
var last_direction = Vector2.DOWN  # Track last movement direction for idle animations
var is_attacking = false
var attack_cooldown = false

func _ready():
	dead = false

func _physics_process(delta):
	if dead:
		$detection_area/CollisionShape2D.disabled = true
		play_death_animation()
		return
	
	$detection_area/CollisionShape2D.disabled = false
	
	if player_in_area and player != null:
		var direction = (player.position - position).normalized()
		
		# Check if player is in attack range
		if position.distance_to(player.position) < 30 and !attack_cooldown:
			is_attacking = true
			play_attack_animation(direction)
			attack_cooldown = true
			await get_tree().create_timer(1.0).timeout  # Attack duration
			is_attacking = false
			await get_tree().create_timer(0.5).timeout  # Cooldown before next attack
			attack_cooldown = false
		elif !is_attacking:
			velocity = direction * speed
			move_and_slide()
			update_movement_animation(direction)
			last_direction = direction
	else:
		play_idle_animation()

func play_attack_animation(direction: Vector2):
	# Determine which attack animation to play based on direction
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
	
	# Store the last direction for when attack finishes
	last_direction = direction

func update_movement_animation(direction: Vector2):
	if is_attacking:
		return
	# Determine which walking animation to play based on direction
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
	# Play idle animation based on last movement direction
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
	# Play death animation based on last movement direction
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
	if body.has_method("player"):
		player_in_area = true
		player = body

func _on_detection_area_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		player_in_area = false
		player = null

func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.has_method("arrow_deal_damage"):
		var damage = area.arrow_deal_damage()
		take_damage(damage)
		area.queue_free()  # This will make the arrow disappear when it hits the enemy

func take_damage(damage):
	health -= damage
	print("Enemy took ", damage, " damage. Health: ", health)
	
	if health <= 0 and !dead:
		death()

func death():
	dead = true
	$CollisionShape2D.set_deferred("disabled", true)
	# Death animation is now handled in play_death_animation()
	
	await get_tree().create_timer(1.0).timeout
	queue_free()

func enemy():
	pass
