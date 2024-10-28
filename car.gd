extends VehicleBody3D
@onready var blwheel = $VehicleWheel3D4
@onready var brwheel = $VehicleWheel3D
@onready var flwheel = $VehicleWheel3D2
@onready var frwheel = $VehicleWheel3D3
@onready var camera = $Camera3D
@onready var capsule = $MeshInstance3D
@export var MAX_STEER = 1
@export var ENGINE_POWER = 4000

@export var DRIFT = 1
var drift
var old_rotation
var old_position
var old_velocity
var axis
var new_rotation
var zero = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	#print(rotation_degrees,rotation)
	#print(linear_velocity)

	
	if Input.is_action_pressed("drift") and Input.get_axis("ui_right","ui_left") != 0 and !drift:
		#Takes the all the cars positional and rotaitional data at the time of the drift
		drift = true
		axis = Input.get_axis("ui_right","ui_left")
		steering = Input.get_axis("ui_right","ui_left")
		old_rotation = global_rotation_degrees
		old_position = position
		old_velocity = linear_velocity
	if Input.is_action_just_released("drift"):
		#print(rotation_degrees.y)
		blwheel.wheel_friction_slip = 10.5
		brwheel.wheel_friction_slip = 10.5
		flwheel.wheel_friction_slip = 10.5
		frwheel.wheel_friction_slip = 10.5
		drift = false
		angular_velocity.y = 0

	engine_force = Input.get_axis("ui_down","ui_up") * ENGINE_POWER
	steering = move_toward(steering, Input.get_axis("ui_right","ui_left") * MAX_STEER, delta * 10)
	
		
		
func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	if drift:
		blwheel.wheel_friction_slip = 2.5
		brwheel.wheel_friction_slip = 2.5
		flwheel.wheel_friction_slip = 10.5
		frwheel.wheel_friction_slip = 10.5
		linear_velocity.z = old_velocity.z
		if axis == Input.get_axis("ui_right","ui_left"):
			apply_torque_impulse(Vector3(0,10*axis,0))
			global_rotation_degrees.y = clamp(global_rotation_degrees.y,[old_rotation.y+75*axis,old_rotation.y].min(),[old_rotation.y+75*axis,old_rotation.y].max())
		elif Input.get_axis("ui_right","ui_left") == 0:
			global_rotation_degrees.y = clamp(global_rotation_degrees.y,[old_rotation.y+75*axis,old_rotation.y+45*axis].min(),[old_rotation.y+75*axis,old_rotation.y+45*axis].max())
		elif axis == -Input.get_axis("ui_right","ui_left"):
			apply_torque_impulse(Vector3(0,5*axis,0))
			global_rotation_degrees.y = clamp(global_rotation_degrees.y,[old_rotation.y+45*axis,old_rotation.y].min(),[old_rotation.y+45*axis,old_rotation.y].max())
