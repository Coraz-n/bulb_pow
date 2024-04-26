extends Panel

var title_label : Label
var description_label : Label
var board : Control

func _enter_tree():
	title_label = get_node("Margin/ReferenceRect/Title")
	description_label = get_node("Margin/ReferenceRect/Description")
	board = get_node("../GameContainer/Board")
	

func _on_board_draw():
	var message = get_level_popup()
	
	if message != null:
		title_label.text = message[0]
		description_label.text = message[1]
		
		position = board.position + Vector2(-size.x -25, -20)
		visible = true

func get_level_popup():
	match Globals.level:
		1:
			return [
				"¡How to play!",
				"Move the wires into empty spaces and connect the power sources with the bulbs."
			]
		2: 
			return [
				"Broken Wires",
				"Grey wires are broken, won't connect to anything."
			]
		4:
			return [
				"¡Colors!",
				"Only wires of the same color can connect."
			]
		6:
			return [
				"One for All",
				"Purple wires can connect to other wires that aren't broken."
			]
		9:
			return [
				"Auto-Wires",
				"Wires with a circle on it will rotate every time they change cell."
			]
		_:
			return null
