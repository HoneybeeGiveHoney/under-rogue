extends CharacterBody2D

var speed = 200

func _process(delta):
	var velocity = Vector2.ZERO  # выставляет текущее направление на 0
	if Input.is_action_pressed("move_right"): # когда кнопка вверх нажата...
		velocity.x += 1 # ... меняем направление (велосити) 
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1

	if velocity.x == 1 and velocity.y == 0:
		$Player.play("walk_right")
	if velocity.x == -1 and velocity.y == 0:
		$Player.play("walk_left")
	if velocity.y == -1 :
		$Player.play("walk_up")
	if velocity.y == 1:
		$Player.play("walk_down")
	if velocity.x == 0 and velocity.y == 0:
		$Player.play("standing")
	
	move_and_slide()
	if velocity.length() > 0: # если направление больше нуля...
		velocity = velocity.normalized() * speed # ... множим скорость на направление
	position += velocity * delta # текущая позиция ангела равна текущему направлению, множеному на время
