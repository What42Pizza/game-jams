extends Area2D

const HEALTH: int = 500
const MIN_SPEED: int = 30
const MAX_SPEED: int = 80
const ANIMATION_TIME: float = 1.5

@onready var sprite = $Sprite2D

var game_manager: Node
var wave_manager: Node
var path_follow: PathFollow2D

var path_num: int
var speed: float

var health: float = HEALTH

var sprite_time: float


func setup(new_game_manager: Node, new_wave_manager: Node, new_path_follow: PathFollow2D, new_path_num: int):
	game_manager = new_game_manager
	wave_manager = new_wave_manager
	path_follow = new_path_follow
	path_num = new_path_num
	speed = lerp(MIN_SPEED, MAX_SPEED, randf())
	pass


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	path_follow.progress += speed * delta
	if path_follow.progress_ratio > 0.9:
		wave_manager.despawn_enemy(self, false)
		game_manager.decrease_health()
	sprite_time = fmod(sprite_time + delta, ANIMATION_TIME);
	sprite.frame = int(sprite_time / ANIMATION_TIME * sprite.hframes)


func contains_point(pos: Vector2):
	return global_position.distance_to(pos) < 35

func get_path_num() -> int:
	return path_num

func take_damage(amount: float) -> float:
	var damage_taken = min(amount, health)
	health -= amount
	if health <= 0.0:
		wave_manager.despawn_enemy(self, true)
	return damage_taken
