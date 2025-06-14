extends CharacterBody2D
 
@onready var player = get_parent().find_child("player")
@onready var sprite = $Sprite2D
@onready var progress_bar = %ProgressBar3
 
var direction : Vector2
 
var health = 100:
	set(value):
		if value < health:
			find_child("FiniteStateMachine").change_state("Stagger")
 
		health = value

 
		if value <= 0:

			find_child("FiniteStateMachine").change_state("Death")
 
 
func _process(_delta):
	direction = player.position - position
 
	if direction.x < 0:
		sprite.flip_h = true
	else:
		sprite.flip_h = false
 
func take_damage(amount: int):
	# Your damage handling logic here
	health -= amount
	# ... rest of damage handling
