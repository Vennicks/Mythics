extends RigidBody2D

var speed = 400
var life_time = 3
var attack_name


func _ready():
	apply_impulse(Vector2(), Vector2(speed, 0).rotated(rotation))
	self.selfDestruct()

func selfDestruct():
	yield(get_tree().create_timer(life_time), "timeout")
	queue_free()


func _on_Spell_body_entered(body):
	if body.has_method("takeDamage") && body.name == "Player":
		body.takeDamage(25)
	self.hide()
