extends TileMap


# Declare member variables here. Examples:
# var a = 2
# var b = "text"4
const HEIGHT = 8
const WIDTH = 8

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
func getNextCell(var pos, var dir):
	var newPos = pos + dir
	return get_cellv(newPos)
func isInRange(var pos):
	return (pos.x >= 0 and pos.x <= WIDTH) and (pos.y >= 0 and pos.y <= HEIGHT)
	
func validMove(var pos, var dir):
	pos = world_to_map(pos)
	var currCell = get_cellv(pos - dir)
	var currPos = pos - dir
	var nextCell = get_cellv(pos)
	var nextPos = pos
	if !isInRange(nextPos):
		print("outOfRange")
		return false
	else:
		if get_cellv(nextPos) == 0:
			return true
		else:
			return roll(currPos,nextPos)
	
	
func roll(var pos, var nextPos):
	print("roll")
	set_cellv(pos, -1)
	set_cellv(nextPos, 0)
	return true
		
	
