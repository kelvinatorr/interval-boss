extends Node
class_name SoundConductor

var _players: Array

onready var _go_go_go: AudioStreamPlayer = $GoGoGo
onready var _alarm_clock: AudioStreamPlayer = $AlarmClock
onready var _spaceship_alarm: AudioStreamPlayer = $SpaceshipAlarm
onready var _beep_player: AudioStreamPlayer = $Beep

func _ready() -> void:
	_players = [_go_go_go, _alarm_clock, _spaceship_alarm, _beep_player]

func play_done() -> void:
	stop_sound()
	_spaceship_alarm.play()

func play_timer_finish(t: LabelTimer, next_t: LabelTimer, rounds: Rounds) -> void:
	if t.wait_time == 0.0:
		return

	stop_sound()
	if t.idx == 0:
		_go_go_go.play()
	elif t.idx == 1:
		if rounds.num_rounds_set == null:
			_alarm_clock.play()
		else:
			if next_t.wait_time != 0.0 or (rounds.rounds - 1) != 0:
				_alarm_clock.play()
	else:
		_alarm_clock.play()

func stop_sound() -> void:
	for p in _players:
		if p.playing:
			p.stop()

func beep() -> void:
	stop_sound()
	_beep_player.play()
