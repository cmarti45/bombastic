extends Sprite
onready var tileMap = get_parent()

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var speed = 4

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var currTile = tileMap.world_to_map(position)
	var velocity = Vector2.ZERO
	if Input.is_key_pressed(KEY_A):
		velocity += Vector2(-speed, 0)
	if Input.is_key_pressed(KEY_D):
		velocity += Vector2(speed, 0)
	if Input.is_key_pressed(KEY_W):
		velocity += Vector2(0, -speed)
	if Input.is_key_pressed(KEY_S):
		velocity += Vector2(0, speed)
	if currTile == tileMap.world_to_map(position+velocity):
		translate(velocity)
	else:
		if tileMap.validMove(position+velocity, get_direction(position, velocity)):
			if abs(get_direction(position, velocity).x + get_direction(position, velocity).y) != 1:
				print(get_direction(position, velocity))
				print("fixit")#corner moves possible?
			translate(velocity)
	
func get_direction(var position, var velocity):
	return tileMap.world_to_map(position+velocity) - tileMap.world_to_map(position)
	
	
	
