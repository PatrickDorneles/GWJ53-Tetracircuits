class_name MotherboardSlot
extends TextureRect

const MIN_OVERLAP_TO_SNAP = 8

var inner_cubes = []
var cube_in: Tetracube = null
var placed_cube: Tetracube = null
onready var is_on_motherboard = get_parent().name == 'Motherboard'

func _process(delta: float):
	if placed_cube != null or inner_cubes.size() == 0:
		modulate = Color.white
		return
	
	var cube_overlapping: Tetracube = null

	for cube in inner_cubes:
		var cube_area = cube.get_node('Area')
		var cube_area_position = cube_area.global_position
		var slot_position = $Area.global_position
		var overlap = cube_area_position.distance_to(slot_position)

		if overlap < MIN_OVERLAP_TO_SNAP:
			cube_overlapping = cube
			cube.hover_slot = self
		elif cube.hover_slot == self:
			cube.hover_slot = null
	
	cube_in = cube_overlapping

	if cube_in != null:
		modulate = Color.green
	else:
		modulate = Color.white

func can_place(): 
	return placed_cube == null

func place_cube(cube: Tetracube):
	if placed_cube == null:
		placed_cube = cube

func release_cube():
	placed_cube = null

func _on_Area_area_entered(area:Area2D):
	if area.get_parent() is Tetracube:
		var cube = area.get_parent()
		inner_cubes.append(cube)


func _on_Area_area_exited(area:Area2D):
	if area.get_parent() is Tetracube:
		area.get_parent().hover_slot = null
		inner_cubes.erase(area.get_parent())


func _on_Area_body_entered(body:Node):
	if body.get_parent() is Tetracube:
		var cube = body.get_parent()
		inner_cubes.append(cube)


func _on_Area_body_exited(body:Node):
	if body.get_parent() is Tetracube:
		var cube = body.get_parent()
		cube.hover_slot = null
		inner_cubes.erase(cube)
