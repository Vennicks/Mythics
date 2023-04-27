extends Area2D

func _on_BasicCloseAttackArea_body_entered(body):
	if body.has_method("takeDamage") && body.type != "Player":
		body.takeDamage(global.first_attack_damage + global.weapon_damage)
		get_tree().get_root().get_node("MainNode").get_node("Player").healing(global.second_attack_damage / 100 * 10)
