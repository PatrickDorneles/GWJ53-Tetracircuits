extends DraggableControl

func _process(_delta):
	if hovering:
		var color = Color("#46878f")
		$Image.material.set_shader_param("color", color)
		$Image.material.set_shader_param("width", 1)
	
	if dragging:
		apply_rotation()
		var color = Color("#e2f3e4")
		$Image.material.set_shader_param("color", color)
		$Image.material.set_shader_param("width", 1)
	
	if not hovering and not dragging:
		$Image.material.set_shader_param("width", 0)


func apply_rotation():

	if Input.is_action_just_pressed("rotate_chip_r"):
		set_rotation(get_rotation() + deg2rad(90))

	if Input.is_action_just_pressed("rotate_chip_l"):
		set_rotation(get_rotation() + deg2rad(-90))


