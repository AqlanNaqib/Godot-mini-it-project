extends Node
const ItemClass = preload("res://coding/Item.gd")
const SlotClass = preload("res://coding/Slot.gd")
const NUM_INVENTORY_SLOTS = 15

var inventory ={
	0:["Axe", 1],
	1:["Apple", 5],
	2:["Apple", 60]
}

func add_item(item_name, item_quantity):
	for item in inventory:
		if inventory[item][0] == item_name:
			inventory[item][1] += item_quantity
			return
	for i in range(NUM_INVENTORY_SLOTS):
		if inventory.has(i) == false:
			inventory[i] = [item_name, item_quantity]
			return

func add_item_to_empty_slot(item: ItemClass, slot: SlotClass):
	inventory[slot.slot_index] = [item.item_name, item.item_quantity]
	
func remove_item(slot: SlotClass):
	inventory.erase(slot.slot_index)

func add_item_quantity(slot: SlotClass, quantity_to_add: int):
	inventory[slot.slot_index][1] += quantity_to_add
