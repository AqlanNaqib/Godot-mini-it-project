extends Area2D

@export var itemRes: InvItem

func collect(inv: Inv):
	if inv and itemRes:
		inv.insert(itemRes)
		queue_free() # Remove the collectable item from the scene after it's picked up
