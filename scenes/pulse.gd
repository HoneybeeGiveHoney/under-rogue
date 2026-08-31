extends AnimatedSprite2D

func _process(_delta):
	if GlobalData.Pulse > 0:
		GlobalData.Pulse -= 0.002
	$".".scale.x = GlobalData.Pulse
	$".".scale.y = GlobalData.Pulse 
