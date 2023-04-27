extends StaticBody2D

var max_hp = 1000
var current_hp = 1000
var type = "ENEMY"
func takeDamage (dmg):
	current_hp = current_hp - dmg
	print(current_hp)
	if current_hp <= 0:
		global.loot(50, 30, 20, get_global_position())
		queue_free()

func activatelaser():
	get_node("laser").togglelaser()

func _process(_delta):
	var playerpos = get_tree().get_root().get_node("MainNode").get_node("Player").get_global_position()
	var selfpos = get_position()
	look_at(playerpos-selfpos)
	if rotation_degrees < 0:
		rotation_degrees += 360
	if rotation_degrees > 360:
		rotation_degrees -= 360

func _on_Timer_timeout():
	activatelaser()
	
