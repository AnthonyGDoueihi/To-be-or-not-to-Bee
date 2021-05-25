extends "res://_Scripts/BeeChopper.gd"

var minVerticalRotation: int = -40
var maxVerticalRotation: int = 80
var lookSensitivity : float = 15.0
var mouseDelta : Vector2
var targetLook: Vector3

func _ready():
	targetLook = Vector3($Arm.global_transform.basis.get_euler().x, global_transform.basis.get_euler().y, 0)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	mouseDelta = Vector2.ZERO
	if event is InputEventMouseMotion:
		mouseDelta = event.relative

func _process(delta):
	var rot = Vector3(-mouseDelta.y, mouseDelta.x, 0) * lookSensitivity * delta
	
	if targetLook.y > 180:
		targetLook.y -= 360
		currentLook.y -= 360
	elif targetLook.y < -180:
		targetLook.y += 360
		currentLook.y += 360

	targetLook.x += rot.x
	targetLook.x = clamp(targetLook.x, minVerticalRotation, maxVerticalRotation)
	
	targetLook.y -= rot.y

	# set_rotation(Vector3(0, deg2rad(targetLook.y), 0))
	# $Arm.set_rotation(Vector3(0, 0, deg2rad(-targetLook.x)))
	look_direction(targetLook)

func _physics_process(delta):
	vel = Vector3.ZERO

	var forward = 0
	var up = 0
	var right = 0
	
	if Input.is_action_pressed("move_forward"):
		forward += 1
	if Input.is_action_pressed("move_left"):
		right -= 1
	if Input.is_action_pressed("move_right"):
		right += 1
	if Input.is_action_pressed("move_up"):
		up += 1
	if Input.is_action_pressed("move_down"):
		up -= 1
		
	var input: Vector3 = Vector3(forward, up, right)
	input = input.normalized()
	var dir = (transform.basis.z * input.z + transform.basis.x * input.x + transform.basis.y * input.y)
	
	var speed = dashSpeed if Input.is_action_pressed("sprint") else moveSpeed 
	print(Input.is_action_pressed("sprint"))
	vel.x = dir.x * speed
	vel.y = dir.y * moveSpeed
	vel.z = dir.z * moveSpeed

	move_and_slide(vel, Vector3.UP)
