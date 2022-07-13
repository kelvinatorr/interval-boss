extends Control

# These have the default timer settings
export(Resource) var settings = preload("res://src/settings.tres")

var running_timer: LabelTimer = null
var timers: Array
var one_shot: bool
var is_editing: bool = false
var green_button_normal_tex: Resource = preload("res://assets/buttons/green_button02.png")
var green_button_pressed_tex: Resource = preload("res://assets/buttons/green_button03.png")
var red_button_normal_tex: Resource = preload("res://assets/buttons/red_button02.png")
var red_button_pressed_tex: Resource = preload("res://assets/buttons/red_button03.png")

onready var start_button: TextureButton = $MarginContainer/VBoxContainer/Start
onready var start_button_label: Label = $MarginContainer/VBoxContainer/Start/Label
onready var sound_conductor: SoundConductor = $SoundConductor
onready var rounds: Rounds = $MarginContainer/VBoxContainer/Rounds
onready var edit_button_label: Label = $MarginContainer/VBoxContainer/Edit/Label

func _ready() -> void:
	var gr_timer: LabelTimer = $MarginContainer/VBoxContainer/VBoxContainer/GRTimer
	var timer_1: LabelTimer = $MarginContainer/VBoxContainer/Timer1
	var timer_2: LabelTimer = $MarginContainer/VBoxContainer/Timer2
	timers = [gr_timer, timer_1, timer_2]
	# Load the previous timer settings from disk
	var previous_settings = settings.load_save()
	if previous_settings:
		settings = previous_settings
	for i in len(timers):
		var t: LabelTimer = timers[i]
		t.idx = i
		# warning-ignore:return_value_discarded
		t.connect("timer_timeout", self, "_on_timer_timeout")
		t.set_wait_time(settings.waits[i])
		t.show_wait_time()
	# Set the rounds
	if settings.rounds != 0:
		rounds.num_rounds_set = settings.rounds
	else:
		rounds.num_rounds_set = null
	rounds.set_rounds()
	# Set the one_shot button state
	one_shot = settings.one_shot
	var one_shot_button = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/OneShotButton
	one_shot_button.pressed = one_shot

func _on_Start_button_up() -> void:
	sound_conductor.beep()
	if is_editing:
		save_edits(timers)

	if running_timer:
		pause(running_timer)
	elif check_wait_times(timers):
		start()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("start_pause"):
		_on_Start_button_up()
	elif event.is_action_pressed("edit"):
		_on_Edit_button_up()

func check_wait_times(ts: Array) -> bool:
	# If at least 1 timer has a wait_time then return true
	var has_wait_time: bool = false
	for t in ts:
		if t.wait_time != 0.0:
			has_wait_time = true
			break
	return has_wait_time

func pause(rt: LabelTimer)-> void:
	start_button_label.text = "START"
	start_button.texture_normal = green_button_normal_tex
	start_button.texture_pressed = green_button_pressed_tex
	rt.pause()
	running_timer = null

func start() -> void:
	start_button_label.text = "PAUSE"
	start_button.texture_normal = red_button_normal_tex
	start_button.texture_pressed = red_button_pressed_tex
	running_timer = get_running_timer(timers)
	running_timer.start()

func _on_timer_timeout(t: LabelTimer) -> void:
	if t == timers[-1]:
		# The last timer timed out
		var done: bool = rounds.increment_rounds()
		self.show_wait_times(timers)
		if one_shot or done:
			if done:
				sound_conductor.play_done()
			else:
				sound_conductor.play_timer_finish(t.idx, timers, rounds)
			pause(t)
			return

	sound_conductor.play_timer_finish(t.idx, timers, rounds)
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
	settings.write_save_one_shot(one_shot)

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
	var new_waits: Array = []
	for t in ts:
		t.save_edit()
		new_waits.append(t.wait_time)
	rounds.save_edit()
	edit_button_label.text = "EDIT"
	edit_button_label.add_color_override("font_color_shadow", "b4000000")
	edit_button_label.add_color_override("font_color", Color(1, 1, 1, 1))
	var rounds_to_save: int = 0
	if rounds.num_rounds_set != null:
		rounds_to_save = rounds.num_rounds_set
	settings.write_save(new_waits, rounds_to_save, one_shot)
	is_editing = !is_editing

func _on_Edit_button_up() -> void:
	sound_conductor.beep()
	if running_timer != null:
		pause(running_timer)

	if not is_editing:
		enable_edits(timers)
	else:
		save_edits(timers)
