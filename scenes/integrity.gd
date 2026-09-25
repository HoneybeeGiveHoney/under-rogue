extends Node2D

signal IntegritySucess

var Right = 0
var Left = 0
var Up = 0
var Down = 0
var IsPlaying = 0

var Failed = 0
var Progress = 0
var Beat = 1
var Alpha = 0
var Current = 0
var Roll = 0

func _process(delta):
#region Inputs
	if Input.is_action_just_pressed("Right") and IsPlaying == 1 and Failed == 0 and Beat == 1:
		Right = 1
		$Sounds/RightArrow.play()
	if Input.is_action_just_released("Right") and IsPlaying == 1:
		Right = 0
	if Input.is_action_just_pressed("Left") and IsPlaying == 1  and Failed == 0 and Beat == 1:
		Left = 1
		$Sounds/LeftArrow.play()
	if Input.is_action_just_released("Left") and IsPlaying == 1 :
		Left = 0
	if Input.is_action_just_pressed("Down") and IsPlaying == 1 and Failed == 0 and Beat == 1:
		Down = 1
		$Sounds/DownArrow.play()
	if Input.is_action_just_released("Down") and IsPlaying == 1:
		Down = 0
	if Input.is_action_just_pressed("Up") and IsPlaying == 1 and Failed == 0 and Beat == 1:
		Up = 1
		$Sounds/UpArrow.play()
	if Input.is_action_just_released("Up") and IsPlaying == 1:
		Up = 0
