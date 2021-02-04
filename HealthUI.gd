extends Control

var hearts = 3 setget set_hearts
var max_hearts = 3 setget set_max_hearts

#https://www.youtube.com/watch?v=7A4EPIr-6Sc&list=PL9FzW-m48fn2SlrW0KoLT4n5egNdX-W9a&index=18
#onready var label = $Label
onready var heartUIFull = $HeartUIFull
onready var heartUIEmpty = $HeartUIEmpty



func set_hearts (value):
	hearts = clamp (value, 0, max_hearts)
	if heartUIFull != null:
		heartUIFull.rect_size.x = hearts * 16 
		
func set_max_hearts(value):
	max_hearts = max(value, 1)
	self.hearts = min(hearts, max_hearts)
	if heartUIEmpty != null:
		heartUIEmpty.rect_size.x = max_hearts * 16
	
func _ready():
	self.max_hearts = PlayerStats.max_health
	self.hearts = PlayerStats.health
	PlayerStats.connect("health_changed", self, "set_hearts")
	PlayerStats.connect("max_health_changed", self, "set_max_hearts")
