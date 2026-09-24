extends Area2D

var speed: = 200.0
var Damage = 10

func Hit():
	$AnimatedSprite2D.play("hit")
	$Fade.start()

func Sound():
	$KnifeSwing.play()

func Beat():
	$KnifeSwing.pitch_scale = 1.50
	$AnimationPlayer.play("Beat")

func UnBeat():
	$KnifeSwing.pitch_scale = 1

func _on_area_entered(area: Area2D):
	if area.is_in_group("Enemies"):
		area.Health -= Damage
		area.Hit()

func _on_fade_timeout():
	queue_free()
