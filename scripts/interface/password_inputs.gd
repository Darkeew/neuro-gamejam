extends Control

var regex = RegEx.new()

func _ready() -> void:
	Global.show_password_inputs.connect(_on_show_password_inputs)

	regex.compile("[0-9]")	

func _on_show_password_inputs() -> void:
	clear_digits()

func _on_digit_text_changed(new_text: String, digit: LineEdit) -> void:
	var filtered_text = _filter_input(new_text)
	digit.text = filtered_text

	var last_symbol = new_text[-1]
	if not regex.search(last_symbol):
		return 

	_change_digit(digit.name, filtered_text.length() == 1)

func _change_digit(current_digit_name: String, advance := true) -> void:
	var current_digit_id := current_digit_name.replace("Digit", "") as int

	if current_digit_id == 1 and not advance:
		return

	if advance:
		var next_digit_id := current_digit_id + 1
		if next_digit_id == 5:
			_submit_password()
			return

		var current_digit := get_node("%%Digit%s" % current_digit_id)
		current_digit.editable = false

		var next_digit := get_node("%%Digit%s" % next_digit_id)
		next_digit.editable = true
		next_digit.grab_focus()

		SoundManager.play_sound.emit("safe_input")
	else:
		var prev_digit_id := current_digit_id - 1
		var prev_digit := get_node("%%Digit%s" % prev_digit_id)
		var current_digit := get_node("%%Digit%s" % current_digit_id)

		current_digit.text = ""
		current_digit.editable = false
		prev_digit.grab_focus()

func _filter_input(new_text: String) -> String:
	var word = ''
	for valid_character in regex.search_all(new_text):
		word += valid_character.get_string()
	return word

func _submit_password() -> void:
	var password := "%s%s%s%s" % [%Digit1.text, %Digit2.text, %Digit3.text, %Digit4.text]
	
	clear_digits()
	Global.send_password.emit(password)

func clear_digits() -> void:
	for digit in [%Digit1, %Digit2, %Digit3, %Digit4]:
		digit.text = ""
		digit.editable = false
		if not digit.text_changed.is_connected(_on_digit_text_changed):
			digit.text_changed.connect(_on_digit_text_changed.bind(digit))

	%Digit1.editable = true
	%Digit1.grab_focus()
