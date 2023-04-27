extends Node2D

var rng = RandomNumberGenerator.new()

func _spawn_badGUYS(coords):
	var enemies = preload("res://Scenes/EnemiesType/Crawler.tscn")
	rng.randomize()
	var my_random_number = rng.randf_range(0.0, 1.0)
	print(my_random_number)
	if my_random_number < 0.5:
		enemies = preload("res://Scenes/EnemiesType/Crawler.tscn")
	else:
		enemies = preload("res://Scenes/EnemiesType/Thrower.tscn")
	var bad = enemies.instance()
	bad.global_position = coords
	yield(get_tree().create_timer(2), 'timeout')
	self.add_child(bad)
	

func openDoors():
	for node in get_children():
		var split = node.name.split("_")
		if split[0] == "Door":
			node.get_node("Area2D").openDoor()
			
func closeDoors():
	for node in get_children():
		var split = node.name.split("_")
		if split[0] == "Door":
			node.get_node("Area2D").lockDoor()

func spawn():
	if self.has_node("BossLaser"):
		get_node("BossLaser").startTime()
	if self.has_node("Spawner"):
		if get_node("Spawner").get_children().size() != 0:
			for node in get_children():
				var split = node.name.split("_")
				if split[0] == "Door":
					node.get_node("Area2D").lockDoor()
		for node in self.get_node("Spawner").get_children():
			_spawn_badGUYS(node.position)
			global.killsBopen += 1
			node.queue_free()
		
func _process(delta):
	if global.killsBopen == 0:
		openDoors()
	else:
		closeDoors()
			
