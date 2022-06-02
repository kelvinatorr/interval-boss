extends Control

onready var start_button_label = $MarginContainer/VBoxContainer/Start/Label
onready var timer_1: Label = $MarginContainer/VBoxContainer/Timer1
onready var timer_2: Label = $MarginContainer/VBoxContainer/Timer2
onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

var running: bool = false

func _on_Start_button_up() -> void:
	timer_1.stop_sound()
	audio_stream_player.play()
	if running:
		pause()
	else:
		start()
	running = !running

func pause()-> void:
	start_button_label.text = "START"
	timer_1.pause()

func start() -> void:
	start_button_label.text = "PAUSE"
	timer_1.start()
