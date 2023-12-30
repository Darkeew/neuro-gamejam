extends Area2D

@export_file("*.tscn") var scene_path: String

func _on_body_entered(body):
	if body is Player:
		Global.change_stage.emit(load(scene_path)) 
