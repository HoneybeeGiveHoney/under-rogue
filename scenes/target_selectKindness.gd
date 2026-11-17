extends Sprite2D
var ATarget = false
var Target = Node
var TargetCD = true

func _process(delta):
	if ATarget == false:
		$".".global_position = $"../../InteractBox/CursorSpawn".global_position
		Target = null
	if ATarget == true:
		$".".global_position = Target.global_position

func _on_seeking_range_area_entered(area: Area2D):
	if area.is_in_group("Enemies") and TargetCD == true:
		ATarget = true
		Target = area
		TargetCD = false
		$CD.start()


func _on_seeking_range_area_exited(area: Area2D):
	if area.is_in_group("Enemies") and area.Dead == true:
		ATarget = false


func _on_cd_timeout():
	TargetCD = true
