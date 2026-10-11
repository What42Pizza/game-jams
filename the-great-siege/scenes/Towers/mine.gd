extends Tower

@onready var game_manager = $/root/Level/GameManager

const RESOURCES_PER_SECOND = 0.25


func setup(placement: Node, _new_wave_manager: Node):
	placement.add_child(self)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	game_manager.resources += RESOURCES_PER_SECOND * delta
