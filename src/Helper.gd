extends Node

var _display_time_template = "{mins}:{secs}"

func format_time(time: float) -> String:
	# ceil() to account for not displaying ms
	var time_int: int = int(ceil(time))
	var mins: String = pad_int(str(time_int/60))
	var secs: String = pad_int(str(time_int%60))
	return _display_time_template.format({"mins": mins, "secs": secs})

func pad_int(val: String) -> String:
	return ("0" + val if len(val) < 2 else val)
