extends Area2D


func _ready():
	pass # Replace with function body.




func _on_WinArea_body_entered(body):
	if body.name == 'Player':
		BackgroundMusic.StopAllTracks()
		body.disable_vel = true
		PlayerStats._deferred_goto_scene()

	pass # Replace with function body.
