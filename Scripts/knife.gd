extends Area2D

@export var speed: = 200.0
@export var lifetime: = 0.5

var direction: Vector2 = Vector2.ZERO

func setup(dir: Vector2):
	direction = dir

func _ready():
	get_tree().create_timer(lifetime).timeout.connect(queue_free)

func _physics_process(delta):
	position += direction * speed * delta

func _on_body_entered(body: Node2D):
	if body.has_method("take_damage"):
		body.take_damage(10)
	queue_free()
