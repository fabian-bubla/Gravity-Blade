extends Node2D

var set_area_block # I use these variables to track the different states, because AREAS may overlap,
#this could disable sthe block if the crosshair exited one area but still remained within the other.
var set_body_block
onready var Chasm_Tilemap = get_tree().current_scene.get_node('/root/MainScene/ChasmTileMap/TileMap')
onready var Player = get_tree().current_scene.get_node('/root/MainScene/YSort/Player')
onready var Coral_Tilemap = get_tree().current_scene.get_node('/root/MainScene/YSort/CoralTileMap')
onready var Pillar_Tilemap = get_tree().current_scene.get_node('/root/MainScene/YSort/PillarTileMap')
func _ready():
	pass
func _process(delta):
	var crosshair_position = Player.position + Player.aim_vector * Player.max_crosshair_distance
#	var tile_pos = Chasm_Tilemap.world_to_map(crosshair_position)
	#I couldn't use self.global_position here. Because the position was always slightly off!
	Player.blade_spawn_block = false
	
	if Chasm_Tilemap.get_cellv(Chasm_Tilemap.world_to_map(crosshair_position)) != -1: #if there is any chasm tile
		Player.blade_spawn_block = true
	
#	if Pillar_Tilemap.get_cellv(Pillar_Tilemap.world_to_map(crosshair_position)) != -1:
#		print('dang')
#		print(Chasm_Tilemap.get_cellv(Chasm_Tilemap.world_to_map(crosshair_position)))
#		print(Pillar_Tilemap.get_cellv(Pillar_Tilemap.world_to_map(crosshair_position)))
#		print(Pillar_Tilemap.get_cellv())

#THESE FUCKERS DON"T WANNA WORK AND IDK WHY
#	elif Pillar_Tilemap.get_cellv(Pillar_Tilemap.world_to_map(crosshair_position)) != -1: 
#		Player.blade_spawn_block = true
#
#	elif Coral_Tilemap.get_cellv(Coral_Tilemap.world_to_map(crosshair_position)) != -1: 
#		Player.blade_spawn_block = true
#
		


#------
#func _process(delta):
#	var tile_pos = Chasm_Tilemap.world_to_map(Player.position + Player.aim_vector * Player.max_crosshair_distance)
#	#I couldn't use self.global_position here. Because the position was always slightly off!
#	if Chasm_Tilemap.get_cell(tile_pos.x, tile_pos.y) != -1: 
#		Player.blade_spawn_block = true
#	else: #if there is a tile
#		Player.blade_spawn_block = false
#		pass
#
#	if Pillar_Tilemap.get_cell(tile_pos.x, tile_pos.y) != -1:
#		Player.blade_spawn_block = true
#	else: #if there is a tile
#		Player.blade_spawn_block = false
#		pass	
#
#	if Coral_Tilemap.get_cell(tile_pos.x, tile_pos.y) != -1:
#		Player.blade_spawn_block = true
#	else: #if there is a tile
#		Player.blade_spawn_block = false
#		pass	
#----
#func _on_Area2D_area_entered(area):
#	if area.name == 'ChasmTileMap':
##		print('area entered chasmmap')
#		set_area_block = true
#		new_set_block()
#
#func _on_Area2D_area_exited(area):
#	if area.name == 'ChasmTileMap':
##		print('area exited chasmmap')
#		set_area_block = false
#		new_set_block()
#
#func _on_Area2D_body_entered(body): #can be used when tilemap is defined as kinematic body
#	if body.name == 'PillarTileMap':
#		set_body_block = true
#		new_set_block()
#
#func _on_Area2D_body_exited(body):
#	if body.name == 'PillarTileMap':
#		set_body_block = false
#		new_set_block()
#
##
#func new_set_block():
#	if set_area_block or set_body_block:
#		var world = get_tree().current_scene
#		world.get_node('/root/MainScene/YSort/Player').blade_spawn_block = true
#	else:
#		var world = get_tree().current_scene
#		world.get_node('/root/MainScene/YSort/Player').blade_spawn_block = false

