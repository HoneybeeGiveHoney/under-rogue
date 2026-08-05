extends Button


var base_style: StyleBoxFlat
var wobble_tween: Tween

const WOBBLE_MIN := -0.45
const WOBBLE_MAX := -0.15
const WOBBLE_SPEED := 0.35


func _ready() -> void:
	var theme_style := get_theme_stylebox("hover")
	if theme_style is StyleBoxFlat:
		base_style = theme_style.duplicate()
		add_theme_stylebox_override("hover", base_style)
		add_theme_stylebox_override("focus", base_style)

	mouse_entered.connect(_on_hover)
	mouse_exited.connect(_on_unhover)


func _on_hover():
	if not base_style:
		return
	if wobble_tween:
		wobble_tween.kill()

	wobble_tween = create_tween()
	wobble_tween.set_loops()
	wobble_tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	wobble_tween.tween_property(base_style, "skew:x", WOBBLE_MIN, WOBBLE_SPEED)
	wobble_tween.tween_property(base_style, "skew:x", WOBBLE_MAX, WOBBLE_SPEED)


func _on_unhover():
	if wobble_tween:
		wobble_tween.kill()
	if base_style:
		base_style.skew.x = -0.3
