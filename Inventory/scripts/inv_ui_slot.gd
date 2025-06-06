extends Button

@onready var container: CenterContainer = $CenterContainer

@onready var inv = preload("res://Inventory/playerInventory.tres")

var itemStackUi: ItemStackUi
var index: int


func insert(isg: ItemStackUi):
	itemStackUi = isg
	container.add_child(itemStackUi)
	
	if !itemStackUi.invSlot || inv.slots[index] == itemStackUi.invSlot:
		return
	
	inv.insertSlot(index, itemStackUi.invSlot)
	
func takeItem():
	var item = itemStackUi
	
	container.remove_child(itemStackUi)
	itemStackUi = null

	return item

func isEmpty():
	return !itemStackUi
