extends CharacterBody2D



@onready var healthbar: ProgressBar = $healthbar





const speed = 80
var current_dir = "none"
var health = 100


func _ready():
	$AnimatedSprite2D.play("front idle")


func _physics_process(delta):
	player_movement(delta)
	update_health()

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
