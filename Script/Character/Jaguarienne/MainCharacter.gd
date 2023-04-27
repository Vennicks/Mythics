extends KinematicBody2D

#preloading needed scenes
var invScene = preload("res://Scenes/Inventory/CanvasInventory.tscn")

onready var root = get_tree().get_root().get_node("MainNode")
#variable needed to attack
var timer_first_attack = null
var timer_second_attack = null
var timer_dodge_attack = null
var timer_basic_attack = null

var canMove = true

var current_hp

onready var speed = global.speed
var speed_added = 0
var vulnerable = false

var targetToDash

var canBasicAttack = true
var can1Attack = true
var can2Attack = true
var canDodge = true
var rotate
var type = "Player"

#variable needed to display the inventory
var inv_disp

func healing(life):
	current_hp += life
	if current_hp >= global.HP:
		current_hp = global.HP
	root.get_node("GUI/hp").setHP(String(current_hp))

func takeDamage(dmg):
	if vulnerable == true:
		return
	var damage = (float(dmg) / 100.0) * global.pct_dam
	current_hp = current_hp - damage
	root.get_node("GUI/hp").setHP(String(current_hp))
	if current_hp <= 0:
		get_tree().change_scene("res://Scenes/Menu/Menu.tscn")
		queue_free()

#function called when timer timeout to delete the attackedScene
func end_first_attack_cd():
	can1Attack = true

func end_second_attack_cd():
	can2Attack = true

func end_dodge_attack_cd():
	canDodge = true

func end_basic_attack_cd():
	canBasicAttack = true

func delete_first_attack_area():
	get_node("FirstAttackArea").free()

func delete_second_attack_area():
	get_node("SecondAttackArea").free()

func delete_dodge_attack_area():
	get_node("DodgeAttackArea").free()

func delete_basic_attack_area():
	get_node("BasicAttackArea").free()

#function to check if there is  a collision
func collision_handler(collider):
	if collider.type != "WALLS" && collider.type != "ENEMY":
		if get_node("CanvasLayer").get_node("Inventory").pickup_item(collider.type):
			collider.free()

#function to display the inventory
func display_inventory():
	if inv_disp == -1:
		self.get_node("CanvasLayer").get_node("Inventory").show()
	else:
		self.get_node("CanvasLayer").get_node("Inventory").hide()
	inv_disp = inv_disp * (-1)

func check_action():
	var attack
	if Input.is_action_just_pressed(inputMap.firstAttack) and inv_disp == -1 and can1Attack:
		var firstAttackScene = preload("res://Scenes/CharacterTemplate/Jaguarienne/FirstAttackArea.tscn")
		attack = firstAttackScene.instance()
		add_child(attack)
		attack.look_at(global.MousePosition)
		can1Attack = false
		timer_first_attack.start()
		yield(get_tree().create_timer(global.first_attack_duration), 'timeout')
		attack.queue_free()
	
	if Input.is_action_just_pressed(inputMap.secondAttack) and inv_disp == -1 and can2Attack:
		speed *= 2
		can2Attack = false
		yield(get_tree().create_timer(global.second_attack_duration), 'timeout')
		timer_second_attack.start()
		speed /= 2
	
	if Input.is_action_just_pressed(inputMap.dodgeAttack) and inv_disp == -1 and canDodge:
		var dodgeScene = preload("res://Scenes/CharacterTemplate/Jaguarienne/DodgeArea.tscn")
		attack = dodgeScene.instance()
		add_child(attack)
		canDodge = false
		canMove = false
		vulnerable = false
		speed_added = 2000
		targetToDash = get_local_mouse_position().normalized()
		timer_dodge_attack.start()
		yield(get_tree().create_timer(global.dodge_duration), 'timeout')
		speed_added = 0
		canMove = true
		vulnerable = true
		attack.queue_free()

	if Input.is_action_just_pressed(inputMap.basicAttack) and inv_disp == -1 and canBasicAttack:
		var basicAttackScene = preload("res://Scenes/CharacterTemplate/Jaguarienne/BasicAttackArea.tscn")
		attack = basicAttackScene.instance()
		add_child(attack)
		attack.look_at(global.MousePosition)
		canBasicAttack = false
		timer_basic_attack.start()
		yield(get_tree().create_timer(global.basic_attack_duration), 'timeout')
		attack.queue_free()

	if Input.is_action_just_pressed(inputMap.menu):
		if get_tree().change_scene("res://Scenes/Menu/Menu.tscn"):
			pass
		else:
			return

	if  Input.is_action_just_pressed(inputMap.invKey):
		display_inventory()


func move_info(velocity):
	if Input.is_action_pressed(inputMap.right) and inv_disp == -1:
		velocity.x += 1
	if Input.is_action_pressed(inputMap.left) and inv_disp == -1:
		velocity.x -= 1
	if Input.is_action_pressed(inputMap.down) and inv_disp == -1:
		velocity.y += 1
	if Input.is_action_pressed(inputMap.up) and inv_disp == -1:
		velocity.y -= 1
	return velocity

func _process(delta):
	var velocity = Vector2(0, 0)
	global.MousePosition = get_global_mouse_position()
	if canMove:
		velocity = move_info(velocity)
	elif canDodge == false:
		velocity = targetToDash
	if velocity.length() > 0:
		velocity = velocity.normalized() * (speed + speed_added)
	check_action()
	var collision = move_and_collide(velocity * delta)
	if collision and collision.collider:
		collision_handler(collision.collider)
	

func set_Timers():
	timer_first_attack = Timer.new()
	timer_basic_attack = Timer.new()
	timer_second_attack = Timer.new()
	timer_dodge_attack = Timer.new()
	
	timer_first_attack.set_one_shot(true)
	timer_basic_attack.set_one_shot(true)
	timer_second_attack.set_one_shot(true)
	timer_dodge_attack.set_one_shot(true)
	
	timer_first_attack.set_wait_time(global.first_attack_cd)
	timer_basic_attack.set_wait_time(global.basic_attack_cd)
	timer_second_attack.set_wait_time(global.second_attack_cd)
	timer_dodge_attack.set_wait_time(global.dodge_cd)

	timer_first_attack.connect("timeout", self, "end_first_attack_cd")
	timer_second_attack.connect("timeout", self, "end_second_attack_cd")
	timer_dodge_attack.connect("timeout", self, "end_dodge_attack_cd")
	timer_basic_attack.connect("timeout", self, "end_basic_attack_cd")
	
	add_child(timer_first_attack)
	add_child(timer_second_attack)
	add_child(timer_dodge_attack)
	add_child(timer_basic_attack)
	

func _ready():
	current_hp = global.HP
	var scene = invScene.instance()
	self.add_child(scene)
	set_Timers()
	inv_disp = -1
	root.get_node("GUI/hp").setHP(String(current_hp))
