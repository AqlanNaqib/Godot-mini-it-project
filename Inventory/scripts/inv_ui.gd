extends Control

@onready var ItemStackUiClass = preload("res://Inventory/item_stack_ui.tscn")
@onready var inv: Inv = preload("res://Inventory/playerInventory.tres")
@onready var slots: Array = $NinePatchRect/GridContainer.get_children()

var itemInHand: ItemStackUi

var is_open: bool = false

func _ready():
	connect_slots()
	inv.update.connect(update_slots)
	update_slots()
	close()
	
func connect_slots():
	for i in range(slots.size()):
		var slot = slots[i]
		slot.index = i
		
		var callable = Callable(on_slot_clicked)
		callable = callable.bind(slot)
		slot.pressed.connect(callable)

func update_slots():
	for i in range(min(inv.slots.size(), slots.size())):
		var invSlot: InvSlot = inv.slots[i]
		
		if !invSlot.item: continue
		
		var itemStackUi: ItemStackUi = slots[i].itemStackUi
		if !itemStackUi:
			itemStackUi = ItemStackUiClass.instantiate()
			slots[i].insert(itemStackUi)
		itemStackUi.invSlot = invSlot
		itemStackUi.update()
		
func _process(delta):
	if Input.is_action_just_pressed("Inventory"):
		if is_open:
			close()
		else:
			open()
				
func open():
	visible = true
	is_open = true

func close():
	visible = false
	is_open = false

func on_slot_clicked(slot):
	if itemInHand:
		if slot.isEmpty():
			insert_item_inSlot(slot)
		elif can_stack_with(slot):
			stackItems(slot)
		else:
			swapItems(slot)
	else:
		if !slot.isEmpty():
			take_item_fromSlot(slot)

func can_stack_with(slot):
	return slot.itemStackUi != null \
		and itemInHand != null \
		and slot.itemStackUi.invSlot.item.name == itemInHand.invSlot.item.name
		
func take_item_fromSlot(slot):
	itemInHand = slot.takeItem()
	add_child(itemInHand)
	update_item_inHand()

func insert_item_inSlot(slot):
	var item = itemInHand
	
	remove_child(itemInHand)
	itemInHand = null 
	
	slot.insert(item)
	
func swapItems(slot):
	var tempItem = slot.takeItem()
	
	insert_item_inSlot(slot)
	
	itemInHand = tempItem
	add_child(itemInHand)
	update_item_inHand()

func stackItems(slot):
	var slotItem: ItemStackUi = slot.itemStackUi
	var maxAmount = slotItem.invSlot.item.maxAmountPerStack
	var totalAmount = slotItem.invSlot.amount + itemInHand.invSlot.amount
	
	if slotItem.invSlot.amount == maxAmount:
		swapItems(slot)
		return
	if totalAmount <= maxAmount:
		slotItem.invSlot.amount = totalAmount
		itemInHand.invSlot.item = null
		itemInHand.invSlot.amount = 0 
		remove_child(itemInHand)
		itemInHand = null
	else:
		slotItem.invSlot.amount = maxAmount
		itemInHand.invSlot.amount = totalAmount - maxAmount
	
	slotItem.update()
	if itemInHand: 
		itemInHand.update()
	
	update_slots()

func update_item_inHand():
	if !itemInHand: return
	itemInHand.global_position = get_global_mouse_position() - itemInHand.size / 2

func _input(event):
	update_item_inHand()
