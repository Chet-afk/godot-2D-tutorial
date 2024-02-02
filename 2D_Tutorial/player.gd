extends Area2D

signal hit

# Export means this resource can be shown on the properties inspector
@export var speed = 400
var screen_size
# Called when the node enters the scene tree for the first time.
func _ready():
	#hide()
	# Get the window size
	screen_size = get_viewport_rect().size


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2.ZERO
	
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1

	if velocity.length() > 0:
		# Normalizing the velocity prevents speed gain when moving diagonally
		# Normalized sets the length to 1, allowing a constant speed.
		velocity = velocity.normalized() * speed
		# "$" is shorthand for get_node() call.
		# That is, this is saying "get_node("AnimatedSprite2D").play()"
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
	
	position += velocity * delta
	# Ensures the position is within the screen, that is, (0,0) and (screen.x, screen.y)
	position = position.clamp(Vector2.ZERO, screen_size)
	
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_v = velocity.y > 0
		


func _on_body_entered(body):
	hide()
	hit.emit()
	$CollisionShape2D.set_deferred("disabled", true)
	
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
