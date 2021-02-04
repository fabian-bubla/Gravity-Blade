extends Area2D
var damage = 0 #bc this otherwise would get counted as touching damage like the enemy hits are registered

#export var reappear_distance = 50
#onready var duplicatedTileMap = preload('res://TileMap2.tscn')
#onready var Tilomap = $TileMap
#onready var Tilomap_duplicate = Tilomap.duplicate()
#var switcher = false
#var logging = false
var Body
var entering_pos
var entering_vel
var stats = PlayerStats
signal _chasm (bodyenteredpos)
var Player_ref
var stop_dying = false
var position_list = []
func _ready():
#	add_child(Tilomap_duplicate)
#	Tilomap.collision_use_parent = true
#	Player_ref = 

	pass
	
func _process(delta):
#	print((entering_pos))
	Player_ref = get_tree().current_scene.get_node('YSort/Player') #maybe not good style because it calls player every frame

#		print(position_list)

	var tile_pos = $TileMap.world_to_map(Player_ref.position)
	if $TileMap.get_cell(tile_pos.x, tile_pos.y) == -1: #if you are on a chasm cell//
		position_list.append(Player_ref.get_global_position())
#	print(Player_ref.position)
		if position_list.size()> 6:
			position_list.remove(0)
#		if entering_pos == null: #if there is no enter pos data yet
		entering_pos = position_list[0]
#		print(position_list[2])
#		entering_pos = Player_ref.get_global_position()
#			entering_vel = Player_ref.vel
		stop_dying = false
#
	if $TileMap.get_cell(tile_pos.x, tile_pos.y) != -1: #if you are not on a chasm cell//
##		if entering_pos == null: #if there is no enter pos data yet
#		entering_pos = position_list[0]
##		print(position_list[2])
##		entering_pos = Player_ref.get_global_position()
##			entering_vel = Player_ref.vel
#

		if stop_dying == false: #else if you entered and there is a entering_pos
			if Player_ref.state != 1:
				if Player_ref.state != 3:
					Player_ref._chasm(entering_pos, entering_vel) 
					stop_dying = true
		

#	else: #if you are on a normal cell
#		entering_pos = null
#		entering_vel = null
		
	
#	else:
#		switcher == false
#
#	if switcher == true:
#		if Body.state != 1:
#			if Body.state != 3:
##				emit_signal('_chasm', entering_pos)
#				var Player = get_tree().current_scene.get_node('YSort/Player')
#				Player._chasm(entering_pos, entering_vel)
#				switcher = false #this fixes it. although I don't understand why.... If this isn't here the area exited signal isn't called until 2-3 frames later so it just keeps on adding damage.
#				#THIS IS A BUG, WHY!
#		else:
#			pass
#
#func _on_ChasmTileMap_body_entered(body):
##	print('bentered signal: ' + body.name )
#
#	if body.is_in_group('Player'):
#		print('entered')
#		Body = body
#		entering_pos = body.get_global_position()
#		entering_vel = body.vel
#		switcher = true
#		pass 
#
#func _on_ChasmTileMap_body_exited(body):
#	if body.is_in_group('Player'):
#		print('exited')
#		switcher = false
#		pass 
