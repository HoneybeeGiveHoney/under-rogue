class_name Melee extends AnimatedSprite2D

func _process(delta: float):
	
	rotation_degrees = $"../../Pointer".rotation_degrees

func _on_area_2d_body_entered(body: Node2D):
	pass
