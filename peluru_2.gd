extends Area2D

@onready var animated_sprite = $AnimatedSprite2D


var acceleration: Vector2 = Vector2.ZERO
var velocity: Vector2 = Vector2.ZERO

var target_player_ref: CharacterBody2D = null 

# New function to set the player target from the spawner (enemy)
func set_target_player(player_node: CharacterBody2D):
	target_player_ref = player_node

func _physics_process(delta):
	if target_player_ref: # Only move if we have a target player
		acceleration = (target_player_ref.position - position).normalized() * 700

		velocity += acceleration * delta
		rotation = velocity.angle()

		velocity = velocity.limit_length(150)

		position += velocity * delta
	else:
		# If for some reason there's no target, perhaps you want it to despawn
		# or move in a straight line. For now, it will just stop.
		pass


func _on_body_entered(body):
	# Check if the collided body is the player we're targeting
	if body == target_player_ref:
		# Call the take_damage function on the player.
		# You can adjust the damage amount (e.g., 15) as needed.
		if target_player_ref.has_method("take_damage"): # Good practice to check if method exists
			target_player_ref.take_damage(15)

	# Always free the missile after it hits something
	queue_free()
