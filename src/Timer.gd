extends Control
class_name LabelTimer

var wait_time: float = 0.0

onready var _my_timer: Timer = $Timer
onready var _audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
onready var _label: Label = $Label
onready var _hbox_container_edit: HBoxContainer = $HBoxContainer
onready var _min_line_edit: LineEdit = $HBoxContainer/MinEdit
onready var _sec_line_edit: LineEdit = $HBoxContainer/SecEdit

signal timer_timeout(timer)

func _ready() -> void:
	if wait_time > 0.0:
		_my_timer.wait_time = wait_time
	self.show_wait_time()

func _physics_process(delta: float) -> void:
	if not is_stopped():
		self._label.text = Helper.format_time(_my_timer.time_left)

func start() -> void:
	if wait_time == 0.0:
		self.emit_signal("timer_timeout", self)
		return
	if _my_timer.paused:
		_my_timer.paused = false
	else:
		_my_timer.start()

func pause() -> void:
	if not is_stopped():
		_my_timer.paused = true

func _on_Timer_timeout() -> void:
	# Play alarm sound
	_audio_stream_player.play()
	self._label.text = Helper.format_time(0.0)
	self.emit_signal("timer_timeout", self)

func stop_sound() -> void:
	if _audio_stream_player.playing:
		_audio_stream_player.stop()

func is_stopped() -> bool:
	return _my_timer.is_stopped()

func show_wait_time() -> void:
	self._label.text = Helper.format_time(wait_time)

func edit() -> void:
	# Edit the wait time not the current time, because when it saves, the round is reset
	var time_array: Array = Helper.get_mins_secs(wait_time)
	_min_line_edit.set_text(Helper.pad_int(str(time_array[0])))
	_sec_line_edit.set_text(Helper.pad_int(str(time_array[1])))
	# Hide the label
	_label.visible = false
	# Show the LineEdits
	_hbox_container_edit.visible = true

func grab_focus() -> void:
	_min_line_edit.grab_focus()

func save_edit() -> void:
	# When the edit is saved, the round is reset
	var total_secs = Helper.calc_total_seconds(_min_line_edit.get_text(), _sec_line_edit.get_text())
	wait_time = total_secs
	if total_secs > 0:
		_my_timer.wait_time = total_secs
	if not is_stopped():
		_my_timer.paused = false
		_my_timer.stop()
	show_wait_time()
	_hbox_container_edit.visible = false
	_label.visible = true
