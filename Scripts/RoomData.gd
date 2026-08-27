class_name RoomData
extends RefCounted

enum Type { NONE, START, NORMAL, BOSS, TREASURE, SHOP, SECRET, SUPER_SECRET }

var grid_pos: Vector2i
var type: Type = Type.NORMAL
var distance_from_start: int = 0

# Какие стороны имеют дверь наружу (в соседнюю существующую комнату)
var door_up: bool = false
var door_down: bool = false
var door_left: bool = false
var door_right: bool = false

# Была ли комната уже посещена игроком (для мини-карты / логики "очистить комнату")
var visited: bool = false
var cleared: bool = false

func _init(pos: Vector2i, room_type: Type = Type.NORMAL):
	grid_pos = pos
	type = room_type

func get_neighbor_positions() -> Array[Vector2i]:
	return [
		grid_pos + Vector2i.UP,
		grid_pos + Vector2i.DOWN,
		grid_pos + Vector2i.LEFT,
		grid_pos + Vector2i.RIGHT,
	]
