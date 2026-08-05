extends Control

var Pause = 0

func _process(delta):
	if Input.is_action_just_pressed("pause") and Pause == 0:
		$AnimationPlayer.play("menu Appear")
		$Timer.start()
	if Input.is_action_just_pressed("pause") and Pause == 1:
		$AnimationPlayer.play("menu Disappear")
		Pause = 0

func _on_weapon_button_pressed():
	$"../WeaponMenu".open_menu()

func _on_timer_timeout():
	Pause = 1
