extends Node
var activateActionTrack = true

func _ready():
	pass
	
func playTrackChill():
	if $TrackChill != null:
		if $TrackChill.is_playing():
			pass
		else:
			$TrackChill.play()
	#		$AmbienceSFX.play()
		$Tween.interpolate_property($TrackAction, "volume_db", 0, -50, 2, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0)
		yield($Tween,"tween_completed")
		$TrackAction.stop()
	
	

func Chill_crossfade(fadein):
		if fadein == true:
			$Tween.interpolate_property($TrackChill, "volume_db", -50, 0, 2, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0)
#			$Tween.interpolate_property($AmbienceSFX,  "volume_db", -30, 0, 2, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0)
		else:
			$Tween.interpolate_property($TrackChill, "volume_db", 0, -50, 2, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0)
#			$Tween.interpolate_property($AmbienceSFX,  "volume_db", 0, -30, 2, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0)
			$Tween.interpolate_property($TrackAction, "volume_db", 0, -50, 2, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0)
		$Tween.start()
		pass # Replace with function body.
	

func playTrackAction():
	if $TrackAction.is_playing() == false:
		$TrackAction.play()
		$Tween.interpolate_property($TrackChill, "volume_db", 0, -50, 2, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0)
	#	$Tween.interpolate_property($AmbienceSFX, "volume_db", 0, -30, 2, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0)
		$Tween.interpolate_property($TrackAction, "volume_db", -50, 0, 2, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0)
		$Tween.start()
		yield($Tween,"tween_completed")
	#	$TrackChill.stop()

func PlayTrackWin():
	$TrackWin.play()
	$TrackChill.stop() #FIXME SHould be removed
#	$AmbienceSFX.stop()
	$Tween.interpolate_property($TrackAction, "volume_db", 0, -50, 2, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0)
#	$Tween.interpolate_property($TrackWin, "volume_db", -50, 0, 2, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0)
	
	yield($Tween,"tween_completed")
	#$TrackChill.stop()
	$TrackAction.stop()

func StopAllTracks(): #Stops all except win track
	$TrackChill.queue_free()
	$TrackAction.stop()
	
func playStartSFX():
	$StartGameSFX.play()
	
#func ActionTrackOneShot():
#	if activateActionTrack == true:
#			playTrackAction()
#			activateActionTrack = false
			
			
#NOTES

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
