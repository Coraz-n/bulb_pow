extends Control
class_name Cell

const connections_node = preload("res://scenes/ConnectionsNode.tscn")

@export var piece_name : String
var connected : bool


func create_connection_nodes(parent : TextureRect) -> ConnectionsNode : 
	match piece_name.split("_")[0]:
		"line":
			var connection_node := connections_node.instantiate() as ConnectionsNode
			parent.add_child(connection_node.build(false, get_layer(), false, false, true, true))
		"corner", "auto":
			var connection_node := connections_node.instantiate() as ConnectionsNode
			parent.add_child(connection_node.build(false, get_layer(), true, false, true, false))
		"start":
			var connection_node := connections_node.instantiate() as ConnectionsNode
			var builded_node = connection_node.build(true, 14, true, true, true, true)
			parent.add_child(builded_node)
			return builded_node
		"end": 
			var connection_node := connections_node.instantiate() as ConnectionsNode
			parent.add_child(connection_node.build(false, get_layer(), false, true, false, false))
		"triple":
			var connection_node := connections_node.instantiate() as ConnectionsNode
			parent.add_child(connection_node.build(false, get_layer(), true, false, true, true))
	
	return null

func get_layer() -> int:
	match piece_name.split("_")[2]:
		"blue":
			return 4
		"red":
			return 8
		"green":
			return 2
		"omni":
			return 14
		_:
			return 16
			
func load_texture(texture_name : String) -> ConnectionsNode :
	var child : TextureRect = get_node("PieceSprite")
	piece_name = texture_name.replace("#", "")

	
	var start_point : ConnectionsNode = create_connection_nodes(child)

	match piece_name.split("_")[0]:
		"blank", "wall":
			child.texture = null
		"block":
			child.texture = load("res://graphics/Pieces/block.svg")
		"start":
			child.texture = load("res://graphics/Pieces/start.svg")
		_:
			var imgTexture = "res://graphics/Pieces/" + piece_name.split("_")[0] + "_" + piece_name.split("_")[2] + ".svg"
			child.texture = load(imgTexture)
			child.rotation_degrees = float(piece_name.split("_")[1])
	
	return start_point

func _onCellConnected():
	if !name.contains("StaticCell"):
		get_node("CellSprite").modulate = Color(1.3, 1.3, 1.3)
		connected = true
		
	if piece_name.split("_")[0] == "end":
		Globals.endings_connected += 1
		
		var light : PointLight2D = PointLight2D.new()
		light.texture = load("res://graphics/light.png")
		light.texture_scale = 0.3
		light.energy = 0.5
		light.position = Vector2(32,32)
		
		get_node("PieceSprite").add_child(light)
	
	if Globals.endings_connected == Globals.level_endings:
		get_node("/root/MainMenu").get_child(get_node("/root/MainMenu").get_child_count() - 1).end_level()
		

func _onCellDisconnected():
	if !name.contains("StaticCell"):
		get_node("CellSprite").modulate = Color(1, 1, 1)
		connected = false
	if piece_name.split("_")[0] == "end":
		Globals.endings_connected -= 1
		for child in get_node("PieceSprite").get_children():
			if child.get_class() == "PointLight2D":
				child.queue_free()
				

func _on_mouse_region_mouse_entered():
	get_node("CellSprite").modulate = Color(.7, .7, .7)
	
func _on_mouse_region_mouse_exited():
	if connected:
		get_node("CellSprite").modulate = Color(1.3, 1.3, 1.3)
	else:
		get_node("CellSprite").modulate = Color(1, 1, 1)
		
