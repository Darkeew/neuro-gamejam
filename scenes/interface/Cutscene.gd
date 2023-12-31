extends Control

@onready var cutscene_player = $CutscenePlayer

func _ready():
	EventBus.register_listener("cutscene", _on_cutscene_event)
	
func _on_cutscene_event(event):
	Global.pause_game.emit()
	
	if event.has("music"):
		SoundManager.change_music.emit(event.music)

	cutscene_player.play(event.cutscene)
	await cutscene_player.animation_finished

	if event.has("music_after"):
		SoundManager.change_music.emit(event.music_after)
	
	Global.unpause_game.emit()
