extends Node2D

var pos_item = Vector2()
var Sword = preload("res://Scenes/Items/Common/Sword.tscn")
var instance
var switch = 0
var r

func _ready():
	global._create_char(global.char_name)
