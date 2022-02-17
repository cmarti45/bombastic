extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var eyeColor= Color.white

# Called when the node enters the scene tree for the first time.
func getColor():
	return eyeColor
func setColor(var color):
	eyeColor = color
	var mat1 = $Cube001.get_active_material(0).duplicate()
	var mat2 = $Cube002.get_active_material(0).duplicate()
	mat1.albedo_color = color
	mat2.albedo_color = color
	$Cube001.set_surface_material(0, mat1)
	$Cube002.set_surface_material(0, mat2)
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
