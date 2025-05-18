extends Node2D

@export var shoot_speed : float = 10.0  # Shots per second
@export var burst_mode : bool = false  # Set true for automatic fire while holding
@export var max_bullets : int = 0  # 0 for unlimited



@onready var marker_2d = $Marker2D
@onready var shoot_timer = $ShootSpeedTimer

var bullets_fired : int = 0
var bullet_direction = Vector2.RIGHT

func _ready():
	update_fire_rate()

func update_fire_rate():
	shoot_timer.wait_time = 1.0 / shoot_speed







func setup_direction(direction):
	bullet_direction = direction.normalized()
	
	# Visual rotation handling
	if abs(direction.x) > abs(direction.y):  # Horizontal dominant
		rotation_degrees = 0
		scale.x = 1 if direction.x > 0 else -1
	else:  # Vertical dominant
		scale.x = 1
		rotation_degrees = 90 if direction.y > 0 else -90
