extends CanvasLayer

export var open = false

func _process(delta):
	if Input.is_action_just_pressed("toggle_inventory"):
		open = not open
		update_visibility()

	if Input.is_action_just_pressed("ui_cancel"):
		open = false
		update_visibility()

func _ready():
	update_visibility()

func _on_CloseButton_pressed():
	open = false
	update_visibility()

func _on_OpenButton_pressed():
	open = true
	update_visibility()

func update_visibility():
	$System.visible = open
	$OpenButton.visible = not open