#endregion

	var random = RandomNumberGenerator.new()
	random.seed = 12345
	Roll = (randi_range(1, 5))

	if Input.is_action_just_pressed("space") and GlobalData.CurrentWeapon == 2 and IsPlaying == 0:
		SongStarted()
		Current = Roll
	if IsPlaying == 1 and Current == 1:   # FIRST SONG 1️⃣
		#region Pointer
		if Progress == 0 and Alpha == 1:
			$Right/Pulse/RightPulse.play("Pulse")
		if Progress == 1 and Alpha == 1:
			$Right/Pulse/RightPulse.play("Pulse")
		if Progress == 2 and Alpha == 1:
			$Up/Pulse/UpPulse.play("Pulse")
		if Progress == 3 and Alpha == 1:
			$Down/Pulse/DownPulse.play("Pulse")
		#endregion
		#region First beat
		if Right == 1 and Progress == 0 and Failed == 0 and Beat == 1:
			$DeadZone.start()
			DoBeat()
		if Left == 1 and Progress == 0:
			Fail()
		if Up == 1 and Progress == 0:
			Fail()
		if Down == 1 and Progress == 0:
			Fail()
		#endregion
	#region second beat
		if Right == 1 and Failed == 0 and Progress == 1 and Beat == 1:
			$DeadZone.start()
			DoBeat()
		if Left == 1 and Progress == 1:
			Fail()
		if Up == 1 and Progress == 1:
			Fail()
		if Down == 1 and Progress == 1:
			Fail()
		#endregion
	#region third beat
		if Right == 1 and Progress == 2:
			Fail()
		if Left == 1 and Progress == 2:
			Fail()
		if Up == 1 and Failed == 0 and Progress == 2 and Beat == 1:
			$DeadZone.start()
			DoBeat()
		if Down == 1 and Progress == 2:
			Fail()
		#endregion
	#region fourth beat
		if Right == 1 and Progress == 3:
			Fail()
		if Left == 1 and Progress == 3:
			Fail()
		if Up == 1 and Progress == 3:
			Fail()
		if Down == 1  and Failed == 0 and Progress == 3 and Beat == 1:
			DoBeat()
			Sucess()
			emit_signal("IntegritySucess")
		#endregion
	if IsPlaying == 1 and Current == 2:   # SECOND SONG 2️⃣
		#region Pointer
		if Progress == 0 and Alpha == 1:
			$Up/Pulse/UpPulse.play("Pulse")
		if Progress == 1 and Alpha == 1:
			$Down/Pulse/DownPulse.play("Pulse")
		if Progress == 2 and Alpha == 1:
			$Down/Pulse/DownPulse.play("Pulse")
		if Progress == 3 and Alpha == 1:
			$Up/Pulse/UpPulse.play("Pulse")
		#endregion
		#region first beat
		if Right == 1 and Progress == 0:
			Fail()
		if Left == 1 and Progress == 0:
			Fail()
		if Up == 1 and Failed == 0 and Progress == 0 and Beat == 1:
			$DeadZone.start()
			DoBeat()
		if Down == 1 and Progress == 0:
			Fail()
		#endregion
		#region second beat
		if Right == 1 and Progress == 1:
			Fail()
		if Left == 1 and Progress == 1:
			Fail()
		if Up == 1 and Progress == 1:
			Fail()
		if Down == 1 and Progress == 1 and Failed == 0  and Beat == 1:
			$DeadZone.start()
			DoBeat()
		#endregion
		#region third beat
		if Right == 1 and Progress == 2:
			Fail()
		if Left == 1 and Progress == 2:
			Fail()
		if Up == 1 and Progress == 2:
			Fail()
		if Down == 1 and Progress == 2 and Failed == 0  and Beat == 1:
			$DeadZone.start()
			DoBeat()
		#endregion
		#region forth beat
		if Right == 1 and Progress == 3:
			Fail()
		if Left == 1 and Progress == 3:
			Fail()
		if Up == 1 and Failed == 0 and Progress == 3 and Beat == 1:
			DoBeat()
			Sucess()
			emit_signal("IntegritySucess")
		if Down == 1 and Progress == 3:
			Fail()
		#endregion
	if IsPlaying == 1 and Current == 3:   # THIRD SONG 3️⃣
		#region Pointer
		if Progress == 0 and Alpha == 1:
			$Up/Pulse/UpPulse.play("Pulse")
		if Progress == 1 and Alpha == 1:
			$Left/Pulse/LeftPulse.play("Pulse")
		if Progress == 2 and Alpha == 1:
			$Left/Pulse/LeftPulse.play("Pulse")
		if Progress == 3 and Alpha == 1:
			$Right/Pulse/RightPulse.play("Pulse")
		#endregion
		#region first beat
		if Right == 1 and Progress == 0:
			Fail()
		if Left == 1 and Progress == 0:
			Fail()
		if Up == 1 and Failed == 0 and Progress == 0 and Beat == 1:
			$DeadZone.start()
			DoBeat()
		if Down == 1 and Progress == 0:
			Fail()
		#endregion
		#region second beat
		if Right == 1 and Progress == 1:
			Fail()
		if Left == 1 and Progress == 1 and Failed == 0  and Beat == 1:
			$DeadZone.start()
			DoBeat()
		if Up == 1 and Progress == 1:
			Fail()
		if Down == 1 and Progress == 1:
			Fail()
		#endregion
		#region third beat
		if Right == 1 and Progress == 2:
			Fail()
		if Left == 1 and Progress == 2 and Failed == 0  and Beat == 1:
			$DeadZone.start()
			DoBeat()
		if Up == 1 and Progress == 2:
			Fail()
		if Down == 1 and Progress == 2:
			Fail()
		#endregion
		#region forth beat
		if Right == 1 and Progress == 3 and Failed == 0 and Beat == 1:
			Sucess()
			DoBeat()
			emit_signal("IntegritySucess")
		if Left == 1 and Progress == 3:
			Fail()
		if Up == 1 and Progress == 3:
			Fail()
		if Down == 1 and Progress == 3:
			Fail()
		#endregion
	if IsPlaying == 1 and Current == 4:   # FOURTH SONG 4️⃣
		#region Pointer
		if Progress == 0 and Alpha == 1:
			$Down/Pulse/DownPulse.play("Pulse")
		if Progress == 1 and Alpha == 1:
			$Right/Pulse/RightPulse.play("Pulse")
		if Progress == 2 and Alpha == 1:
			$Left/Pulse/LeftPulse.play("Pulse")
		if Progress == 3 and Alpha == 1:
			$Up/Pulse/UpPulse.play("Pulse")
		#endregion
		#region first beat
		if Right == 1 and Progress == 0:
			Fail()
		if Left == 1 and Progress == 0:
			Fail()
		if Up == 1 and Progress == 0:
			Fail()
		if Down == 1 and Progress == 0 and Beat == 1 and Failed == 0:
			$DeadZone.start()
			DoBeat()
		#endregion
		#region second beat
		if Right == 1 and Progress == 1 and Failed == 0  and Beat == 1:
			$DeadZone.start()
			DoBeat()
		if Left == 1 and Progress == 1:
			Fail()
		if Up == 1 and Progress == 1:
			Fail()
		if Down == 1 and Progress == 1:
			Fail()
		#endregion
		#region third beat
		if Right == 1 and Progress == 2:
			Fail()
		if Left == 1 and Progress == 2 and Failed == 0  and Beat == 1:
			$DeadZone.start()
			DoBeat()
		if Up == 1 and Progress == 2:
			Fail()
		if Down == 1 and Progress == 2:
			Fail()
		#endregion
		#region forth beat
		if Right == 1 and Progress == 3:
			Fail()
		if Left == 1 and Progress == 3:
			Fail()
		if Up == 1 and Progress == 3 and Failed == 0 and Beat == 1:
			Sucess()
			DoBeat()
			emit_signal("IntegritySucess")
		if Down == 1 and Progress == 3:
			Fail()
		#endregion
	if IsPlaying == 1 and Current == 5:   # FIFTH SONG 5️⃣
		#region Pointer
		if Progress == 0 and Alpha == 1:
			$Left/Pulse/LeftPulse.play("Pulse")
		if Progress == 1 and Alpha == 1:
			$Left/Pulse/LeftPulse.play("Pulse")
		if Progress == 2 and Alpha == 1:
			$Right/Pulse/RightPulse.play("Pulse")
		if Progress == 3 and Alpha == 1:
			$Right/Pulse/RightPulse.play("Pulse")
		#endregion
		#region first beat
		if Right == 1 and Progress == 0:
			Fail()
		if Left == 1 and Progress == 0 and Beat == 1 and Failed == 0:
			$DeadZone.start()
			DoBeat()
		if Up == 1 and Progress == 0:
			Fail()
		if Down == 1 and Progress == 0:
			Fail()
		#endregion
		#region second beat
		if Right == 1 and Progress == 1:
			Fail()
		if Left == 1 and Progress == 1 and Beat == 1 and Failed == 0:
			$DeadZone.start()
			DoBeat()
		if Up == 1 and Progress == 1:
			Fail()
		if Down == 1 and Progress == 1:
			Fail()
		#endregion
		#region third beat
		if Right == 1 and Progress == 2 and Failed == 0  and Beat == 1:
			$DeadZone.start()
			DoBeat()
		if Left == 1 and Progress == 2:
			Fail()
		if Up == 1 and Progress == 2:
			Fail()
		if Down == 1 and Progress == 2:
			Fail()
		#endregion
		#region forth beat
		if Right == 1 and Progress == 3 and Failed == 0  and Beat == 1:
			Sucess()
			DoBeat()
			emit_signal("IntegritySucess")
		if Left == 1 and Progress == 3:
			Fail()
		if Up == 1 and Progress == 3:
			Fail()
		if Down == 1 and Progress == 3:
			Fail()
		#endregion


func SongStarted():
	Progress = 0
	IsPlaying = 1
	Alpha = 1
	GlobalData.CanFocus = 0
	$Fail.start()
	$ArrowsMovement.play("Appear")

func Fail():
	Failed = 1
	Progress = 0
	$Sounds/Failure.play()
	$Cooldown.start()
	$ArrowsMovement.play("Dissapear")
	Alpha = 0

func Sucess():
	$Cooldown.start()
	GlobalData.CanFocus = 1
	Right = 0
	Left = 0
	Up = 0
	Down = 0
	Progress = 0
	$Fail.stop()
	$Sounds/Sucess.play()
	$ArrowsMovement.play("Dissapear")
	Alpha = 0

func DoBeat():
	$Beat.start()
	Beat = 0

func _on_fail_timeout():
	Fail()

func _on_beat_timeout():
	Beat = 1
	$Sounds/Beat.play()

func _on_dead_zone_timeout():
	Progress += 1

func _on_cooldown_timeout():
	Failed = 0
	IsPlaying = 0
