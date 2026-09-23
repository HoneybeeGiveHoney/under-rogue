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

func _on_second_pulse_area_entered(area: Area2D):
	if area.is_in_group("Enemies"):
		area.Health -= 15

func _on_third_pulse_area_entered(area: Area2D):
	if area.is_in_group("Enemies"):
		area.Health -= 20
