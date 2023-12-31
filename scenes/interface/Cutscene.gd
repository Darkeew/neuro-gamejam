extends Control

@onready var cutsceneplayer = $CutscenePlayer

func _ready():
	EventBus.register_listener("cutscene",on_cutscene_event)


func on_cutscene_event(event):
	Global.game_paused = true
	
	SoundManager.change_music.emit(event.music)
	cutsceneplayer.play(event.cutscene)
	await cutsceneplayer.animation_finished
	SoundManager.change_music.emit(event.music_after)
	
	Global.game_paused = false
