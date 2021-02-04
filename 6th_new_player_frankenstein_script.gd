extends KinematicBody2D #only here to attempt using _input, which necessitates a var event
 

#sprite
onready var sprite : Sprite = get_node("character")

#states
enum {
#	IDLE
	MOVE
	LEVITATE
	KILL
	BREAK
}

var state = MOVE
const PlayerHurtSound = preload ("res://PlayerHurtSound.tscn")


export var player_base_speed : int = 100 #general player speed across states
export var gravity_strenght_divided_by = 15 #general gravity strength across states
export var MOVE_max_movement_speed = 82 # limits the MOVE velocity per second. Therefore allows acc power to act against gravity, but limits the sped of movement
export var MOVE_movement_MULTIPLIER: float = 20 # defines how far one can get away from the sword
export var MOVE_gravity_multiplayer: float = 2 #defines how far one can get away from the sword, also gives the rate of attraction to the sword
export var LEVITATE_movement_multiplier: float = 0.1 #defines the power the player has to steer during levitation
export var LEVITATE_gravity_multiplier: float = 1.3 #defines the launching power of the gravity during levitation
export var actual_friction_for_airborne_personnel = 2.5
export var reappear_distance: int = 30 #how far from the abyss the player reappears

export var friction : float = 5 #friction is only reduced to define the rate at which movement slows down if no button is pressed, only when standing
export var max_gravityblade_attraction = 500 #max amount of distance the gravityblade can attract per frame
export var max_crosshair_distance = 90 # maximum distance of crosshair from player
export var breaking_friction_per_frame = 7 # used to be 12.5
export var speed_to_start_braking_at = 60 #at which e of slowness (bottom speed), the breaking state should be initiated
export var max_float_vel = 400

var acc : Vector2 = Vector2() #acceleration is the base player_base_speed * the vector so it is weighted accordin to the vector
var vel : Vector2 = Vector2()
var levitating : bool = false #used as flag to switch between levitation and walking controlsv
var lev_toggle_press : bool = false
var input_vector: Vector2 = Vector2()
var gravityblade_pos: Vector2 = Vector2()
var is_blade_out: bool = false
var aim_vector: Vector2 = Vector2()
var keep_levitation_state: bool = false
var keep_breaking_state: bool = false
var blade_spawn_block = false
var disable_vel: bool = false
export var blade_picked_up_yet: bool = false
var bugcounter: int = 0
onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback") #access to the animation stat
var stats = PlayerStats #PlayerStats is a singleton I defined
onready var hurtbox = $Hurtbox
onready var blinkAnimationPlayer = $BlinkAnimationPlayer
onready var sword_collisionshape = $HitboxPivot/SwordHitbox/CollisionShape2D




func _ready():
	PlayerStats.set_health(PlayerStats.max_health) #makes sure that after death the health is refilled
	stats.connect("no_health", self, "death_screen") # i have no idea what this does, but its used for player damage
#	get_tree().current_scene.get_node('ChasmTileMap').connect('_chasm', self, '_chasm')
	
	if PlayerStats.checkpoint_store != null:
		self.global_position = PlayerStats.checkpoint_store
		blade_picked_up_yet = true
#		BackgroundMusic.playTrackChill()
#		BackgroundMusic.

func _process(delta):
	acc.x = 0 #resets the acceleration each frame
	acc.y = 0 #same
