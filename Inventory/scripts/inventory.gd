extends Resource

class_name Inv

signal update

@export var slots: Array[InvSlot]

func insert(item: InvItem):
	var itemslots = slots.filter(func(slot): return slot.item == item)
	print("item added:", item)
	if !itemslots.is_empty():
		itemslots[0].amount += 1
	else:
		var emptyslots = slots.filter(func(slot): return slot.item == null)
		if !emptyslots.is_empty():
			emptyslots[0].item = item
			emptyslots[0].amount = 1
	update.emit()

func removeSlot(invSlot: InvSlot):
	var index = slots.find(invSlot)
	if index < 0:
		return
	slots[index] = InvSlot.new()
	update.emit()
func insertSlot(index: int, invSlot: InvSlot):
	slots[index] = invSlot
	update.emit()
