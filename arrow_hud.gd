extends CanvasLayer

@onready var arrow_label := $Control/Label as Label  # More specific path

func _ready():
	# Wait until next frame to ensure all nodes are ready
	await get_tree().process_frame
	update_display(5)  # Initial value

func update_display(count: int):
	if arrow_label:  # Safety check
		arrow_label.text = "Arrows: %d" % count
	else:
		push_error("Arrow Label not found! Check node path.")
