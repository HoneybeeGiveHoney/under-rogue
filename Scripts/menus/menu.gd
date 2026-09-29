extends Control

var Pause = false

func _process(_delta):
	if Input.is_action_just_pressed("pause") and Pause == false and GlobalData.IsPaused == false and GlobalData.CanFocus == true:
		$AnimationPlayer.play("menu Appear")
		GlobalData.IsPaused = true
		GlobalData.BlockMovements = true
		$PauseCooldown.start()

	if Input.is_action_just_pressed("pause") and Pause == true:
		$UnblockMovements.start()
		$AnimationPlayer.play("menu Disappear")
		GlobalData.IsPaused = false
		Pause = false
		get_tree().paused = false

func _on_weapon_button_pressed():
	$"../WeaponMenu".open_menu()

func _on_pause_cooldown_timeout():
	Pause = true
	get_tree().paused = true

func _on_unblock_movements_timeout():
	GlobalData.BlockMovements = false
