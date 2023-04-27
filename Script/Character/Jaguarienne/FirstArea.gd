extends Node2D

func _on_FirstAttackArea_body_entered(body):
	if body.has_method("takeDamage") && body.type != "Player":
		body.takeDamage(global.first_attack_damage + global.weapon_damage)
		if body.paralyzed:
			body.takeDamage(global.first_attack_damage + global.weapon_damage)
	var para = rand_range(0, 9)
	if body.has_method("paralyzing") &&  para <= 5 && para > 4:
		body.paralyzing(5)
