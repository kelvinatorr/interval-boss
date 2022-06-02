extends Node

var _display_time_template = "{mins}:{secs}"

func format_time(time: float) -> String:
	var time_int: int = int(time) + 1  # To account for not displaying ms
	var mins: String = _pad_time(str(time_int/60))
	var secs: String = _pad_time(str(time_int%60))
	return _display_time_template.format({"mins": mins, "secs": secs})

func _pad_time(val: String) -> String:
	return ("0" + val if len(val) < 2 else val)
