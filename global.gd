extends Node2D

var MousePosition
var screen_size 

var speed
var HP
var dodge_damage
var dodge_cd
var first_attack_damage
var second_attack_damage
var first_attack_cd
var second_attack_cd
var basic_attack_damage
var basic_attack_cd
var dodge_duration
var basic_attack_duration
var first_attack_duration
var second_attack_duration
var char_name
var json
var curr_x = 0
var curr_y = 0
var killsBopen = 0

var weapon_damage = 0
var pct_dam = 100

func _ready():
	screen_size = get_viewport_rect().size
	var itemdata_file = File.new()
	itemdata_file.open("res://Data/CharacterSettings.json", File.READ)
	var itemdata_json = JSON.parse(itemdata_file.get_as_text())
	itemdata_file.close()
	json = itemdata_json.result

func _create_char(type):
	speed = json[type]["SPEED"]
	HP = json[type]["LIFE_POINTS"]
	dodge_damage = json[type]["DODGE_DAMAGE"]
	dodge_cd = json[type]["DODGE_CD"]
	first_attack_damage = json[type]["1ST_ATTACK_DMG"]
	first_attack_cd = json[type]["1ST_ATTACK_CD"]
	second_attack_damage = json[type]["2ND_ATTACK_DMG"]
	second_attack_cd = json[type]["2ND_ATTACK_CD"]
	basic_attack_damage = json[type]["BASIC_ATTACK_DMG"]
	basic_attack_cd = json[type]["BASIC_ATTACK_CD"]
	dodge_duration = json[type]["DODGE_DURATION"]
	first_attack_duration = json[type]["1ST_ATTACK_DURATION"]
	basic_attack_duration = json[type]["BASIC_ATTACK_DURATION"]
	second_attack_duration = json[type]["2ND_ATTACK_DURATION"]
	var character = load("res://Scenes/CharacterTemplate/" + type + "/MainCharScene.tscn")
	#bug à partir d'ici
	get_tree().get_root().get_node("MainNode").add_child(character.instance())
	var pos = get_tree().get_root().get_node("MainNode").get_node("SpawnChar").get_global_position()
	get_tree().get_root().get_node("MainNode").get_node("Player").set_z_index(10)
	get_tree().get_root().get_node("MainNode").get_node("Player").set_global_position(pos)

func list_items_in_directory(path, position):
	var files = []
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			files.append(file)
	dir.list_dir_end()
	
	var rdm = int(rand_range(0, files.size() - 1))
	var scene = load(path + files[rdm])
	var instance = scene.instance()
	get_tree().get_root().get_node("MainNode").add_child(instance)
	instance.set_global_position(position)

func loot(common_pct, rare_pct, legendary_pct, position):
	var nb = rand_range(0, 100)
	if nb >= 0 && nb < common_pct:
		list_items_in_directory("res://Scenes/Items/Common/", position)
	if nb >= common_pct && nb <= common_pct + rare_pct:
		list_items_in_directory("res://Scenes/Items/Rare/", position)
	if nb >= common_pct + rare_pct && nb <= common_pct + rare_pct + legendary_pct:
		list_items_in_directory("res://Scenes/Items/Legendary/", position)
