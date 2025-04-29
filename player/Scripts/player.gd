class_name Player extends CharacterBody2D

var move_speed : float = 100.0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'Delta' is the elapsed time since the previous frame.
func _process(delta):
	var direction : Vector2 = Vector2.ZERO
	direction.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	direction.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	
	velocity = direction * move_speed
	
	pass


func _physics_process(delta):
	move_and_slide()
	
func _input(event):
	if event.is_action_pressed("pickup"):
		if $PickUpZone.items_in_range.size() > 0:
			var pickup_item = $PickUpZone.items_in_range.values()[0]
			pickup_item.pick_up_item(self)
			$PickUpZone.items_in_range.erase(pickup_item)
