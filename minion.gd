extends CharacterBody2D
 
@onready var player = get_tree().get_first_node_in_group("player") 
@onready var animation = $AnimatedSprite2D
 
func _ready():
	set_physics_process(false)
	await animation.animation_finished
	set_physics_process(true)
	animation.play("idle")
 
func _physics_process(_delta):
	var direction = player.position - position
	velocity = direction.normalized() * 60
	move_and_slide()
 
func take_damage():
	queue_free()
