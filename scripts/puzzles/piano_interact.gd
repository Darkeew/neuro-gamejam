extends Node2D


@onready var pickup_line = $PickupLine
var piano_minigame = load("res://scenes/puzzles/piano.tscn")
var isplaying = false
func _ready() -> void: 
	pickup_line.modulate.a = 0	

func _process(_delta) -> void:
	if Global.game_paused or isplaying:
		return 
	
	if Input.is_action_just_pressed("choice 1"):
		SoundManager._stop_music()
		var minigame = piano_minigame.instantiate()
		add_child(minigame)
		minigame.position = Vector2(-360,-160)
		minigame.scale = Vector2.ONE*0.3
		minigame.piano_prev = self
		isplaying = true

func _on_interactible_area_entered(_area):
	Global.tween_property(name, pickup_line, "modulate:a", 1) 

func _on_interactible_area_exited(_area):
	Global.tween_property(name, pickup_line, "modulate:a", 0)
