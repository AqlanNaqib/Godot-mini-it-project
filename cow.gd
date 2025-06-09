extends CharacterBody2D

enum State { IDLE, WALK, SLEEP }
enum Direction { FRONT, BACK, LEFT, RIGHT }

@export var move_speed: float = 35.0
@export var energy_drain_rate: float = 0.2
@export var energy_regen_rate: float = 1.5
@export var direction_change_chance: float = 0.01  # 1% chance per frame
@export var state_change_chance: float = 0.005     # 0.5% chance per frame

var current_state: State = State.IDLE
var current_direction: Direction = Direction.FRONT
var energy: float = 100.0
var is_sleeping: bool = false
var rng = RandomNumberGenerator.new()

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready():
	rng.randomize()
	_update_animation()

func _physics_process(delta):
	# Handle energy system
	_handle_energy(delta)
	
	# Random movement decisions
	if not is_sleeping:
		_make_random_decisions()
	
	# Handle movement based on state
	match current_state:
		State.WALK:
			_handle_movement()
		State.IDLE, State.SLEEP:
			velocity = Vector2.ZERO
	
	move_and_slide()
	_update_animation()

func _handle_energy(delta):
	if not is_sleeping:
		energy = max(0, energy - energy_drain_rate * delta)
		if energy <= 0:
			_start_sleeping()
	else:
		energy = min(100, energy + energy_regen_rate * delta)
		if energy >= 100:
			_wake_up()

func _make_random_decisions():
	# Random direction change
	if rng.randf() < direction_change_chance:
		current_direction = rng.randi() % 4
	
	# Random state change between idle/walk
	if rng.randf() < state_change_chance:
		current_state = State.WALK if current_state == State.IDLE else State.IDLE

func _handle_movement():
	match current_direction:
		Direction.FRONT:
			velocity = Vector2(0, move_speed)
		Direction.BACK:
			velocity = Vector2(0, -move_speed)
		Direction.LEFT:
			velocity = Vector2(-move_speed, 0)
			animated_sprite.flip_h = true
		Direction.RIGHT:
			velocity = Vector2(move_speed, 0)
			animated_sprite.flip_h = false

func _start_sleeping():
	is_sleeping = true
	current_state = State.SLEEP
	current_direction = rng.randi() % 4

func _wake_up():
	is_sleeping = false
	current_state = State.IDLE
	energy = 100.0

func _update_animation():
	var anim_name = ""
	
	match current_state:
		State.IDLE: anim_name = "idle_"
		State.WALK: anim_name = "walk_"
		State.SLEEP: anim_name = "sleep_"
	
	match current_direction:
		Direction.FRONT: anim_name += "front"
		Direction.BACK: anim_name += "back"
		Direction.LEFT: anim_name += "left"
		Direction.RIGHT: anim_name += "right"
	
	if animated_sprite.sprite_frames.has_animation(anim_name):
		animated_sprite.play(anim_name)
