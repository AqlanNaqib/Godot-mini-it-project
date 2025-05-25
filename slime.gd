extends CharacterBody2D

var speed = 50
var health = 100
var dead = false
var player_in_area = false
var player = null

func _ready():
	dead = false

func _physics_process(delta):
	if !dead:
		$detection_area/CollisionShape2D.disabled = false
		if player_in_area and player != null:
			var direction = (player.position - position).normalized()
			velocity = direction * speed
			move_and_slide()
			$AnimatedSprite2D.play("move")
		else:
			$AnimatedSprite2D.play("idle")
	
	if dead:
		$detection_area/CollisionShape2D.disabled = true

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
	$AnimatedSprite2D.play("death")
	await get_tree().create_timer(1.0).timeout
	queue_free()
