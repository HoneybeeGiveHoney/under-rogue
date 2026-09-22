extends Area2D

var Health = 50
var Dead = false

func _process(_delta):
	if Health <= 0 and Dead == false:
		Dead = true
		$"../Timer".start()
		$"../hit".emitting = true
		$"..".alive = false


func _on_timer_timeout():
	$"..".queue_free()
