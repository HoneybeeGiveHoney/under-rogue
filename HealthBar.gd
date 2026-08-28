@tool
extends Control
class_name DeltaruneHealthBar

## Полоска здоровья в стиле Deltarune (без кнопок), с именем "suferer".
## Просто добавь Control-ноду на сцену, назначь ей этот скрипт,
## выставь размер (рекомендуется примерно 500x100) — и готово.

@export var character_name: String = "suferer"
@export var max_health: int = 120
@export var current_health: int = 120:
	set(value):
		current_health = clamp(value, 0, max_health)
		queue_redraw()

@export_group("Портрет")
@export var portrait_texture: Texture2D # можно оставить пустым - будет просто цветной кружок
@export var portrait_bg_color: Color = Color(0.15, 0.55, 0.9)

@export_group("Шрифт")
@export var font: Font # рекомендуется пиксельный моноширинный шрифт (напр. "Determination Mono")
@export var name_font_size: int = 26
@export var hp_font_size: int = 20
@export var numbers_font_size: int = 22

@export_group("Цвета")
@export var border_color: Color = Color(0.253, 0.253, 0.253, 1.0)
@export var bg_color: Color = Color(0, 0, 0)
@export var bar_bg_color: Color = Color(0.08, 0.08, 0.08)
@export var bar_fill_color: Color = Color(0.255, 0.255, 0.255, 1.0)
@export var text_color: Color = Color(1, 1, 1)

@export_group("Анимация")
@export var damage_flash: bool = true
@export var lerp_speed: float = 8.0

var _displayed_health: float
var _flash_t: float = 0.0

func _ready() -> void:
	_displayed_health = current_health
	set_process(true)

func _process(delta: float) -> void:
	var target := float(current_health)
	if absf(_displayed_health - target) > 0.05:
		_displayed_health = lerp(_displayed_health, target, delta * lerp_speed)
		queue_redraw()
	elif _displayed_health != target:
		_displayed_health = target
		queue_redraw()
	if _flash_t > 0.0:
		_flash_t = max(0.0, _flash_t - delta)
		queue_redraw()

func take_damage(amount: int) -> void:
	if amount > 0 and damage_flash:
		_flash_t = 0.4
	current_health -= amount

func heal(amount: int) -> void:
	current_health += amount

func set_health(cur: int, max_hp: int = -1) -> void:
	if max_hp > 0:
		max_health = max_hp
	current_health = cur

func _get_font() -> Font:
	return font if font else ThemeDB.fallback_font

func _draw() -> void:
	var size := get_size()
	var border_w := 4.0
	var corner := 10.0

	# внешняя рамка (голубая)
	var outer := StyleBoxFlat.new()
	outer.bg_color = border_color
	outer.set_corner_radius_all(int(corner))
	draw_style_box(outer, Rect2(Vector2.ZERO, size))

	# внутренний чёрный фон
	var inner := StyleBoxFlat.new()
	inner.bg_color = bg_color
	inner.set_corner_radius_all(int(corner - border_w))
	draw_style_box(inner, Rect2(Vector2.ONE * border_w, size - Vector2.ONE * border_w * 2))

	# --- портрет слева ---
	var portrait_size: float = size.y - border_w * 2 - 8
	var portrait_pos := Vector2(border_w + 4, (size.y - portrait_size) / 2)
	if portrait_texture:
		draw_texture_rect(portrait_texture, Rect2(portrait_pos, Vector2(portrait_size, portrait_size)), false)
	else:
		draw_circle(portrait_pos + Vector2(portrait_size, portrait_size) / 2, portrait_size / 2, portrait_bg_color)

	var f := _get_font()

	# --- имя ---
	var name_x := portrait_pos.x + portrait_size + 24
	var name_baseline := size.y / 2 + name_font_size * 0.35
	draw_string(f, Vector2(name_x, name_baseline), character_name.to_upper(), HORIZONTAL_ALIGNMENT_LEFT, -1, name_font_size, border_color)

	var name_width := f.get_string_size(character_name.to_upper(), HORIZONTAL_ALIGNMENT_LEFT, -1, name_font_size).x

	# --- "HP" ---
	var hp_label_x := name_x + name_width + 30
	draw_string(f, Vector2(hp_label_x, size.y / 2 + hp_font_size * 0.35), "HP", HORIZONTAL_ALIGNMENT_LEFT, -1, hp_font_size, text_color)
	var hp_label_width := f.get_string_size("HP", HORIZONTAL_ALIGNMENT_LEFT, -1, hp_font_size).x

	# --- полоска здоровья ---
	var bar_x := hp_label_x + hp_label_width + 16
	var bar_h := 24.0
	var bar_y := size.y / 2 - bar_h / 2
	var bar_w := size.x - bar_x - border_w - 10
	if bar_w < 10:
		bar_w = 10

	draw_rect(Rect2(Vector2(bar_x, bar_y), Vector2(bar_w, bar_h)), bar_bg_color, true)

	var ratio: float = clampf(_displayed_health / float(max(max_health, 1)), 0.0, 1.0)
	var fill_color := bar_fill_color
	if _flash_t > 0.0:
		fill_color = fill_color.lerp(Color(1, 0.2, 0.2), sin(_flash_t * 40.0) * 0.5 + 0.5)
	draw_rect(Rect2(Vector2(bar_x, bar_y), Vector2(bar_w * ratio, bar_h)), fill_color, true)

	# --- цифры "120 / 120" над полоской ---
	var hp_text := "%d / %d" % [int(round(_displayed_health)), max_health]
	var num_size := f.get_string_size(hp_text, HORIZONTAL_ALIGNMENT_LEFT, -1, numbers_font_size)
	draw_string(f, Vector2(bar_x + bar_w - num_size.x, bar_y - 8), hp_text, HORIZONTAL_ALIGNMENT_LEFT, -1, numbers_font_size, text_color)
