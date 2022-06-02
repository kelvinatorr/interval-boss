extends Label

onready var my_timer: Timer = $Timer
onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

func _physics_process(delta: float) -> void:
	self.text = Helper.format_time(my_timer.time_left)

func start() -> void:
	if my_timer.paused:
		my_timer.paused = false
	else:
		my_timer.start()

func pause() -> void:
	my_timer.paused = true

func _on_Timer_timeout() -> void:
	# Play alarm sound
	audio_stream_player.play()

func stop_sound() -> void:
	if audio_stream_player.playing:
		audio_stream_player.stop()
