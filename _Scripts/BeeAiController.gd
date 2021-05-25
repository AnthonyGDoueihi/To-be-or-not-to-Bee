extends "res://_Scripts/BeeChopper.gd"

var target: Vector3

var swarm: Array = []

var targetDirection: Vector3 = Vector3.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	pass 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	look_direction(targetDirection)

func _physics_process(delta):
	var sep: Vector3 = get_seperation()
	var ali: Vector3 = get_align()
	var coh: Vector3 = get_cohesion()

	targetDirection = ((sep * 1.5) + (ali * 1) + (coh * 1) + (target.normalized() * 1.5)) / 4
	targetDirection = targetDirection.normalized()
	
	move_direction(targetDirection.z, targetDirection.x, targetDirection.y, false)

func get_seperation():
	var desiredSeperation: float = 25.0
	var steer: Vector3 = Vector3.ZERO
	var count: int = 0

	for i in swarm:
		var d = i.global_transform.distance_to(global_transform)
		if d > 0 and d < desiredSeperation:
			var diff: Vector3 = global_transform - i.global_transform
			diff = diff.normalized() / d
			steer += diff
			count += 1

	if count > 0:
		steer = steer / count
		steer = steer.normalized()
		
	return steer

func get_align():
	var neightbourDist: float = 50
	var sum: Vector3 = Vector3.ZERO
	var count: int = 0
	for i in swarm:
		var d = i.global_transform.distance_to(global_transform)
		if d > 0 and d < neightbourDist:
			sum = sum + targetDirection
			count += 1

	if count > 0:
		sum = sum / count
	
	return sum

func get_cohesion():
	var neightbourDist: float = 50
	var sum: Vector3 = Vector3.ZERO
	var count: int = 0
	for i in swarm:
		var d = i.global_transform.distance_to(global_transform)
		if d > 0 and d < neightbourDist:
			sum = sum + i.global_transform
			count += 1

	if count > 0:
		sum = sum / count
		var desired = sum - global_transform.origin
		desired = desired.normalized()
		return desired
	else:
		return sum

