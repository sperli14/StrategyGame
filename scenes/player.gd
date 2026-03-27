extends CharacterBody2D


const SPEED = 350.0
const JUMP_VELOCITY = -400.0
const FLAP_VELOCITY = -40.0
const MAX_FLIGHT_SPEED = -600.0
const MAX_FALL_SPEED = 700.0
const CEILING_BOUNCE = 0.8 #how elastic are collisions with ceiling - 1 = elastic

@onready var screen_size = [2050, 1200]#DisplayServer.screen_get_size()#get_viewport_rect().size

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	if is_on_ceiling() and velocity.y < -10:
		velocity.y = velocity.y * -1 * CEILING_BOUNCE
	# Handle jump.
	#if Input.is_action_just_pressed("ui_accept"):
	if Input.is_action_pressed("ui_accept"):
		if is_on_floor():
			velocity.y = JUMP_VELOCITY
		else:
			velocity.y += FLAP_VELOCITY
	if velocity.y < MAX_FLIGHT_SPEED:
		velocity.y = MAX_FLIGHT_SPEED
	if velocity.y > MAX_FALL_SPEED:
		velocity.y = MAX_FALL_SPEED
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	position.x = wrapf(position.x, -1*screen_size[0], screen_size[0])
	position.y = wrapf(position.y, -1*screen_size[1], screen_size[1])
	move_and_slide()
