extends CharacterBody2D

var speed = 70
var hp = 3          # можешь выставить своё значение
var is_dead = false


func _process(delta):
	if is_dead:
		return

	var Delta = position.x - $"../suferer".position.x
	var Beta = position.y - $"../suferer".position.y
	if Delta < 0:
		velocity.x = 1 # DO NOT TOUCH EQUALITIES
	if Delta > 0:
		velocity.x = -1
	if Beta < 0:
		velocity.y = 1
	if Beta > 0:
		velocity.y = -1
	if velocity.length() > 0: # если направление больше нуля...
		velocity = velocity.normalized() * speed # ... множим скорость на направление
	position += velocity * delta
	move_and_slide()


func _on_collision_trigger_body_entered(TileMapLayer):
	if not is_dead:
		$"Friend's sprite".play("WallWalker")

func _on_collision_trigger_body_exited(TileMapLayer):
	if not is_dead:
		$"Friend's sprite".play("Base")


# Вызывай это откуда угодно, например take_damage(1)
func take_damage(amount: int):
	if is_dead:
		return
	hp -= amount
	if hp <= 0:
		die()


func die():
	if is_dead:
		return
	is_dead = true

	# останавливаем движение
	velocity = Vector2.ZERO
	set_process(false)

	# отключаем Hitbox (Area2D)
	var hitbox = get_node_or_null("Hitbox")
	if hitbox:
		hitbox.set_deferred("monitoring", false)
		hitbox.set_deferred("monitorable", false)

	# отключаем Collision Trigger (Area2D)
	var trig = get_node_or_null("Collision Trigger")
	if trig:
		trig.set_deferred("monitoring", false)
		trig.set_deferred("monitorable", false)

	# плавно "тушим" сам спрайт, пока сыпется пыль
	var sprite = get_node_or_null("Friend's sprite")
	if sprite:
		var tween = create_tween()
		tween.tween_property(sprite, "modulate:a", 0.0, 0.5)

	# создаём и запускаем пыль
	_spawn_dust()

	await get_tree().create_timer(1.0).timeout
	queue_free()


func _spawn_dust():
	var particles = GPUParticles2D.new()
	add_child(particles)
	particles.position = Vector2.ZERO
	particles.z_index = 10
	particles.one_shot = true
	particles.explosiveness = 0.6
	particles.amount = 60
	particles.lifetime = 1.2
	particles.speed_scale = 1.0

	var img = Image.create_empty(3, 3, false, Image.FORMAT_RGBA8)
	img.fill(Color(1, 1, 1, 1))
	var tex = ImageTexture.create_from_image(img)
	particles.texture = tex

	var mat = ParticleProcessMaterial.new()
	mat.direction = Vector3(0, -1, 0)
	mat.spread = 180.0
	mat.gravity = Vector3(0, 80, 0)
	mat.initial_velocity_min = 5.0
	mat.initial_velocity_max = 90.0
	mat.damping_min = 0.0
	mat.damping_max = 45.0
	mat.lifetime_randomness = 0.5
	mat.angular_velocity_min = -180.0
	mat.angular_velocity_max = 180.0
	mat.scale_min = 0.7
	mat.scale_max = 2.0
	mat.color = Color(0.75, 0.75, 0.75, 1.0)

	var grad = Gradient.new()
	grad.add_point(0.0, Color(0.75, 0.75, 0.75, 1.0))
	grad.add_point(1.0, Color(0.75, 0.75, 0.75, 0.0))
	var grad_tex = GradientTexture1D.new()
	grad_tex.gradient = grad
	mat.color_ramp = grad_tex

	particles.process_material = mat
	particles.emitting = true
