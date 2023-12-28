extends Node

var player : CharacterBody2D

var shadow_canvas_group : CanvasGroup

var current_scene = null
func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS

	var root = get_tree().root
	current_scene = root.get_child(root.get_child_count() - 1)

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

	
	get_tree().root.add_child(stage)

	setup_player()

	oldscene.queue_free()


func setup_player():
	var player_scene = load("res://scenes/character/player.tscn").instantiate();
	player = player_scene
	current_scene.add_child(player)
