extends Node

@onready var music_player := get_node("/root/MainScene/AudioController/MusicPlayer")

var music_bus := AudioServer.get_bus_index("Music")
var sfx_bus := AudioServer.get_bus_index("SFX")

var tweens := {}

func _ready():
	var music := AudioStreamOggVorbis.load_from_file("res://assets/music/part2theme.ogg")
	music_player.stream = music
	
	music_player.volume_db = -30.0
	music_player.play()

	if tweens.has("main"):
		tweens["main"].kill()

	tweens["main"] = create_tween().set_trans(Tween.TRANS_SINE)
	tweens["main"].tween_property(music_player, "volume_db", 0, 5)


