extends Control
class_name ConnectionsNode

const connections_node : PackedScene = preload("res://scenes/ConnectionsNode.tscn")

signal node_connected
signal node_disconnected

var is_start : bool
var south_ray : RayCast2D
var north_ray : RayCast2D
var east_ray : RayCast2D
var west_ray : RayCast2D

var board : BoardContainer

var south : bool
var north : bool
var east : bool
var west : bool

var layer
var connected : bool

# Called when the node enters the scene tree for the first time.
func _ready():
	
	board = get_node("../../../../BoardContainer")
	
	south_ray = get_node("SouthConnector/SouthRaycast")
	north_ray = get_node("NorthConnector/NorthRaycast")
	east_ray = get_node("EastConnector/EastRaycast")
	west_ray = get_node("WestConnector/WestRaycast")
	
	if south:
		south_ray.enabled = true
		south_ray.get_parent().collision_layer = layer
	if north:
		north_ray.enabled = true
		north_ray.get_parent().collision_layer = layer
	if east:
		east_ray.enabled = true
		east_ray.get_parent().collision_layer = layer
	if west:
		west_ray.enabled = true
		west_ray.get_parent().collision_layer = layer
	
	south_ray.collision_mask = layer
	north_ray.collision_mask = layer
	east_ray.collision_mask = layer
	west_ray.collision_mask = layer
	
	node_connected.connect(get_parent().get_parent()._onCellConnected)
	node_disconnected.connect(get_parent().get_parent()._onCellDisconnected)
	
	force_disconnect()


func build(p_is_start = false, p_layer = 16, p_north = false, p_south = false, p_west = false, p_east = false) -> ConnectionsNode:
	#var node := connections_node.instantiate() as ConnectionsNode
	layer = p_layer
	north = p_north
	south = p_south
	east = p_east
	west = p_west
	connected = p_is_start
	is_start = p_is_start
	return self

func force_disconnect():
	while Globals.in_game:
		await board.try_reconnect_nodes
		
		if !is_start:
			if connected: emit_signal("node_disconnected")
			connected = false
	
func check_connections():
	if !connected: 
		return
	
	if south_ray.is_colliding(): Connect(south_ray.get_collider().get_node("../../ConnectionsNode"))
	if north_ray.is_colliding(): Connect(north_ray.get_collider().get_node("../../ConnectionsNode"))
	if east_ray.is_colliding(): Connect(east_ray.get_collider().get_node("../../ConnectionsNode"))
	if west_ray.is_colliding(): Connect(west_ray.get_collider().get_node("../../ConnectionsNode"))

func Connect(node : ConnectionsNode):
	if node.connected: 
		return
		
	node.connected = true
	node.emit_signal("node_connected")
	node.check_connections()
