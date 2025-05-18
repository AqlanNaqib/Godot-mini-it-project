extends Area2D

@export var speed = 200
@export var damage = 15

var direction:Vector2

func _ready():
	await get_tree().create_timer(3).timeout
	queue_free()

func set_direction(bulletDirection):
		direction = bulletDirection
		rotation_degrees = rad_to_deg(global_position.angle_to_point(global_position+direction))

func _physics_process(delta):
		global_position += direction * speed * delta

func _on_body_entered(body):
	if body.is_in_group("enemies"):
		# Call the monster's take_damage function
		body.take_damage(damage)  # Use your damage variable
	queue_free()
