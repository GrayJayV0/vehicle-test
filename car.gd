extends VehicleBody3D
@onready var blwheel = $VehicleWheel3D4
@onready var brwheel = $VehicleWheel3D
@onready var flwheel = $VehicleWheel3D2
@onready var frwheel = $VehicleWheel3D3
@onready var camera = $Camera3D
@export var MAX_STEER = 1
@export var ENGINE_POWER = 2000
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
	if Input.is_action_pressed("drift") and Input.get_axis("ui_right","ui_left") != 0 and !drift:
		drift = true
		axis = Input.get_axis("ui_right","ui_left")
		steering = Input.get_axis("ui_right","ui_left")
		new_rotation = rotation_degrees
		old_position = position
		old_velocity = linear_velocity
	if Input.is_action_just_released("drift"):
		blwheel.wheel_friction_slip = 10.5
		brwheel.wheel_friction_slip = 10.5
		flwheel.wheel_friction_slip = 10.5
		frwheel.wheel_friction_slip = 10.5
		drift = false
		angular_velocity.y == 0

	if !drift:
		steering = move_toward(steering, Input.get_axis("ui_right","ui_left") * MAX_STEER, delta * 10)
		engine_force = Input.get_axis("ui_down","ui_up") * ENGINE_POWER
	else:
		linear_velocity = old_velocity
		blwheel.wheel_friction_slip = 0
		brwheel.wheel_friction_slip = 0	
		apply_torque_impulse(Vector3(0,10*Input.get_axis("ui_right","ui_left"),0))
		
func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	if drift and axis == 1:
		if Input.get_axis("ui_right","ui_left") == 1:
			var thing = clamp(rotation_degrees.y,0,new_rotation.y+75)
			rotation_degrees.y = thing
		if Input.get_axis("ui_right","ui_left") == 0:
			var thing = clamp(rotation_degrees.y,0,new_rotation.y+55)
			rotation_degrees.y = thing
		elif Input.get_axis("ui_right","ui_left") == -1:
			var thing = clamp(rotation_degrees.y,35,new_rotation.y+55)
			rotation_degrees.y = thing
	elif drift and axis == -1:
		if Input.get_axis("ui_right","ui_left") == -1:
			var thing = clamp(rotation_degrees.y,new_rotation.y-75,0)
			rotation_degrees.y = thing
			apply_central_impulse(Vector3(0,0,0))
		if Input.get_axis("ui_right","ui_left") == 0:
			var thing = clamp(rotation_degrees.y,new_rotation.y-55,0)
			rotation_degrees.y = thing
		elif Input.get_axis("ui_right","ui_left") == 1:
			var thing = clamp(rotation_degrees.y,new_rotation.y-55,-35)
			rotation_degrees.y = thing
	print(rotation_degrees.y)
