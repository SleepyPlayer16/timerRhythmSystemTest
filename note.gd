extends Sprite


onready var scr = get_parent()
var strumtime = 0.0
var advance = false
var note_id = 0
var layer = -1
var can_be_hit = true
var on_hold = false
var scroll_speed = 150
var safezone = 0.2
var hit_at = 0.0
var last_hit_index = null
var next_note = 0
var closeness = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	modulate.a = 1
	next_note = scr.noteloop[note_id+1]
#	print("Strumtime= ",strumtime)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if scr.time <=strumtime:
		modulate.a = -((strumtime-1.8)-scr.time)*2
	elif scr.time >=strumtime:
		modulate.a -= 0.04
	
	if advance == true:
		position.x = 480 + (strumtime-scr.time)*scroll_speed

	if Input.is_action_just_pressed("z") and !on_hold:
		if (scr.time <= strumtime+safezone and scr.time >= strumtime-safezone):
			scr.receptor_animation.seek(0.0,true)
			scr.receptor_animation.play("Hit")
			scr.metronome.play()
			if !on_hold:
				hit_at = scr.time
				can_be_hit = false
				on_hold = true
			$AnimationPlayer.play("Hit")
	if modulate.a <= 0 and scr.time >=strumtime:
		queue_free()


	if on_hold:
		advance = false
		position.x = 480
		if !$AnimationPlayer.is_playing():
			queue_free()
#	pass
