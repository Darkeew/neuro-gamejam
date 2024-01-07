extends Node

const MUSIC_PATH = "res://assets/music/%s"
const SFX_PATH = "res://assets/sfx/%s"
const INIT_VOLUME = -80.0

@onready var music_player := $MusicPlayer
@onready var footsteps_player := $FootstepsPlayer
@onready var misc_player := $MiscPlayer
@onready var wind_player := $WindPlayer

signal play_footstep_sound
signal stop_music
signal play_sound(sound_name: String)
signal change_music(track_name: String)
signal change_footsteps(bank_name: String)
signal stop_wind()

var music_bus := AudioServer.get_bus_index("Music")
var sfx_bus := AudioServer.get_bus_index("SFX")

@onready var sounds := {
	"key_collect": load(SFX_PATH % "key_collect.ogg"),
	"button_press": load(SFX_PATH % "button_sound.ogg"),
	"door_open": load(SFX_PATH % "door-open.ogg"),
	"door_closed": load(SFX_PATH % "door-closed.ogg"),
	"safe_failed": load(SFX_PATH % "failedsafe.ogg"),
	"safe_open": load(SFX_PATH % "safeopen.ogg"),
	"safe_input": load(SFX_PATH % "safeinput.ogg"),
	"paper_pickup": load(SFX_PATH % "paperpickup.ogg"),
	"vase_break": load(SFX_PATH % "vasebreak.ogg"),
	"book_rip": load(SFX_PATH % "bookrip.ogg"),
	"hatch_close": load(SFX_PATH % "hatchclose.ogg"),
	"hatch_open": load(SFX_PATH % "hatchopen.ogg"),
}

@onready var footsteps := {
	"Bedroom": load(SFX_PATH % "woodstep.tres"),
	"Hallway": load(SFX_PATH % "carpetstep.tres")
}

@onready var music := {
	"part2theme": load(MUSIC_PATH % "part2theme.ogg"),
	"softerparttheme": load(MUSIC_PATH % "softerparttheme.ogg"),
	"cutscene1": load(MUSIC_PATH % "cutscene1.ogg") 
}

var tweens := {}

func _ready() -> void:
	_connect_signals()
	_init_players()

func _connect_signals() -> void:
	change_music.connect(_on_change_music)
	change_footsteps.connect(_on_change_footsteps)
	
	play_footstep_sound.connect(_on_play_footstep_sound)
	play_sound.connect(_on_play_sound)
	
	stop_music.connect(_on_stop_music)
	stop_wind.connect(_on_stop_wind)

func _init_players() -> void:
	change_music.emit("part2theme")
	change_footsteps.emit("Bedroom")
	
func _on_stop_music() -> void:
	_tween_volume(-80.0)

func _on_change_music(track_name: String) -> void:
	if not track_name:
		printerr("Track name %s was not expected" % track_name)
		return

	var callback := func():
		_load_music_file(track_name)

	if music_player.is_playing():
		_tween_volume(INIT_VOLUME, callback)
	else:
		callback.call()

func _on_change_footsteps(bank_name: String) -> void:
	if footsteps.has(bank_name):
		footsteps_player.stream = footsteps[bank_name]
	else:
		footsteps_player.stream = footsteps["Bedroom"]
		# printerr("Footsteps sound bank %s was not found" % bank_name)

func _on_play_sound(sound_name: String) -> void:
	if not sounds.has(sound_name):
		printerr("Sound file %s was not found" % sound_name)
		return
	
	if misc_player.playing:
		misc_player.stop()

	misc_player.stream = sounds[sound_name]
	misc_player.play()

func _on_play_footstep_sound() -> void:
	footsteps_player.play()

func _load_music_file(track_name: String) -> void:
	if not music.has(track_name):
		printerr("Music file for stage %s was not found" % track_name)
		return

	music_player.stream = music[track_name]	
	music_player.volume_db = INIT_VOLUME
	
	music_player.play()
	_tween_volume(0.0)
	
func _on_stop_wind() -> void:
	tweens["wind"] = create_tween().set_trans(Tween.TRANS_QUAD)
	tweens["wind"].tween_property(wind_player, "volume_db", INIT_VOLUME, 5.0)

func _tween_volume(value := 0.0, callback = null):	
	if tweens.has("main"):
		tweens["main"].kill()

	tweens["main"] = create_tween().set_trans(Tween.TRANS_QUAD)
	tweens["main"].tween_property(music_player, "volume_db", value, 1.5)

	if callback is Callable:
		tweens["main"].tween_callback(callback)
