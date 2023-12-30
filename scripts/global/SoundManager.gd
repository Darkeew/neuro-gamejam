extends Node

const MUSIC_PATH = "res://assets/music/%s"
const SFX_PATH = "res://assets/sfx/%s"
const INIT_VOLUME = -40.0

@onready var music_player := $MusicPlayer
@onready var footsteps_player := $FootstepsPlayer
@onready var misc_player := $MiscPlayer

signal play_footstep_sound
signal play_sound(sound_name: String)
signal change_stage(stage_name: String)

var music_bus := AudioServer.get_bus_index("Music")
var sfx_bus := AudioServer.get_bus_index("SFX")

@onready var sounds := {
	"key_collect": load(SFX_PATH % "key_collect.ogg"),
	"button_press": load(SFX_PATH % "button_sound.ogg")
}

@onready var footsteps := {
	"Bedroom": load(SFX_PATH % "woodstep.tres"),
	"Hallway": load(SFX_PATH % "carpetstep.tres")
}

@onready var music := {
	"Bedroom": load(MUSIC_PATH % "part2theme.ogg"),
	"Hallway": load(MUSIC_PATH % "part3theme.ogg"),
}

var tweens := {}

func _ready() -> void:
	_connect_signals()
	_init_players()

func _connect_signals() -> void:
	play_footstep_sound.connect(_on_play_footstep_sound)
	play_sound.connect(_on_play_sound)
	change_stage.connect(_on_change_stage)

func _init_players() -> void:
	_load_music_file("Bedroom")
	_change_footsteps_soundbank("Bedroom")

func _on_change_stage(stage_name: String) -> void:
	if not stage_name:
		printerr("Stage %s was not expected" % stage_name)
		return

	var callback := func():
		_load_music_file(stage_name)

	_tween_volume(INIT_VOLUME, callback)	

	_change_footsteps_soundbank(stage_name)	

func _change_footsteps_soundbank(bank_name: String) -> void:
	if footsteps.has(bank_name):
		footsteps_player.stream = footsteps[bank_name]
	else:
		printerr("Footsteps sound bank %s was not found" % bank_name)

func _on_play_sound(sound_name: String) -> void:
	if not misc_player.playing and sounds.has(sound_name):
		misc_player.stream = sounds[sound_name]
		misc_player.play()
	else:
		printerr("Sound file %s was not found" % sound_name)

func _on_play_footstep_sound() -> void:
	footsteps_player.play()

func _load_music_file(stage_name: String) -> void:
	if not music.has(stage_name):
		printerr("Music file for stage %s was not found" % stage_name)

	music_player.stream = music[stage_name]	
	music_player.volume_db = INIT_VOLUME
	music_player.play()
	
	_tween_volume(0.0)

func _tween_volume(value: float, callback = null):	
	if tweens.has("main"):
		tweens["main"].kill()

	tweens["main"] = create_tween().set_trans(Tween.TRANS_QUAD)
	tweens["main"].tween_property(music_player, "volume_db", value, 1.5)

	if callback is Callable:
		tweens["main"].tween_callback(callback)
