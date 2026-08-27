class_name Door
extends Area2D

signal body_entered_door(direction: Vector2i)

@export var direction: Vector2i = Vector2i.UP  # какой стороне комнаты соответствует эта дверь

@onready var sprite: Sprite2D = $Sprite2D if has_node("Sprite2D") else null
@onready var collision: CollisionShape2D = $CollisionShape2D if has_node("CollisionShape2D") else null

var is_open: bool = true

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	set_open(is_open)

func set_open(open: bool) -> void:
	is_open = open
	if collision:
		collision.disabled = open  # физически проходима, когда открыта (нет блокирующего коллайдера)
	if sprite:
		sprite.frame = 0 if open else 1  # предполагается 2 кадра в спрайтшите: открыто/закрыто

func _on_body_entered(body: Node2D) -> void:
	if not is_open:
		return
	if body.is_in_group("player"):
		body_entered_door.emit(direction)
