extends Node2D

func _on_DodgeArea_body_entered(body):
	if body.has_method("takeDamage") && body.type != "Player":
		body.takeDamage(global.dodge_damage + global.weapon_damage)
	var para = rand_range(0, 9)
	if body.has_method("paralyzing") &&  para <= 4 && para >= 0:
		body.paralyzing(5)
