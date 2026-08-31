extends CharacterBody2D

var speed = 200

@export var knife_scene: PackedScene
@export var cooldown: = 0.1
@export var knife_spawn_point: Node2D
var can_hit: bool = true

func _physics_process(delta: float) -> void:
	var direction = Vector2.ZERO
	if Input.is_action_pressed("move_right") and GlobalData.IsPaused == 0:
		direction.x += 1
	if Input.is_action_pressed("move_left") and GlobalData.IsPaused == 0:
		direction.x -= 1
	if Input.is_action_pressed("move_down") and GlobalData.IsPaused == 0:
		direction.y += 1
	if Input.is_action_pressed("move_up") and GlobalData.IsPaused == 0:
		direction.y -= 1

	if direction.x == 1 and direction.y == 0:
		$Player.play("walk_right")
	elif direction.x == -1 and direction.y == 0:
		$Player.play("walk_left")
	elif direction.y == -1:
		$Player.play("walk_up")
	elif direction.y == 1:
		$Player.play("walk_down")
	elif direction == Vector2.ZERO and GlobalData.IsPaused == 0:
		$Player.play("standing")

	if direction.length() > 0:
		direction = direction.normalized()
	velocity = direction * speed
	move_and_slide()

func _process(_delta: float):
	if Input.is_action_pressed("attack") and can_hit and GlobalData.CurrentWeapon == 1:
		$sounds/KnifeSwing.play()
		if GlobalData.Pulse < 1.2:
			GlobalData.Pulse += 0.1
		attack_knife()

func attack_knife():
	can_hit = false
	var knife = knife_scene.instantiate()
	get_tree().current_scene.add_child(knife)
	var direction = (get_global_mouse_position() - global_position).normalized()
	knife.global_position = global_position + direction * 10
	knife.rotation = direction.angle()
	knife.setup(direction)
	var timer = get_tree().create_timer(cooldown)
	timer.timeout.connect(func(): can_hit = true)

func attack_spin():
	pass
	
