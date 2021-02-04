extends AudioStreamPlayer

func _ready():
	pass # Replace with function body.

func _on_HeartPickupSound_finished():
	self.queue_free()
	pass # Replace with function body.
