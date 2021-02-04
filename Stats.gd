extends Node

#onready var CreditsScreen = load("res://CreditsScreen.tscn")
export var max_health = 10 setget set_max_health
var health = max_health setget set_health #the onready statement here makes it so that 
var level_number = 0
var checkpoint_store
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
	if health == 0:
		emit_signal("no_health")
	elif health < 0:
		pass
		
func _ready():
	self.health = max_health

#func goto_scene(): #FIXME change name
	
#	var nr_of_enemies = get_tree().get_nodes_in_group("Enemy").size()
#	if nr_of_enemies == 0:
#		call_deferred("_deferred_goto_scene")
#	call_deferred("_deferred_goto_scene")
#	else:
#		pass

	


func _deferred_goto_scene():
	# It is now safe to remove the current scene
	#else Tree overrides the fall animation

#	yield(get_node("AnimationPlayer"), "animation_finished") #waits until either animation is finished
#now tree can resume to idle animation
	#Make all the win animationstuffs here:
	var Player = get_tree().current_scene.find_node('Player')
	var animationplayer = Player.get_node('AnimationPlayer')
	var animationTree = Player.get_node("AnimationTree")
	animationTree.active = false 
	animationplayer.play('win')
	BackgroundMusic.PlayTrackWin()
	yield(animationplayer, 'animation_finished')


	fade_to_black()
	yield($Tween, 'tween_completed' )
#	BackgroundLoadAttempts.load_scene(CreditsScreen) #FIXME I could reduce load time even more if the screen darkening was in that script
	get_tree().change_scene_to(load("res://CreditsScreen.tscn"))
#
func fade_to_black():
	
	var fadein = get_tree().current_scene.find_node('BlackSquare')

	$Tween.interpolate_property(fadein, "modulate", Color(1, 1, 1, 0), Color(1, 1, 1, 1), 3.0, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()
	fadein.visible = true
#	yield($Tween, 'tween_completed' ) #FIXME POTENTIAL
	
	#LEGACY FOR LEVEL CHANGE
#	level_number += 1
#	var next_lvl_path = "res://Level"+str(level_number)+'.tscn'
#	var directory = Directory.new();
#	var doFileExists = directory.file_exists(next_lvl_path)
#
#	Player_pos = Player.global_position
#	print(Player_pos)
#	if doFileExists == true:
#		print(next_lvl_path)
#		get_tree().change_scene(next_lvl_path)
#		Player.global_position = Player_pos
		
#	else:
##		get_tree().change_scene('PLACEHOLDER WIN SCREEN)
#		pass
