extends Resource

class_name Inv

signal update
signal use_item

@export var slots: Array[InvSlot]

func insert(item: InvItem):
	# Add null check for 'slot' within the filter
	var itemslots = slots.filter(func(slot): return slot != null and slot.item == item)
	print("item added:", item)
	if !itemslots.is_empty():
		itemslots[0].amount += 1
	else:
		# Add null check for 'slot' within the filter
		var emptyslots = slots.filter(func(slot): return slot != null and slot.item == null)
		if !emptyslots.is_empty():
			emptyslots[0].item = item
			emptyslots[0].amount = 1
		else: # No empty slots found
			print("No empty slots available in inventory for ", item.name)
			# You might want to add logic here to drop the item, or not pick it up.
			return # Exit if no slot found
	update.emit()

func removeSlot(invSlot: InvSlot):
	var index = slots.find(invSlot)
	if index < 0:
		return
		
	remove_atIndex(index)

func remove_atIndex(index: int):
	# Ensure the index is valid
	if index < 0 || index >= slots.size():
		printerr("Inv.remove_atIndex: Invalid index ", index)
		return

	slots[index] = InvSlot.new() # This correctly re-initializes the slot
	update.emit()
	
func insertSlot(index: int, invSlot: InvSlot):
	# Ensure the index is valid and invSlot is not null
	if index < 0 || index >= slots.size() || invSlot == null:
		printerr("Inv.insertSlot: Invalid index or invSlot is null. Index: ", index, " InvSlot: ", invSlot)
		return

	slots[index] = invSlot
	update.emit()

func use_item_atIndex(index: int):
	# Add null check for slots[index] before accessing .item
	if index < 0 || index >= slots.size() || slots[index] == null || !slots[index].item:
		return
		
	var slot = slots[index]
	use_item.emit(slot.item) # Signal that an item was used
	
	# Execute the item's use effect
	slot.item.use() # Calls the item's use() method which now interacts with Globals

	if slot.amount > 1:
		slot.amount -= 1
		update.emit()
	else:
		remove_atIndex(index) # This emits update as well
