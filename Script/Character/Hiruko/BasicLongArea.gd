extends RigidBody2D

var speed = 1000
var life_time = 0.35
var attack_name

func _ready():
	apply_impulse(Vector2(), Vector2(speed, 0).rotated(rotation))
	self.selfDestruct()

func selfDestruct():
	yield(get_tree().create_timer(life_time), "timeout")
	queue_free()

func _on_Blood_body_entered(body):
	if body.has_method("takeDamage") && body.name != "Player":
		body.takeDamage(global.basic_attack_damage + global.weapon_damage)
		get_tree().get_root().get_node("MainNode").get_node("Player").healing(global.basic_attack_damage / 100 * 10)
		self.hide()
