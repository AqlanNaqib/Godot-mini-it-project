extends CharacterBody2D

@onready var player = get_parent().find_child("player")
@onready var animated_sprite = $AnimatedSprite2D
@onready var progress_bar = $UI/ProgressBar
@onready var attack_cooldown = $AttackCooldown
@onready var attack_range = $AttackRange/CollisionShape2D

var direction : Vector2
var can_attack = true
var attack_damage = 20
var player_in_range = false

var health: = 10:
	set(value):
		health = value
		progress_bar.value = value
		if value <= 0:
			progress_bar.visible = false
			find_child("FiniteStateMachine").change_state("Death")

func _ready():
	set_physics_process(false)

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
		# Only move if player is not in range
		velocity = direction.normalized() * 40
		move_and_collide(velocity * delta)

func attack_player():
	if player and can_attack:
		player.take_damage(attack_damage)
		can_attack = false
		attack_cooldown.start()
		animated_sprite.play("attack")  # Make sure you have an attack animation

func take_damage():
	health -= 2

func _on_attack_range_body_entered(body):
	if body.name == "Player":
		player_in_range = true

func _on_attack_range_body_exited(body):
	if body.name == "Player":
		player_in_range = false

func _on_attack_cooldown_timeout():
	can_attack = true
