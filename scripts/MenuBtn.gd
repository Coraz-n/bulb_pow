extends Button

signal pressed_continue

@export var button_text : String
@export var button_image : Texture2D
@export var icon_image : Texture2D

var audio : AudioStreamPlayer

func _ready():
	var label = get_node("BtnTexture/Margin/BtnText/BtnLabel")
	var texture = get_node("BtnTexture")
	var _icon = get_node("BtnTexture/Margin/BtnText/Icon")
	audio = get_node("BtnSound")
	
	label.text = button_text
	texture.texture = button_image
	_icon.texture = icon_image
	
	if icon_image == null:
		_icon.visible = false
	
	if button_text.is_empty():
		label.visible = false
		
func _on_mouse_entered():
	if disabled: 
		return
	modulate = Color(0.7, 0.7, 0.7)
	
func _on_mouse_exited():
	if disabled: 
		return
	modulate = Color(1, 1, 1)
	
func _on_pressed():
	audio.play()
	await audio.finished
	emit_signal("pressed_continue")
