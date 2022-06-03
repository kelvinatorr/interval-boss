extends Control

var running_timer: LabelTimer = null
var rounds: int = 0
var rounds_label_text = "Rounds: %s"

onready var start_button_label = $MarginContainer/VBoxContainer/Start/Label
onready var timer_1: LabelTimer = $MarginContainer/VBoxContainer/Timer1
onready var transition_timer: LabelTimer = $MarginContainer/VBoxContainer/VBoxContainer/TTimer
onready var timer_2: LabelTimer = $MarginContainer/VBoxContainer/Timer2
onready var timers: Array = [timer_1, transition_timer, timer_2]
onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
onready var rounds_label: Label = $MarginContainer/VBoxContainer/Rounds

func _ready() -> void:
	for t in timers:
		t.connect("timer_timeout", self, "_on_timer_timeout")

func _on_Start_button_up() -> void:
	audio_stream_player.play()
	if running_timer:
		stop_timer_sounds(timers)
		pause(running_timer)
	else:
		start()

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
		increment_rounds()
	running_timer = get_next_timer(timers, t)
	running_timer.start()

func get_running_timer(ts: Array) -> LabelTimer:
	for t in ts:
		if not t.is_stopped():
			return t
	return timer_1

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
