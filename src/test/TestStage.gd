extends Node2D

var maximize = OS.is_window_maximized()
var set_max_size = OS.set_window_maximized(true)

func _process(delta):
    if maximize == false:
        set_max_size = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
