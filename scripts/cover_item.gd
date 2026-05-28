class_name CoverItem
	
var type: Globals.Cover
var direction: Vector2

static func create(_type: Globals.Cover, _direction: Vector2):
	var coverItem = CoverItem.new()
	coverItem.type = _type
	coverItem.direction = _direction
	return coverItem
