extends Node

signal change_stage(stage_scene: PackedScene)

var player: CharacterBody2D = preload("res://scenes/character/player.tscn").instantiate()
var shadow_canvas_group: CanvasGroup = preload("res://scripts/global/ShadowGroup.tscn").instantiate()
var main_menu: CanvasLayer = preload("res://scenes/interface/main_menu.tscn").instantiate()
var current_scene = null

var test

var main_camera : CameraController

# region GLOBAL VARS

var game_paused := true
signal game_unpaused

# endregion

func _ready():
	change_stage.connect(load_stage)
	
	process_mode = Node.PROCESS_MODE_ALWAYS

	var root = get_tree().root
	current_scene = root.get_child(root.get_child_count() - 1)
	print(current_scene)

	if get_tree().current_scene is Control:
		return

	current_scene = get_tree().current_scene
	
	setup_player()

	current_scene.add_child(shadow_canvas_group)

	setup_main_menu()

func load_stage(stage_scene : PackedScene):
	var oldscene = current_scene
	var stage = stage_scene.instantiate()

	current_scene = stage

	current_scene.add_child(shadow_canvas_group)
	
	get_tree().root.call_deferred("add_child", stage) 
	setup_player()
	
	oldscene.queue_free()

	get_tree().root.call_deferred("move_child", main_menu, -1) 

func setup_player():
	current_scene.add_child(player)

func setup_main_menu():
	get_tree().root.call_deferred("add_child", main_menu) 

func hide_menu():
	get_node("/root/MainMenu").hide()
	game_unpaused.emit()
