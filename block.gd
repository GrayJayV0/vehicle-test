extends RigidBody3D
@onready var grounded := $Grounded

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if grounded.is_colliding():
		#This vector is broken its missing a value needed to allow jumping
		#Vectors are writen in (x,y,z) what value needs to be changed to allow jumping
		apply_impulse(Vector3(0,1,0))
