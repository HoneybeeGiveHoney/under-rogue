extends Area2D

func Appear():
	$Ding.play("Ding")
	$Appear.play("Appear")

func Fade():
	$Fade.start()

func _on_fade_timeout():
	queue_free()

func _on_area_entered(area: Area2D):
	if area.is_in_group("Enemies"):
		area.Health -= 10

func _on_second_pulse_body_entered(body: Node2D):
	if body.is_in_group("Enemies"):
		pass
	
func _on_third_pulse_body_entered(body: Node2D):
	if body.is_in_group("Enemies"):
		pass
