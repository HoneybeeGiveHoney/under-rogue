extends CharacterBody2D

signal hit
var speed = 200
var Roll = 1

@export var knife_scene: PackedScene
@export var Bell_scene: PackedScene
@export var cooldown: = 0.5
@export var spawn_point: Node2D
var can_hit: bool = true

func _physics_process(_delta):
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

	$Attacks/Cooldown.wait_time = cooldown
	$InteractBox.position = get_local_mouse_position()
	
	#region
	var random = RandomNumberGenerator.new()
	random.seed = 12345
	Roll = (randi_range(1, 6))
	#endregion
	
func _process(_delta):
	if GlobalData.CurrentWeapon == 1 and cooldown > 0.3:
		cooldown /= 2
	
	if Input.is_action_pressed("attack") and can_hit and GlobalData.CurrentWeapon == 1 and GlobalData.PatienceCharges > 0:
		if GlobalData.Pulse < 1.2:
			GlobalData.Pulse += 0.1
		if GlobalData.PatienceCharges > 0:
			GlobalData.PatienceCharges -= 1
		emit_signal("hit")
		attack_knife()
	
	if Input.is_action_pressed("attack") and can_hit and GlobalData.CurrentWeapon == 2 and GlobalData.Inspiration >= $InteractBox/Integrity/Inspiration.MaxConsumption and $InteractBox/Integrity/Inspiration.CA == true:
		emit_signal("hit")
		# $InteractBox/Integrity/Inspiration.MaxConsumption = GlobalData.currentType
		attack_integrity()

func attack_knife():
	can_hit = false
	$Attacks/Cooldown.start()
	var knife = knife_scene.instantiate()
	get_tree().current_scene.add_child(knife)
	knife.Hit()
	knife.Sound()
	if $InteractBox/PatienceBrakets.Beat == 0:
		knife.Damage = 10
		knife.UnBeat()
	if $InteractBox/PatienceBrakets.Beat > 0:
		knife.Damage = 25
		$InteractBox/Scope/Pulse.play("Pulse")
		knife.Beat()
	knife.global_position = $InteractBox/CursorSpawn.global_position
	
	#region
	if Roll == 1:
		knife.rotation = 0
	if Roll == 2:
		knife.rotation = 45
	if Roll == 3:
		knife.rotation = -45
	if Roll == 4:
		knife.rotation = 90
	if Roll == 5:
		knife.rotation = 128
	if Roll == 6:
		knife.rotation = -128
	#endregion
func attack_integrity():
	can_hit = false
	$Attacks/Cooldown.start()
	var Bell = Bell_scene.instantiate()
	get_tree().current_scene.add_child(Bell)
	Bell.global_position = $InteractBox/CursorSpawn.global_position
	Bell.Fade()
	Bell.Appear()
	
@export var rmb_attack_scene: PackedScene
@export var rmb_cooldown: float = 0.3
var can_rmb_attack: bool = true

func _input(event: InputEvent):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			if can_rmb_attack and GlobalData.IsPaused == 0:
				attack_rmb()

func attack_rmb():
	can_rmb_attack = false
	var direction = (get_global_mouse_position() - global_position).normalized()

	var atk = rmb_attack_scene.instantiate()
	get_tree().current_scene.add_child(atk)
	atk.global_position = global_position + direction * 10
	atk.rotation = direction.angle()
	if atk.has_method("setup"):
		atk.setup(direction)

	var timer = get_tree().create_timer(rmb_cooldown)
	timer.timeout.connect(func(): can_rmb_attack = true)
	
func _on_cooldown_timeout():
	can_hit = true
