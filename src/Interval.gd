extends Control

var running_timer: LabelTimer = null
var rounds: int = 0
var rounds_label_text = "Rounds: %s"
var timers: Array
var one_shot: bool = true

onready var start_button_label = $MarginContainer/VBoxContainer/Start/Label
onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
onready var rounds_label: Label = $MarginContainer/VBoxContainer/Rounds

func _ready() -> void:
	var timer_1: LabelTimer = $MarginContainer/VBoxContainer/Timer1
	var transition_timer: LabelTimer = $MarginContainer/VBoxContainer/VBoxContainer/TTimer
	var timer_2: LabelTimer = $MarginContainer/VBoxContainer/Timer2
	timers = [timer_1, transition_timer, timer_2]
	for t in timers:
		t.connect("timer_timeout", self, "_on_timer_timeout")
	# Set the one_shot button state
	var one_shot_button = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/OneShotButton
	one_shot_button.pressed = one_shot

func _on_Start_button_up() -> void:
	audio_stream_player.play()
	if running_timer:
		stop_timer_sounds(timers)
		pause(running_timer)
	else:
		start()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("start_pause"):
		_on_Start_button_up()

func pause(rt: LabelTimer)-> void:
	start_button_label.text = "START"
	rt.pause()
	running_timer = null

func start() -> void:
	start_button_label.text = "PAUSE"
	running_timer = get_running_timer(timers)
	running_timer.start()

func _on_timer_timeout(t: LabelTimer) -> void:
	if t == timers[-1]:
		# The last timer timed out
		increment_rounds()
		self.show_wait_times(timers)
		if one_shot:
			pause(t)
			return
	running_timer = get_next_timer(timers, t)
	running_timer.start()

func get_running_timer(ts: Array) -> LabelTimer:
	for t in ts:
		if not t.is_stopped():
			return t
	return ts[0]

func get_next_timer(ts: Array, current_t: LabelTimer) -> LabelTimer:
	var next: bool = false
	for t in ts:
		if next:
			return t
		if t == current_t:
			next = true
	return ts[0]

func stop_timer_sounds(ts: Array) -> void:
	for t in ts:
		t.stop_sound()

func increment_rounds() -> void:
	if rounds >= 99:
		return
	rounds += 1
	rounds_label.text = rounds_label_text % Helper.pad_int(str(rounds))

func _on_OneShotButton_toggled(button_pressed: bool) -> void:
	one_shot = button_pressed

func show_wait_times(ts: Array) -> void:
	for t in ts:
		t.show_wait_time()


