extends Node2D

func _ready():
	if Global.current_iteration == 7:
		var creditscene = preload("res://scenes/credits/Credits.tscn").instantiate()
		Global.hud.add_child(creditscene)

		SoundManager.change_music.emit("softerparttheme")
		SoundManager.stop_wind.emit()

