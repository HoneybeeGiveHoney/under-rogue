extends Control

var Pause = 0

func _process(_delta):
	if Input.is_action_just_pressed("pause") and Pause == 0 and GlobalData.IsPaused == 0:
		$AnimationPlayer.play("menu Appear")
		GlobalData.IsPaused = 1
		GlobalData.BlockMovements = 1
		$PauseCooldown.start()

	if Input.is_action_just_pressed("pause") and Pause == 1:
		$UnblockMovements.start()
		$AnimationPlayer.play("menu Disappear")
		GlobalData.IsPaused = 0
		Pause = 0
		get_tree().paused = false

func _on_weapon_button_pressed():
	$"../WeaponMenu".open_menu()

func _on_pause_cooldown_timeout():
	Pause = 1
	get_tree().paused = true

func _on_unblock_movements_timeout():
	GlobalData.BlockMovements = 0
