extends State3
 
@onready var collision = %CollisionShape2D
@onready var progress_bar = %ProgressBar3
 
var player_entered: bool = false:
	set(value):
		player_entered = value
		collision.set_deferred("disabled", value)

 
 
func _on_player_entered(_body):
	player_entered = true
 
 
func transition():
	if player_entered:
		get_parent().change_state("Summon")
