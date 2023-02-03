extends KinematicBody2D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
var velocity = Vector2()
var velocityV = Vector2()
var dash_timer = 30
var speedo = 200
var dash_speed = 0
var state = 0
var dir = 1
onready var rhythm = get_parent()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:

	if speedo < 15:
		speedo = 15
	if state == 0:
		if Input.is_action_pressed("ui_left"):
			dir = -1
			velocity.x =-speedo
			move_and_slide(velocity)
		if Input.is_action_pressed("ui_right"):
			dir = 1
			velocity.x = speedo
			move_and_slide(velocity)
		if Input.is_action_pressed("ui_up"):
			velocityV.y =-speedo
			move_and_slide(velocityV)
		if Input.is_action_pressed("ui_down"):
			velocityV.y = speedo
			move_and_slide(velocityV)
	if Input.is_action_just_pressed("z"):
		if Input.is_action_pressed("ui_left"):
			dir = -1
		if Input.is_action_pressed("ui_right"):
			dir = 1
		state = 1
		velocity.x = 0
		dash_speed = speedo
		dash_timer = speedo*12
	if state == 1:
		dash_timer-=dash_speed
		if dash_timer > dash_speed/2:
			velocity.x = ((dash_speed*4)*dir)
			move_and_slide(velocity)

		if dash_timer <= dash_speed/1.2:
			velocity.x = (velocity.x - dash_speed)*dir
			
			move_and_slide(velocity)
		if velocity.x >= -60 and dir == -1:
			dash_end()
		elif velocity.x <= 60 and dir == 1:
			dash_end()

			
func dash_end():
			state = 0
			velocity.x = 0
			dash_timer = 30
			dash_speed = 0
