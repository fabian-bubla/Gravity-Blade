extends Node2D

onready var animationBG = $BG
onready var fadeIn = $FadeIn
onready var names = $Names
onready var gameDesign = $GameDesign
onready var thanks = $Thanks

onready var fadeInAP = $FadeIn/APFade
onready var namesAP = $Names/APNames
onready var gameDesignAP = $GameDesign/APGameDesign

onready var lamusica = $AudioStreamPlayer
onready var ambience = $AmbienceSFX
onready var tween = $Tween

onready var counter = 0
 

func _ready():
	fadeIn.visible = true
	get_tree().get_root().set_disable_input(true)
#	lamusica.play()
	ambience.play()
	animationBG.play("CreditsBG")
	namesAP.play("Idle")
	fadeInAP.play("FadeIn")
	yield(get_tree().create_timer(3),"timeout")
	get_tree().get_root().set_disable_input(false)
	
	
func _on_APNames_animation_finished(_anim_name):
	if counter < 2:
		namesAP.play("Idle")
		counter += 1
#		print(counter, "Names")
	else:
		namesAP.play("FadeOut")
		yield(get_tree().create_timer(2),"timeout")
		namesAP.stop(true)
		names.visible = false
		gameDesign.visible = true
		gameDesignAP.play("FadeIn")
		yield(get_tree().create_timer(2),"timeout")
		
		
func _on_APGameDesign_animation_finished(_anim_name):
	if counter < 4:
		gameDesignAP.play("Idle")
		counter += 1
#		print(counter, "Games")
	else:
		gameDesignAP.play("FadeOut")
		yield(get_tree().create_timer(2),"timeout")
		gameDesignAP.stop(true)
		gameDesign.visible = false
		names.visible = true
		counter = 0
		namesAP.play("FadeIn")
		yield(get_tree().create_timer(2),"timeout")
		
		
func _input(event):
	if event is InputEventKey and event.pressed:
		if event.scancode != KEY_ENTER:
			thanks.visible = true
			fadeInAP.play("FadeOut")
			
			tween.interpolate_property(get_node("/root/BackgroundMusic/TrackWin"), "volume_db", 0, -35, 3.5, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0)
			tween.start()
			yield(get_tree().create_timer(5),"timeout")
			get_tree().quit()
