extends Node

func _on_soul_button_pressed() -> void:
	GameData.chosen_soul = "Пустая Оболочка"
	get_tree().change_scene_to_file("res://Game.tscn")
