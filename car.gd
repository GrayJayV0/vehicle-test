extends VehicleBody3D
@onready var blwheel = $VehicleWheel3D4
@onready var brwheel = $VehicleWheel3D
@onready var flwheel = $VehicleWheel3D2
@onready var frwheel = $VehicleWheel3D3
@export var MAX_STEER = 1
@export var ENGINE_POWER = 800


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	steering = move_toward(steering, Input.get_axis("ui_right","ui_left") * MAX_STEER, delta * 10)
	engine_force = Input.get_axis("ui_down","ui_up") * ENGINE_POWER
	if Input.is_action_pressed("drift") :
		blwheel.wheel_friction_slip = 0
		brwheel.wheel_friction_slip = 0
		
	if Input.is_action_just_released("drift"):
		blwheel.wheel_friction_slip = 10.5
		brwheel.wheel_friction_slip = 10.5
		
		
