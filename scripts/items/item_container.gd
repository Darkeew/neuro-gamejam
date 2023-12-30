extends Area2D
class_name ItemContainer 

@export var item: Item

@onready var pickup_line = $PickupLine

func _ready() -> void:
	$Sprite2D.texture = item.texture

func show_pickup_line() -> void:
	pickup_line.visible = true 

func hide_pickup_line() -> void: 
	pickup_line.visible = false 
