extends Control

@onready var cutsceneplayer = $CutscenePlayer

func _ready():
	EventBus.register_listener("cutscene",on_cutscene_event)


func on_cutscene_event(event):
	cutsceneplayer.play(event.cutscene)
	Global.game_paused = true
	await cutsceneplayer.animation_finished
	Global.game_paused = false
