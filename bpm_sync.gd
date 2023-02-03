extends Panel

const BPM = 135
const BARS = 4
const TRUEBPS = 60.0/BPM
const BPS = BPM/60.0
var song_chart = "res://testSong.json"
var note = {}
var noteloop = []
var cur_note = 0
onready var noteScene = load("res://note.tscn")
var id
var begin_song = false
var time = 0.0
var number_of_notes = null

var time_of_loop = 0.0
var playing = false
var layer = -1
const COMPENSATE_FRAMES = 2
const COMPENSATE_HZ = 60.0
var show_in_advance = 4
var begin_at = null

var time_begin2 = 0
var time_delay2 = 0
var secondary_time = 0.0

enum SyncSource {
	SYSTEM_CLOCK,
	SOUND_CLOCK,
}

var curr_note_by_time = 0

var sync_source = SyncSource.SYSTEM_CLOCK

onready var receptor_animation = $SprReceptor/AnimationPlayer

# Used by system clock.
var time_begin
var time_delay
var show_notes = 1
onready var metronome = $Player

var countdown = true

func _ready() -> void:
	_load()
	set_physics_process_internal(true)
	begin_at = note["notes"][str(show_in_advance)]

	$Node2D.speedo = 15
	time-=TRUEBPS*4
	for i in range(0,note["notes"].size()):
		noteloop.append(note["notes"][str(i)])
	number_of_notes = noteloop.size()

func strsec(secs):
	var s = str(secs)
	if (secs < 10):
		s = "0" + s
	return s

func _process(_delta: float):
	print(number_of_notes)
	$RichTextLabel.text = "cur_note = " + str(cur_note)
	if sync_source == SyncSource.SYSTEM_CLOCK and begin_song:
		#time = (OS.get_ticks_usec() - time_begin) / 1000000.0
		#time -= time_delay
		time = $AudioStreamPlayer.get_playback_position() + AudioServer.get_time_since_last_mix()
		time -= AudioServer.get_output_latency()
	if !begin_song:
		time += _delta

	if time >= 0.0 and !begin_song:
		$AudioStreamPlayer.play()
		sync_source = SyncSource.SYSTEM_CLOCK
		time_begin = OS.get_ticks_usec()
		time_delay = AudioServer.get_time_to_next_mix() + AudioServer.get_output_latency()
		playing = true
		begin_song = true
	if (time+begin_at) >= noteloop[cur_note] and cur_note != noteloop.size()-1:
#		noteloop.append(noteloop.back()+TRUEBPS)
#		number_of_notes = noteloop.size()
		spawn_note()
		
	if Input.is_action_just_pressed("r"):
		get_tree().reload_current_scene()

	if not playing or not $AudioStreamPlayer.playing:
		return


func _on_PlaySystem_pressed():
	cur_note = 0
	sync_source = SyncSource.SYSTEM_CLOCK
	time_begin = OS.get_ticks_usec()
	time_delay = AudioServer.get_time_to_next_mix() + AudioServer.get_output_latency()
	playing = true
	$AudioStreamPlayer.play(0)

func _on_PlaySound_pressed():
	sync_source = SyncSource.SOUND_CLOCK
	playing = true
	$AudioStreamPlayer.play()
	
func _metronomePlay():
	time_begin2 = OS.get_ticks_usec()
	time_delay2 = AudioServer.get_time_to_next_mix() + AudioServer.get_output_latency()
	metronome.play()

func _load():
	var file = File.new()
	file.open(song_chart, File.READ)
	var data = parse_json(file.get_as_text())
	note = data
	
func spawn_note():
		id = noteScene.instance()
		id.strumtime = noteloop[cur_note]
		id.advance = true
		id.note_id = cur_note
		if cur_note < number_of_notes-1:
			cur_note+=1
		add_child(id)
