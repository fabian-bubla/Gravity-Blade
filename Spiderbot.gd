extends KinematicBody2D

onready var playerDetectionZone = $PlayerDetectionZone
var velocity = Vector2.ZERO
onready var stats = $SpiderbotStats

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var softCollision = $SoftCollision
export var ACCELERATION = 4000  # 200 man idk like change this value to change what happens i guess, thats how coding works no
export var FRICTION = 200 #
export var MAX_SPEED = 50  #50
var return_active
var state = IDLE
var disable_velocity: bool = false
var death_position


enum {
	IDLE
	INDIVIDUAL_CHASE
}




func _process(delta):
	#swarm velocity is passed here at the beginning or is it? it is!
#	print('1 : ' + str (velocity))
	var swarm_velocity = velocity #OMG I hate myself for what I am about to do here
#	print('velocity b4 reset', velocity)
	velocity = Vector2.ZERO #I should put my balls in a lawn mower as punishment for this
	seek_player()
	match state:
		IDLE: #0 #this actually isnt idle but SWARM CHASE

			#return force
			var raw_return_vector = Vector2.ZERO - self.get_position()
			var return_vector = raw_return_vector.normalized()
			velocity += velocity.move_toward(return_vector *MAX_SPEED, ACCELERATION *delta) #FIXME: possibly a += here
			#jittering fix
			if raw_return_vector.abs() < Vector2(1,1): #this fixes the jittering when the spiderbots aim to get back to their position, bc it just sets their vel to 0 when they are close enough
				velocity = Vector2.ZERO
			pass
		
		INDIVIDUAL_CHASE: #2
			var player = playerDetectionZone.player
			if player != null:
				var direction = (player.global_position - global_position).normalized() #.normalized is called, because then the only thing that remains is the direction of the player because the values are normalized between 0 and 1.
#				print('dir' + str(direction))
				velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta ) #FIXME: individual chase should not be combined with the velocity given by swarm, but I think right now it isn't
#				print(velocity)
	if softCollision.is_colliding():
		velocity += softCollision.get_push_vector() * delta *400 #FIXME: this should be with some const
	
	anim_player(velocity, swarm_velocity)
	
	if disable_velocity == true:
		
		velocity = Vector2.ZERO
		swarm_velocity = Vector2.ZERO
		self.global_position = death_position #ueberschreibt einfach die position mit der position wo es sterben haette sollen jedes frame.
		
		
	velocity = move_and_slide(velocity)
#	print('3 : ' + str (velocity))


func seek_player():
	if playerDetectionZone.can_see_player():
		state = INDIVIDUAL_CHASE
	else:
		state = IDLE
	pass

func anim_player(velocity, swarm_velocity):
	if velocity != Vector2.ZERO:
		$AnimationTree["parameters/Idle/blend_position"] = velocity.normalized()
		$AnimationTree["parameters/Walk/blend_position"] = velocity.normalized()
		$AnimationTree["parameters/Death/blend_position"] = velocity.normalized()
		animationState.travel('Walk')
	elif swarm_velocity != Vector2.ZERO: #ugh i want to kill myself for this abomination
		$AnimationTree["parameters/Walk/blend_position"] = swarm_velocity.normalized()
		$AnimationTree["parameters/Idle/blend_position"] = swarm_velocity.normalized()
		$AnimationTree["parameters/Death/blend_position"] = swarm_velocity.normalized()
		animationState.travel('Walk')
	else:
		animationState.travel('Idle')
		pass
		
func _on_PlayerDetectionZone_body_entered(body):
	pass # Replace with function body.


func _on_PlayerDetectionZone_body_exited(body):
	pass # Replace with function body.


func _on_Hurtbox_area_entered(area):
#	print(area.name)
	if area.name == 'SwordHitbox':
		stats.health -= area.damage #gets the damage value thats associatd with the area 
#	print (stats.health)
	pass # Replace with function body.




func _on_SpiderbotStats_no_health():
	
	animationTree.active = false
	#bam
	$Hitbox.queue_free()
	$Hurtbox.queue_free()
	$CollisionShape2D.queue_free()
	
	$CollisionShape2D.disabled = true
	if velocity.x > velocity.y:
		if velocity.x > 0:
			animationPlayer.play('death_right')
		else:
			animationPlayer.play('death_left')
	else:
		if velocity.y > 0:
			animationPlayer.play("down_up")
		else:
			animationPlayer.play("death_down")
	disable_velocity = true
	death_position = self.global_position
	$SpiderbotDeathSFX.play()
	yield($AnimationPlayer, 'animation_finished')
	self.queue_free()
	pass # Replace with function body.
