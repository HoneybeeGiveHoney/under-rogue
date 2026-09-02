extends Node2D

var Right = 0
var Left = 0
var Up = 0
var Down = 0
var IsPlaying = 0

var Failed = 0
var Progress = 0
var Beat = 1

func _process(delta):
#region Inputs
	if Input.is_action_just_pressed("Right") and IsPlaying == 1 and Failed == 0:
		Right = 1
		$Sounds/RightArrow.play()
	if Input.is_action_just_released("Right") and IsPlaying == 1:
		Right = 0
	if Input.is_action_just_pressed("Left") and IsPlaying == 1  and Failed == 0:
		Left = 1
		$Sounds/LeftArrow.play()
	if Input.is_action_just_released("Left") and IsPlaying == 1 :
		Left = 0
	if Input.is_action_just_pressed("Down") and IsPlaying == 1 and Failed == 0:
		Down = 1
		$Sounds/DownArrow.play()
	if Input.is_action_just_released("Down") and IsPlaying == 1:
		Down = 0
	if Input.is_action_just_pressed("Up") and IsPlaying == 1 and Failed == 0:
		Up = 1
		$Sounds/UpArrow.play()
	if Input.is_action_just_released("Up") and IsPlaying == 1:
		Up = 0
#endregion
	
	if Input.is_action_just_pressed("Info"):
		print(Progress, Beat, Failed, IsPlaying, Right, Left, Up, Down)
	
	
	var Current = 1 #(randi_range(1, 5))
	#var random = RandomNumberGenerator.new()
	#random.seed = 12345
	
	if Input.is_action_just_pressed("space") and IsPlaying == 0:
		SongStarted()
	if IsPlaying == 1 and Current == 1:
		if Progress == 0:
			$PointerMovement.play("Right")
		if Progress == 1:
			$PointerMovement.play("Right")
		if Progress == 2:
			$PointerMovement.play("Up")
		if Progress == 3:
			$PointerMovement.play("Down")
	#region First Song
		if Right == 1 and Progress == 0 and Failed == 0 and Beat == 1:
			$DeadZone.start()
			DoBeat()
		if Left == 1 and Progress == 0:
			Fail()
		if Up == 1 and Progress == 0:
			Fail()
		if Down == 1 and Progress == 0:
			Fail()
	# second beat
		if Right == 1 and Failed == 0 and Progress == 1 and Beat == 1:
			$DeadZone.start()
			DoBeat()
		if Left == 1 and Progress == 1:
			Fail()
		if Up == 1 and Progress == 1:
			Fail()
		if Down == 1 and Progress == 1:
			Fail()
	# third beat
		if Right == 1 and Progress == 2:
			Fail()
		if Left == 1 and Progress == 2:
			Fail()
		if Up == 1 and Failed == 0 and Progress == 2 and Beat == 1:
			$DeadZone.start()
			DoBeat()
		if Down == 1 and Progress == 2:
			Fail()
	# fourth beat
		if Right == 1 and Progress == 3:
			Fail()
		if Left == 1 and Progress == 3:
			Fail()
		if Up == 1 and Progress == 3:
			Fail()
		if Down == 1  and Failed == 0 and Progress == 3 and Beat == 1:
			DoBeat()
			Sucess()
			GlobalData.IntegritySucess = 1
		
#endregion

func SongStarted():
	Progress = 0
	IsPlaying = 1
	GlobalData.CanFocus = 0
	$Fail.start()
	$ArrowsMovement.play("Appear")
	$"../Pointer/PointerAnimation".play("Appear")

func Fail():
	Failed = 1
	$Sounds/Failure.play()
	$Cooldown.start()
	$ArrowsMovement.play("Dissapear")
	$"../Pointer/PointerAnimation".play("Dissapear")

func Sucess():
	IsPlaying = 0
	GlobalData.CanFocus = 1
	Right = 0
	Left = 0
	Up = 0
	Down = 0
	$Fail.stop()
	$Sounds/Sucess.play()
	$ArrowsMovement.play("Dissapear")
	$"../Pointer/PointerAnimation".play("Dissapear")

func DoBeat():
	$Beat.start()
	Beat = 0
	$"../Pointer/PointerAnimation".play("Beat")

func _on_fail_timeout():
	IsPlaying = 0
	GlobalData.CanFocus = 1
	$Sounds/Failure.play()
	$"../Pointer".visible = false

func _on_beat_timeout():
	Beat = 1
	$Sounds/Beat.play()

func _on_dead_zone_timeout():
	Progress += 1

func _on_cooldown_timeout():
	Failed = 0
	IsPlaying = 0
