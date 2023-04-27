extends Node2D

func _ready():
	pass # Replace with function body.

func _on_AreaI_mouse_entered():
	get_node("icon/TextI").show()

func _on_AreaI_mouse_exited():
	get_node("icon/TextI").hide()



func _on_AreaI2_mouse_entered():
	get_node("icon2/TextI2").show()

func _on_AreaI2_mouse_exited():
	get_node("icon2/TextI2").hide()



func _on_AreaI3_mouse_entered():
	get_node("icon3/TextI3").show()

func _on_AreaI3_mouse_exited():
	get_node("icon3/TextI3").hide()



func _on_AreaI4_mouse_entered():
	get_node("icon4/TextI4").show()

func _on_AreaI4_mouse_exited():
	get_node("icon4/TextI4").hide()
