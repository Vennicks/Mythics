extends Area2D

var test = load("res://Script/Room.gd").new()
var locked = false
func lockDoor():
	self.get_node("Polygon2D").color = "512e90"
	locked = true

func openDoor():
	locked = false
	self.get_node("Polygon2D").color = "228f19"

func _on_Area2D_body_entered(body):
	if !locked and body.name == "Player":
		self.get_parent().get_parent().hide();
		var splitedPos = get_parent().get_parent().name.split("_")[1].split(";")
		var splitedDir = get_parent().name.split("_")
		var dir = splitedDir[1]
		var pos = Vector2(int(splitedPos[0]),int(splitedPos[1]))
		var root = get_tree().get_root().get_node("MainNode")
		var room_cont = root.get_node("Room_Container")

		if dir == "N":
			root.get_node("Player").get_node("Camera2D2").smoothing_enabled = false;
			pos.y = pos.y - 1
			global.curr_y -= 1
			var room = "Room_" + String(pos.x) + ";" + String(pos.y)
			var tp = room_cont.get_node(room).get_node("Spawn_"+dir).get_global_position()
			root.get_node("Player").set_global_position(tp)
			room_cont.get_node(room).show();
			room_cont.get_node(room).spawn();
			yield(get_tree().create_timer(0.5), 'timeout')
			root.get_node("Player").get_node("Camera2D2").smoothing_enabled = true;
			
		if dir == "S":
			root.get_node("Player").get_node("Camera2D2").smoothing_enabled = false;
			pos.y = pos.y + 1
			global.curr_y += 1
			var room = "Room_" + String(pos.x) + ";" + String(pos.y)
			var tp = room_cont.get_node(room).get_node("Spawn_"+dir).get_global_position()
			root.get_node("Player").set_global_position(tp)
			room_cont.get_node(room).show();
			room_cont.get_node(room).spawn();
			yield(get_tree().create_timer(0.5), 'timeout')
			root.get_node("Player").get_node("Camera2D2").smoothing_enabled = true;
			
		if dir == "E":
			root.get_node("Player").get_node("Camera2D2").smoothing_enabled = false;
			pos.x = pos.x + 1
			global.curr_x += 1
			var room = "Room_" + String(pos.x) + ";" + String(pos.y)
			var tp = room_cont.get_node(room).get_node("Spawn_"+dir).get_global_position()
			root.get_node("Player").set_global_position(tp)
			room_cont.get_node(room).show();
			room_cont.get_node(room).spawn();
			yield(get_tree().create_timer(0.5), 'timeout')
			root.get_node("Player").get_node("Camera2D2").smoothing_enabled = true;
		
		if dir == "W":
			root.get_node("Player").get_node("Camera2D2").smoothing_enabled = false;
			pos.x = pos.x - 1
			global.curr_x -= 1
			var room = "Room_" + String(pos.x) + ";" + String(pos.y)
			var tp = room_cont.get_node(room).get_node("Spawn_"+dir).get_global_position()
			root.get_node("Player").set_global_position(tp)
			room_cont.get_node(room).show();
			room_cont.get_node(room).spawn();
			yield(get_tree().create_timer(0.5), 'timeout')
			root.get_node("Player").get_node("Camera2D2").smoothing_enabled = true;
