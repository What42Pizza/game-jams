extends Node2D

const basic_enemy_scene = preload("res://scenes/Enemies/basic-enemy.tscn")
const tank_enemy_scene = preload("res://scenes/Enemies/tank-enemy.tscn")
const speed_enemy_scene = preload("res://scenes/Enemies/speed-enemy.tscn")

@onready var game_manager = $/root/Level/GameManager
@onready var main_path_1 = $"../World/MainPath1"
@onready var main_path_2 = $"../World/MainPath2"
@onready var kill_sound = $KillEnemySound

var spawn_datas = {
	"basic-enemy" = {
		"time_to_next_spawn" = 5.0,
		"time_between_spawns" = 2.5,
		"scene" = basic_enemy_scene,
	},
	"speed_enemy" = {
		"time_to_next_spawn" = 55.0,
		"time_between_spawns" = 4.0,
		"scene" = speed_enemy_scene,
	},
	"tank_enemy" = {
		"time_to_next_spawn" = 105.0,
		"time_between_spawns" = 7.0,
		"scene" = tank_enemy_scene,
	},
}

var enemies: Array = []
var enemies_defeated: int = 0


func _ready() -> void:
	pass # Replace with function body.
func _process(delta: float) -> void:
	pass


func _physics_process(delta):
	
	# spawn enemies
	for spawn_data_name in spawn_datas:
		var spawn_data = spawn_datas[spawn_data_name]
		spawn_data.time_to_next_spawn -= delta
		if spawn_data.time_to_next_spawn <= 0.0:
			spawn_enemy(spawn_data.scene, 1)
			spawn_enemy(spawn_data.scene, 2)
			spawn_data.time_to_next_spawn += spawn_data.time_between_spawns
			spawn_data.time_between_spawns *= 0.98
			spawn_data.time_between_spawns += 0.004
	
	# sort enemies from oldest to newest
	for i in enemies.size() - 1:
		if enemies[i].get_parent().progress_ratio < enemies[i + 1].get_parent().progress_ratio:
			var temp = enemies[i]
			enemies[i] = enemies[i + 1]
			enemies[i + 1] = temp


func spawn_enemy(scene: Resource, path: int):
	var path_follow = PathFollow2D.new()
	var enemy = scene.instantiate()
	enemy.setup(game_manager, self, path_follow, path)
	path_follow.add_child(enemy)
	if path == 1:
		main_path_1.add_child(path_follow)
	if path == 2:
		main_path_2.add_child(path_follow)
	enemies.push_back(enemy)

func despawn_enemy(enemy: Node, was_killed: bool):
	enemy.get_parent().queue_free()
	enemies.erase(enemy)
	if was_killed:
		enemies_defeated += 1
		kill_sound.play()


func get_enemies() -> Array:
	return enemies
func get_enemies_defeated() -> int:
	return enemies_defeated
