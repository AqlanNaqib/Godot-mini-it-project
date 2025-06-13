extends CanvasLayer

@onready var arrow_label: Label = $Control/Label

func update_arrow_count(count: int):
	arrow_label.text = "Arrows: %d" % count
