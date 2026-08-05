extends CanvasLayer

@onready var anim_player: AnimationPlayer = $AnimationPlayer

func _ready():
	visible = false

func _unhandled_input(event: InputEvent):
	if event.is_action_pressed("pause"):
		toggle_pause()

func toggle_pause():
	if get_tree().paused:
		get_tree().paused = false
		anim_player.play("hide_menu")
		await anim_player.animation_finished
		visible = false
	else:
		visible = true
		get_tree().paused = true
		anim_player.play("show_menu")


func _on_weapon_button_pressed():
	$"../WeaponMenu".open_menu()
