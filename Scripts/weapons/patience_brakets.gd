extends AnimatedSprite2D

var Beat = 0

func _process(_delta):
	if GlobalData.CurrentWeapon == 1:
		$Brakets.play("pulse")
	else:
		$Brakets.play("Reset")

func _on_searching_range_area_entered(area: Area2D):
	if area.is_in_group("PatienceBeat"):
		Beat += 1
		$Window.start()

func _on_window_timeout():
	Beat -= 1
