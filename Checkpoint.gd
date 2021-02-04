extends Area2D

var one_shot = true



func _ready():
	pass # Replace with function body.




func _on_Checkpoint_body_entered(body):
	if one_shot == true:
		if body.name == 'Player':
			PlayerStats.checkpoint_store = self.global_position
			one_shot = false
		
	pass # Replace with function body.
