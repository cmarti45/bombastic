extends KinematicBody

var row
var column
var pushTarget = Vector2.ZERO
var pushed = false
var rotationConstant = 0
var pushVelocity = Vector2.ZERO
var gravity = Vector3.DOWN * 12  # strength of gravity
onready var bugger = $bugger
export var speed = 0.125 # movement speed
var WIDTH
var HEIGHT
var rolling = false
var jump_speed = 6  # jump strength
var color
var playerId
var controlScemes = [
	["P1_UP", "P1_DOWN", "P1_LEFT", "P1_RIGHT"],
	["P2_UP", "P2_DOWN", "P2_LEFT", "P2_RIGHT"]
]
var controlScheme

var cube
var spin = 0.1  # rotation speed
var direction = Vector3.ZERO
func gridPos():
	var playerPos = Vector2(round(translation.x / 2 + 0.5) -1 , round(translation.z / 2 + 0.5)-1)
	if playerPos.x > WIDTH-1:
		playerPos.x = WIDTH-1
	if playerPos.y > HEIGHT-1:
		playerPos.y = HEIGHT-1
	return playerPos

func getRow():
	return translation.x
func getColumn():
	return translation.z
func getNextRow():
	return translation.x + velocity.x
func getNextColumn():
	return translation.z + velocity.z
	
func setRow(var x):
	translation.x = x
func setColumn(var z):
	translation.z = z


func setId(var id):
	controlScheme = controlScemes[id]
	playerId = id

var velocity = Vector3.ZERO
var jump = false
func getColor():
	return bugger.getColor()

func push(target, direction, speed):
	pushed = true
	pushTarget = target
	pushVelocity = direction * speed * 1.1

func _ready():
	
	bugger.setColor(randomColor(-1))
func randomColor(var forceColor):
	var colorNum = 0
	var colors = [Color.red, Color.aqua, Color.green, Color.yellow]
	if forceColor == -1:
		var rng = RandomNumberGenerator.new()
		rng.randomize()
		colorNum = rng.randi_range(0,3)
	else:
		colorNum = forceColor
	return colors[colorNum]

func setLoc(var i, var j):
	translation = Vector3(i*2, 2, j*2)

func get_input(delta):
	var currRotation = bugger.rotation_degrees.y
	var targetRotation = currRotation
	var doublePress = true
	velocity.x = 0
	velocity.z = 0
	if Input.is_action_pressed(controlScheme[0]):
		velocity.z -= speed
		direction = Vector3.FORWARD
		targetRotation = 90
		
	if Input.is_action_pressed(controlScheme[1]):
		velocity.z += speed
		direction = Vector3.BACK
		targetRotation = 270
	if Input.is_action_pressed(controlScheme[2]):
		velocity.x -= speed
		direction = Vector3.LEFT
		targetRotation = 180
	if Input.is_action_pressed(controlScheme[3]):
		velocity.x += speed
		direction = Vector3.RIGHT
		targetRotation = 360
	
	if Input.is_key_pressed(KEY_W) and Input.is_key_pressed(KEY_D):
		targetRotation = 45
	if Input.is_key_pressed(KEY_W) and Input.is_key_pressed(KEY_A):
		targetRotation = 135
	if Input.is_key_pressed(KEY_S) and Input.is_key_pressed(KEY_A):
		
		targetRotation = 225
	if Input.is_key_pressed(KEY_S) and Input.is_key_pressed(KEY_D):
		targetRotation = 315
	var change = targetRotation - currRotation
	
	if change > 180:
		currRotation += 360
		bugger.rotation_degrees.y -= 360
	if change < -180:
		currRotation -= 360
		bugger.rotation_degrees.y += 360
	
	
		
	bugger.rotation_degrees.y = lerp(currRotation, targetRotation, speed)

func _physics_process(delta):
	#velocity += gravity * delta
	get_input(delta)
	pass
	

	#if !rolling:
	#	if $RayCast.get_collider() != null:
	#		surface = $RayCast.get_collider()
	#	elif surface != null:
	#		surface.roll(direction, self)
	#else:
	#	if $RayCast.get_collider() != null:
	#		stopRolling()
