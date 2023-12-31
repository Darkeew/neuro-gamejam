extends Node2D

@onready var pickup_line = $PickupLine


var near = false
func _ready() -> void: 
	pickup_line.modulate.a = 0	

func _process(_delta) -> void:
	if Global.game_paused or !near:
		return 
	
	if Global.current_iteration != 3:
		pass 

func _on_interactible_area_entered(_area):
	Global.tween_property(name, pickup_line, "modulate:a", 1) 
	near = true

func _on_interactible_area_exited(_area):
	Global.tween_property(name, pickup_line, "modulate:a", 0)
	near = false
