extends Node
class_name SoundConductor

var _players: Array

onready var _go_go_go: AudioStreamPlayer = $GoGoGo
onready var _alarm_clock: AudioStreamPlayer = $AlarmClock
onready var _spaceship_alarm: AudioStreamPlayer = $SpaceshipAlarm
onready var _beep_player: AudioStreamPlayer = $Beep

func _ready() -> void:
	_players = [_go_go_go, _alarm_clock, _spaceship_alarm, _beep_player]

func play_timer_finish(is_gr: bool, done: bool) -> void:
	stop_sound()
	if done:
		_spaceship_alarm.play()
	else:
		if is_gr:
			_go_go_go.play()
		else:
			_alarm_clock.play()

func stop_sound() -> void:
	for p in _players:
		if p.playing:
			p.stop()

func beep() -> void:
	stop_sound()
	_beep_player.play()
