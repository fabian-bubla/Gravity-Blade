extends Area2D

#https://www.youtube.com/watch?v=1MO8DtnxSQs&list=PL9FzW-m48fn2SlrW0KoLT4n5egNdX-W9a&index=17

#const HitEffect = (preload(""))

var invincible = false setget set_invincible
onready var timer = $Timer
onready var collisionShape = $CollisionShape2D
signal invincibility_started
signal invincibility_ended


func set_invincible(value):
	invincible = value
	if invincible == true:
		emit_signal("invincibility_started")
	else:
		emit_signal("invincibility_ended")


func start_invincibility(duration):
	self.invincible = true
	timer.start(duration)
	
#func create_hit_effect(): #for later use should I ever need to play a hit effect
#	var effect = HitEffect.instance()
#	var main = get_tree().current_scene
#	main.add_child(effect)
#	effect.global_position = global_position
#	pass



func _on_Timer_timeout():
	self.invincible = false
	pass # Replace with function body.


func _on_Hurtbox_invincibility_started():
	
	collisionShape.set_deferred('disabled', true) #deactivating hurtbox while we are invicible
	#set deferred because it cannot be done during the _physics_process, 
	#so we need to use set deferred and then it will be set at the end of the game loop
	pass # Replace with function body.


func _on_Hurtbox_invincibility_ended():
	collisionShape.disabled = false#dreactivating hurtbox while we are invicible
	pass # Replace with function body.
