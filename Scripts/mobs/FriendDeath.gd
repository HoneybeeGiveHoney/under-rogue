extends Area2D

signal Death
var Health = 50
var Dead = false

var Burns = 0
var BurnsCD = true

func _process(_delta):
	if Health <= 0 and Dead == false:
		Dead = true
		emit_signal("Death")
		$"../DeathTimer".start()
		$"..".alive = false
		$"../Death".play("death")
	
	if not Burns == 0:
		$"../Burning".emitting = true
	else:
		$"../Burning".emitting = false
	
	if Burns > 0 and BurnsCD == true:
		BurnsCD = false
		Hit()
		$"../StatusEffects/Burning".start()
		if Burns < 0:
			Burns = 0


func Hit():
	$"../Damage".play("damage")

func _on_DeathTimer_timeout():
	$"../Hitbox".queue_free()
	$"..".queue_free()

func _on_burning_timeout():
	$"../StatusEffects/Burning".stop()
	Health = Health - 25
	Burns = Burns - 1
	BurnsCD = true

func _on_kindness_burn(amount):
	Burns = Burns + amount
