extends Sprite2D

func _physics_process(_delta):
	
	if GlobalData.CurrentWeapon == 0:
		$"pointer's movement".play("normal")
		$"../../Pulse/ColorChange".play("Normal")
	if GlobalData.CurrentWeapon == 1:
		$"pointer's movement".play("patience")
		$"../../Pulse/ColorChange".play("Patience")
	if GlobalData.CurrentWeapon == 2:
		$"pointer's movement".play("integrity")
		$"../../Pulse/ColorChange".play("Integrity")
	if GlobalData.CurrentWeapon == 3:
		$"pointer's movement".play("kindness")
		$"../../Pulse/ColorChange".play("Kindness")
	if GlobalData.CurrentWeapon == 4:
		$"pointer's movement".play("justice")
		$"../../Pulse/ColorChange".play("Justice")
	if GlobalData.CurrentWeapon == 5:
		$"pointer's movement".play("bravery")
		$"../../Pulse/ColorChange".play("Bravery")
	if GlobalData.CurrentWeapon == 6:
		$"pointer's movement".play("dexterity")
		$"../../Pulse/ColorChange".play("Dexterity")
	
	if GlobalData.CurrentWeapon < 0:
		GlobalData. CurrentWeapon = 6
	if GlobalData.CurrentWeapon > 6:
		GlobalData. CurrentWeapon = 0
	
	if Input.is_action_just_pressed("move_right") and GlobalData.IsPaused == 1:
		GlobalData.CurrentWeapon -= 1
	if Input.is_action_just_pressed("move_left") and GlobalData.IsPaused == 1:
		GlobalData.CurrentWeapon += 1
	
