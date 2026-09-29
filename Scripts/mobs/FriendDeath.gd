extends Area2D

var Health = 50
var Dead = false

func _process(_delta):
	if Health <= 0 and Dead == false:
		Dead = true
		$"../Timer".start()
		$"..".alive = false
		$"../Death".play("death")

func Hit():
	$"../Damage".play("damage")

func _on_timer_timeout():
	$"..".queue_free()
