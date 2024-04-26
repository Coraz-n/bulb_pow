extends Button
class_name MouseRegion

var picked_up : bool = false

signal mouse_released

var parent
var audio : AudioStreamPlayer
var offset : Vector2
var speed : float = 400


# Called when the node enters the scene tree for the first time.
func _ready():
	parent = get_parent()
	audio = get_node("GrabSound")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if picked_up:
		var pos = get_global_mouse_position() - offset
		global_position = global_position.move_toward(pos, delta * speed)
	
	if Input.is_action_just_released("click"):
		emit_signal("mouse_released") 

func _onMouseRegionPressed():
	picked_up = true
	offset = get_global_mouse_position() - global_position
	
	audio.pitch_scale = 1
	audio.play()
	
	await mouse_released
	
	audio.pitch_scale = 0.7
	audio.play()
	
	global_position = get_parent().global_position
	picked_up = false
	
func _onAreaEntered(area: Area2D):
	if !picked_up: 
		return
	
	emit_signal("mouse_released")
	if(area.get_parent() is MouseRegion && area.get_parent().get_parent().piece_name == "blank"):
		special_piece()
		
		var area_cell = area.get_parent().get_parent()
		var index_of_this = parent.get_index()
		
		parent.get_parent().move_child(parent, area_cell.get_index())
		area_cell.get_parent().move_child(area_cell, index_of_this)
		
		await get_tree().create_timer(0.1).timeout
		parent.get_parent().reconnect_nodes()
		
func special_piece():
	var piece_name = parent.piece_name.split("_")[0]
	
	if piece_name == "auto":
		get_node("../PieceSprite").rotation_degrees += 90
