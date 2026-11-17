extends Node2D
signal Burn(amount)

var SackOpened = false # открыт ли мешок?
var SackCooldown = false # кулдаун мешка
var HandIn = false # рука в мешке?
var IngredientPickability = true

var CanCook = false
var CurrentIngredient = 0
var MaxIngredients = 3
var Ingredient1 = 0
var Ingredient2 = 0
var Ingredient3 = 0
var IngredientsCooking = 0


var SSSC = true # super spin step cooldown
var SSC = true #spin step cooldown
var SSC2 = true #spin slowing cooldown
var Stopping = false
var SpinAccel = 0
var MaxSpinAccel = 4
var Spin = 1

var CookingThreshold = 80
var CACooldown = true
var DebuffProgress = 0
var DebuffProgressRaw = 0
var CastCD = true

func _process(_delta):
#region кручение колеса
	
	$Pot.rotation_degrees = Spin
	if Spin >= 359: # сброс колеса при полном обороте, что-бы оно не крутилось в минусовые значения
		Spin = 0
	if $Pot.rotation_degrees >= 359:
		$Pot.rotation_degrees = 0
	
	Spin = Spin + SpinAccel # каждый тик, к текущей позиции колеса добавляется ускорение
	
	if SpinAccel < 0.01:  # нормализатор (без него скорость раскрутки сходит с катушек при очень маленьких значениях)
		SpinAccel = roundf(SpinAccel)
	
	if SpinAccel > 0: # тормозим, если у колеса есть ускорение
		Stopping = true
	else:
		Stopping = false
	
	if SpinAccel == 0:
		SSSC = true
	
	if Stopping == true and SSC2 == true: # уменьшение ускорения колеса, если тормозит
		SSC2 = false
		$Pot/SpinSlowingCooldown.start()
		SpinAccel -= 0.1
	
	if Input.is_action_pressed("Reload") and SSC == true and SpinAccel < MaxSpinAccel and SSSC == true: # добавление ускорения
		SpinAccel += 1.4
		SSC = false
		$Pot/SpinStepCooldown.start()
		
	
	$VisibleIngredients/Ingredient1.global_position = $Pot/Ingredient1.global_position
	$VisibleIngredients/Ingredient2.global_position = $Pot/Ingredient2.global_position
	$VisibleIngredients/Ingredient3.global_position = $Pot/Ingredient3.global_position
	
	#endregion

#region увеличение ауры
	$Aura.scale.x = $Aura/Aura.value / 30
	$Aura.scale.y = $Aura/Aura.value / 30
	
	if SpinAccel > 0 and CanCook == true:
		$Aura/Aura.value = $Aura/Aura.value + (roundf(SpinAccel) / 22)
	if SpinAccel < 3 and CanCook == true:
		$Aura/Aura.value = $Aura/Aura.value - 0.5

#endregion

#region накладываем еффекты
	$Pot/IngredientCooking.value = IngredientsCooking # прогресс траты продуктов
	IngredientsCooking = $Pot/IngredientCooking.value 
	$TargetSelect/DebuffProgress.value = DebuffProgress
	DebuffProgress = $TargetSelect/DebuffProgress.value # прогресс наложения эффекта
	DebuffProgress = DebuffProgressRaw / 4
	if $Aura/Aura.value > CookingThreshold and CanCook == true: # если достаточно ауры и можно готовить,
		if CACooldown == true: # также если оно не в КД
			CACooldown = false
			$Pot/IngredientCooking/adding.start() #стартуем таймер
	else: # иначе всё ресетнется
		CACooldown = false
		$Pot/IngredientCooking/adding.stop()
		$Pot/IngredientCooking/MessUp.start()
	if Input.is_action_just_released("attack") and not DebuffProgress == 0 and CastCD == true:
		$CastCD.start()
		CastCD = false
		emit_signal("Burn", DebuffProgress)
		DebuffProgress = 0
		DebuffProgressRaw = 0
	
	if IngredientsCooking == 100:
		IngredientsCooking = 0
		SpendIngredients()

#region манипуляции с текущими продуктами
	if not Ingredient1 == 0 and not Ingredient2 == 0 and not Ingredient3 == 0:
		CanCook = true
	else:
		CanCook = false
		
	if SackOpened == true: #анимка мешка
		$Sack.play("opened")
	else:
		$Sack.play("closed")
	
	if Input.is_action_just_pressed("Right") and CurrentIngredient < MaxIngredients and HandIn == true:
		CurrentIngredient += 1 # по нажатию вправо, меняет продукт внутри мешка
		$Sack/shaking.play("shaking")
		$Sack/searching.play()
		$Hand/Shake.play("shake")

	if Input.is_action_just_pressed("Left") and CurrentIngredient > 0 and HandIn == true:
		CurrentIngredient -= 1
		$Sack/searching.play()
		$Sack/shaking.play("shaking")
		$Hand/Shake.play("shake")
#endregion

