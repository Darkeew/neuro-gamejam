extends Node2D

@onready var usable_notes = [$PianoKeyD4,$PianoKeyE4,$"PianoKeyF#4",$PianoKeyG4,$PianoKeyA4,$PianoKeyB4,$"PianoKeyC#5",$PianoKeyD5]
var note_files = ["res://assets/sfx/note1.ogg","res://assets/sfx/note2.ogg","res://assets/sfx/note3.ogg","res://assets/sfx/note4.ogg","res://assets/sfx/note5.ogg","res://assets/sfx/note6.ogg","res://assets/sfx/note7.ogg","res://assets/sfx/note8.ogg"]
@onready var audio = $AudioStreamPlayer
var just_pressed_note = 0
var notes_to_pass = [1,8,7,5,1,8,7,5,2,6,5,4,3,4,5,7,8,5,1]
var notes_correct = 0
# Called when the node enters the scene tree for the first time.
var piano_prev


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#note playing
	if Input.is_action_just_pressed("Note1"):
		audio.stream = load(note_files[0])
		just_pressed_note = 1
		check_notes()
		usable_notes[just_pressed_note-1].set_color()
		audio.play()
	elif Input.is_action_just_pressed("Note2"):
		audio.stream = load(note_files[1])
		just_pressed_note = 2
		usable_notes[just_pressed_note-1].set_color()
		check_notes()
		audio.play()
	elif Input.is_action_just_pressed("Note3"):
		audio.stream = load(note_files[2])
		just_pressed_note = 3
		usable_notes[just_pressed_note-1].set_color()
		check_notes()
		audio.play()
	elif Input.is_action_just_pressed("Note4"):
		audio.stream = load(note_files[3])
		just_pressed_note = 4
		usable_notes[just_pressed_note-1].set_color()
		check_notes()
		audio.play()
	elif Input.is_action_just_pressed("Note5"):
		audio.stream = load(note_files[4])
		just_pressed_note = 5
		usable_notes[just_pressed_note-1].set_color()
		check_notes()
		audio.play()
	elif Input.is_action_just_pressed("Note6"):
		audio.stream = load(note_files[5])
		just_pressed_note = 6
		usable_notes[just_pressed_note-1].set_color()
		check_notes()
		audio.play()
	elif Input.is_action_just_pressed("Note7"):
		audio.stream = load(note_files[6])
		just_pressed_note = 7
		usable_notes[just_pressed_note-1].set_color()
		check_notes()
		audio.play()
	elif Input.is_action_just_pressed("Note8"):
		audio.stream = load(note_files[7])
		just_pressed_note = 8
		usable_notes[just_pressed_note-1].set_color()
		check_notes()
		audio.play()
	#messup handling
	
	
func check_notes():
	#print(notes_correct)
	if notes_correct >= len(notes_to_pass)-1:
		$NoteUI.current_y_pos = 200.0*(notes_correct+1)
		var timer := Timer.new()
		add_child(timer)
		timer.wait_time = 2.0
		timer.one_shot = true
		timer.start()
		timer.connect("timeout", next_iteration.bind())
		
		#print("complete")
		return
	if just_pressed_note == notes_to_pass[notes_correct]:
		notes_correct = notes_correct + 1
		$NoteUI.current_y_pos = 200.0*notes_correct
	elif just_pressed_note != notes_to_pass[notes_correct]:
		notes_correct = 0
		$NoteUI.current_y_pos = 0.0
	#print("Just Pressed Note: " + str(just_pressed_note))
	#print("Correct Note: " + str(notes_to_pass[notes_correct]))
	#print("Amount of Notes Correct: " + str(notes_correct))
func next_iteration():
	Global.start_next_iteration.emit()
	piano_prev.queue_free()
	queue_free()
	
