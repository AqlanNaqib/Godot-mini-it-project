extends InvItem

class_name Key

@export var key_id: String = ""

# Change signature to match parent (InvItem)
func use(): # Removed 'player: Player' argument
	print("Using key: ", key_id)
	# If using a key should affect a global game state (e.g., unlock a door),
	# you would interact with the Globals singleton here.
	# For example:
	# Globals.set_door_unlocked(key_id)
