extends GridContainer
class_name LevelSelect

const menu_button : PackedScene = preload("res://scenes/MenuBtn.tscn")
const button_texture : Texture2D = preload("res://graphics/blue_gui_box_64.png")

var level_select : Control

# Called when the node enters the scene tree for the first time.
func _ready():
	level_select = get_node("/root/MainMenu/LevelSelect")


func load_level_buttons():
	var level_count = Globals.level_data.data.size()
	
	for i in level_count:
		var button = menu_button.instantiate()
		var level : int = i + 1
		
		button.button_text = str(level)
		button.button_image = button_texture
		button.pressed_continue.connect(_play_level.bind(level))
		
		if Globals.level_max < level:
			button.disabled = true
			button.modulate = Color(.4, .4, .4)
			
		add_child(button)
		

func clear_buttons():
	for child in get_children():
		child.queue_free()

func _play_level(level: int):
	Globals.level = level
	
	await tween_position(level_select, Vector2(384,720), Tween.TRANS_LINEAR)
	
	level_select.visible = false
	clear_buttons()
	
	get_node("/root/MainMenu").start_game()
	

func tween_position(node, postion : Vector2, type):
	var tween = create_tween()
	
	tween.tween_property(node, "position", postion, 0.2 if type == Tween.TRANS_LINEAR else 0.7).set_trans(Tween.TRANS_LINEAR)
	
	await tween.finished
