extends VehicleBody3D
@onready var blwheel = $VehicleWheel3D4
@onready var brwheel = $VehicleWheel3D
@onready var flwheel = $VehicleWheel3D2
@onready var frwheel = $VehicleWheel3D3
@export var MAX_STEER = 1
@export var ENGINE_POWER = 2000
var drift

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("drift") and Input.get_axis("ui_right","ui_left") != 0 and drift != true:
		drift = true
		steering = Input.get_axis("ui_right","ui_left")
		engine_force = 0
		var rotation = rotation_degrees
		var new_rotation = clamp(rotation_degrees.z,rotation.z-45,rotation.z+45)
		print(new_rotation)
		
	if Input.is_action_just_released("drift"):
		blwheel.wheel_friction_slip = 10.5
		brwheel.wheel_friction_slip = 10.5
		flwheel.wheel_friction_slip = 10.5
		frwheel.wheel_friction_slip = 10.5
		drift = false
		
		
	if drift != true:
		steering = move_toward(steering, Input.get_axis("ui_right","ui_left") * MAX_STEER, delta * 10)
		engine_force = Input.get_axis("ui_down","ui_up") * ENGINE_POWER
	elif drift == true:
		engine_force = 0
		blwheel.wheel_friction_slip = 0
		brwheel.wheel_friction_slip = 0	
		apply_torque_impulse(Vector3(0,20*Input.get_axis("ui_right","ui_left"),0))

		
		
		
