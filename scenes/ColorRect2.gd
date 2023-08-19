extends ColorRect

var border_radius = 2
var border_width = 3

func _draw():
	# Draw rounded rectangle border
	draw_polyline([
		Vector2(border_radius, 0),
		Vector2(get_size().x - border_radius, 0),
		Vector2(get_size().x, border_radius),
		Vector2(get_size().x, get_size().y - border_radius),
		Vector2(get_size().x - border_radius, get_size().y),
		Vector2(border_radius, get_size().y),
		Vector2(0, get_size().y - border_radius),
		Vector2(0, border_radius),
		Vector2(border_radius, 0)
	], Color(1, 1, 1), border_width)
