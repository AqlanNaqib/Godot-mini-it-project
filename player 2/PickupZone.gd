extends Area2D

var items_in_range = {}

func _on_body_entered(body: PhysicsBody2D):
	if body.has_method("pick_up_item"):
		items_in_range[body] = body


func _on_body_exited(body: PhysicsBody2D):
	if items_in_range.has(body):
		items_in_range.erase(body)
