extends TextureProgressBar

@export var player: NodePath  # Still need to assign player for health updates

func _ready():
	# Set fixed max health
	max_value = 100
	
	# Wait until player node is ready
	await get_tree().process_frame
	
	# Get player node
	var player_node = get_node(player_node)
	if not player_node:
		push_error("Player node not assigned!")
		return
	
	# Set initial health
	value = player_node.health
	
	# Connect health changed signal
	if player_node.has_signal("health_changed"):
		player_node.health_changed.connect(update_health)
	else:
		push_error("Player missing health_changed signal!")

func update_health(new_health):
	value = new_health
	# Visual feedback
	if value < 30:  # Now using absolute values since max is fixed
		tint_progress = Color.RED
	elif value < 60:
		tint_progress = Color.YELLOW
	else:
		tint_progress = Color.GREEN
