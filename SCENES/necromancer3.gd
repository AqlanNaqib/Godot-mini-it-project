extends CharacterBody2D
 
@onready var player = get_parent().find_child("player")
@onready var sprite = $Sprite2D
@onready var progress_bar = %ProgressBar3 # Using NodePath directly if it's correct
 
var direction : Vector2
 
var health = 100:
	set(value):
		# Only trigger Stagger if health is actually decreasing
		if value < health:
			find_child("FiniteStateMachine").change_state("Stagger")
 
		health = value

 
		if value <= 0:
	
			find_child("FiniteStateMachine").change_state("Death")
 
 
func _ready():
	set_physics_process(false)
	# Initialize the progress bar with the current health


 
func _process(_delta):
	direction = player.position - position
 
	if direction.x < 0:
		sprite.flip_h = true
	else:
		sprite.flip_h = false
 
func take_damage(amount: int): # Modified to accept 'amount' argument
	health -= amount # Subtract the received damage amount
	health = max(0, health) # Ensure health doesn't go below zero
	print("Boss health: ", health) # For debugging purposes
