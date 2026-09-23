extends Area2D

var speed: = 200.0

func Hit():
	$AnimatedSprite2D.play("hit")
	$Fade.start()

func _on_area_entered(area: Area2D):
	if area.is_in_group("Enemies"):
		area.Health -= 10
		area.Hit()

func _on_fade_timeout():
	queue_free()
