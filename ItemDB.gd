extends Node

var ITEMS

func _ready():
	var itemdata_file = File.new()
	itemdata_file.open("res://Data/ItemsDB.json", File.READ)
	var itemdata_json = JSON.parse(itemdata_file.get_as_text())
	itemdata_file.close()
	ITEMS = itemdata_json.result

func get_item(item_id):
	if item_id in ITEMS:
		return ITEMS[item_id]
	else:
		return ITEMS["error"]
