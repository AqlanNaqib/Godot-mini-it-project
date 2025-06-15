extends Resource

class_name InvItem

@export var name: String = ""
@export var texture: Texture2D
@export var maxAmountPerStack: int = 1 # Added default for safety

# The 'use' method now directly interacts with the Globals singleton
# It no longer needs to know about the 'Player' node.
func use(): # No 'player' argument needed
	pass # This 'pass' needs to be overridden by specific item types
