extends Resource
class_name Settings

const _SAVE_PATH: String = "user://interval-boss-settings.tres"

export(Array, float) var waits = [0.0, 0.0, 0.0]
export(int) var rounds: int = 0
export(bool) var one_shot: bool = true

func write_save(new_waits: Array, rounds: int, one_shot: bool) -> void:
	for i in len(new_waits):
		self.waits[i] = new_waits[i]
	self.rounds = rounds
	self.one_shot = one_shot
	ResourceSaver.save(_SAVE_PATH, self)

func write_save_one_shot(one_shot: bool) -> void:
	self.one_shot = one_shot
	ResourceSaver.save(_SAVE_PATH, self)

static func load_save() -> Resource:
	if ResourceLoader.exists(_SAVE_PATH):
		return load(_SAVE_PATH)
	return null
