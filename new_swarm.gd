extends KinematicBody2D

onready var playerDetectionZone = $PlayerDetectionZone
#var player = 
#for i in get_tree().get_nodes_in_group('Player'):
#	player = i
var velocity = Vector2.ZERO
export var ACCELERATION = 200 #ACCELERATION OF SPIDERBOT
export var FRICTION = 200 #FRICTION OF SPIDERBOT
export var MAX_SPEED = 50 #MAX SPEED SPIDERBOT CAN HAVE
var player_pos : Vector2
var state = IDLE #Potential FIXME
export var distance = 30


enum {
	IDLE
	CHASE
}
var bots_in_swarm = Array()

func _ready():
	
#	print(self.name)
	var enemy_group = get_tree().get_nodes_in_group("Enemy")
	for n in self.get_children():
		for n2 in n.get_children():
			if enemy_group.has(n2):
#				print(n2)
#				print(self.name)
				n2.add_to_group(str(get_instance_id())+'Enemy')
				bots_in_swarm.append(n2)
	pass

func _physics_process(delta):
	seek_player()
#	return_switch()
	if get_tree().get_nodes_in_group(str(get_instance_id()) + 'Enemy').size() == 0: #deletes the swarm if there are no enemies in it left anymore. could however be changed to 1, delete swarm when only one enemy left.
#		PlayerStats.goto_scene() #this used to be here when killing enemies was the win condition
			BackgroundMusic.Chill_crossfade(true)
			BackgroundMusic.playTrackChill()
#			yield($PlayerDetectionZone/Timer, "timeout")
			queue_free()

	match state:
		IDLE: #0
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION *delta)
		CHASE: #1
			var player = playerDetectionZone.player
			if player != null:
				var direction = (player.global_position - global_position).normalized() #.normalized is called, because then the only thing that remains is the direction of the player because the values are normalized between 0 and 1.
				velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
#				print(self.name, velocity)
				for i in get_tree().get_nodes_in_group(str(get_instance_id()) + 'Enemy'):
					i.velocity = velocity #the swarm velocity gets passed to the bots #FIXME

	if velocity != Vector2.ZERO:
#	print($SpiderbotWalkPlayer.is_playing())
		if not $SpiderbotWalkPlayer.is_playing():
			$SpiderbotWalkPlayer.play()
	else:
		if $SpiderbotWalkPlayer.is_playing():
			$SpiderbotWalkPlayer.stop()
			

	
	velocity = move_and_slide(velocity)

#
func seek_player(): #FIXME: does this really be need to called every frame?
	if playerDetectionZone.can_see_player():
		state = CHASE #if player in range, go into chase mode
	else:
		state = IDLE
		
#func return_switch():
#	player_pos = get_tree().current_scene.get_node('/root/MainScene/YSort/Player').get_global_position()
#	if player_pos.distance_to(self.position) < 75: #FIXME: I could instead use the collision player detection zone of the spiderbot -> makes more sense////when to dissolve the squadron
#		for i in get_tree().get_nodes_in_group('Enemy'):
#			i.return_active = false
#	else:
#		for i in get_tree().get_nodes_in_group('Enemy'):
#
#			i.return_active = true
func getallnodes(_node):
	for N in self.get_children():
		if N.get_child_count() > 0:
#			print("["+N.get_name()+"]")
			getallnodes(N)
		else:
			pass
			#
#			print("- "+N.get_name())


func _on_AudioStreamPlayer_ready():
	print('nodeready')
	pass # Replace with function body.
