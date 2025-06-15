extends CharacterBody2D

@onready var player = get_parent().find_child("player")
@onready var animated_sprite = $AnimatedSprite2D
@onready var progress_bar = $UI/ProgressBar
@onready var attack_cooldown = $AttackCooldown
@onready var attack_range = $AttackRange/CollisionShape2D

@onready var key = $skeleton_collectable
@export var itemRes: InvItem

var direction : Vector2
var can_attack = true
var attack_damage = 20
var player_in_range = false

var health: = 100:
	set(value):
		health = value
		progress_bar.value = value
		if value <= 0:
			progress_bar.visible = false
			find_child("FiniteStateMachine").change_state("Death")
			drop_key()

func _ready():
	set_physics_process(false)
	# Initialize the progress bar with the current health
	progress_bar.max_value = health # Set max value to initial health
	progress_bar.value = health

func _process(_delta):
	if player:
		direction = player.position - position
		
		if direction.x < 0:
			animated_sprite.flip_h = true
		else:
			animated_sprite.flip_h = false

func _physics_process(delta):
	if player_in_range and can_attack:
		attack_player()
	elif player:
		velocity = direction.normalized() * 40
		move_and_collide(velocity * delta)

func attack_player():
	if player and can_attack:
		player.take_damage(attack_damage)
		can_attack = false
		attack_cooldown.start()
		animated_sprite.play("attack")

func take_damage(amount: int): # Modified to accept 'amount' argument
	health -= amount # Subtract the received damage amount
	health = max(0, health) # Ensure health doesn't go below zero
	print("Boss health: ", health) # For debugging purposes
	if health <= 0:
		progress_bar.visible = false
		find_child("FiniteStateMachine").change_state("Death")
		drop_key()

func _on_attack_range_body_entered(body):
	if body.name == "Player":
		player_in_range = true

func _on_attack_range_body_exited(body):
	if body.name == "Player":
		player_in_range = false

func _on_attack_cooldown_timeout():
	can_attack = true
	
func drop_key():
	key.visible = true
	$key_collect_area/CollisionShape2D.disabled = false
	key_collect()
	
func key_collect():
	await get_tree().create_timer(1.5).timeout
	key.visible = false
	player.collect(itemRes)
	queue_free()

func _on_key_collect_area_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player = body
