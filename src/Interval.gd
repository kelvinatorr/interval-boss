extends Control

var running_timer: LabelTimer = null
var timers: Array
var one_shot: bool = true
var is_editing: bool = false

onready var start_button_label = $MarginContainer/VBoxContainer/Start/Label
onready var sound_conductor: SoundConductor = $SoundConductor
onready var rounds: Rounds = $MarginContainer/VBoxContainer/Rounds
onready var edit_button_label: Label = $MarginContainer/VBoxContainer/Edit/Label

func _ready() -> void:
	var gr_timer: LabelTimer = $MarginContainer/VBoxContainer/VBoxContainer/GRTimer
	var timer_1: LabelTimer = $MarginContainer/VBoxContainer/Timer1
	var timer_2: LabelTimer = $MarginContainer/VBoxContainer/Timer2
	timers = [gr_timer, timer_1, timer_2]
	for t in timers:
		t.connect("timer_timeout", self, "_on_timer_timeout")
	# Set the one_shot button state
	var one_shot_button = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/OneShotButton
	one_shot_button.pressed = one_shot

func _on_Start_button_up() -> void:
	sound_conductor.beep()
	if is_editing:
		save_edits(timers)

	if running_timer:
		pause(running_timer)
	else:
		start()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("start_pause"):
		_on_Start_button_up()
	elif event.is_action_pressed("edit"):
		_on_Edit_button_up()

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
		var done: bool = rounds.increment_rounds()
		self.show_wait_times(timers)
		if one_shot or done:
			if t.wait_time != 0.0:
				sound_conductor.play_timer_finish(false, done)
			pause(t)
			return
	if t.wait_time != 0.0:
		sound_conductor.play_timer_finish(t == timers[0], false)
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

func _on_OneShotButton_toggled(button_pressed: bool) -> void:
	one_shot = button_pressed

func show_wait_times(ts: Array) -> void:
	for t in ts:
		t.show_wait_time()

func enable_edits(ts: Array) -> void:
	for t in ts:
		t.edit()
	ts[0].grab_focus()
	rounds.edit()
	edit_button_label.text = "SAVE"
	edit_button_label.add_color_override("font_color_shadow", Color(0, 0, 0, 0))
	edit_button_label.add_color_override("font_color", "b4000000")
	is_editing = !is_editing

func save_edits(ts: Array) -> void:
	for t in ts:
		t.save_edit()
	rounds.save_edit()
	edit_button_label.text = "EDIT"
	edit_button_label.add_color_override("font_color_shadow", "b4000000")
	edit_button_label.add_color_override("font_color", Color(1, 1, 1, 1))
	is_editing = !is_editing

func _on_Edit_button_up() -> void:
	sound_conductor.beep()
	if running_timer != null:
		pause(running_timer)

	if not is_editing:
		enable_edits(timers)
	else:
		save_edits(timers)
