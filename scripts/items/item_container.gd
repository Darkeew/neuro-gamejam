extends Area2D
class_name ItemContainer 

@export var item: Item

@onready var pickup_line = $PickupLine

func _ready() -> void:
	$Sprite2D.texture = item.texture
	pickup_line.modulate.a = 0

func show_pickup_line() -> void:
	Global.tween_property(name, pickup_line, "modulate:a", 1) 

func hide_pickup_line() -> void:
	Global.tween_property(name, pickup_line, "modulate:a", 0)

