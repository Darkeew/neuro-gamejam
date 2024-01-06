extends Node2D


@onready var pickup_line = $PickupLine
var piano_minigame = load("res://scenes/puzzles/piano.tscn")
var is_playing = false
var near = false

func _ready() -> void: 
	pickup_line.modulate.a = 0	

func _process(_delta) -> void:
	if Global.game_paused or is_playing or !near:
		return 
	
	if Input.is_action_just_pressed("choice 1"):
		SoundManager.stop_music.emit()
		Global.tween_property(name, pickup_line, "modulate:a", 0) 	

		var minigame = piano_minigame.instantiate()
		minigame.position = Vector2(-380, -100)
		minigame.scale = Vector2.ONE * 0.3
		minigame.piano_prev = self
		
		add_child(minigame)
		is_playing = true

func _on_interactible_area_entered(_area):
	Global.tween_property(name, pickup_line, "modulate:a", 1) 
	near = true

func _on_interactible_area_exited(_area):
	Global.tween_property(name, pickup_line, "modulate:a", 0)
	near = false
