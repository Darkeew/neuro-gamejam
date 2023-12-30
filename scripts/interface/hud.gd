extends CanvasLayer

@onready var inventory = %Inventory
@onready var inventory_item_container = %InventoryItemContainer
@onready var inventory_cell = %InventoryCell

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.pickup_item.connect(_on_pickup_item)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Global.game_paused:
		inventory.visible = false 
		return 
	
	if Input.is_action_just_pressed("inventory"):
		if inventory.visible:
			inventory.visible = false 
		else:
			inventory.visible = true 

func _on_pickup_item(item: Item) -> void:
	print(item)
	var new_inventory_cell = inventory_cell.duplicate()
	new_inventory_cell.visible = true 
	new_inventory_cell.get_node("TextureRect").texture = item.texture
	inventory_item_container.call_deferred("add_child", new_inventory_cell)
