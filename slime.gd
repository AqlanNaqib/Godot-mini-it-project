extends CharacterBody2D

var speed = 50
var health = 100
var dead = false
var player_in_area = false
var player = null
var last_direction = Vector2.DOWN  # Track last movement direction for idle animations

func _ready():
	dead = false

func _physics_process(delta):
	if !dead:
		$detection_area/CollisionShape2D.disabled = false
		if player_in_area and player != null:
			var direction = (player.position - position).normalized()
			velocity = direction * speed
			move_and_slide()
			update_movement_animation(direction)
			last_direction = direction
		else:
			play_idle_animation()
	
	if dead:
		$detection_area/CollisionShape2D.disabled = true
		play_death_animation()

func update_movement_animation(direction: Vector2):
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

# Rest of your existing functions remain the same...
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
