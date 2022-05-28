extends Node

func _ready() -> void:
	load_interval()

func load_interval() -> void:
	var interval = load("res://src/Interval.tscn").instance()
	add_child(interval)
