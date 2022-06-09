extends Control
class_name Rounds

var rounds: int = 0
var rounds_label_text: String = "Rounds: %s"

onready var _label: Label = $Label
onready var _label_edit: Label = $LabelEdit
onready var _rounds_edit: LineEdit = $RoundEdit

func _ready() -> void:
	_set_text(rounds)
	_label_edit.visible = false
	_rounds_edit.visible = false

func increment_rounds() -> void:
	if rounds >= 99:
		return
	rounds += 1
	_set_text(rounds)

func _set_text(rounds_int: int) -> void:
	_label.text = rounds_label_text % Helper.pad_int(str(rounds_int))

func set_rounds(rounds: int) -> void:
	rounds = rounds

func edit() -> void:
	# Edit the wait time not the current time, because when it saves, the round is reset
	_rounds_edit.set_text(Helper.pad_int(str(rounds)))
	# Hide the label
	_label.visible = false
	_label_edit.visible = true
	_rounds_edit.visible = true

func save_edit() -> void:
	# When the edit is saved, the save the rounds
	rounds = int(_rounds_edit.get_text())
	_set_text(rounds)
	_label.visible = true
	_label_edit.visible = false
	_rounds_edit.visible = false
