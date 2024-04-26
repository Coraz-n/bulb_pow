extends Control
class_name Level

var level_number : Label
var win_container : Control
var next_level : Button

var audio : AudioStreamPlayer
var music : AudioStreamPlayer

signal load_level(level: int)
signal main_menu

func _enter_tree():
	level_number = get_node("GameContainer/LevelGroup/LevelNumber")
	win_container = get_node("GameContainer/WinContainer")
	next_level = get_node("GameContainer/ActionButtons/NextLevel")
	audio = get_node("WinSound")
	music = get_node("/root/MainMenu/Background/MainMusic")


func _ready():
	level_number.text = level_number.text + str(Globals.level)
	
	if !Globals.restart:
		var tween = create_tween()
		global_position = Vector2(0, -720)
		tween.tween_property(self, "position", Vector2.ZERO, 0.7).set_trans(Tween.TRANS_ELASTIC)
		
	Globals.restart = false
	

func end_level():
	audio.play(0.3)
	get_tree().call_group("CellsButtons", "set_disabled", true)
	get_tree().call_group("CellsButtons", "set_mouse_filter", 2)
	
	next_level.visible = true
	if Globals.level_data.data.size() == Globals.level:
		win_container.get_node("LevelWin").text = "¡Congratulations! \n All levels completed."
		next_level.visible = false
	else:
		if Globals.level == Globals.level_max: Globals.level_max += 1
	
	win_container.visible = true
	

func _on_next_level_pressed():
	win_container.visible = false
	var tween = create_tween()
	tween.tween_property(self, "position", Vector2(0, -720), 0.2).set_trans(Tween.TRANS_LINEAR)
	
	await tween.finished
	emit_signal("load_level", Globals.level + 1)
	

func _on_restart_level_pressed():
	Globals.restart = true
	emit_signal("load_level", Globals.level)

func _on_menu_button_pressed():
	win_container.visible = false
	var tween = create_tween()
	tween.tween_property(self, "position", Vector2(0, -720), 0.2).set_trans(Tween.TRANS_LINEAR)
	
	await tween.finished
	emit_signal("main_menu")

func _on_music_button_pressed_continue():
	if music.playing: music.stop()
	else: music.play()
