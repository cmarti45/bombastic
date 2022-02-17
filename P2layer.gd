extends KinematicBody

var gravity = Vector3.DOWN * 12  # strength of gravity

export var speed = 0.125 # movement speed
var rolling = false
var jump_speed = 6  # jump strength

var surface
var spin = 0.1  # rotation speed
var direction = Vector3.ZERO

var velocity = Vector3.ZERO
var jump = false
func getColor():
	return $MeshInstance.get_active_material(0).albedo_color

func startRolling():
	rolling = true
	var material = SpatialMaterial.new()
	material.albedo_color = Color.black
	$MeshInstance.set_surface_material(0, material)
func _ready():
	
	var material = SpatialMaterial.new()
	material.albedo_color = Color.red
	$MeshInstance.set_surface_material(0, material)
func stopRolling():
	
	rolling = false
	var material = SpatialMaterial.new()
	material.albedo_color = Color.white
	$MeshInstance.set_surface_material(0, material)
	
func get_input():
	velocity.x = 0
	velocity.z = 0
	if Input.is_key_pressed(KEY_Y):
		velocity.z -= speed
		direction = Vector3.FORWARD
	if Input.is_key_pressed(KEY_H):
		velocity.z += speed
		direction = Vector3.BACK
	if Input.is_key_pressed(KEY_G):
		velocity.x -= speed
		direction = Vector3.LEFT
	if Input.is_key_pressed(KEY_J):
		velocity.x += speed
		direction = Vector3.RIGHT

func _physics_process(_delta):
	#velocity += gravity * delta
	get_input()
	pass
	#if !rolling:
	#	if $RayCast.get_collider() != null:
	#		surface = $RayCast.get_collider()
	#	elif surface != null:
	#		surface.roll(direction, self)
	#else:
	#	if $RayCast.get_collider() != null:
	#		stopRolling()
