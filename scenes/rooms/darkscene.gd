extends Node2D

@export var darkscreen : Control
@export var switch_off : Node2D
@export var switch_on : Node2D

@onready var pickup_line = $PickupLine

var player_near = false

func _ready() -> void: 
	pickup_line.modulate.a = 0	

func _process(_delta):
	if Global.player == null:
		return
	
	darkscreen.global_position = Global.player.global_position - darkscreen.size/2
	
	return
	if !player_near:
		return
	
	if Input.is_action_just_pressed("choice 1"):
		switch()

func switch():
	switch_on.visible = true
	switch_off.visible = false
	darkscreen.visible = false
	





func _on_interactible_area_exited(_area:Area2D):
	player_near = false
	Global.tween_property(name, pickup_line, "modulate:a", 0)
	

func _on_interactible_area_entered(_area:Area2D):
	player_near = true
	Global.tween_property(name, pickup_line, "modulate:a", 1) 
