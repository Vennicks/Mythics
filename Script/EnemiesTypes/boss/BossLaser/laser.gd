extends Node2D

const MAXLEN = 200000

onready var beam = $laser
onready var end = $end
onready var ray = $RayCast2D
var toogle
func _ready():
	beam.hide()
	toogle = false

func togglelaser():
	beam.show()
	toogle = true
	yield(get_tree().create_timer(1), 'timeout')
	var object = ray.get_collider()
	if object and object.name == "Pillar":
		object.queue_free()
	toogle = false
	beam.hide()

func _physics_process(_delta):
	var max_cast_to = Vector2(1,0) * MAXLEN
	ray.cast_to = max_cast_to
	if ray.is_colliding() and toogle == true:
		end.global_position = ray.get_collision_point()
		var object = ray.get_collider()
		if object.name == "Player":
			print("OMOK")
	else:
		end.global_position = ray.cast_to
	beam.region_rect.end.x = end.position.length()
