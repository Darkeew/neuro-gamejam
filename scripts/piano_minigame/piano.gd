extends Node2D

@onready var usable_notes = [$PianoKeyD4, $PianoKeyE4, $"PianoKeyF#4", $PianoKeyG4, $PianoKeyA4, $PianoKeyB4, $"PianoKeyC#5", $PianoKeyD5]
@onready var audio = $AudioStreamPlayer

const POSSIBLE_NOTES := 8
const NOTE_FILE_NAME := "res://assets/sfx/note%s.ogg"
const BASE_POS := 200.0

var notes_to_pass := [1, 8, 7, 5, 1, 8, 7, 5, 2, 6, 5, 4, 3, 4, 5, 7, 8, 5, 1]
var note_files := []
var note_inputs := []

var just_pressed_note := 0
var notes_correct := 0
var piano_prev

func _init() -> void:
	self.modulate.a = 0

	for i in range(1, POSSIBLE_NOTES + 1):
		note_inputs.append("Note%s" % i)
		note_files.append(load(NOTE_FILE_NAME % i))

func _ready():
	Global.pause_game.emit()
	Global.tween_property(self.name, self, "modulate:a", 1)

func _process(_delta):
	for key in note_inputs:
		if Input.is_action_just_pressed(key):
			_play_note(key)
	
func _play_note(note_input: String) -> void:
	just_pressed_note = int(note_input.replace("Note", ""))
	
	audio.stream = note_files[just_pressed_note - 1]
	usable_notes[just_pressed_note - 1].set_color()
	check_notes()
	audio.play()

func check_notes():
	#print(notes_correct)
	if notes_correct >= len(notes_to_pass) - 1:
		$NoteUI.current_y_pos = BASE_POS * (notes_correct + 1)
		Global.unpause_game.emit()
		EventBus.emit_event("piano_completed")
		
		#print("complete")
		return

	if just_pressed_note == notes_to_pass[notes_correct]:
		notes_correct = notes_correct + 1
		$NoteUI.current_y_pos = BASE_POS * notes_correct
	else:
		notes_correct = 0
		$NoteUI.current_y_pos = 0.0
	#print("Just Pressed Note: " + str(just_pressed_note))
	#print("Correct Note: " + str(notes_to_pass[notes_correct]))
	#print("Amount of Notes Correct: " + str(notes_correct))
