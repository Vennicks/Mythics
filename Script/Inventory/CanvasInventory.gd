extends CanvasLayer

var invScene = preload("res://Scenes/Inventory/Inventory.tscn")

func _ready():
	var scene = invScene.instance()
	add_child(scene)
	scene.hide()
