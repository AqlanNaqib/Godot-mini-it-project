extends Area2D

@export var itemRes: InvItem

func collect(inv: Inv):
	inv.insert(itemRes)
	queue_free()
