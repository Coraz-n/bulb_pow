extends Node

var in_game : bool
var level : int = 1
var level_max : int = 1
var level_endings : int 
var endings_connected : int 
var restart : bool 
var level_data : JSON = preload("res://data/level_data.json")
