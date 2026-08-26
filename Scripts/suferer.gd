extends CharacterBody2D

var speed = 200

func _process(delta):
	var velocity = Vector2.ZERO  # выставляет текущее направление на 0
	if Input.is_action_pressed("move_right") and GlobalData.IsPaused == 0: # когда кнопка вверх нажата...
		velocity.x += 1 # ... меняем направление (велосити) 
	if Input.is_action_pressed("move_left") and GlobalData.IsPaused == 0:
		velocity.x -= 1
	if Input.is_action_pressed("move_down") and GlobalData.IsPaused == 0:
		velocity.y += 1
	if Input.is_action_pressed("move_up") and GlobalData.IsPaused == 0:
		velocity.y -= 1

	if velocity.x == 1 and velocity.y == 0:
		$Player.play("walk_right")
	if velocity.x == -1 and velocity.y == 0:
		$Player.play("walk_left")
	if velocity.y == -1 :
		$Player.play("walk_up")
	if velocity.y == 1:
		$Player.play("walk_down")
	if velocity.x == 0 and velocity.y == 0 and GlobalData.IsPaused == 0:
		$Player.play("standing")
	
		move_and_slide()
	if velocity.length() > 0: # если направление больше нуля...
		velocity = velocity.normalized() * speed # ... множим скорость на направление
	position += velocity * delta # текущая позиция ангела равна текущему направлению, множеному на время
	
<<<<<<< Updated upstream
	if Input.is_action_pressed("left_mouse"):
		pass
=======

@export var knife_scene: PackedScene  # сюда в инспекторе перетащи Knife.tscn
@export var throw_cooldown: float = 1.5
@export var knife_spawn_point: Node2D  # Marker2D, откуда вылетает нож

var can_throw: bool = true

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("attack") and can_throw:
		throw_knife()

func throw_knife() -> void:
	can_throw = false
	var knife = knife_scene.instantiate()
	get_tree().current_scene.add_child(knife)
	var direction = (get_global_mouse_position() - global_position).normalized()
	
	# Спавним чуть впереди игрока, в направлении курсора
	knife.global_position = global_position + direction * 20
	knife.rotation = direction.angle()
	knife.setup(direction)
	
	var timer = get_tree().create_timer(throw_cooldown)
	timer.timeout.connect(func(): can_throw = true)
>>>>>>> Stashed changes
