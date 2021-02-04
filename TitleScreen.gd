extends Node2D

onready var animationBG = $BG
onready var selection = $Selection
onready var startAnimation = $StartAnimation
onready var quitAnimation = $QuitAnimation
onready var animationPlayer = $FadeIn/APFadeIn
onready var animationPlayerTitle = $Title01/APTitle
onready var animationPlayerStart = $StartAnimation/APStart
onready var animationPlayerQuit = $QuitAnimation/APQuit
onready var fadeInRect = $FadeIn
onready var lamusica = $AudioStreamPlayer
onready var ambience = $AmbienceSFX
#onready var startgamesfx = $StartGameSFX
onready var startButton = $StartButton
onready var quitButton = $QuitButton
#var level0= preload("res://LevelFinished.tscn")
var currently_selected
var input_unlocked = false

func _ready():
	lamusica.play()
	ambience.play()
	selection.visible = false
	startButton.disabled = true
	quitButton.disabled = true
	fadeInRect.visible = true
	animationPlayer.play("fade_in")
	animationBG.play("BGAnimation")
	
func _process(delta):
	if Input.is_action_just_pressed("ui_left") and input_unlocked:
		selection.visible = true
#		$Selection.global_position = $StartButton.rect_global_position
		selection.global_position = Vector2(93.5, 188)
		currently_selected = 'start'
		
	if Input.is_action_just_pressed("ui_right") and input_unlocked:
		selection.visible = true
		selection.global_position = Vector2(373.5, 188)
		currently_selected = 'quit'
	
	if Input.is_action_just_pressed("levitation_toggle"):
		if currently_selected == 'start':
			_on_StartButton_pressed()
		if currently_selected == 'quit':
			_on_QuitButton_pressed()

func _on_AnimationPlayer_animation_finished(_anim_name):
	animationPlayerTitle.play("FadeInTitle")
	animationPlayerStart.play("FadeInStart")
	animationPlayerQuit.play("FadeInQuit")

func _on_APStart_animation_finished(_anim_name):
	startButton.disabled = false
	quitButton.disabled = false
	fadeInRect.visible = false
	animationPlayerStart.play("IdleStart")
	animationPlayerQuit.play("IdleQuit")
	input_unlocked = true
	selection.play("idle")
	



func _on_QuitButton_pressed():
	quitButton.visible = false
	fadeInRect.visible = true
	animationPlayer.play_backwards("fade_in")
	var tween = get_node("Tween")
	tween.interpolate_property($AudioStreamPlayer, "volume_db", 0, -20, 2, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0)
	tween.start()
	yield(get_tree().create_timer(4),"timeout")
	get_tree().quit()


func _on_StartButton_pressed():
	BackgroundMusic.playStartSFX() 
	startButton.visible = false
	fadeInRect.visible = true
	animationPlayer.play_backwards("fade_in")
	yield (animationPlayer, "animation_finished")
	var tween = get_node("Tween")
	tween.interpolate_property($AudioStreamPlayer, "volume_db", 0, -30, 2, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0)
	tween.start()

#	BackgroundLoadAttempts.load_scene('res://LevelFinished.tscn') #FIXME I could reduce load time even more if the screen darkening was in that script
	get_tree().change_scene('res://LevelFinished.tscn')
#	yield(tween, "tween_completed")
#	yield(get_tree().create_timer(2),"timeout")
#	yield(BackgroundLoadAttempts.load_scene("res://Level0.tscn"), 'completed')


	


