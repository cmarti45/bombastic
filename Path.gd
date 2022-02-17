extends Path


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	print(curve.get_point_position(0))
	curve.set_point_position(0, Vector3(0, 0, 0))
	curve.set_point_position(1, Vector3(0.1, 0.1, 0))
	curve.set_point_position(2, Vector3(0.2, 0, 0))
	#curve.set_point_position(3, Vector3(0.1, 0.1, 0))
	#curve.set_point_position(4, Vector3(0, 0, 0))
	print(curve.get_baked_length())
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
