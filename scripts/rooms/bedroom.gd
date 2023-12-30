extends Node2D

func _ready() -> void: 
	match Global.current_iteration: 
		2:
			$SecondIteration.visible = true 
