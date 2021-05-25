extends KinematicBody
# Made a fundamental mistake where the bee is rotated 90 degrees and I didnt notice

var curHp : int = 10
var maxHp : int = 10
var damage : int = 5

var maxPollen : int = 50
var pollen : int = 0

var moveSpeed : float = 5.0
var dashSpeed : float = 10.0

var rotationFollowVelocity: float = 20

onready var stringCast = get_node("StingCast")

var vel : Vector3
var currentLook: Vector3

func _ready():
	pass

func _physics_process(delta):
	vel = move_and_slide(vel, Vector3.UP)
	vel = Vector3.ZERO;

func move_direction(forward: float, right: float, up: float, dash: bool):
	var input: Vector3 = Vector3(right, up, forward)
	input = input.normalized()
	var dir = (transform.basis.z * input.z + transform.basis.x * input.x + transform.basis.y * input.y)
	
	var speed = dashSpeed if dash else moveSpeed 
	vel.x = dir.x * speed
	vel.y = dir.y * moveSpeed
	vel.z = dir.z * moveSpeed
	
func look_direction(targetLook: Vector3):
	currentLook = lerp(currentLook, targetLook, rotationFollowVelocity / 100)
	set_rotation(Vector3(0, deg2rad(currentLook.y), deg2rad(currentLook.x)))
