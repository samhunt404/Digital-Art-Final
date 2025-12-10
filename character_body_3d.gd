extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const MOUSE_SENS = 0.005
var pause := false
@onready var camera = $Camera3D

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if(Input.is_action_just_pressed("ui_pause")):
		pause = !pause
		print("PAusing")
	if(pause):
		#disable input
		return
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("walk_left", "walk_right", "walk_forward", "walk_backwards")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	move_and_slide()

func _input(event: InputEvent) -> void:

	if(pause):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		return
	else:
		Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	
	if(event is InputEventMouseMotion):
		rotation.y += event.relative.x * -MOUSE_SENS
		camera.rotation.x += event.relative.y * -MOUSE_SENS
		
		camera.rotation.x = clamp(camera.rotation.x, -PI/2.0,PI/2.0)
