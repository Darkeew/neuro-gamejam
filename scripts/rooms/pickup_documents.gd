extends Node2D
@onready var pickup_line = $PickupLine
@export var document : Sprite2D
@export var newtexture : Texture

@export var item: Item

var player_near = false
var done = false

func _ready() -> void: 
	pickup_line.modulate.a = 0	

func _process(_delta):
	if Global.player == null or done:
		return
	if !player_near:
		return
	
	if Input.is_action_just_pressed("choice 1"):
		EventBus.emit_event("pickup_document")
		EventBus.emit_event("piano_book")
		document.texture = newtexture
		pickup_line.visible = false
		done = true
		Global.pickup_item.emit(item)
	





func _on_interactible_area_exited(_area:Area2D):
	player_near = false
	Global.tween_property(name, pickup_line, "modulate:a", 0)
	

func _on_interactible_area_entered(_area:Area2D):
	player_near = true
	Global.tween_property(name, pickup_line, "modulate:a", 1) 
