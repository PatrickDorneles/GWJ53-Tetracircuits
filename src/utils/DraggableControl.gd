class_name DraggableControl
extends Control

var hovering = false
var dragging = false
var initial_position = rect_global_position
var drag_start_position := Vector2.ZERO

func _input(event):
	# Mouse in viewport coordinates.
	if event is InputEventMouseButton:
		if event.is_pressed() and hovering:
			initial_position = rect_global_position
			drag_start_position = (get_viewport().get_mouse_position() - initial_position).abs()
			var rotation = abs(int(round(rad2deg(get_rotation()))))
			print(rotation)
			if rotation != 0 and rotation % 180 != 0: 
				var reversion_util = drag_start_position.x
				drag_start_position.x = drag_start_position.y
				drag_start_position.y = reversion_util
			rect_pivot_offset = drag_start_position
			dragging = true
		else:
			dragging = false
	elif event is InputEventMouseMotion:
		if dragging:
			var new_position = get_viewport().get_mouse_position() - drag_start_position
			
			new_position.x = round(new_position.x)
			new_position.y = round(new_position.y)

			set_position(new_position)

func _on_DraggableControl_mouse_entered():
	hovering = true

func _on_DraggableControl_mouse_exited():
	hovering = false
