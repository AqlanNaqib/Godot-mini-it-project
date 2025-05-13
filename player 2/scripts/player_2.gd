extends CharacterBody2D

class_name Player

@onready var gun = $Gun
@onready var healthbar: ProgressBar = $healthbar
@onready var bullet_spawn_point = $CenterMarker  # Add a Marker2D node at center






const speed = 80
var current_dir = "none"
var health = 100


func _ready():
	$AnimatedSprite2D.play("front idle")


func _physics_process(delta):
	player_movement(delta)  # Add this line
	update_health()
	
	if Input.is_action_pressed("attack"):
		gun.setup_direction(get_shooting_direction())
		gun.shoot()


# Helper function to convert current_dir to Vector2
func get_shooting_direction() -> Vector2:
	match current_dir:
		"right":
			return Vector2.RIGHT
		"left":
			return Vector2.LEFT
		"up":
			return Vector2.UP
		"down":
			return Vector2.DOWN
		_:
			return Vector2.RIGHT  # Default to right if no direction

func player_movement(delta):
	
	if Input.is_action_pressed("ui_right"):
		current_dir = "right"
		play_anim(1)
		velocity.x = speed
		velocity.y = 0
	elif Input.is_action_pressed("ui_left"):
		current_dir = "left"
		play_anim(1)
		velocity.x = -speed
		velocity.y = 0
	elif  Input.is_action_pressed("ui_down"):
		current_dir = "down"
		play_anim(1)
		velocity.y = speed
		velocity.x = 0
	elif  Input.is_action_pressed("ui_up"):
		current_dir = "up"
		play_anim(1)
		velocity.y = -speed
		velocity.x = 0
	else:
		play_anim(0)
		velocity.x = 0
		velocity.y = 0
		
	move_and_slide()
	
	
func play_anim(movement):
	var dir = current_dir
	var anim = $AnimatedSprite2D
	
	if dir == 'right':
		anim.flip_h = false
		if movement == 1:
			anim.play("walk right")
		elif movement == 0:
			anim.play("right down idle")
	
			
	if dir == 'left':
		anim.flip_h = false
		if movement == 1:
			anim.play("walk left")
		elif movement == 0:
			anim.play("left down idle")
			
	
	if dir == 'down':
		anim.flip_h = false
		if movement == 1:
			anim.play("walk down")
		elif movement == 0:
			anim.play("front idle")
			
			
	if dir == 'up':
		anim.flip_h = false
		if movement == 1:
			anim.play("walk up")
		elif movement == 0:
			anim.play("back idle")
			

func update_health():
	var healthbar = $healthbar
	healthbar.value = health
	

		
		
	
	

func _on_regen_timer_timeout():
	if health < 100:
		health = health + 20
		if health > 100:
			health = 100
	if health  <= 0:
		health = 0
