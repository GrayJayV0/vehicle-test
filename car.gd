extends VehicleBody3D
@onready var blwheel = $VehicleWheel3D4
@onready var brwheel = $VehicleWheel3D
@onready var flwheel = $VehicleWheel3D2
@onready var frwheel = $VehicleWheel3D3
@onready var camera = $Camera3D
@export var MAX_STEER = 1
@export var ENGINE_POWER = 8000
var drift
var new_rotation
var old_position
var old_velocity
var axis
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	#print(rotation_degrees,rotation)
	#print(linear_velocity)
	if Input.is_action_pressed("drift") and Input.get_axis("ui_right","ui_left") != 0 and !drift:
		drift = true
		axis = Input.get_axis("ui_right","ui_left")
		steering = Input.get_axis("ui_right","ui_left")
		new_rotation = rotation_degrees
		old_position = position
		old_velocity = linear_velocity
	if Input.is_action_just_released("drift"):
		flwheel.wheel_friction_slip = 10.5
		frwheel.wheel_friction_slip = 10.5
		drift = false
		angular_velocity.y = 0
		#rotation_degrees.y = 0
	blwheel.wheel_friction_slip = 5
	brwheel.wheel_friction_slip = 5

	if !drift:
		engine_force = Input.get_axis("ui_down","ui_up") * ENGINE_POWER
		steering = move_toward(steering, Input.get_axis("ui_right","ui_left") * MAX_STEER, delta * 10)
	else:
		linear_velocity.z = old_velocity.z
	apply_central_impulse(Vector3(0,0,10*Input.get_axis("ui_down","ui_up")))
	apply_torque_impulse(Vector3(0,10*Input.get_axis("ui_right","ui_left"),0))
		
func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	
	if drift and axis == 1:
		if Input.get_axis("ui_right","ui_left") == 1:
			var clamp_rotation = clamp(rotation_degrees.y,new_rotation.y,new_rotation.y+75)
			rotation_degrees = Vector3(rotation_degrees.x,clamp_rotation,rotation_degrees.z)
		elif Input.get_axis("ui_right","ui_left") == 0:
			var clamp_rotation = clamp(rotation_degrees.y,new_rotation.y+45,new_rotation.y+75)
			rotation_degrees = Vector3(rotation_degrees.x,clamp_rotation,rotation_degrees.z)
		elif Input.get_axis("ui_right","ui_left") == -1:
			var clamp_rotation = clamp(rotation_degrees.y,new_rotation.y+25,new_rotation.y+75)
			rotation_degrees = Vector3(rotation_degrees.x,clamp_rotation,rotation_degrees.z)
		else:
			pass
	elif drift and axis == -1:
		
		if Input.get_axis("ui_right","ui_left") == -1:
			var clamp_rotation = clamp(rotation_degrees.y,new_rotation.y-75,new_rotation.y)
			rotation_degrees = Vector3(rotation_degrees.x,clamp_rotation,rotation_degrees.z)
		elif Input.get_axis("ui_right","ui_left") == 0:
			var clamp_rotation = clamp(rotation_degrees.y,new_rotation.y-75,new_rotation.y-45)
			rotation_degrees = Vector3(rotation_degrees.x,clamp_rotation,rotation_degrees.z)
		elif Input.get_axis("ui_right","ui_left") == 1:
			var clamp_rotation = clamp(rotation_degrees.y,new_rotation.y-75,new_rotation.y-25)
			rotation_degrees = Vector3(rotation_degrees.x,clamp_rotation,rotation_degrees.z)
		else:
			pass
