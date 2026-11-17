extends AudioStreamPlayer2D

var Showing = false

func _on_extend_tip_area_entered(area: Area2D):
	if area.is_in_group("Mouse") and Showing == false:
		Showing = true
		$Tip/sliding.play("out")

func _on_extend_tip_area_exited(area: Area2D):
	if area.is_in_group("Mouse") and Showing == true:
		$Tip/sliding.play("in")
		Showing = false
