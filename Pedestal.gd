extends Area2D

var pullsound = load('res://GravityPullSFX.tscn')

func _on_Pedestal_body_entered(body):
	if body.name == 'Player':
		body.blade_picked_up_yet = true
		if $Sword01 != null:
			$AudioStreamPlayer.play()
			$Sword01.queue_free()
			
	pass # Replace with function body.
