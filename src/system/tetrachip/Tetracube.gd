class_name Tetracube
extends Control

var hover_slot = null
var placed_slot = null

onready var icon: TextureRect = get_node("Icon")

func set_icon_texture(texture: StreamTexture):
	icon.texture = texture

func start_drag():
	if placed_slot != null:
		placed_slot.release_cube()
		placed_slot = null

func drop():
	if hover_slot != null:
		hover_slot.place_cube(self)
		placed_slot = hover_slot

