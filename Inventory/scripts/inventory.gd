extends Resource

class_name Inv

signal update
signal use_item

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
		
	remove_atIndex(index)

func remove_atIndex(index: int):
	slots[index] = InvSlot.new()
	update.emit()
	
func insertSlot(index: int, invSlot: InvSlot):
	slots[index] = invSlot
	update.emit()

func use_item_atIndex(index: int):
	if index < 0 || index >= slots.size() || !slots[index].item: 
		return
		
	var slot = slots[index]
	use_item.emit(slot.item)
	if slot.amount > 1:
		slot.amount -= 1
		update.emit()
		return
	
	remove_atIndex(index)

func clear():
	for slot in slots:
		slot.item = null
		slot.amount = 0
