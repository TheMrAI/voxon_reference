extends Camera3D

var speed = 1.0; # m/s
var pitch_rad = 0.0;
var roll_rad = 0.0;
var yaw_rad = 0.0;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func recalculate_quaternion() -> void:
	var pitch = Quaternion(Vector3.RIGHT, pitch_rad).normalized()
	var roll = Quaternion(Vector3.FORWARD, roll_rad).normalized()
	var yaw = Quaternion(Vector3.UP, yaw_rad).normalized()
	
	quaternion = roll * yaw * pitch

func _input(event: InputEvent) -> void:
	# Only handle any input events if we are navigating.
	if not Input.is_action_pressed("navigating"):
		return
	
	if event is InputEventMouseMotion:
		yaw_rad += -event.relative.x / 50.0;
		pitch_rad += -event.relative.y / 50.0;
	if event.is_action("speed_up"):
		speed += log(speed + 1.0) / 2.0
		speed = clamp(speed, 0.1, 30.0)
	if event.is_action("slow_down"):
		speed -= log(speed + 1.0) / 2.0
		speed = clamp(speed, 0.1, 30.0)
	#if event is InputEventJoypadMotion:
		#print("Joypad ", event)
		#if event.axis == 2:
			#yaw_rad += -event.axis_value / 50.0;
		#if event.axis == 3:
			#pitch_rad += -event.axis_value / 50.0;
	recalculate_quaternion()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Only handle any input events if we are navigating.
	if not Input.is_action_pressed("navigating"):
		return
	
	var scaler = delta * speed
	if Input.is_action_pressed("boost_speed"):
		scaler *= 3.0

	if Input.is_action_pressed("move_forward"):
		position += scaler * (quaternion * Vector3.FORWARD)
	if Input.is_action_pressed("move_backward"):
		position -= scaler * (quaternion * Vector3.FORWARD)
	if Input.is_action_pressed("pan_up"):
		position += scaler * (quaternion * Vector3.UP)
	if Input.is_action_pressed("pan_down"):
		position -= scaler * (quaternion * Vector3.UP)
	if Input.is_action_pressed("pan_right"):
		position += scaler * (quaternion * Vector3.RIGHT)
	if Input.is_action_pressed("pan_left"):
		position -= scaler * (quaternion * Vector3.RIGHT)
		
