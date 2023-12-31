extends Node2D
@onready var note_fab = preload("res://scenes/puzzles/note_ui.tscn")
var xposes = [169,224,283,312,350,395,459,486]
var notes_to_pass = [1,8,7,5,1,8,7,5,2,6,5,4,3,4,5,7,8,5,1]
var notes_to_generate = {}
var current_y_pos = 0.0
# Called when the node enters the scene tree for the first time.
func _ready():
	for i in len(notes_to_pass):
		var new_ob = note_fab.instantiate()
		add_child(new_ob)
		new_ob.position.x = xposes[notes_to_pass[i]-1]
		new_ob.position.y = i*-200+288

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.y = lerp(position.y, current_y_pos, 5*delta)
