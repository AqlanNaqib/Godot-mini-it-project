extends Node2D
 
var current_state: State3
var previous_state: State3
 
func _ready():
	current_state = get_child(0) as State3
	previous_state = current_state
	current_state.enter()
 
func change_state(state):
	if state == previous_state.name:
		return
 
	current_state = find_child(state) as State3
	current_state.enter()
 
 
	previous_state.exit()
	previous_state = current_state
