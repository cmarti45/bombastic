extends KinematicBody

onready var pivot = $Pivot
onready var mesh = $Pivot/MeshInstance
onready var tween = $Tween
onready var fireEffect = $FireEffect
var material = preload("res://DieMaterial.tres").duplicate()
var gridPos = Vector2()
var rolling = false
var dieValue
var lit = false
var explosionTime = 100.0
var explosionRange = 100.0
var speed = 0
var playerOwner
var rng = RandomNumberGenerator.new()
var color = Color.white
signal explosion(player, dieValue, gridPos, cube)
func explode(var player):
	emit_signal("explosion", player, dieValue, gridPos, self)
	pass

func light(var player):
	material = preload("res://DieMaterial.tres").duplicate()
	playerOwner = player
	speed = player.speed * 16
	color = player.getColor()
	lit = true
	explosionTime = 40 * dieValue
	explosionRange = explosionTime
func randomOrientation():
	rng.randomize()
	var rDieValue = rng.randi_range(1,6)
	var rotationValue = rng.randi_range(0,3)
	var rotationAmount = Vector3(0,0,0)
	if rDieValue == 1:
		rotationAmount = Vector3(0,90*rotationValue,0)
	elif rDieValue == 2:
		rotationAmount = Vector3(0,90*rotationValue,90)
	elif rDieValue == 3:
		rotationAmount = Vector3(90,90*rotationValue,0)
	elif rDieValue == 4:
		rotationAmount = Vector3(270,90*rotationValue,0)
	elif rDieValue == 5:
		rotationAmount = Vector3(0,90*rotationValue,270)
	elif rDieValue == 6:
		rotationAmount = Vector3(0,90*rotationValue,180)
	$positions.rotation_degrees = Vector3(0,-90,0) + rotationAmount
	$Pivot/MeshInstance.rotation_degrees = rotationAmount
	dieValue = rDieValue
	#get_parent().checkCombo(gridPos)
	
	
	

func getValue():
	var value = 1
	for dieSide in $positions.get_children():
		if round(dieSide.global_transform.origin.y) == 2:
			value = dieSide.getValue()
	dieValue = value
	return value

func _physics_process(_delta):
	if lit:
		explosionTime -= speed/8
		material.albedo_color = mixColors(Color.white, color, explosionTime/explosionRange)
		if explosionTime < 0:
			#explode
			explosionTime = 0
			lit = false
			material.albedo_color = Color(1, 1, 1)
			explode(playerOwner)
		$Pivot/MeshInstance.set_surface_material(0, material)
		$Pivot/MeshInstance/DICE/Cube001.set_surface_material(0,material)
func mixColors(startColor, finishColor, change):
	var r = startColor.r * (change) + finishColor.r * (1-change)
	var g = startColor.g * (change) + finishColor.g * (1-change)
	var b = startColor.b * (change) + finishColor.b * (1-change)
	return Color(r,g,b)

func roll(dir, rollSpeed):
		rollSpeed *= 16
		speed = rollSpeed
		if tween.is_active():
			return
		rolling = true
		pivot.translate(dir)
		mesh.global_translate(-dir)
		
		var axis = dir.cross(Vector3.DOWN)
		tween.interpolate_property(pivot, "transform:basis",
				null, pivot.transform.basis.rotated(axis, PI/2),
				1/rollSpeed, Tween.TRANS_QUAD, Tween.EASE_IN)
		tween.start()
		yield(tween, "tween_all_completed")
		
		transform.origin += dir * 2
		var b = mesh.global_transform.basis
		pivot.transform = Transform.IDENTITY
		mesh.transform.origin = Vector3(0, 1, 0)
		mesh.global_transform.basis = b
		rolling = false
		$positions.rotate(dir, PI/2)
		return gridPos
		#get_parent().checkCombo(gridPos)


func _on_Tween_tween_step(object, key, elapsed, value):
	pivot.transform = pivot.transform.orthonormalized()
