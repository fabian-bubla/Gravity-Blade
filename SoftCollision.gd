extends Area2D

#https://www.youtube.com/watch?v=ffXx0dPejWY&list=PL9FzW-m48fn2SlrW0KoLT4n5egNdX-W9a&index=19
func is_colliding():
	var areas = get_overlapping_areas()
	return areas.size() > 0 #returns true if there is any areas
	
func get_push_vector():
	var areas = get_overlapping_areas()
	var push_vector = Vector2.ZERO
	if is_colliding():
		var area = areas[0]
		push_vector = area.global_position.direction_to(global_position)
		push_vector = push_vector.normalized()
	return push_vector
