extends Node2D


const RESOURCES_PER_SECOND = 0.9

@onready var wave_manager = $"../WaveManager"

@onready var health_label = $/root/Level/Ui/Control/HealthLabel
@onready var money_label = $/root/Level/Ui/Control/MoneyLabel
@onready var game_over_screen = $/root/Level/Ui/Control/GameOverScreen
@onready var background_music = $BackgroundMusic

@export var health: int = 100
@export var resources: float = 20


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if health > 0.0:
		resources += RESOURCES_PER_SECOND * delta
	health_label.text = "Health: " + str(health)
	money_label.text = "Resources: " + str(int(resources))
	pass


func try_buy(cost: int) -> bool:
	if resources >= cost:
		resources -= cost
		return true
	else:
		return false

func decrease_health():
	health -= 1
	if health == 0:
		game_over_screen.visible = true
		game_over_screen.find_child("GameOverLabel").text = "Game Over!\nEnemies Defeated: " + str(wave_manager.get_enemies_defeated())
	health = max(health, 0)
