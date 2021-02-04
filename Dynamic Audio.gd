extends Node

func _ready( ):
	var player = AudioStreamPlayer.new()
	self. add_child(player)
	player.stream = load("res://Assets/Music/Track2.wav")
	player.play()
