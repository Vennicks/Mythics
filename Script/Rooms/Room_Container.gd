extends Node

func _ready():
	for N in self.get_children():
		N.hide()
	self.get_node("Room_0;0").show()
