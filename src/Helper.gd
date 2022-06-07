extends Node

var _display_time_template = "{mins}:{secs}"

func format_time(time: float) -> String:
	var time_array: Array = get_mins_secs(time)
	var mins: String = pad_int(str(time_array[0]))
	var secs: String = pad_int(str(time_array[1]))
	return _display_time_template.format({"mins": mins, "secs": secs})

func pad_int(val: String) -> String:
	return ("0" + val if len(val) < 2 else val)

func calc_total_seconds(min_string: String, sec_string: String) -> float:
	var mins = int(min_string)
	var secs = int(sec_string)
	return float(mins * 60 + secs)

func get_mins_secs(time: float) -> Array:
	# ceil() to account for not displaying ms
	var time_int: int = int(ceil(time))
	return [time_int/60, time_int%60]
