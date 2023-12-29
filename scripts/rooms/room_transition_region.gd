extends Area2D

@export var room: PackedScene

func _on_body_entered(body):
	if body is Player:
		Global.change_stage.emit(room) 
