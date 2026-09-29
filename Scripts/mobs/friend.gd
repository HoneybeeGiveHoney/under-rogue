extends CharacterBody2D

var alive = true
var speed = 70

func _process(delta):
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
	if velocity.length() > 0 and alive == true: # если направление больше нуля...
		velocity = velocity.normalized() * speed # ... множим скорость на направление
	if alive == true:
		position += velocity * delta
	move_and_slide()
