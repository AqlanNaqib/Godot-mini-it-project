extends Area2D

var direction = Vector2.RIGHT
var speed = 300
var damage = 10  # Add this line
 
func _physics_process(delta):
	position += direction * speed * delta
 
 
func _on_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(damage)  # Pass the bullet's damage value
 
 

 


func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	queue_free()
