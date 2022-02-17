extends PathFollow
onready var targetOffset = get_parent().get_curve().get_baked_length()
var t = 0
var rising = true
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	#if rising:
	#	offset  = lerp(offset, targetOffset, targetOffset/30.0)
	#	if offset >= targetOffset: rising = false
	#else:
	#	offset  = lerp(offset, 0, targetOffset/30.0)
	#	if offset <= 0: rising = true
