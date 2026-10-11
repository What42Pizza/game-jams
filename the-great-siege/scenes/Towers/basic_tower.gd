extends Tower

var bullet_scene = preload("res://scenes/Bullets/basic-arrow.tscn")

@onready var level = $/root/Level
@onready var wave_manager: Node
@onready var turret = $Turret
@onready var range_indicator = $RangeIndicator
@onready var shoot_sound = $ShootSound
var enemies: Array

const RANGE = 230
const ROTATE_SPEED = 3.0

@onready var cooldown_time = 1.5 + 0.1 * (randf() * 2.0 - 1.0)
@onready var shoot_cooldown = cooldown_time

var prev_enemy_pos = Vector2.ZERO
var target_rotation = PI
var curr_rotation = PI



func setup(placement: Node, new_wave_manager: Node):
	placement.add_child(self)
	wave_manager = new_wave_manager
	enemies = wave_manager.get_enemies()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var range_ind_size = RANGE / 255.0 * 2.0
	range_indicator.scale = Vector2(range_ind_size, range_ind_size)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	# update range indicator
	var mouse_pos = get_viewport().get_mouse_position()
	range_indicator.visible = turret.global_position.distance_to(mouse_pos) < 20
	
	var curr_target_enemy = get_best_target()
	
	# rotate:
	if curr_target_enemy:
		var new_enemy_pos = curr_target_enemy.global_position
		var look_ahead_amount = (turret.global_position - new_enemy_pos).length() * 0.0015 + 0.15
		target_rotation = get_angle_to(lerp(prev_enemy_pos, new_enemy_pos, look_ahead_amount / delta))
		prev_enemy_pos = new_enemy_pos
	else:
		shoot_cooldown = cooldown_time
	
	while curr_rotation > target_rotation + PI:
		curr_rotation -= PI*2
	while curr_rotation < target_rotation - PI:
		curr_rotation += PI*2
	curr_rotation = lerp(curr_rotation, target_rotation, 1.0 - exp(-ROTATE_SPEED * delta))
	turret.rotation = curr_rotation + PI/2
	
	# shoot:
	shoot_cooldown -= delta
	if curr_target_enemy && shoot_cooldown < 0.0:
		shoot()
	
	# update animation
	turret.frame = int(max(cooldown_time - shoot_cooldown, 0.0) / cooldown_time * turret.hframes)


func get_best_target() -> Node:
	for enemy in enemies:
		if turret.global_position.distance_to(enemy.global_position) < RANGE:
			return enemy
	return null


func shoot():
	var bullet = bullet_scene.instantiate()
	var direction = Vector2(cos(curr_rotation), sin(curr_rotation))
	bullet.setup(wave_manager, turret.global_position + direction * 30, 1200, direction)
	level.add_child(bullet)
	shoot_cooldown = cooldown_time
	shoot_sound.play()
