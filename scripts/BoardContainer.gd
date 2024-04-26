extends GridContainer
class_name BoardContainer

signal try_reconnect_nodes
signal first_reconnection

var cell : PackedScene = preload("res://scenes/Cell.tscn")
var staticCell : PackedScene = preload("res://scenes/StaticCell.tscn")

var start_points

func _init():
	start_points = []
	Globals.endings_connected = 0
	Globals.level_endings = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	first_reconnection.connect(_first_reconnection)
	var data : Dictionary = Globals.level_data.data["level_" + str(Globals.level)]
	var columns_number : int = data["level_columns"]
	
	columns = columns_number
	var level_build : Dictionary = data["level_build"]
	
	Globals.in_game = true
	
	for y in level_build.size():
		var row = level_build["row" + str(y + 1)]
		for x in columns_number:
			var child : Cell
			var child_name : String
			
			if row[x].contains("#"):
				child = staticCell.instantiate()
				child_name = "StaticCell_"
			else:
				child = cell.instantiate()
				child_name = "Cell_"
			
			child.name = child_name + str(y) + "_" + str(x)
			var start_point = child.load_texture(row[x])
			
			if start_point != null: start_points.append(start_point)
			if row[x].contains("#end"): Globals.level_endings += 1
			
			add_child(child)
		
	emit_signal("first_reconnection")

func _on_draw():
	resize_texture()

func resize_texture():
	get_parent().get_parent().custom_minimum_size = size

func _first_reconnection():
	await get_tree().create_timer(0.1).timeout
	reconnect_nodes()

func reconnect_nodes():
	emit_signal("try_reconnect_nodes")
	for conn : ConnectionsNode in start_points:
		conn.check_connections()
	