#	
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	aim_vector.x = Input.get_action_strength("aim_right") - Input.get_action_strength("aim_left")
	aim_vector.y = Input.get_action_strength("aim_down") - Input.get_action_strength("aim_up")

	input_vector = input_vector.normalized() #input_vector.normalized() just returns the normalized version of the input vector. an explanation of normalization is here at 6:40 https://www.youtube.com/watch?v=EQA9MJ5_TxU&list=PL9FzW-m48fn2SlrW0KoLT4n5egNdX-W9a&index=2
	aim_vector = aim_vector.normalized() #idk why i do this with this one.
	acc.y = player_base_speed * input_vector.y #acceleration is the product of player_base_speed times the intensity of the stick press
	acc.x = player_base_speed * input_vector.x
		
	if input_vector != Vector2.ZERO:
		$AnimationTree["parameters/Idle_sw/blend_position"] = input_vector
		$AnimationTree["parameters/Idle/blend_position"] = input_vector
		$AnimationTree["parameters/Run_sw/blend_position"] = input_vector
		$AnimationTree["parameters/Run/blend_position"] = input_vector
		$AnimationTree["parameters/Levitate/blend_position"] = input_vector #FIXME: maybe I should use velocity vector normalized here?
		$AnimationTree["parameters/Kill/blend_position"] = input_vector
		
	if keep_breaking_state == true:
		state = BREAK
		

	elif keep_levitation_state == true and Input.is_action_just_pressed("levitation_toggle"):
		if not $BrakeAudio.is_playing():
			$BrakeAudio.play()
		state = BREAK

	elif keep_levitation_state == true:
		state = LEVITATE
		
	elif Input.is_action_just_pressed("levitation_toggle") and is_blade_out == true:
		if not $JumpAudio.is_playing():
			$JumpAudio.play()
		state = LEVITATE
	else: #input_vector != Vector2.ZERO
		state = MOVE #do i really need delta? it should be contained in the function anyhow

		
#_______________________________________________________________________________
	match state:
#		IDLE:
#			idle()
		MOVE:
			move(delta)
		LEVITATE:
			levitate(delta)
		KILL:
			pass
		BREAK:
			breaking(delta)
			
	#
		#animation set
	if is_blade_out:  #this needs to be after the first gravity() function call else the gravityblade_pos is still empty, and it doesn't work.
		if not $PullAudio.is_playing():
			$PullAudio.play()
		#SET CAMERA 
		#Camera is fixed on sword when it is out
		$RemoteTransform2D.global_position = gravityblade_pos
		
		#IF you wanna rotate the gravityblade collisionshape.
#		get_tree().current_scene.get_node('Gravityblade/bharea/Swordbox').rotation_degrees = rad2deg((gravityblade_pos - self.position).angle())
	else:
		$PullAudio.stop()
	if disable_vel == true:
		vel = Vector2.ZERO

	vel = move_and_slide(vel)
		
		
		
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
func crosshair():
	if blade_picked_up_yet == true:
		if aim_vector != Vector2.ZERO: #if any aim input is given
			$Crosshair.show()
			$Crosshair.position = aim_vector * max_crosshair_distance
			if is_blade_out:
				$Crosshair.hide()
		else:
			$Crosshair.hide()
func blade_spawn():
	if Input.is_action_just_pressed("blade_toggle") and blade_picked_up_yet:
		if is_blade_out == false:
			if blade_spawn_block == false:
				var Gravity_blade = load("res://Gravityblade.tscn")
				var gravity_blade = Gravity_blade.instance()
				var world = get_tree().current_scene
				world.add_child(gravity_blade)
				world.get_node('Gravityblade').global_position = global_position + $Crosshair.position
				$BladeSpawnAudio.play()
				is_blade_out = true
				gravityblade_pos = world.get_node("Gravityblade").global_position
				

#			else:
#
#				blade_spawn_block = false
func blade_despawn():
	var world = get_tree().current_scene
	world.get_node('Gravityblade').queue_free()

	$BladeDespawnAudio.play()
	is_blade_out = false

func gravity():
		#GRAVITYBLADE POSITION MANIPULATION
		var world = get_tree().current_scene
		var gravitational_force
		if world.has_node('Gravityblade'):
			gravityblade_pos = world.get_node("Gravityblade").global_position
			var distance =  -1 * (global_position - gravityblade_pos) / gravity_strenght_divided_by #EDITTT the 10 need be changed.
			distance.x = distance.x *abs(distance.x) #this is away to square a number while retaining it's sign!
			distance.y = distance.y * abs(distance.y)
			distance.x = clamp (distance.x, -max_gravityblade_attraction, max_gravityblade_attraction)
			distance.y = clamp (distance.y, -max_gravityblade_attraction, max_gravityblade_attraction)
			gravitational_force = distance
		else:
			gravitational_force = Vector2.ZERO
		return gravitational_force
