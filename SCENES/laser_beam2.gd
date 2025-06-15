extends State2

@onready var pivot = $"../../Pivot"
var can_transition: bool = false

# Add a timer for periodic damage checks
var damage_timer: Timer 
@export var damage_per_tick: int = 10 # Damage amount per tick
@export var damage_tick_interval: float = 0.2 # How often to apply damage

func _ready():
	# Initialize the damage timer
	damage_timer = Timer.new()
	damage_timer.wait_time = damage_tick_interval
	damage_timer.autostart = false
	damage_timer.one_shot = false
	damage_timer.timeout.connect(_on_damage_timer_timeout)
	add_child(damage_timer)

func enter():
	super.enter()
	set_target() # Make sure the laser is aimed correctly
	
	await play_animation("laser_cast")
	
	# Start playing the main laser animation
	animation_player.play("laser")
	
	# Start the damage timer when the laser animation begins
	damage_timer.start()
	
	await animation_player.animation_finished
	
	# Stop the damage timer when the laser animation finishes
	damage_timer.stop()
	
	can_transition = true

func play_animation(anim_name):
	# This function remains the same for playing animations
	animation_player.play(anim_name)
	await animation_player.animation_finished

func set_target():
	# This aligns the pivot (presumably the laser's origin) towards the player
	pivot.rotation = (owner.player.position - pivot.global_position).angle()

func _on_damage_timer_timeout():
	# This function is called periodically by the timer
	if owner.player:
		# Calculate the direction of the laser beam
		var laser_direction = (owner.player.position - pivot.global_position).normalized()
		
		# Define a "hitbox" for the laser as a ray or a narrow rectangle
		# For simplicity, we'll check if the player is "along the beam"
		# You'll need to define the laser's range/length
		var laser_length = 500 # Adjust this to your laser's visual length
		
		var player_relative_pos = owner.player.position - pivot.global_position
		
		# Project player's position onto the laser's direction vector
		var projection = laser_direction.dot(player_relative_pos)
		
		# Check if the player is within the laser's length (along the beam)
		if projection > 0 and projection < laser_length:
			# Check if the player is close enough to the "line" of the laser
			# This creates a narrow "hitbox" around the laser line
			var distance_from_line = abs(laser_direction.cross(player_relative_pos))
			var laser_width_tolerance = 30 # Adjust this value for the laser's width
			
			if distance_from_line < laser_width_tolerance:
				owner.player.take_damage(damage_per_tick)
				print("Player hit by laser! Health: ", owner.player.health) # Debugging

func transition():
	if can_transition:
		can_transition = false
		get_parent().change_state("Dash")
