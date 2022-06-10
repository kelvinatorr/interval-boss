extends Control
class_name Rounds

var num_rounds_set = null
var rounds: int
var rounds_label_text: String = "Rounds: %s"

onready var _label: Label = $Label
onready var _label_edit: Label = $LabelEdit
onready var _rounds_edit: LineEdit = $RoundEdit
onready var _audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

func _ready() -> void:
	if num_rounds_set == null:
		rounds = 0
	else:
		rounds = num_rounds_set
	_set_text(rounds)
	_label.visible = true
	_label_edit.visible = false
	_rounds_edit.visible = false

func _play_sound() -> void:
	_audio_stream_player.play()

func increment_rounds() -> bool:
	if num_rounds_set == null:
		if rounds < 99:
			rounds += 1
	else:
		rounds -= 1
		if rounds == 0:
			_play_sound()
			_ready()
			return true
	_set_text(rounds)
	return false

func _set_text(rounds_int: int) -> void:
	_label.text = rounds_label_text % Helper.pad_int(str(rounds_int))

func edit() -> void:
	# Edit the num_rounds_set not the current rounds, because when it saves, the round is reset
	if num_rounds_set == null:
		_rounds_edit.set_text("00")
	else:
		_rounds_edit.set_text(Helper.pad_int(str(num_rounds_set)))
	# Hide the label
	_label.visible = false
	_label_edit.visible = true
	_rounds_edit.visible = true

func save_edit() -> void:
	# When the edit is saved, the save the rounds
	var rounds_entered: int = int(_rounds_edit.get_text())
	if rounds_entered != 0:
		num_rounds_set = rounds_entered
	else:
		num_rounds_set = null
	_ready()
