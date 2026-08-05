extends Control

var Pause = 0

func _process(delta):
	if Input.is_action_just_pressed("pause") and Pause == 0 and not GlobalData.IsPausing == 1:
		GlobalData.IsPausing = 1
		$pausing.play("menu Appear")
		$PauseCooldown.start()
	if Input.is_action_just_pressed("pause") and Pause == 1:
		$pausing.play("menu Disappear")
		GlobalData.IsPausing = 0
		get_tree().paused = false
		Pause = 0

func _on_weapon_button_pressed():
	$"../WeaponMenu".open_menu()

func _on_timer_timeout():
	Pause = 1
	get_tree().paused = true
