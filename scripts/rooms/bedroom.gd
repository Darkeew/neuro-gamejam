extends Node2D
var uninteractable_piano = preload("res://scenes/rooms/fifth_iteration_piano.tscn")

func _ready() -> void: 
	match Global.current_iteration: 
		2:
			$SecondIteration.visible = true 
		5:
			var piano = uninteractable_piano.instantiate()
			add_child(piano)
