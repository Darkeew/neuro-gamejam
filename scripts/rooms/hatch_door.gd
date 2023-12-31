extends Node2D

@onready var pickup_line = $PickupLine
var scene_path = load("res://scenes/rooms/hatch_room.tscn") 

var near = false
func _ready() -> void: 
	pickup_line.modulate.a = 0	

	EventBus.register_condition_solver("doc_check", doc_check)

func doc_check(_event) -> bool:
	if Global.current_iteration == 5:
		for item in Global.collected_items:
			if item.tag == "doc":
				return true
	
	return false


func _process(_delta) -> void:
	if Global.game_paused or !near:
		return 
	
	if Input.is_action_just_pressed("choice 1"):
		if Global.current_iteration == 5:
			print("here")
			Global.change_stage.emit(scene_path) 
			return
			for item in Global.collected_items:
				if item.tag == "Second Key":
					Global.change_stage.emit(scene_path) 
					return
			EventBus.emit_event("wrong_key")
		
func _on_interactible_area_entered(_area):
	Global.tween_property(name, pickup_line, "modulate:a", 1) 
	near = true

func _on_interactible_area_exited(_area):
	Global.tween_property(name, pickup_line, "modulate:a", 0)
	near = false
