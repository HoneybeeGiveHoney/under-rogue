extends Area2D

@export var speed: float = 800.0
@export var lifetime: float = 3.0

var direction: Vector2 = Vector2.ZERO

func setup(dir: Vector2) -> void:
	direction = dir

func _ready() -> void:
	# Автоуничтожение, если никуда не попал
	get_tree().create_timer(lifetime).timeout.connect(queue_free)

func _physics_process(delta: float) -> void:
	position += direction * speed * delta

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage(10)
	queue_free()

func _on_area_entered(area: Area2D) -> void:
	queue_free()
