# EnemyFSM.gd
extends Node2D

var current_state: State3 = null
var previous_state: State3 = null

func _ready():
	# Explicitly set the initial state by name.
	# Make sure "Follow" matches the name of your Follow state node in the scene tree.
	current_state = find_child("Follow") as State3 # <-- Changed this line

	if current_state:
		previous_state = current_state
		current_state.enter()
		print("FSM: Initial state set to: ", current_state.name)
	else:
		push_error("FSM Error: Initial state 'Follow' not found!")
		# If the initial state isn't found, this means a critical setup error.
		# You might want to disable the enemy or alert the user.

func change_state(state_name: String):
	if current_state and current_state.name == state_name:
		return

	var new_state: State3 = find_child(state_name) as State3

	if new_state == null:
		push_error("FSM Error: State '" + state_name + "' not found!")
		return

	if current_state: # Exit the previous state (which is currently 'current_state')
		current_state.exit()
		print("FSM: Exited state: ", current_state.name)

	previous_state = current_state
	current_state = new_state

	current_state.enter()
	print("FSM: Entered state: ", current_state.name)

func _physics_process(delta):
	if current_state:
		current_state.transition()
