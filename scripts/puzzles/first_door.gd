extends Node2D

@onready var pickup_line = $PickupLine

func _ready() -> void: 
	pickup_line.modulate.a = 0	

func _process(_delta) -> void:
	if Global.game_paused:
		return 
	
	if Input.is_action_just_pressed("choice 1"):
		print("The game is over, for now... ")

func _on_interactible_area_entered(_area):
	Global.tween_property(name, pickup_line, "modulate:a", 1) 

func _on_interactible_area_exited(_area):
	Global.tween_property(name, pickup_line, "modulate:a", 0)
