extends CanvasLayer

export var backpack_open = false

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		backpack_open = false
		update_visibility()

func _ready():
	update_visibility()

func _on_CloseButton_pressed():
	backpack_open = false
	update_visibility()

func _on_OpenButton_pressed():
	backpack_open = true
	update_visibility()

func update_visibility():
	$Backpack.visible = backpack_open
	$OpenButton.visible = not backpack_open
