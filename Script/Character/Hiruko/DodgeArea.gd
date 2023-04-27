extends Node2D

func _on_DodgeArea_body_entered(body):
	if body.has_method("takeDamage") && body.type != "Player":
		body.takeDamage(global.dodge_damage + global.weapon_damage)
	get_tree().get_root().get_node("MainNode").get_node("Player").healing(global.dodge_damage / 100 * 10)
