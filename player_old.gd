extends Area2D
signal hit

@export var speed = 20 # How fast the player will move
@export var max_speed = 500 # How fast the player can move 
@export var fly_speed = 30 # How fast the player will fly upwards when holding fly/jump
@export var max_fly_speed = -500 # How fast the player can fly upwards when holding fly/jump
@export var h_friction = 3 #how much to slow down horizontally each frame
@export var grav = 15 #force due to gravity
@export var max_fallspeed = 500

var screen_size # Size of the game window.
var velocity = Vector2.ZERO # The player's movement vector.


func _ready():
	screen_size = get_viewport_rect().size

func _process(delta):
	#var velocity = Vector2.ZERO 
	if velocity.x > 0:
		velocity.x -= h_friction
	elif velocity.x < 0:
		velocity.x += h_friction
	
	if Input.is_action_pressed("move_right"):
		velocity.x += speed
	if Input.is_action_pressed("move_left"):
		velocity.x -= speed
	if Input.is_action_pressed("jump"):
		velocity.y -= fly_speed
	
	if velocity.x > max_speed:
		velocity.x = max_speed
	elif velocity.x < -1 * max_speed:
		velocity.x = -1 * max_speed
	
	#gravity
	velocity.y += grav
	
	if velocity.y > max_fallspeed:
		velocity.y = max_fallspeed
	if velocity.y < max_fly_speed:
		velocity.y = max_fly_speed
	if velocity.length() > 0:
		#velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	if velocity.x != 0:
		#$AnimatedSprite2D.animation = "walk"
		#$AnimatedSprite2D.flip_v = false
		# See the note below about the following boolean assignment.
		$AnimatedSprite2D.flip_h = velocity.x < 0


func _on_body_entered(body):
	if body.y < position.y:
		hide() # Player disappears after being hit.
		hit.emit()
		# Must be deferred as we can't change physics properties on a physics callback.
		$CollisionShape2D.set_deferred("disabled", true)
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
