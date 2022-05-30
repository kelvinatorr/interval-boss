extends Label

onready var my_timer: Timer = $Timer

func _physics_process(delta: float) -> void:
	self.text = Helper.format_time(my_timer.time_left)
	
func start() -> void:
	if my_timer.paused:
		my_timer.paused = false
	else:
		my_timer.start()

func pause() -> void:
	my_timer.paused = true

