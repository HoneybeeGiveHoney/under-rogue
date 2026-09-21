extends Area2D

@export var speed: = 200.0
@export var lifetime: = 0.4

var direction: Vector2 = Vector2.ZERO
var has_hit: = false
var pending_target: Node = null

func setup(dir: Vector2):
	direction = dir

func _ready():
	# удаляем нож через lifetime секунд, даже если он ни во что не попал
	get_tree().create_timer(lifetime).timeout.connect(_on_lifetime_timeout)

func _physics_process(delta):
	if has_hit:
		return
	position += direction * speed * delta

func _on_body_entered(body: Node2D):
	_try_hit(body)

func _on_area_entered(area: Area2D):
	_try_hit(area)

func _try_hit(node: Node):
	if has_hit:
		return

	var target = node
	if not target.is_in_group("enemies"):
		target = target.get_parent()

	if target and target.is_in_group("enemies") and target.has_method("take_damage"):
		has_hit = true
		pending_target = target
		direction = Vector2.ZERO # нож замирает на месте

		# отключаем собственные коллизии, чтобы не сработать повторно
		set_deferred("monitoring", false)
		set_deferred("monitorable", false)

		# ждём, когда доиграется анимация ножа
		var sprite: AnimatedSprite2D = $AnimatedSprite2D
		if sprite and not sprite.animation_finished.is_connected(_on_animation_finished):
			sprite.animation_finished.connect(_on_animation_finished, CONNECT_ONE_SHOT)
		elif not sprite:
			# если спрайта с таким именем нет — просто наносим урон сразу
			_deal_damage()

func _on_animation_finished():
	_deal_damage()

func _deal_damage():
	if pending_target and pending_target.has_method("take_damage"):
		pending_target.take_damage(10)
	queue_free()

func _on_lifetime_timeout():
	# если нож ни во что не попал — просто удаляем как раньше
	if not has_hit:
		queue_free()
