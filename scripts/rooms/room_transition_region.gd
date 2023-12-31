extends Area2D

@export_file("*.tscn") var scene_path: String

@export var player_spot := "PlayerEnterPos"
@export var direction := Vector2(0,1)

func _on_body_entered(body):
	if body is Player:
		Global.change_stage.emit(load(scene_path),player_spot) 
