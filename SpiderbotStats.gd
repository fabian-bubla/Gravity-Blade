extends Node

export var max_health = 1 setget set_max_health
var health = max_health setget set_health #the onready statement here makes it so that 
#the health is only set when the node is ready and not before, so it will consider
#values given to the export variable and not just the standard value that was passed
#I am using the setget function, so that the program doesn't check for whether the enemy is destroyed every frame but only when it has received damage.
#this doesn't really matter for enemies with only 1 hp but certainly matters for enemies with more than that
signal no_health
signal health_changed(value)
signal max_health_changed (value)

func set_max_health(value):
	max_health = value
	self.health = min(health, max_health)
	emit_signal("max_health_changed", max_health)

func set_health(value):
	health = value
	emit_signal("health_changed", health)
	if health <= 0:
		emit_signal("no_health")
		
func _ready():
	self.health = max_health
