extends CanvasLayer

@onready var inventory = %Inventory
@onready var inventory_item_container = %InventoryItemContainer
@onready var inventory_cell = %InventoryCell
@onready var password_inputs = $PasswordInputsContainer
@onready var sticky_note = $StickyNoteContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	password_inputs.modulate.a = 0
	sticky_note.modulate.a = 0

	Global.pickup_item.connect(_on_pickup_item)
	Global.show_password_inputs.connect(_on_show_password_inputs)
	Global.hide_password_inputs.connect(_on_hide_password_inputs)
	Global.show_sticky_note.connect(_on_show_sticky_note)
	Global.hide_sticky_note.connect(_on_hide_sticky_note)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
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

func _on_show_password_inputs() -> void:
	password_inputs.visible = true
	Global.tween_property(name, password_inputs, "modulate:a", 1, 0.5) 

func _on_hide_password_inputs() -> void:
	Global.tween_property(name, password_inputs, "modulate:a", 0, 0.5, func(): password_inputs.visible = false) 

func _on_show_sticky_note() -> void:
	sticky_note.visible = true
	Global.tween_property(name, sticky_note, "modulate:a", 1, 0.5) 
	
func _on_hide_sticky_note() -> void:
	Global.tween_property(name, sticky_note, "modulate:a", 0, 0.5, func(): sticky_note.visible = false) 