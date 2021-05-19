extends Node

# Exports properties
export var max_health = 1
onready var health = max_health setget set_health
	
signal no_health # Creates a signal for 0 health

func set_health(value):
	health = value
	if health <= 0:
		emit_signal("no_health")
