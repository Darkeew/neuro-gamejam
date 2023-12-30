extends Node

signal change_stage(stage_scene: PackedScene)

var player: CharacterBody2D
var shadow_canvas_group: CanvasGroup
var main_menu: CanvasLayer = preload("res://scenes/interface/main_menu.tscn").instantiate()
var current_scene = null

var main_camera : CameraController

# region GLOBAL VARS

static var game_paused := true
signal game_unpaused

# endregion

func _ready():
	change_stage.connect(load_stage)
	
	process_mode = Node.PROCESS_MODE_ALWAYS

	var root = get_tree().root
	current_scene = root.get_child(root.get_child_count() - 1)

	if get_tree().current_scene is Control:
		return

	current_scene = get_tree().current_scene
	
	setup_player()

	shadow_canvas_group = preload("res://scripts/global/ShadowGroup.tscn").instantiate()
	current_scene.add_child(shadow_canvas_group)
	SoundManager.change_stage.emit(current_scene.name)

	setup_main_menu()

func load_stage(stage_scene : PackedScene):
	var oldscene = current_scene
	var stage = stage_scene.instantiate()

	current_scene = stage

	shadow_canvas_group = preload("res://scripts/global/ShadowGroup.tscn").instantiate()
	current_scene.add_child(shadow_canvas_group)
	
	get_tree().root.call_deferred("add_child", stage) 
	
	setup_player()	
	
	oldscene.queue_free()
	
	get_tree().root.call_deferred("move_child", main_menu, -1) 
	SoundManager.change_stage.emit(stage.name)

func setup_player():
	player = preload("res://scenes/character/player.tscn").instantiate()
	current_scene.add_child(player)

func setup_main_menu():
	get_tree().root.call_deferred("add_child", main_menu) 

func hide_menu():
	get_node("/root/MainMenu").hide()
	game_unpaused.emit()
