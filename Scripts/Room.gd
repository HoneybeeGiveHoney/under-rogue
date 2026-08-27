class_name Room
extends Node2D

signal room_cleared
signal player_entered_door(direction: Vector2i)

@export var room_type: RoomData.Type = RoomData.Type.NORMAL

# Ссылки на узлы-двери в сцене — назовите их именно так в каждой Room.tscn,
# либо оставьте пустыми, если дверь с этой стороны не нужна в этом шаблоне
@onready var door_up: Node2D = $Doors/DoorUp if has_node("Doors/DoorUp") else null
@onready var door_down: Node2D = $Doors/DoorDown if has_node("Doors/DoorDown") else null
@onready var door_left: Node2D = $Doors/DoorLeft if has_node("Doors/DoorLeft") else null
@onready var door_right: Node2D = $Doors/DoorRight if has_node("Doors/DoorRight") else null

@onready var enemies_container: Node = $Enemies if has_node("Enemies") else null

var room_data: RoomData
var _alive_enemies: int = 0
var _is_cleared: bool = false

func setup(data: RoomData) -> void:
	room_data = data
	room_type = data.type
	_configure_doors()
	_count_enemies()

	# в стартовой/сокровищнице/магазине двери сразу открыты
	if room_type in [RoomData.Type.START, RoomData.Type.TREASURE, RoomData.Type.SHOP]:
		_set_doors_open(true)
	elif _alive_enemies == 0:
		_set_doors_open(true)
	else:
		_set_doors_open(false)

# Включаем/выключаем узлы дверей по данным из RoomData (какие стороны вообще существуют)
func _configure_doors() -> void:
	if door_up: door_up.visible = room_data.door_up
	if door_down: door_down.visible = room_data.door_down
	if door_left: door_left.visible = room_data.door_left
	if door_right: door_right.visible = room_data.door_right

	for d in [door_up, door_down, door_left, door_right]:
		if d and d.has_signal("body_entered_door"):
			d.body_entered_door.connect(_on_door_entered)

func _count_enemies() -> void:
	_alive_enemies = 0
	if enemies_container == null:
		return
	for enemy in enemies_container.get_children():
		_alive_enemies += 1
		if enemy.has_signal("died"):
			enemy.died.connect(_on_enemy_died)

func _on_enemy_died() -> void:
	_alive_enemies -= 1
	if _alive_enemies <= 0 and not _is_cleared:
		_is_cleared = true
		_set_doors_open(true)
		room_cleared.emit()

func _set_doors_open(open: bool) -> void:
	for d in [door_up, door_down, door_left, door_right]:
		if d and d.has_method("set_open"):
			d.set_open(open)

func _on_door_entered(direction: Vector2i) -> void:
	player_entered_door.emit(direction)
