extends LineEdit

var current_text: String

func _ready() -> void:
	current_text = self.text

func _on_MinEdit_text_changed(new_text: String) -> void:
	if new_text.is_valid_integer() or new_text == "":
		self.text = new_text
		current_text = self.text
	else:
		self.text = current_text
	# Set the cursor so the text is the order of input
	set_cursor_right()

func get_text() -> String:
	return ("0" if self.text == "" else self.text)

func set_text(txt: String) -> void:
	self.text = txt
	current_text = self.text

func set_cursor_right() -> void:
	set_cursor_position(self.text.length())

func _on_MinEdit_focus_entered() -> void:
	set_cursor_right()
