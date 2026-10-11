extends Node2D

var damage: float = 250

var wave_manager: Node
var enemies: Array

var speed: float
var direction: Vector2


func setup(new_wave_manager: Node, new_position: Vector2, new_speed: float, new_direction: Vector2):
	wave_manager = new_wave_manager
	enemies = wave_manager.get_enemies()
	position = new_position
	speed = new_speed
	direction = new_direction.normalized()
	look_at(position + direction)
	rotate(PI/2)
	pass


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for enemy in enemies:
		if enemy.contains_point(global_position):
			var damage_dealt = enemy.take_damage(damage)
			damage -= damage_dealt
			if damage <= 0.0:
				queue_free()
			return
	position += direction * speed * delta
	if global_position.length() > 2000:
		queue_free()
