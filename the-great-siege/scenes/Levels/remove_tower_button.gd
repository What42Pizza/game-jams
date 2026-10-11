extends Button


@onready var tower_placement_manager = $"/root/Level/TowerPlacementManager"
@onready var info_panel = $InfoPanel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_button_down() -> void:
	tower_placement_manager.set_selected_item("Remove")


func _on_mouse_entered() -> void:
	info_panel.visible = true
func _on_mouse_exited() -> void:
	info_panel.visible = false
