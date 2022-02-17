extends Spatial

var distance = 1.0
const duration = 1.5/6.0
var orientation = Vector2.ZERO
const initVelocity = 32.0
var explodeBounds = [6,6,6,6]
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func setColor(var color):
	for particles in $Particles.get_children():
		particles.color = color
func _ready():
	for particles in $Particles.get_children():
		particles.initial_velocity = initVelocity
	
	pass # Replace with function body.
func explode(var distance, var player):
	setColor(player.getColor())
	setDistance(distance)
	yield(explosion_co(), "completed")
	
func setLength(var direction, var length):
	explodeBounds[direction] = length
	
	$Particles.get_children()[direction].lifetime = 0 #2.0 / initVelocity * length +  1.0/ initVelocity
func setDistance(var distance):	
	var i = 0
	for particles in $Particles.get_children():
		if distance <= explodeBounds[i]:
			particles.lifetime = 2.0 / initVelocity * distance +  1.0/ initVelocity
		else:
			particles.lifetime = 2.0 / initVelocity * explodeBounds[i] +  1.0/ initVelocity
		i+= 1
	

func explosion_co():
	
	for particles in $Particles.get_children():
		particles.emitting =true
	yield(get_tree().create_timer(distance * duration), "timeout")
	for particles in $Particles.get_children():
		particles.emitting =false
	pass
