extends Area2D

@export_file("*.tscn") var scene_path: String

@export var player_spot := "PlayerEnterPos"

func _on_body_entered(body):
	if body is Player:
		Global.change_stage.emit(load(scene_path),player_spot) 
