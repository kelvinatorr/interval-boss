extends Label
class_name LabelTimer

onready var _my_timer: Timer = $Timer
onready var _audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

signal timer_timeout(timer)

func _ready() -> void:
	self.show_wait_time()

func _physics_process(delta: float) -> void:
	if not _my_timer.is_stopped():
		self.text = Helper.format_time(_my_timer.time_left)

func start() -> void:
	if _my_timer.paused:
		_my_timer.paused = false
	else:
		_my_timer.start()

func pause() -> void:
	if not _my_timer.is_stopped():
		_my_timer.paused = true

func _on_Timer_timeout() -> void:
	# Play alarm sound
	_audio_stream_player.play()
	self.text = Helper.format_time(0.0)
	self.emit_signal("timer_timeout", self)

func stop_sound() -> void:
	if _audio_stream_player.playing:
		_audio_stream_player.stop()

func is_stopped() -> bool:
	return _my_timer.is_stopped()

func show_wait_time() -> void:
	self.text = Helper.format_time(_my_timer.wait_time)
