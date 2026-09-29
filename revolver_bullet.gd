extends Area2D

var speed = 1500
var direction: Vector2 = Vector2.ZERO
var current_rotation = 0

func _process(_delta):
	position += direction * speed * _delta
	rotation = current_rotation
	$RevolverBullet/RevolverBulletAura.angle_max = -rotation_degrees
	$RevolverBullet/RevolverBulletAura.angle_min = -rotation_degrees
