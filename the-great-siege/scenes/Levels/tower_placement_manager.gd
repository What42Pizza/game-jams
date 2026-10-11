extends Node2D

var placement_indicator_scene = preload("res://scenes/Misc/placement_indicator.tscn")
var basic_tower_scene = preload("res://scenes/Towers/basic_tower.tscn")
var wizzard_scene = preload("res://scenes/Towers/wizzard.tscn")
var mine_scene = preload("res://scenes/Towers/mine.tscn")

@onready var placement_slots = $"../World/PlacementSlots".get_children()
@onready var wave_manager = $"../WaveManager"
@onready var game_manager = $"../GameManager"
@onready var ui_control = $/root/Level/Ui/Control

var selected_item = null


@onready var item_datas = {
	"Remove" = {
		"selection_indicator" = ui_control.find_child("RemoveTowerButton").find_child("SelectionIndicator"),
	},
	"BasicTower" = {
		"scene" = basic_tower_scene,
		"cost" = 10,
		"selection_indicator" = ui_control.find_child("BasicTowerButton").find_child("SelectionIndicator"),
	},
	"Wizzard" = {
		"scene" = wizzard_scene,
		"cost" = 20,
		"selection_indicator" = ui_control.find_child("WizzardButton").find_child("SelectionIndicator"),
	},
	"Mine" = {
		"scene" = mine_scene,
		"cost" = 15,
		"selection_indicator" = ui_control.find_child("MineButton").find_child("SelectionIndicator"),
	},
}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for placement in placement_slots:
		var placement_indicator = placement_indicator_scene.instantiate()
		placement_indicator.setup(placement)


func _input(event):
	if event is InputEventMouseButton && event.pressed:
		var closest_placement = placement_slots[0]
		var closest_placement_dist = INF
		for placement in placement_slots:
			var dist = event.position.distance_to(placement.global_position)
			if dist < closest_placement_dist:
				closest_placement = placement
				closest_placement_dist = dist
		if selected_item && closest_placement_dist < 17 && game_manager.health > 0.0:
			use_selected_item(closest_placement)
	if event is InputEventKey:
		if event.pressed && event.keycode == KEY_1:
			set_selected_item("Remove")
		if event.pressed && event.keycode == KEY_2:
			set_selected_item("BasicTower")
		if event.pressed && event.keycode == KEY_3:
			set_selected_item("Wizzard")
		if event.pressed && event.keycode == KEY_4:
			set_selected_item("Mine")

func use_selected_item(chosen_placement: Node):
	if selected_item != "Remove" && chosen_placement.get_children().size() == 1:
		var item_data = item_datas[selected_item]
		if item_data and game_manager.try_buy(item_data.cost):
			var new_tower = item_data.scene.instantiate()
			new_tower.setup(chosen_placement, wave_manager)
	elif selected_item == "Remove" && chosen_placement.get_children().size() > 1:
		for child in chosen_placement.get_children():
			if child.name != "PlacementIndicator":
				child.queue_free()


func set_selected_item(new_selected_item):
	if selected_item != new_selected_item:
		selected_item = new_selected_item
		for item_name in item_datas:
			var item_data = item_datas[item_name]
			item_data.selection_indicator.visible = false
		item_datas[selected_item]["selection_indicator"].visible = true
	else:
		item_datas[selected_item]["selection_indicator"].visible = false
		selected_item = null
