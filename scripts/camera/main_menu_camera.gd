extends Node2D


func _ready():
	if not Global.game_paused:
		get_parent().queue_free()
	Global.game_unpaused.connect(_on_unpaused)

func _on_unpaused():
	get_parent().queue_free()
