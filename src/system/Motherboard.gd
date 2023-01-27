tool

extends Control

var ItemSlot = preload('res://src/system/ItemSlot.tscn')

var grid = [
	[0,0,0,0,0],
	[0,1,1,1,0],
	[0,1,1,1,0],
	[0,1,1,1,0],
	[0,0,0,0,0],
	[0,1,1,1,0], 
	[0,1,1,1,0], 
	[0,0,0,0,0], 
	[0,0,0,0,0],
	[0,0,0,0,0],
	[0,0,0,0,0],
]

var chips = []

func _ready():
	load_grid()

func load_grid():
	for x in range(0,grid.size()):
		for y in range(0,grid[x].size()):
			if grid[x][y] == 1:
				var slot = ItemSlot.instance()
				add_child(slot)
				slot.set_position(Vector2(y * slot.rect_size.y, x * slot.rect_size.x))


func add_chip(chip):
	chips.append(chip)

func remove_chip(chip):
	chips.erase(chip)

func get_chips():
	return chips
