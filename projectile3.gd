extends Area2D
 
var player
var direction
var speed = 250
var damage = 25 
 
func _ready():
	player = get_parent().find_child("player")
	
	
	if player:
		direction = (player.position - position).normalized()
	else:
		
		print("Boss Projectile: Player not found!")
		queue_free()
		return

	
	connect("body_entered", Callable(self, "_on_body_entered"))
	
	
	set_as_top_level(true) 
 
func _physics_process(delta):
	
	if direction != null:
		position += direction * speed * delta
 
func _on_body_entered(body):
	
	if body.name == "Player" or body.has_method("take_damage"):
		body.take_damage(damage) 
		queue_free() 
	
func _on_screen_exited(): 
	queue_free()
