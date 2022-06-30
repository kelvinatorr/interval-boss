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

func play_timer_finish(t_idx: int, timers: Array, rounds: Rounds) -> void:
	var t: LabelTimer = timers[t_idx]
	if t.wait_time == 0.0:
		return

	# If we are in rounds mode and it is the last round, 
	# look ahead to see if there are future timers with wait times
	if rounds.num_rounds_set != null and (rounds.rounds - 1) == 0 and t.idx != 2:
		var no_future_waits: bool = true
		for timer in timers:
			if timer.idx > t.idx and timer.wait_time != 0.0:
				no_future_waits = false
		if no_future_waits:
			# Because it is the last round and the spaceship alarm should play next
			return

	stop_sound()
	if t.idx == 0:
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
