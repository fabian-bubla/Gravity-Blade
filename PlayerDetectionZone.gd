extends Area2D

var player


func can_see_player(): #returns true if the player is inside the zone
	return player != null #evaluates the expression and then returns true or false



func _on_PlayerDetectionZone_body_entered(body):
	
	BackgroundMusic.playTrackAction()
	if $Timer.is_stopped() == false:
		$Timer.stop()
	player = body #assignment works
	print('ping body entered detection zone')
	print(body)
	pass # Replace with function body.


func _on_PlayerDetectionZone_body_exited(body):
	print('player exited detection zone')
	player = null
	
	$Timer.start(8)
	yield($Timer, "timeout")
	BackgroundMusic.Chill_crossfade(true)
	BackgroundMusic.playTrackChill()
	
	pass # Replace with function body.

	#fade in Battletrack on encounter
	# 2. if player excited FOLLOW ZONE then wait 5 seconds before fading back to chill track.
	# _on_area_exited:
	# start a timer
	# the timer is always stopped when _on_area_entered
	#if the timer runs out it fades back to the other track
