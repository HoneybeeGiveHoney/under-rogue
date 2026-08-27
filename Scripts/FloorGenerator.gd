class_name FloorGenerator
extends RefCounted

const DIRECTIONS: Array[Vector2i] = [Vector2i.UP, Vector2i.DOWN, Vector2i.LEFT, Vector2i.RIGHT]

var grid_size: int = 9          # размер сетки (grid_size x grid_size)
var target_room_count: int = 14  # сколько обычных комнат хотим получить
var max_neighbors: int = 2       # ограничение "кучности" — макс. соседей у обычной комнаты

var rooms: Dictionary = {}       # Vector2i -> RoomData
var start_pos: Vector2i

func generate() -> Dictionary:
	rooms.clear()
	start_pos = Vector2i(grid_size / 2, grid_size / 2)

	_random_walk()
	_compute_distances()
	_place_boss_room()
	_place_special_rooms()
	_compute_doors()

	return rooms

# --- Шаг 1: случайное блуждание для формирования "скелета" этажа ---
func _random_walk() -> void:
	var start_room = RoomData.new(start_pos, RoomData.Type.START)
	rooms[start_pos] = start_room

	var frontier: Array[Vector2i] = [start_pos]
	var attempts := 0
	var max_attempts := target_room_count * 40  # предохранитель от бесконечного цикла

	while rooms.size() - 1 < target_room_count and attempts < max_attempts:
		attempts += 1

		var current: Vector2i = frontier[randi() % frontier.size()]
		var dir: Vector2i = DIRECTIONS[randi() % DIRECTIONS.size()]
		var next_pos: Vector2i = current + dir

		if not _in_bounds(next_pos):
			continue
		if rooms.has(next_pos):
			continue
		if _count_existing_neighbors(next_pos) > 1:
			# избегаем ситуаций, когда новая комната прилипает сразу к нескольким —
			# это создавало бы "толстые" скопления и лишние двери
			continue
		if _count_existing_neighbors(current) >= max_neighbors:
			# у текущей комнаты и так много соседей — не растим отсюда дальше
			frontier.erase(current)
			continue

		# небольшой шанс "не расти" в эту итерацию, чтобы путь был не абсолютно прямым
		if randf() < 0.15:
			continue

		var new_room := RoomData.new(next_pos, RoomData.Type.NORMAL)
		rooms[next_pos] = new_room
		frontier.append(next_pos)

# --- Шаг 2: BFS от старта, чтобы знать расстояние каждой комнаты от старта ---
func _compute_distances() -> void:
	var queue: Array[Vector2i] = [start_pos]
	var visited := {start_pos: true}
	rooms[start_pos].distance_from_start = 0

	while not queue.is_empty():
		var current: Vector2i = queue.pop_front()
		var current_dist: int = rooms[current].distance_from_start

		for dir in DIRECTIONS:
			var neighbor = current + dir
			if rooms.has(neighbor) and not visited.has(neighbor):
				visited[neighbor] = true
				rooms[neighbor].distance_from_start = current_dist + 1
				queue.append(neighbor)

# --- Шаг 3: комната босса — самая дальняя от старта, желательно тупиковая (1 сосед) ---
func _place_boss_room() -> void:
	var best_pos: Vector2i = start_pos
	var best_score := -1

	for pos in rooms.keys():
		var room: RoomData = rooms[pos]
		if room.type != RoomData.Type.NORMAL:
			continue
		var is_dead_end = _count_existing_neighbors(pos) == 1
		var score = room.distance_from_start + (10 if is_dead_end else 0)
		if score > best_score:
			best_score = score
			best_pos = pos

	if rooms.has(best_pos):
		rooms[best_pos].type = RoomData.Type.BOSS

# --- Шаг 4: спец-комнаты (сокровище, магазин, секретная) в тупиках ---
func _place_special_rooms() -> void:
	var dead_ends: Array[Vector2i] = []
	for pos in rooms.keys():
		var room: RoomData = rooms[pos]
		if room.type == RoomData.Type.NORMAL and _count_existing_neighbors(pos) == 1:
			dead_ends.append(pos)

	dead_ends.shuffle()

	var special_types = [RoomData.Type.TREASURE, RoomData.Type.SHOP]
	for t in special_types:
		if dead_ends.is_empty():
			break
		var pos = dead_ends.pop_back()
		rooms[pos].type = t

	_place_secret_room()

# Секретная комната: ищем свободную клетку, граничащую с максимальным
# количеством уже существующих комнат (как в оригинале — открывается бомбой)
func _place_secret_room() -> void:
	var best_pos := Vector2i.ZERO
	var best_count := 0
	var found := false

	for x in range(grid_size):
		for y in range(grid_size):
			var pos = Vector2i(x, y)
			if rooms.has(pos):
				continue
			var neighbor_count = _count_existing_neighbors(pos)
			if neighbor_count >= 2 and neighbor_count > best_count:
				best_count = neighbor_count
				best_pos = pos
				found = true

	if found:
		rooms[best_pos] = RoomData.new(best_pos, RoomData.Type.SECRET)

# --- Шаг 5: проставляем флаги дверей на основе того, какие соседи существуют ---
func _compute_doors() -> void:
	for pos in rooms.keys():
		var room: RoomData = rooms[pos]
		room.door_up = rooms.has(pos + Vector2i.UP)
		room.door_down = rooms.has(pos + Vector2i.DOWN)
		room.door_left = rooms.has(pos + Vector2i.LEFT)
		room.door_right = rooms.has(pos + Vector2i.RIGHT)

# --- Вспомогательные функции ---
func _in_bounds(pos: Vector2i) -> bool:
	return pos.x >= 0 and pos.x < grid_size and pos.y >= 0 and pos.y < grid_size

func _count_existing_neighbors(pos: Vector2i) -> int:
	var count := 0
	for dir in DIRECTIONS:
		if rooms.has(pos + dir):
			count += 1
	return count
