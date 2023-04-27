extends KinematicBody2D

onready var root = get_tree().get_root().get_node("MainNode")

onready var player = get_node("../../../Player")

onready var map_navigation = get_node("../Navigation2D")

var type = "ENEMY"

var max_hp = 400
var current_hp
var percentage_hp = 100
var dead = false
var speed = 120
var state

var test = true
var test2 = true

var paralyzed = false

var player_position
var destination
var can_attack = true
var player_in_sight
var player_seen

func _ready():
	state = "search"
	current_hp = max_hp

func _process(_delta):
	if player != null:
		match state:
			"search":
				if destination != null:
					search(_delta)
				else:
					pass
			"attack":
				if can_attack:
					attack()
				else:
					move(_delta)

func move(_delta):
	var velocity = global_position.direction_to(player.global_position) * speed
	velocity = move_and_slide(velocity)

func attack():
	can_attack = false
	speed = 1
	var fire_direction = (get_angle_to(player_position)/3.14) * 180
	get_node("TurnAxis").rotation = get_angle_to(player.get_global_position())
	var attack = preload("res://Scenes/Projectiles/Arrow.tscn")
	var attack_instance = attack.instance()
	attack_instance.attack_name = "thing"
	#attack_instance.fire_direction = fire_direction
	attack_instance.rotation = get_angle_to(player_position)
	attack_instance.position = get_node("TurnAxis/CastPoint").get_global_position()
	root.add_child(attack_instance)
	yield(get_tree().create_timer(2), "timeout")
	speed = 120
	can_attack = true


func search(_delta):
	var path_to_dest = map_navigation.get_simple_path(get_global_position(), destination)
	var start_point = get_global_position()
	var moving = speed * _delta
	for point in range (path_to_dest.size()):
		var distance_to_next_point = start_point.distance_to(path_to_dest[0])
		if moving <= distance_to_next_point:
			var move_rotation = get_angle_to(start_point.linear_interpolate(path_to_dest[0], moving/ distance_to_next_point ))
			var motion = Vector2(speed, 0).rotated(move_rotation)
			move_and_slide(motion)
			break
		moving -= distance_to_next_point
		start_point = path_to_dest[0]
		path_to_dest.remove(0)

	if path_to_dest.size() == 0:
		player_seen = 0

func _physics_process(_delta):
	if player != null:
		SightCheck()

func SightCheck():
	var space_state = get_world_2d().direct_space_state
	var sight_check = space_state.intersect_ray(global_position, player.global_position, [self], collision_mask);
	if sight_check && sight_check.collider && sight_check.collider.name == "Player":
		player_position = player.get_global_position()
		destination = map_navigation.get_closest_point(player_position)
		player_in_sight = true
		state = "attack"
	else:
		player_in_sight = false
		state = "search"

func paralyzing(time):
	speed /= 2
	paralyzed = true
	yield(get_tree().create_timer(time), 'timeout')
	speed *= 2
	paralyzed = false

func takeDamage (dmg):
	if paralyzed:
		dmg *= 2
	current_hp = current_hp - dmg
	if current_hp <= 0:
		global.loot(60, 30, 10, get_global_position())
		global.killsBopen -=1
		queue_free()
