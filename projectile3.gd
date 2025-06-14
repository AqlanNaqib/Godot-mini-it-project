extends Area2D
 
var player
var direction 
var speed = 250
 
func _ready():
	player = get_parent().find_child("player")
	direction = (player.position - position).normalized()
 
 
func _physics_process(delta):
	position += direction * speed * delta
 
 
 
func _on_screen_exited():
	queue_free()
