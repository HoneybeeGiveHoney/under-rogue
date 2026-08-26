extends Sprite2D
func _process(delta: float):
	rotate(get_angle_to(get_global_mouse_position())+ deg_to_rad(-90))