#region визуализация выбраных продуктов
	if Ingredient1 == 0:
		$VisibleIngredients/Ingredient1.play("Nothing")
	if Ingredient1 == 1:
		$VisibleIngredients/Ingredient1.play("Apple")
	if Ingredient1 == 2:
		$VisibleIngredients/Ingredient1.play("Carroot")
	if Ingredient1 == 3:
		$VisibleIngredients/Ingredient1.play("Potato")

	if Ingredient2 == 0:
		$VisibleIngredients/Ingredient2.play("Nothing")
	if Ingredient2 == 1:
		$VisibleIngredients/Ingredient2.play("Apple")
	if Ingredient2 == 2:
		$VisibleIngredients/Ingredient2.play("Carroot")
	if Ingredient2 == 3:
		$VisibleIngredients/Ingredient2.play("Potato")
	
	if Ingredient3 == 0:
		$VisibleIngredients/Ingredient3.play("Nothing")
	if Ingredient3 == 1:
		$VisibleIngredients/Ingredient3.play("Apple")
	if Ingredient3 == 2:
		$VisibleIngredients/Ingredient3.play("Carroot")
	if Ingredient3 == 3:
		$VisibleIngredients/Ingredient3.play("Potato")


	if CurrentIngredient == 0: # меняем текстурку на мешке, в зависимости от текущего продукта
		$Sack/Ingredients.play("Nothing")
	if CurrentIngredient == 1:
		$Sack/Ingredients.play("Apple")
	if CurrentIngredient == 2:
		$Sack/Ingredients.play("Carrot")
	if CurrentIngredient == 3:
		$Sack/Ingredients.play("Potato")
#endregion

 #region открываем\закрываем мешок
	if Input.is_action_just_pressed("space"):
		if SackOpened == false and SackCooldown == false:
			$Sack/SackCooldown.start()
			$Hand/Lowering.start()
			SackCooldown = true
			SackOpened = true
		
		if SackOpened == true and SackCooldown == false:
			$Sack/SackCooldown.start()
			$Hand/Shake.play("Reset")
			$Sack/searching.stop()
			$Sack/shaking.play("RESET")
			if HandIn == true:
				AddIngredient()
				HandIn = false
				$Hand/Hand.play("back up")
				$Hand/PullingOut.start()
			else:
				$Hand/Lowering.stop()
				SackCooldown = true
				SackOpened = false

func _on_sack_cooldown_timeout():
	SackCooldown = false

func _on_lowering_timeout():
	HandIn = true
	$Hand/Hand.play("lowering")

func _on_pulling_out_timeout():
	$Hand/Lowering.stop()
	SackCooldown = true
	SackOpened = false
#endregion

#region добавление продуктов в казан
func AddIngredient():
	if Ingredient1 == 0 and IngredientPickability == true and not CurrentIngredient == 0: 
		$VisibleIngredients/pickability.start() # если продукт 1 пуст, берёт в него продукт
		IngredientPickability = false
		Ingredient1 = CurrentIngredient
		$Pot/Ingredient1/spores.emitting = true
		$PickSound.play()
		$VisibleIngredients/Ingredient1/FadeUnfade.play('unfade')
		
	if not Ingredient1 == 0 and Ingredient2 == 0 and IngredientPickability == true and not CurrentIngredient == 0 : 
		$VisibleIngredients/pickability.start() # если продукт 1 полон и этот пуст, берёт в него продукт
		IngredientPickability = false
		Ingredient2 = CurrentIngredient
		$Pot/Ingredient2/spores.emitting = true
		$PickSound.play()
		$VisibleIngredients/Ingredient2/FadeUnfade.play('unfade')
		
	if not Ingredient2 == 0 and Ingredient3 == 0 and IngredientPickability == true and not CurrentIngredient == 0 :
		$VisibleIngredients/pickability.start() # если продукт 2 полон и этот пуст, берёт в него продукт
		IngredientPickability = false
		$Pot/Ingredient3/spores.emitting = true
		Ingredient3 = CurrentIngredient
		$PickSound.play()
		$VisibleIngredients/Ingredient3/FadeUnfade.play('unfade')

func SpendIngredients():
	$Pot/Ingredient1/spores.emitting = false
	$Pot/Ingredient2/spores.emitting = false
	$Pot/Ingredient3/spores.emitting = false
	$VisibleIngredients/Ingredient1/FadeUnfade.play('fade')
	$VisibleIngredients/Ingredient2/FadeUnfade.play('fade')
	$VisibleIngredients/Ingredient3/FadeUnfade.play('fade')
	CanCook = false
	Ingredient1 = 0
	Ingredient2 = 0
	Ingredient3 = 0
	$Aura/Aura.value = 0
#endregion



#region таймеры
func _on_pickability_timeout():
	IngredientPickability = true

func _on_spin_step_cooldown_timeout():
	SSC = true

func _on_spin_slowing_cooldown_timeout():
	SSC2 = true

func _on_adding_timeout():
	IngredientsCooking += 5
	DebuffProgressRaw += 1
	CACooldown = true

func _on_mess_up_timeout():
	CACooldown = true

func _on_cast_cd_timeout():
	CastCD = true
#endregion
