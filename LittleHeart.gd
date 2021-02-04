extends Node2D
var damage = 0 #it does no damage

onready var animplay = $AnimationPlayer

var HeartSFX = load('res://HeartPickupSound.tscn').instance()


# Called when the node enters the scene tree for the first time.
func _ready():
	animplay.play("idle")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Little_Heart_body_entered(body):
	if PlayerStats.health != PlayerStats.max_health:
		PlayerStats.health += 2
		animplay.stop(true)
		get_tree().current_scene.add_child(HeartSFX)
		queue_free()
	pass # Replace with function body.
