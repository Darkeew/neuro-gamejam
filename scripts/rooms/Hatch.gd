extends Node2D
@onready var pickup_line = $PickupLine

var player_near = false

func _ready() -> void: 
	pickup_line.modulate.a = 0	
	EventBus.register_listener("enter_hatch", next_scene)

func next_scene(_event):
	var stage_scene = preload("res://scenes/rooms/basement.tscn")
	Global.unpause_game.emit()
	Global.change_stage.emit(stage_scene,"PlayerLadderSpot")
	print("next scene")
	
func _process(_delta):
	if !player_near:
		print("player not near")
		return
	
	if Input.is_action_just_pressed("choice 1"):
		EventBus.emit_event("inspect_hatch")
		print("inspect hatch")
	

func _on_interactible_area_exited(_area:Area2D):
	player_near = false
	Global.tween_property(name, pickup_line, "modulate:a", 0)
	

func _on_interactible_area_entered(_area:Area2D):
	player_near = true
	Global.tween_property(name, pickup_line, "modulate:a", 1) 
