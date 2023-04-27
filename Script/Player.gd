extends KinematicBody2D

var speed = 2000
var velocity = Vector2()

onready var root = get_tree().get_root().get_node("Node2D")
onready var label = root.get_node("GUI").get_node("Coords")

func get_input():
	velocity = Vector2()
	if Input.is_action_pressed('ui_right'):
		velocity.x += 1
	if Input.is_action_pressed('ui_left'):
		velocity.x -= 1
	if Input.is_action_pressed('ui_down'):
		velocity.y += 1
	if Input.is_action_pressed('ui_up'):
		velocity.y -= 1
	velocity = velocity.normalized() * speed

func _physics_process(_delta):
	label.text = String(self.position.x)
	label.text = label.text + " " + String(self.position.y)
	get_input()
	velocity = move_and_slide(velocity)
