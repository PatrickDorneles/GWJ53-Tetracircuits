extends Control

var Tetracube = preload("res://src/system/tetrachip/Tetracube.tscn")

var hovering = false
var dragging = false
var placed = false

onready var initial_rotation = $CubePlacement.get_rotation()
var initial_position = rect_global_position
var initial_drag_position = initial_position
var drag_start_position := Vector2.ZERO

export var icon: StreamTexture
export(String, MULTILINE) var description: String
export var can_rotate = true
export var cost: int = 1
export var effects: PoolStringArray = []

func _ready():
	initial_position = rect_global_position

	$Overlay/Description/DescriptionText.bbcode_text = description
	$Overlay/Description/Name.text = name
	$Overlay/Description/IconBG/Icon.texture = icon
	$Overlay/Description/CostBG/Cost.text = String(cost)
	$Overlay.visible = true
	$Cubes.set_position(Vector2.ZERO)
	$CubePlacement.visible = false
	
	create_cubes()

func _process(_delta):

	if hovering:
		set_opacity(1)
		$Cubes.z_index = 0
	
	if dragging:
		apply_rotation()
		set_opacity(0.5)
		$Cubes.z_index = 10
	
	if not hovering and not dragging:
		set_opacity(1)
		$Cubes.z_index = 0

	$Overlay/Description.visible = hovering or dragging

	if $Overlay/Description.visible:
		var new_position = get_global_mouse_position()
		new_position.x = (
			new_position.x + 20 
			if new_position.x + 20 < get_viewport_rect().size.x - $Overlay/Description.rect_size.x 
			else new_position.x - $Overlay/Description.rect_size.x - 20
		)

		new_position.y = new_position.y - $Overlay/Description.rect_size.y/2 + 8
		$Overlay/Description.set_global_position(new_position)
	
	try_to_place_chip()

func _input(event):
	if event.is_action("ui_cancel") and dragging:
		set_global_position(initial_position)
	# Mouse in viewport coordinates.
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		if event.is_pressed() and hovering:
			for cube in $Cubes.get_children(): cube.start_drag()
			initial_drag_position = $Cubes.global_position
			drag_start_position = get_viewport().get_mouse_position() - initial_drag_position
			rect_pivot_offset = drag_start_position
			$Cubes.set_position(Vector2.ZERO)
			get_tree().call_group("Motherboard", 'remove_chip', self)
			
			placed = false
			dragging = true

		elif hovering:
			try_to_place_chip()
			dragging = false

	elif event is InputEventMouseMotion:
		if dragging:
			var new_position = get_viewport().get_mouse_position() - drag_start_position
			
			new_position.x = round(new_position.x)
			new_position.y = round(new_position.y)

			set_position(new_position)

# functions

func place_chip_on_slot():
	for cube in $Cubes.get_children(): cube.drop()
	var first_cube = $Cubes.get_children()[0]
	var diff = first_cube.rect_global_position - first_cube.hover_slot.rect_global_position
	set_position(rect_position - diff)
	initial_position = rect_global_position
	initial_rotation = $CubePlacement.get_rotation()

	if first_cube.hover_slot.is_on_motherboard: 
		get_tree().call_group("Motherboard", 'add_chip', self)
	
	placed = true

func try_to_place_chip():
	if placed or dragging:
		return
	
	var all_is_on_placeable_slot := true
	for cube in $Cubes.get_children():
		all_is_on_placeable_slot = all_is_on_placeable_slot and cube.hover_slot != null and cube.hover_slot.can_place()
	
	if all_is_on_placeable_slot:
		place_chip_on_slot()
		initial_position = rect_global_position
	else:
		$Cubes.set_position(Vector2.ZERO)
		$CubePlacement.set_rotation(initial_rotation)
		clear_cubes()
		create_cubes()

		set_global_position(initial_position)
		hovering = false

		yield(get_tree().create_timer(0), 'timeout')
		try_to_place_chip()

func create_cubes():
	for placement in $CubePlacement.get_children():
		var tetracube = Tetracube.instance()
		tetracube.set_position(
			placement.rect_position.rotated(
				$CubePlacement.get_rotation()
			)
		)
		$Cubes.add_child(tetracube)
		tetracube.set_icon_texture(icon)

func clear_cubes():
	for cube in $Cubes.get_children():
		cube.queue_free()

func apply_rotation():
	if not can_rotate: return

	if Input.is_action_just_pressed("rotate_chip_r"):
		clear_cubes()
		$CubePlacement.set_rotation($CubePlacement.get_rotation() + deg2rad(90))
		create_cubes()

	if Input.is_action_just_pressed("rotate_chip_l"):
		clear_cubes()
		$CubePlacement.set_rotation($CubePlacement.get_rotation() + deg2rad(-90))
		create_cubes()

func set_opacity(value: float):
	$Cubes.modulate = Color(1,1,1,value)


# signals

func _on_Tetrachip_mouse_entered():
	hovering = true

func _on_Tetrachip_mouse_exited():
	hovering = false

func _on_Tetrachip_hide():
	hovering = false
	dragging = false
