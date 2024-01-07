extends Control

@onready var cutscene_player = $CutscenePlayer
var current_event = null

func _ready():
	EventBus.register_listener("cutscene", _on_cutscene_event)
	
func _on_cutscene_event(event):
	current_event = event

	Global.pause_game.emit()
	
	if event.has("music"):
		SoundManager.change_music.emit(current_event.music)

	cutscene_player.play(current_event.cutscene)
	await cutscene_player.animation_finished

	_next_scene()

func _process(_delta):
	if Input.is_action_just_pressed("escape") and current_event:
		var animation_length = cutscene_player.current_animation_length
		cutscene_player.seek(animation_length - 1.0)
	
func _next_scene() -> void:
	if current_event.has("music_after"):
		SoundManager.change_music.emit(current_event.music_after)
	
	Global.unpause_game.emit()
	
	current_event = null