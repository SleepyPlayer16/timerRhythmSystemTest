extends ColorRect

const SPEED = 5000
var vec
func _ready():
	vec = get_viewport().get_mouse_position() - self.rect_position
	rect_position = rect_position.snapped(Vector2.ONE * 64)##Snappa o player no grid
	rect_position += Vector2.ONE * 64 ##Centraliza o player no tile
	
func _process(delta):
	vec = get_viewport().get_mouse_position() - self.rect_position	
	rect_position = rect_position.snapped(Vector2.ONE * 64)##Snappa o player no grid
	rect_position += vec
