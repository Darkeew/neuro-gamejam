extends Node2D

@onready var pickup_line = $PickupLine
var scene_path = load("res://scenes/rooms/wallpaper_room.tscn") 

var near = false
func _ready() -> void: 
	pickup_line.modulate.a = 0	


func _process(_delta) -> void:
	if Global.game_paused or !near:
		return 
	
	if Input.is_action_just_pressed("choice 1"):
		if Global.current_iteration < 4: 
			for item in Global.collected_items:
				if item.tag == "First Key":
					EventBus.emit_event("wrong_key")
					return
			EventBus.emit_event("key_missing")
		if Global.current_iteration == 4:
			for item in Global.collected_items:
				if item.tag == "Second Key":
					Global.change_stage.emit(scene_path) 
					return
			EventBus.emit_event("wrong_key")
		if Global.current_iteration > 4:
			EventBus.emit_event("already_been")
		
		
func _on_interactible_area_entered(_area):
	Global.tween_property(name, pickup_line, "modulate:a", 1) 
	near = true

func _on_interactible_area_exited(_area):
	Global.tween_property(name, pickup_line, "modulate:a", 0)
	near = false
