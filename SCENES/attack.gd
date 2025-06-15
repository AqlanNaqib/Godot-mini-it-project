extends State
 
func enter():
	super.enter()
	combo()
 
func attack(move = "1"):
	animation_player.play("attack_" + move)
	await animation_player.animation_finished
	
	# --- ADDED CODE START ---
	# Get a reference to the player node from the owner (the boss)
	# Assuming 'player' is correctly set up in your final_boss_main_code
	var player_node = owner.player 
	if player_node:
		# Check if the player is within the boss's attack range
		# You'll need to define how 'attack_range' is checked for the boss.
		# A simple way is to check the distance or use a dedicated Area2D.
		# For this example, let's assume the boss has an 'attack_range_node' (e.g., an Area2D)
		# and it needs to check if the player is inside it.
		# If you don't have a specific attack range Area2D for the boss,
		# you might need to add one or use a distance check here.
		
		# For now, let's assume the boss will always try to deal damage after an attack animation,
		# and you'll rely on the player's collision detection for who gets hit.
		# A more robust solution involves checking if the player is actually within range
		# when the attack connects.
		
		# Directly call the take_damage function on the player
		# You can set the damage amount here or get it from a variable in the boss script.
		var damage_amount = 30 # Example damage, adjust as needed
		player_node.take_damage(damage_amount)
		print("Player hit for ", damage_amount, " damage!")
	# --- ADDED CODE END ---
 
func combo():
	var move_set = ["1","1","2"]
	for i in move_set:
		await attack(i)
 
	combo()
 
func transition():
	if owner.direction.length() > 40:
		get_parent().change_state("Follow")
