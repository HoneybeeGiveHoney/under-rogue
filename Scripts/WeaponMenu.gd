extends CanvasLayer

@onready var panel: Control = $Background  #корневой визуальный узел меню оружия

var tween: Tween

func _ready() -> void:
	visible = false
	panel.modulate.a = 0.0

func open_menu() -> void:
	visible = true
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(panel, "modulate:a", 1.0, 0.2)

func close_menu() -> void:
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(panel, "modulate:a", 0.0, 0.2)
	tween.tween_callback(func(): visible = false)

func _unhandled_input(event: InputEvent) -> void:
	if visible and event.is_action_pressed("pause"):
		close_menu()
		get_viewport().set_input_as_handled()  # чтобы это же нажатие не закрыло ещё и паузу
