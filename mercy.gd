extends Area2D

@export var speed: float = 600.0

@export var pitch_min: float = 0.9
@export var pitch_max: float = 1.1

var direction: Vector2 = Vector2.RIGHT

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var sound: AudioStreamPlayer2D = $Sound

func setup(dir: Vector2) -> void:
	direction = dir
	rotation = dir.angle()

func _ready() -> void:
	anim.play("mercy")
	anim.animation_finished.connect(_on_animation_finished)
	play_shot_sound()

func play_shot_sound() -> void:
	sound.pitch_scale = randf_range(pitch_min, pitch_max)
	sound.play()

func _physics_process(delta: float) -> void:
	position += direction * speed * delta

func _on_animation_finished() -> void:
	queue_free()

func _on_body_entered(body: Node) -> void:
	if body.has_method("take_damage"):
		body.take_damage(10)
