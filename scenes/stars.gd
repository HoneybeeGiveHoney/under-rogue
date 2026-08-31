extends CPUParticles2D

func _ready() -> void:
	# === Общие настройки эмиссии ===
	emitting = false
	one_shot = true
	amount = 1
	lifetime = 0.6
	explosiveness = 1.0
	randomness = 0.3

	# === Форма эмиссии (точка) ===
	emission_shape = CPUParticles2D.EMISSION_SHAPE_POINT

	# === Направление и разлёт ===
	direction = Vector2(0, -1)
	spread = 60.0

	# === Скорость ===
	initial_velocity_min = 150.0
	initial_velocity_max = 250.0

	# === Гравитация ===
	gravity = Vector2(0, 400)

	# === Затухание скорости ===
	damping_min = 20.0
	damping_max = 40.0

	# === Масштаб (звезда уменьшается со временем) ===
	scale_amount_min = 1.0
	scale_amount_max = 1.8
	var scale_curve := Curve.new()
	scale_curve.add_point(Vector2(0.0, 1.0))
	scale_curve.add_point(Vector2(1.0, 0.0))
	scale_amount_curve = scale_curve

	# === Вращение ===
	angular_velocity_min = -180.0
	angular_velocity_max = 180.0

	# === Цвет и плавное исчезновение ===
	var grad := Gradient.new()
	grad.set_color(0, Color(1, 1, 0.6, 1))   # ярко-жёлтая в начале
	grad.set_color(1, Color(1, 0.9, 0.4, 0)) # прозрачная в конце
	color_ramp = grad


func hit() -> void:
	restart()
