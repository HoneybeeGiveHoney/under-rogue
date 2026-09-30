extends Node2D

var HoldingBullet = false

var RevFirst = false
var RevSecond = false
var RevThird = false
var RevFourth = false
var RevFifth = false
var RevSixth = false
var RevSeventh = false
var RevEight = false
var Reloading = false
var CanOpenBarrel = true
var CanShoot = false

var Current = 6
var Ammo = 0
var MaxAmmo = 8

func _on_timer_timeout():
	CanOpenBarrel = true

func _process(_delta):
	
	if Current >= 9:
		Current = 1
	
			#region Shoot Detection
	if Current == 1 and RevFirst == true:
		CanShoot = true
	if Current == 1 and RevFirst == false:
		CanShoot = false
	if Current == 2 and RevSecond == true:
		CanShoot = true
	if Current == 2 and RevSecond == false:
		CanShoot = false
	if Current == 3 and RevThird == true:
		CanShoot = true
	if Current == 3 and RevThird == false:
		CanShoot = false
	if Current == 4 and RevFourth == true:
		CanShoot = true
	if Current == 4 and RevFourth == false:
		CanShoot = false
	if Current == 5 and RevFifth == true:
		CanShoot = true
	if Current == 5 and RevFifth == false:
		CanShoot = false
	if Current == 6 and RevSixth == true:
		CanShoot = true
	if Current == 6 and RevSixth == false:
		CanShoot = false
	if Current == 7 and RevSeventh == true:
		CanShoot = true
	if Current == 7 and RevSeventh == false:
		CanShoot = false
	if Current == 8 and RevEight == true:
		CanShoot = true
	if Current == 8 and RevEight == false:
		CanShoot = false
		#endregion
	
	if Input.is_action_just_pressed("Reload") and Reloading == false:
		Reloading = true
		CanOpenBarrel = false
		Current += 1
		$RevolverReloadingThing.visible = true
		$RevolverReloadingThing/Timer.start()
		$RevolverBarrelOpen.play()
			#region Animations
		if Current == 9:
			$RevolverCurrentPointer/Pointer.play("First")
		if Current == 2:
			$RevolverCurrentPointer/Pointer.play("Second")
		if Current == 3:
			$RevolverCurrentPointer/Pointer.play("Third")
		if Current == 4:
			$RevolverCurrentPointer/Pointer.play("Fourth")
		if Current == 5:
			$RevolverCurrentPointer/Pointer.play("Fifth")
		if Current == 6:
			$RevolverCurrentPointer/Pointer.play("Sixth")
		if Current == 7:
			$RevolverCurrentPointer/Pointer.play("Seventh")
		if Current == 8:
			$RevolverCurrentPointer/Pointer.play("Eight")
	#endregion
	
	if Input.is_action_just_released("Reload") and Reloading == true and CanOpenBarrel == true:
		Reloading = false
		$RevolverReloadingThing.visible = false
	
	if HoldingBullet == true:
		$Bullet.position = get_local_mouse_position()
		GlobalData.CanFocus = false

	if HoldingBullet == false:
		GlobalData.CanFocus = true

#region
	if RevFirst == true:
		$RevolverBarrel/First.visible = true
	if RevFirst == false: 
		$RevolverBarrel/First.visible = false
	if RevSecond == true:
		$RevolverBarrel/Second.visible = true
	if RevSecond == false: 
		$RevolverBarrel/Second.visible = false
	if RevThird == true:
		$RevolverBarrel/Third.visible = true
	if RevThird == false: 
		$RevolverBarrel/Third.visible = false
	if RevFourth == true:
		$RevolverBarrel/Fourth.visible = true
	if RevFourth == false:
		$RevolverBarrel/Fourth.visible = false
	if RevFifth == true:
		$RevolverBarrel/Fifth.visible = true
	if RevFifth == false:
		$RevolverBarrel/Fifth.visible = false
	if RevSixth == true:
		$RevolverBarrel/Sixth.visible = true
	if RevSixth == false:
		$RevolverBarrel/Sixth.visible = false
	if RevSeventh == true:
		$RevolverBarrel/Seventh.visible = true
	if RevSeventh == false:
		$RevolverBarrel/Seventh.visible = false
	if RevEight == true:
		$RevolverBarrel/Eight.visible = true
	if RevEight == false:
		$RevolverBarrel/Eight.visible = false
#endregion

func Shoot():
	if Current == 1 and RevFirst == true:
		Ammo -= 1
		RevFirst = false
	if Current == 2 and RevSecond == true:
		Ammo -= 1
		RevSecond = false
	if Current == 3 and RevThird == true:
		Ammo -= 1
		RevThird = false
	if Current == 4 and RevFourth == true:
		Ammo -= 1
		RevFourth = false
	if Current == 5 and RevFifth == true:
		Ammo -= 1
		RevFifth = false
	if Current == 6 and RevSixth == true:
		Ammo -= 1
		RevSixth = false
	if Current == 7 and RevSeventh == true:
		Ammo -= 1
		RevSeventh = false
	if Current == 8 and RevEight == true:
		Ammo -= 1
		RevEight = false



func _on_ammo_source_button_down():
	if Reloading == true:
		HoldingBullet = true
		$Bullet/GrabbingAmmo.play()
		$Bullet/Bullet.play("pickup")

func _on_first_pressed():
	if HoldingBullet == true and RevFirst == false:
		RevFirst = true
		Ammo += 1
		HoldingBullet = false 
		$LoadingRevolver.play()
		$Bullet/Bullet.play("Reset")

func _on_second_pressed():
	if HoldingBullet == true and RevSecond == false:
		RevSecond = true
		Ammo += 1
		HoldingBullet = false 
		$LoadingRevolver.play()
		$Bullet/Bullet.play("Reset")

func _on_third_pressed():
	if HoldingBullet == true and RevThird == false:
		RevThird = true
		Ammo += 1
		HoldingBullet = false
		$LoadingRevolver.play()
		$Bullet/Bullet.play("Reset")

func _on_fourth_pressed():
	if HoldingBullet == true and RevFourth == false:
		RevFourth = true
		Ammo += 1
		$LoadingRevolver.play()
		HoldingBullet = false 
		$Bullet/Bullet.play("Reset")

func _on_fifth_pressed():
	if HoldingBullet == true and RevFifth == false:
		RevFifth = true
		Ammo += 1
		$LoadingRevolver.play()
		HoldingBullet = false 
		$Bullet/Bullet.play("Reset")

func _on_sixth_pressed():
	if HoldingBullet == true and RevSixth == false:
		RevSixth = true
		Ammo += 1
		$LoadingRevolver.play()
		HoldingBullet = false 
		$Bullet/Bullet.play("Reset")

func _on_seventh_pressed():
	if HoldingBullet == true and RevSeventh == false:
		RevSeventh = true
		Ammo += 1
		$LoadingRevolver.play()
		HoldingBullet = false 
		$Bullet/Bullet.play("Reset")

func _on_eight_pressed():
	if HoldingBullet == true and RevEight == false:
		RevEight = true
		Ammo += 1
		$LoadingRevolver.play()
		HoldingBullet = false 
		$Bullet/Bullet.play("Reset")


func _on_bang_timeout():
	$Bang/AnimationPlayer.play("reset")
