extends Node2D

@export var shoot_speed : float = 10.0  # Shots per second
@export var burst_mode : bool = false  # Set true for automatic fire while holding
@export var max_bullets : int = 0  # 0 for unlimited

const BULLET = preload("res://bullet.tscn")

@onready var marker_2d = $Marker2D
@onready var shoot_timer = $ShootSpeedTimer

var bullets_fired : int = 0
var bullet_direction = Vector2.RIGHT

func _ready():
	update_fire_rate()

func update_fire_rate():
	shoot_timer.wait_time = 1.0 / shoot_speed

func shoot():
	if shoot_timer.is_stopped() and (max_bullets == 0 or bullets_fired < max_bullets):
		fire_bullet()
		
		if burst_mode:
			shoot_timer.start()


func _on_shoot_speed_timer_timeout():
	if Input.is_action_pressed("attack") and burst_mode:
		fire_bullet()
		if max_bullets > 0 and bullets_fired >= max_bullets:
			shoot_timer.stop()
	else:
		shoot_timer.stop()

func fire_bullet():
	var bullet = BULLET.instantiate()
	bullet.set_direction(bullet_direction)
	get_parent().add_child(bullet)
	bullet.global_position = marker_2d.global_position
	bullets_fired += 1

func setup_direction(direction):
	bullet_direction = direction.normalized()
	
	# Visual rotation handling
	if abs(direction.x) > abs(direction.y):  # Horizontal dominant
		rotation_degrees = 0
		scale.x = 1 if direction.x > 0 else -1
	else:  # Vertical dominant
		scale.x = 1
		rotation_degrees = 90 if direction.y > 0 else -90
