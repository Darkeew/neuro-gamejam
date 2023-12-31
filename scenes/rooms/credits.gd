extends Node2D

func _ready():
	if Global.current_iteration == 7:
		var creditscene = preload("res://scenes/credits/Credits.tscn").instantiate()
		Global.hud.add_child(creditscene)

