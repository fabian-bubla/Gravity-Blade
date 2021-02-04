extends Node2D

func _ready():
#	print('MainScene loaded')
	#DEBUG OVERLAY -> refer to https://www.youtube.com/watch?v=8Us2cteHbbo for tutorial
#	var overlay = load("res://Debug Overlay.tscn").instance()
#
#	overlay.add_stat("Player position", $YSort/Player, "position", false) #text, from node, property, function call?
#	overlay.add_stat("Swarm state", $swarm, "state", false)
#	overlay.add_stat("Swarm position", $swarm, "position", false)
#	overlay.add_stat("Spiderbot state", $swarm/Position2D/Spiderbot, "state", false)
#	overlay.add_stat("return active:", $swarm/Position2D/Spiderbot, "return_active", false)
#	overlay.add_stat("swarm vel", $swarm, "velocity", false)
#	overlay.add_stat("spider1 vel", $swarm/Position2D/Spiderbot, "velocity", false)
#	overlay.add_stat("spider2 vel", $swarm/Position2D2/Spiderbot, "velocity", false)
#	overlay.add_stat("spider3 vel", $swarm/Position2D3/Spiderbot, "velocity", false)
#	overlay.add_stat("player health", PlayerStats, "health", false)
#	overlay.add_stat("player state", $YSort/Player, "state", false)
#	add_child(overlay)
	BackgroundMusic.get_node('TrackChill').volume_db = -80
	BackgroundMusic.Chill_crossfade(true)
#	BackgroundMusic.PlayTrackAction()
#	BackgroundMusic.get_node('Tween').interpolate_property($TrackChill, "volume_db", -50, 0, 2, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0)
	BackgroundMusic.playTrackChill()
	print('played')

#func _process(delta):
#	print($ChasmTileMap.get_overlapping_bodies ( ))
#onready var dist: float = $Player2.position.distance_to($Gravityblade.position)
