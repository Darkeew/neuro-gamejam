extends Node2D
@onready var pickup_line = $PickupLine

var player_near = false
var has_not_document = true

func _ready() -> void: 
	pickup_line.modulate.a = 0	
	EventBus.register_listener("pickup_document",doc_pickup)
	EventBus.register_listener("go_out_basement_scene_change",go_out)

func doc_pickup():
	has_not_document = false

func _process(_delta):
	if Global.player == null:
		return
	if !player_near:
		return
	
	if Input.is_action_just_pressed("choice 1") and !has_not_document:
		EventBus.emit_event("go_out_basement")


func go_out():
	var stage_scene = preload("res://scenes/rooms/hatch_room.tscn")
	Global.unpause_game.emit()
	Global.change_stage.emit(stage_scene,"HatchStartPos")



func _on_interactible_area_exited(_area:Area2D):
	
	player_near = false
	if has_not_document:
		return
	Global.tween_property(name, pickup_line, "modulate:a", 0)
	

func _on_interactible_area_entered(_area:Area2D):
	player_near = true
	if has_not_document:
		return
	Global.tween_property(name, pickup_line, "modulate:a", 1) 
