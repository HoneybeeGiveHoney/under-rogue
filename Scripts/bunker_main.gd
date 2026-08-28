extends Node2D 

var health: int = 120
var max_health: int = 120

@onready var hp_bar := $CanvasLayer/HealthBar

func _ready() -> void:
	hp_bar.set_health(health, max_health)

func take_damage(amount: int) -> void:
	health -= amount
	hp_bar.take_damage(amount)
	if health <= 0:
		die()

func heal(amount: int) -> void:
	health += amount
	hp_bar.heal(amount)

func die() -> void:
	print("Игрок умер")
