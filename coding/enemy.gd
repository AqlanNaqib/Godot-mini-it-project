extends CharacterBody2D

var speed = 40
var player_chase = false
var player = null
@export var max_health := 30
var current_health := max_health

func take_damage(amount):
	current_health -= amount
	# Optional: Add damage effect (flash, sound, etc.)
	$AnimationPlayer.play("hit_flash")  # Example
	
	if current_health <= 0:
		die()

func die():
	# Optional death effects before disappearing
	$CollisionShape2D.set_deferred("disabled", true)  # Disable collisions
	$DeathSound.play()  # Example sound
	$AnimationPlayer.play("death_animation")  # Example animation
	await $AnimationPlayer.animation_finished  # Wait if you have animation
	queue_free()  # Remove from scene

func _physics_process(delta):
	if player_chase:
		position += (player.position - position)/speed
		
		$AnimatedSprite2D.play("walk")
		
		if(player.position.x - position.x) < 0:
			$AnimatedSprite2D.flip_h = true
		else: 
			$AnimatedSprite2D.flip_h = false
	else:
		$AnimatedSprite2D.play("idle")
	
func _on_detection_area_body_entered(body: Node2D) -> void:
	player = body
	player_chase = true

func _on_detection_area_body_exited(body: Node2D) -> void:
	player = null
	player_chase = false