#--------------------------------
#STATE FUNCTIONS
func move(delta): #move and idle
	if is_blade_out == false:
		vel = Vector2.ZERO #vel in move state needs to be reset else the character keeps walking when there is no blade.
	vel = acc * friction * delta *60 *MOVE_movement_MULTIPLIER #sth must be wrong here, maybe multiplier should happen at anoter point.
	vel.x = clamp (vel.x, -MOVE_max_movement_speed, MOVE_max_movement_speed) #makes sure movement speed before gravity cannot exceed a certain limit
	vel.y = clamp (vel.y, -MOVE_max_movement_speed, MOVE_max_movement_speed)
	vel += gravity() * MOVE_gravity_multiplayer
	##FIRST CONTROLS FOR STATES
	crosshair()
	blade_spawn()
	
	if blade_picked_up_yet == false: #disable some animations before 
		if input_vector == Vector2.ZERO:
			animationState.travel('Idle')
		elif input_vector != Vector2.ZERO:
			animationState.travel('Run')
			
			
	else:
		if input_vector == Vector2.ZERO and is_blade_out == false:
			animationState.travel('Idle_sw')
		if input_vector == Vector2.ZERO and is_blade_out == true:
			animationState.travel('Idle')
		if input_vector != Vector2.ZERO and is_blade_out == false:
			animationState.travel('Run_sw')
		elif input_vector != Vector2.ZERO and is_blade_out == true:
			animationState.travel('Run')
			 
	#WALK AUDIO!
	if vel != Vector2.ZERO:
		if not $WalkAudio.is_playing():
			$WalkAudio.play()
	else:
		if $WalkAudio.is_playing():
			$WalkAudio.stop()

	


func idle():
	pass
	#set idle animation

func levitate (delta):
	if $WalkAudio.is_playing():
		$WalkAudio.stop()
	var vel_last_frame = vel

	keep_levitation_state = true
	var gravity_acceleration = gravity() *LEVITATE_gravity_multiplier * delta * 60
	var player_accel = acc * 60 * delta * LEVITATE_movement_multiplier
	if is_blade_out == true:
#		vel = vel + gravity_acceleration + player_accel
		#this is helping the player point at the blade
		#FIXME change aimvector to input vector
		
		
		#FIXME
		#ACCEL VERSION $#ISSUE DAS ES NUR IN EINE RICHTUNG FUNKTIONIERT NUR NACH LINKS DERZEIT
		if input_vector.normalized().dot((global_position - gravityblade_pos).normalized()*-1) > 0.625:
			if input_vector != Vector2.ZERO:
				player_accel = (global_position - gravityblade_pos).normalized()*-1 * player_accel.length()

#				PLAYER A LEFT RIGHT PROBLEM

#				print('occurred', player_accel)
#		else:
#			$ColorRect.visible = false
#			pass
		
		vel = vel + gravity_acceleration + player_accel
		
		#VEL VERSION
#
#		vel = vel + gravity_acceleration + player_accel
#		if input_vector.normalized().dot((global_position - gravityblade_pos).normalized()*-1) > 0.625:
#			if input_vector != Vector2.ZERO:
##				vel = vel.move_toward((gravityblade_pos - global_position).normalized() * vel, 1)
##				vel = (gravityblade_pos - global_position).normalized() * vel
##				vel = (gravityblade_pos - global_position)
##				vel = -1 * (global_position - gravityblade_pos).normalized() * vel
#
#				$ColorRect.rect_global_position = gravityblade_pos
#				$ColorRect.visible = true
##				print('occurred', player_accel)
#		else:
#			$ColorRect.visible = false
#			pass

			
	else:
		vel = (vel + player_accel).clamped(vel.length())
		vel = vel.move_toward(Vector2.ZERO, actual_friction_for_airborne_personnel)
	vel = vel.clamped(max_float_vel)
	

	if vel_last_frame.abs() > vel.abs(): #if spee

		if vel.length() < speed_to_start_braking_at:
			keep_breaking_state = true
			pass
	elif vel == Vector2.ZERO:
		keep_breaking_state = true
		
	crosshair()
	animationState.travel('Levitate')
	if is_blade_out == false:
		#apply friction
#		vel = vel.move_toward(Vector2.ZERO, 1)
		blade_spawn()
		animationState.travel('Kill')
		sword_collisionshape.disabled = false #DOCUMENTATION: this enables the hitbox on kill mode
		#FIXME: make path into var
		#sprite.visible = false ##PLACEHOLDER FOR CODE LOGIC
	else:
		sword_collisionshape.disabled = true #FIXME: make path into var

