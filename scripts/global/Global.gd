extends Node

signal change_stage(stage_scene: PackedScene)

var player : CharacterBody2D
var shadow_canvas_group : CanvasGroup
@onready var current_scene := get_tree().current_scene

@onready var menu_scene := current_scene.get_node("MainMenu")

var main_camera : CameraController

# region GLOBAL VARS

static var game_paused := true
signal game_unpaused

# endregion

func _ready():

	print(menu_scene)

	change_stage.connect(load_stage)
	
	process_mode = Node.PROCESS_MODE_ALWAYS

	var root = get_tree().root
	current_scene = root.get_child(root.get_child_count() - 1)
	print(current_scene)

	if get_tree().current_scene is Control:
		return

	shadow_canvas_group = load("res://Scripts/Global/ShadowGroup.tscn").instantiate()

	setup_player()
	
	var viewport = current_scene.get_node_or_null("MainViewport/ViewportContainer")
	if viewport == null:
		game_paused = false
		return
	viewport.add_child(shadow_canvas_group)

func load_stage(stage_scene : PackedScene):
	var oldscene = current_scene
	var stage = stage_scene.instantiate()

	current_scene = stage

	shadow_canvas_group = load("res://Scripts/Global/ShadowGroup.tscn").instantiate()
	current_scene.add_child(shadow_canvas_group)
	
	get_tree().root.call_deferred("add_child", stage) 
	setup_player()

	oldscene.queue_free()


func setup_player():
	var player_scene = load("res://scenes/character/player.tscn").instantiate();
	player = player_scene
	var viewport = current_scene.get_node_or_null("MainViewport/ViewportContainer")
	if viewport == null:
		current_scene.add_child(player)
		game_paused = false
		return
	viewport.add_child(player)


func hide_menu():
	menu_scene.hide()
	game_unpaused.emit()
