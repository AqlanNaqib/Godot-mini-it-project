extends CharacterBody2D


var speed = 25
var health = 50
var dead = false
var player_in_area = false
var player = null 
var last_direction = Vector2.DOWN    
var is_attacking = false
var attack_cooldown = false

@onready var slime = $slime_collectable 
@export var itemRes: InvItem 


@export var unique_slime: String = "" 


func _ready():
	

	if !unique_slime.is_empty() and Globals.is_enemy_defeated(unique_slime):
	 
		queue_free() 
		return 
	
	
	dead = false 
	
	$CollisionShape2D.disabled = false
	$hitbox/CollisionShape2D.disabled = false
	$detection_area/CollisionShape2D.disabled = false
	
  # 


func _physics_process(delta):
	
	if dead:
		return
	
	
	
	if player_in_area and player != null:
		var direction = (player.position - position).normalized()
		
		
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
		
		if not is_attacking:
			play_idle_animation()

func play_attack_animation(direction: Vector2):
	# ... 
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
	# ... 
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
	
	if body.is_in_group("player"): 
		player_in_area = true
		player = body
	  

func _on_detection_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_area = false
		player = null
		velocity = Vector2.ZERO 

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
	   
		
		death()

func death():
	dead = true
	$CollisionShape2D.set_deferred("disabled", true) 
	$hitbox/CollisionShape2D.disabled = true 
	$detection_area/CollisionShape2D.disabled = true 

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
	
	
	queue_free()

func enemy():
	pass

func _on_meat_collect_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"): 
		player = body
		collect_and_free()
