extends Node

signal change_stage(stage_scene: PackedScene)
signal pickup_item(item: Item)
signal show_password_inputs
signal hide_password_inputs
signal show_sticky_note
signal hide_sticky_note
signal send_password(password: int)
signal start_next_iteration 

var player: CharacterBody2D
var shadow_canvas_group: CanvasGroup
var main_menu: PackedScene = preload("res://scenes/interface/main_menu.tscn")
var hud: CanvasLayer = preload("res://scenes/interface/hud.tscn").instantiate()
var current_scene = null
var current_iteration := 1

var main_camera : CameraController

# region GLOBAL VARS

static var game_paused := true
signal game_unpaused

var collected_items := []
var tweens := {}

# endregion

func _ready():
	connect_signals() 
	
	process_mode = Node.PROCESS_MODE_ALWAYS

	var root = get_tree().root
	current_scene = root.get_child(root.get_child_count() - 1)

	if get_tree().current_scene is Control:
		return

	current_scene = get_tree().current_scene
	
	setup_player("PlayerStartPos")

	shadow_canvas_group = preload("res://scripts/global/ShadowGroup.tscn").instantiate()
	current_scene.add_child(shadow_canvas_group)
	SoundManager.change_stage.emit(current_scene.name)

	setup_hud() 
	setup_main_menu()

func connect_signals() -> void:
	change_stage.connect(load_stage)
	pickup_item.connect(_on_pickup_item)
	start_next_iteration.connect(_on_start_next_iteration)

func _on_pickup_item(item: Item) -> void:
	collected_items.append(item)
	if item.tag == "First Key":
		await get_tree().process_frame
		Global.start_next_iteration.emit()

func _on_start_next_iteration() -> void:
	current_iteration += 1 
	
	var stage_scene: PackedScene = load("res://scenes/rooms/bedroom.tscn")
	load_stage(stage_scene, "PlayerStartPos")
	
	setup_main_menu()

func load_stage(stage_scene : PackedScene, player_pos := "PlayerEnterPos"):
	var old_scene = current_scene
	var stage = stage_scene.instantiate()
	current_scene = stage

	SoundManager.change_stage.emit(stage.name)
	tween_property(
		hud.name, hud.smooth_transition, "self_modulate:a", 1,  0.5, 
		func(): load_next_stage(stage, old_scene, player_pos)
	)

func load_next_stage(stage: Node2D, old_scene: Node2D, player_pos := "PlayerEnterPos") -> void:
	shadow_canvas_group = preload("res://scripts/global/ShadowGroup.tscn").instantiate()
	current_scene.add_child(shadow_canvas_group)
	
	get_tree().root.call_deferred("add_child", stage) 
	
	setup_player(player_pos)	
	
	old_scene.queue_free()
	
	# get_tree().root.call_deferred("move_child", main_menu, -1) 
	get_tree().root.call_deferred("move_child", hud, -2)

	tween_property(hud.name, hud.smooth_transition, "self_modulate:a", 0, 0.5)

func setup_player(player_pos: String):
	player = preload("res://scenes/character/player.tscn").instantiate()
	player.global_position = current_scene.get_node(player_pos).global_position
	current_scene.add_child(player)

func setup_main_menu():
	get_tree().root.call_deferred("add_child", main_menu.instantiate()) 

func setup_hud():
	get_tree().root.call_deferred("add_child", hud)

func hide_menu():
	get_node("/root/MainMenu").queue_free()
	game_unpaused.emit()

func tween_property(id: String, node: Node, prop: String, value: float, time := 1.0, callback = null) -> void:
	var tween_name := "%s_%s_%s" % [id, node.name, prop]
	if tweens.has(tween_name):
		tweens[tween_name].kill()

	tweens[tween_name] = create_tween()
	tweens[tween_name].tween_property(node, prop, value, time)

	if callback is Callable:
		tweens[tween_name].tween_callback(callback)
