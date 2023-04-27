extends Button

onready var root = get_tree().get_root().get_node("MainNode")
onready var room_cont = root.get_node("Room_Container")
onready var player = root.get_node("Player")

func teleport(split):
	if len(split) == 4:
		var room = "Room_"+split[1]+";"+split[2]
		if room_cont.has_node(room) and room_cont.get_node(room)\
		.has_node("Spawn_"+split[3]):
			var pos = room_cont.get_node(room).get_node("Spawn_"+split[3])\
			.get_global_position()
			player.global_position = pos

func _on_Button_pressed():
	var text = (get_parent().get_node("TextEdit").text)
	get_parent().get_node("TextEdit").text = ""
	var split = text.split(" ")
	if split[0] == "/tp":
		teleport(split)
