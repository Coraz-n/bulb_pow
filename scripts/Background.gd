extends ParallaxBackground

@export var speed : float

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	scroll_offset += Vector2(speed * delta, 0)
