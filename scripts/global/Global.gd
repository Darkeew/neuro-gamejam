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

#region NUMBERS SCHIZO 
var numbers_schizo := []
var sticky_note_code: int
var safe_code: int 
#endregion 

var dialog_label : Label

var main_camera : CameraController

# region GLOBAL VARS

var game_paused := true
signal pause_game
signal unpause_game

var collected_items := []
var tweens := {}
var is_from_bed := true 

# endregion

func _ready():
	connect_signals() 
	generate_codes()
	
	process_mode = Node.PROCESS_MODE_ALWAYS

	var root = get_tree().root
	current_scene = root.get_child(root.get_child_count() - 1)

	EventBus.register_listener("next_iter",next_iter)
	EventBus.register_condition_solver("iter_check", iter_check)
	EventBus.register_condition_solver("iter_check_greater", iter_check_greater)

	if get_tree().current_scene is Control:
		return

	current_scene = get_tree().current_scene
	
	setup_player("PlayerStartPos")

	shadow_canvas_group = preload("res://scripts/global/ShadowGroup.tscn").instantiate()
	current_scene.add_child(shadow_canvas_group)

	setup_hud() 

	if current_iteration == 1:
		setup_main_menu()
	else:
		unpause_game.emit()

func connect_signals() -> void:
	change_stage.connect(load_stage)
	pickup_item.connect(_on_pickup_item)
	start_next_iteration.connect(_on_start_next_iteration)
	
	pause_game.connect(_on_game_state_change.bind(true))
	unpause_game.connect(_on_game_state_change.bind(false))

func _on_game_state_change(is_paused: bool) -> void:
	game_paused = is_paused

func generate_codes() -> void:
	for num in range(4):
		var random_digit = randi_range(0, 9)
		
		while numbers_schizo.has(random_digit):
			random_digit = randi_range(0, 9)
		
		numbers_schizo.append(random_digit)
	
	var digits = [1, 2, 3, 4]
	var number_order = [] 
	while len(digits) > 0: 
		var index = randi_range(0, len(digits)-1)
		number_order.append(digits[index])
		digits.remove_at(index)
	
	var number_order_str: PackedStringArray = []
	number_order_str.resize(4)
	
	for i in range(4): 
		number_order_str[i] = str(number_order[i])
	sticky_note_code = int("".join(number_order_str))
	
	var ordered_numbers: PackedStringArray = []
	ordered_numbers.resize(4)
	
	for i in range(4):
		ordered_numbers[number_order[i] - 1] = str(numbers_schizo[i])
	safe_code = int("".join(ordered_numbers)) 

func next_iter():
	start_next_iteration.emit()

func _on_pickup_item(item: Item) -> void:
	collected_items.append(item)

var is_next_iter: bool = false
func _on_start_next_iteration() -> void:
	current_iteration += 1 
	is_next_iter = true
	
	var stage_scene: PackedScene = load("res://scenes/rooms/bedroom.tscn")
	load_stage(stage_scene, "PlayerStartPos")

func load_stage(stage_scene : PackedScene, player_pos := "PlayerEnterPos"):
	var old_scene = current_scene
	var stage = stage_scene.instantiate()
	current_scene = stage

	SoundManager.change_footsteps.emit(stage.name)
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

	SoundManager.change_footsteps.emit(stage.name)
	
	# get_tree().root.call_deferred("move_child", main_menu, -1) 
	get_tree().root.call_deferred("move_child", hud, -1)
	if is_next_iter:
		is_next_iter = false
		await EventBus.emit_event("cutscene")
	tween_property(hud.name, hud.smooth_transition, "self_modulate:a", 0, 0.5)

func setup_player(player_pos: String):
	if player_pos == "PlayerStartPos":
		is_from_bed = true 
	else:
		is_from_bed = false 
	
	player = preload("res://scenes/character/player.tscn").instantiate()
	if current_scene.has_node(player_pos):
		player.global_position = current_scene.get_node(player_pos).global_position
	current_scene.add_child(player)

func setup_main_menu():
	get_tree().root.call_deferred("add_child", main_menu.instantiate()) 

func setup_hud():
	get_tree().root.call_deferred("add_child", hud)

func tween_property(id: String, node: Node, prop: String, value: float, time := 0.25, callback = null) -> void:
	var tween_name := "%s_%s_%s" % [id, node.name, prop]
	if tweens.has(tween_name):
		tweens[tween_name].kill()

	tweens[tween_name] = create_tween()
	tweens[tween_name].tween_property(node, prop, value, time)

	if callback is Callable:
		tweens[tween_name].tween_callback(callback)

func show_dialog(event):
	if dialog_label == null:
		print("dialog_label is null")
		return
	await dialog_label.show_dialog(event)

func iter_check(event) -> bool:
	print(str(event))
	if event["iter"] == current_iteration:
		return true
	return false

func iter_check_greater(event) -> bool:
	print(str(event))
	if event["iter"] >= current_iteration:
		return true
	return false