#--------------------------------
func breaking(delta):

	$HitboxPivot/SwordHitbox/CollisionShape2D.disabled = true #DOC, this enables the Hitbox
	keep_levitation_state = false
	keep_breaking_state = true
	vel = vel.move_toward(Vector2.ZERO, breaking_friction_per_frame)
	$AnimationTree["parameters/Break/blend_position"] = vel.normalized() #this one uses velcoity bc u shouldnt be able to change the direction whilst braking
	$AnimationTree["parameters/Break_sw/blend_position"] = vel.normalized()
	if is_blade_out == true:
		animationState.travel('Break')
	else:
		animationState.travel('Break_sw')
	if vel == Vector2.ZERO:
			keep_breaking_state = false
			
func _on_Hurtbox_area_entered(area):
	if area.damage > 0:
		stats.health -= area.damage
		hurtbox.start_invincibility(2)

func _chasm(entering_pos, entering_vel):
	animationTree.active = false #else Tree overrides the fall animation
	if is_blade_out == true:
		animationPlayer.play('fall_sw')
	else:
		animationPlayer.play('fall')
	disable_vel = true #BOOKMAR
	yield(get_node("AnimationPlayer"), "animation_finished") #waits until either animation is finished
	disable_vel = false
	animationTree.active = true #now tree can resume to idle animation
	
#	print(self.global_position, entering_pos)
	
	self.global_position = entering_pos
	
	
	
#	self.global_position = search_nearest_tile(entering_pos)
	
	#rest of the position code
#	var new_pos = entering_pos - self.global_position #self position needs a minimum tho and a max
#	new_pos += new_pos.normalized() * reappear_distance
#	self.global_position = self.global_position + new_pos
#	print('_chasm called', bugcounter)
#	bugcounter = bugcounter +1
	
##	var new_pos = entering_pos - self.global_position #self position needs a minimum tho and a max
#	new_pos = entering_pos + new_pos.normalized() * 40
#	self.global_position = entering_pos - (-1 *(entering_pos -global_position).normalized() *30)

	#finding the respawn position

	
 
#	self.global_position = entering_pos - entering_vel.normalized() *30
	
	stats.health -= 1
	hurtbox.start_invincibility(1.0)
	if is_blade_out == true:
		blade_despawn()

func search_nearest_tile(entering_pos):
	var Chasm_Tilemap = get_tree().current_scene.get_node('/root/MainScene/ChasmTileMap/TileMap')
	var new_ent_pos = entering_pos 
	var entry_tile = Chasm_Tilemap.world_to_map(new_ent_pos)
#	return Chasm_Tilemap.map_to_world(entry_tile) #if use below delete this
#	for i in range (-1, 1):
#		for j in range(-1, 4):
#			if Chasm_Tilemap.get_cellv(entry_tile + Vector2(i,j)) == -1:
#				print(i,j)
#				return Chasm_Tilemap.map_to_world(entry_tile + Vector2(i,j))
func _on_Hurtbox_invincibility_started():
	blinkAnimationPlayer.play("Start")
	var playerhurtsound = PlayerHurtSound.instance()
	get_tree().current_scene.add_child(playerhurtsound)

func _on_Hurtbox_invincibility_ended():
	blinkAnimationPlayer.play("Stop")

func on_disallow_blade_spawn(blade_spawn_block): #FIXME delete
	blade_spawn_block = true
	
func death_screen():
	animationTree.active = false
	$Hurtbox.monitorable = false
	$Hurtbox.monitoring = false
	disable_vel = true
	if is_blade_out:
		if vel.x <= 0:
			animationPlayer.play("death_left")
		else:
			animationPlayer.play("death_right")
	else:

		if vel.x <= 0:
			animationPlayer.play("death_sw_left")
		else:
			animationPlayer.play("death_sw_right")
#	vel = Vector2.ZERO
	yield(animationPlayer, "animation_finished")
#	BackgroundMusic.playTrackChill()
	BackgroundMusic.Chill_crossfade(false)
	PlayerStats.fade_to_black()
	yield(PlayerStats.get_node('Tween'), "tween_completed")
	get_tree().change_scene('res://LevelFinished.tscn')
