extends Node

signal change_stage(stage_scene: PackedScene)

var player : CharacterBody2D
var shadow_canvas_group : CanvasGroup
var current_scene = null

var main_camera : CameraController

func _ready():
	change_stage.connect(load_stage)
	
	process_mode = Node.PROCESS_MODE_ALWAYS

	var root = get_tree().root
	current_scene = root.get_child(root.get_child_count() - 1)
	print(current_scene)

	if get_tree().current_scene is Control:
		return

	shadow_canvas_group = load("res://Scripts/Global/ShadowGroup.tscn").instantiate()

	current_scene = get_tree().current_scene
	
	setup_player()

	current_scene.add_child(shadow_canvas_group)

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
	current_scene.add_child(player)
