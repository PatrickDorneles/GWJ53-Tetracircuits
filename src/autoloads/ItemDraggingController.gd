extends Node

var dragging_item: Node = null

func start_dragging_item(item: Node):
	dragging_item = item

func drop_item():
	dragging_item = null

func is_dragging(): return dragging_item != null