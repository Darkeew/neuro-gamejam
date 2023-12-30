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

var sounds := {
	"key_collect": "key_collect.ogg",
	"button_press": "button_sound.ogg"
}

var footsteps := {
	"Main": "woodstep.tres",
	"Hallway": "carpetstep.tres"
}

var music := {
	"Main": "part2theme.ogg",
	"Hallway": "part3theme.ogg",
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
	_load_music_file("Main")
	_change_footsteps_soundbank("Main")

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
		var bank := load(SFX_PATH % footsteps[bank_name])
		footsteps_player.stream = bank
	else:
		printerr("Footsteps sound bank %s was not found" % bank_name)

func _on_play_sound(sound_name: String) -> void:
	if not misc_player.playing and sounds.has(sound_name):
		var sound := AudioStreamOggVorbis.load_from_file(SFX_PATH % sounds[sound_name])
		misc_player.stream = sound
		misc_player.play()
	else:
		printerr("Sound file %s was not found" % sound_name)

func _on_play_footstep_sound() -> void:
	footsteps_player.play()

func _load_music_file(stage_name: String) -> void:
	if not music.has(stage_name):
		printerr("Music file for stage %s was not found" % stage_name)

	var music_name: String = music[stage_name]
	var music_file := AudioStreamOggVorbis.load_from_file(MUSIC_PATH % music_name)
	music_player.stream = music_file
	
	music_player.volume_db = INIT_VOLUME
	music_player.play()
	
	_tween_volume(0.0)

func _tween_volume(value: float, callback = null):	
	if tweens.has("main"):
		tweens["main"].kill()

	tweens["main"] = create_tween().set_trans(Tween.TRANS_QUAD)
	tweens["main"].tween_property(music_player, "volume_db", value, 2)

	if callback is Callable:
		tweens["main"].tween_callback(callback)
