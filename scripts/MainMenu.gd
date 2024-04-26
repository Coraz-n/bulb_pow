extends Control
class_name MainMenu

const level : PackedScene = preload("res://scenes/Level.tscn")

var menu : Control
var level_select : Control
var credits : Control

# Called when the node enters the scene tree for the first time.
func _ready():
	menu = get_node("Menu")
	level_select = get_node("LevelSelect")
	credits = get_node("Credits")
	
	var tween = create_tween()
	
	tween.tween_property(menu, "position", Vector2.ZERO, 0.7).set_trans(Tween.TRANS_ELASTIC)

func _on_btn_play_pressed():
	var tween = create_tween()
	
	tween.tween_property(menu, "position", Vector2(-512,0), 0.2).set_trans(Tween.TRANS_LINEAR)
	
	await tween.finished
	
	menu.visible = false
	Globals.level = Globals.level_max
	start_game()
	

func start_game():
	if (Globals.level_data.data.size() < Globals.level):
		Globals.level = Globals.level_data.data.size()
	
	var child : Level = level.instantiate()
	child.load_level.connect(_on_load_new_level)
	child.main_menu.connect(_on_main_menu)
	
	add_child(child)


func _on_load_new_level(p_level : int):
	get_child(get_child_count() - 1).queue_free()
	
	Globals.level = p_level
	
	start_game()
	
func _on_main_menu():
	get_child(get_child_count() - 1).queue_free()
	menu.visible = true
	var tween = create_tween()
	
	tween.tween_property(menu, "position", Vector2.ZERO, 0.7).set_trans(Tween.TRANS_ELASTIC)
	
	await tween.finished
	
func _on_btn_select_level_pressed_continue():
	await tween_position(menu, Vector2(-512,0), Tween.TRANS_LINEAR)
	
	menu.visible = false
	level_select.visible = true
	level_select.get_node("MenuContainer/MarginContainer/VBoxContainer/MarginContainer/LevelSelect").load_level_buttons()
	
	await tween_position(level_select, Vector2(384,0), Tween.TRANS_ELASTIC)

func _on_btn_volver_pressed_continue():
	if level_select.visible:
		await tween_position(level_select, Vector2(384,720), Tween.TRANS_LINEAR)
		level_select.get_node("MenuContainer/MarginContainer/VBoxContainer/MarginContainer/LevelSelect").clear_buttons()
		level_select.visible = false
	else:
		await tween_position(credits, Vector2(384,720), Tween.TRANS_LINEAR)
		credits.visible = false
		
	menu.visible = true
	await tween_position(menu, Vector2(0,0), Tween.TRANS_ELASTIC)

func _on_btn_credits_pressed_continue():
	await tween_position(menu, Vector2(-512,0), Tween.TRANS_LINEAR)
	
	menu.visible = false
	credits.visible = true
	
	await tween_position(credits, Vector2(384,0), Tween.TRANS_ELASTIC)

func tween_position(node, postion : Vector2, type):
	var tween = create_tween()
	
	tween.tween_property(node, "position", postion, 0.2 if type == Tween.TRANS_LINEAR else 0.7).set_trans(type)
	
	await tween.finished


