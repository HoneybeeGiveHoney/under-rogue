class_name LevelManager
extends Node2D

# Размер одной комнаты в пикселях — должен совпадать с размером ваших Room.tscn
@export var room_pixel_size: Vector2 = Vector2(1152, 648)  # например 18x9 тайлов по 64px

# Пулы шаблонов сцен под каждый тип комнаты. Заполните в инспекторе.
@export var normal_room_scenes: Array[PackedScene] = []
@export var start_room_scenes: Array[PackedScene] = []
@export var boss_room_scenes: Array[PackedScene] = []
@export var treasure_room_scenes: Array[PackedScene] = []
@export var shop_room_scenes: Array[PackedScene] = []
@export var secret_room_scenes: Array[PackedScene] = []

@export var player_scene: PackedScene

var generator: FloorGenerator
var rooms_data: Dictionary  # Vector2i -> RoomData
var current_room_instance: Room
var current_grid_pos: Vector2i
var player: Node2D

func _ready() -> void:
	generate_new_floor()

func generate_new_floor() -> void:
	generator = FloorGenerator.new()
	generator.grid_size = 9
	generator.target_room_count = 14
	rooms_data = generator.generate()
	current_grid_pos = generator.start_pos

	_spawn_player()
	_load_room(current_grid_pos, Vector2i.ZERO)

func _spawn_player() -> void:
	if player == null and player_scene:
		player = player_scene.instantiate()
		add_child(player)

# entry_direction — с какой стороны игрок зашёл в новую комнату (чтобы поставить его у противоположной двери)
func _load_room(grid_pos: Vector2i, entry_direction: Vector2i) -> void:
	if current_room_instance:
		current_room_instance.player_entered_door.disconnect(_on_player_entered_door)
		current_room_instance.queue_free()

	var data: RoomData = rooms_data[grid_pos]
	var scene := _pick_scene_for_type(data.type)
	if scene == null:
		push_error("Нет доступных шаблонов сцен для типа комнаты: %s" % data.type)
		return

	current_room_instance = scene.instantiate()
	add_child(current_room_instance)
	current_room_instance.setup(data)
	current_room_instance.player_entered_door.connect(_on_player_entered_door)

	current_grid_pos = grid_pos
	data.visited = true

	_position_player_after_transition(entry_direction)

func _pick_scene_for_type(type: RoomData.Type) -> PackedScene:
	var pool: Array[PackedScene]
	match type:
		RoomData.Type.START: pool = start_room_scenes
		RoomData.Type.BOSS: pool = boss_room_scenes
		RoomData.Type.TREASURE: pool = treasure_room_scenes
		RoomData.Type.SHOP: pool = shop_room_scenes
		RoomData.Type.SECRET, RoomData.Type.SUPER_SECRET: pool = secret_room_scenes
		_: pool = normal_room_scenes

	if pool.is_empty():
		return null
	return pool[randi() % pool.size()]

func _on_player_entered_door(direction: Vector2i) -> void:
	var next_pos = current_grid_pos + direction
	if not rooms_data.has(next_pos):
		return
	# entry_direction для новой комнаты — противоположное направление
	_load_room(next_pos, -direction)

# Ставим игрока у двери, противоположной той, через которую он вошёл
func _position_player_after_transition(entry_direction: Vector2i) -> void:
	if player == null:
		return

	var half := room_pixel_size / 2.0
	var margin := 80.0
	var offset := Vector2.ZERO

	# entry_direction — через какую дверь НОВОЙ комнаты вошёл игрок,
	# значит его нужно поставить рядом именно с этой дверью
	if entry_direction == Vector2i.UP:
		offset = Vector2(0, -half.y + margin)
	elif entry_direction == Vector2i.DOWN:
		offset = Vector2(0, half.y - margin)
	elif entry_direction == Vector2i.LEFT:
		offset = Vector2(-half.x + margin, 0)
	elif entry_direction == Vector2i.RIGHT:
		offset = Vector2(half.x - margin, 0)
	else:
		offset = Vector2.ZERO  # старт игры — центр комнаты

	player.global_position = current_room_instance.global_position + offset
