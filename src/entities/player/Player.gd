class_name Player
extends KinematicBody2D

onready var animation_tree_playback: AnimationNodeStateMachinePlayback = $AnimationTree.get("parameters/playback")

export var speed = 200

var facing_direction := Vector2.DOWN
var motion := Vector2.ZERO

func _physics_process(delta):
	apply_movement()

	move_and_slide(motion)

	position.x = round(position.x)
	position.y = round(position.y)

func apply_movement():
	var direction := Vector2.ZERO
	direction.x = Input.get_axis("move_left", "move_right")
	direction.y= Input.get_axis("move_up", "move_down")

	direction = direction.normalized()

	motion = direction * speed

	if motion != Vector2.ZERO:
		$AnimationTree.set("parameters/Walk/blend_position", facing_direction)
		animation_tree_playback.travel("Walk")
		facing_direction = direction
	else:
		$AnimationTree.set("parameters/Idle/blend_position", facing_direction)
		animation_tree_playback.travel("Idle")

func _ready():
	pass # Replace with function body.

