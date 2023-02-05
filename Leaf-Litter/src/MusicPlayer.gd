extends AudioStreamPlayer

# Note: Must be mono.  Wave and ogg are treated differently.
#       See Utils.playAudio for details on format and mix rate.
var RNG = RandomNumberGenerator.new()

var currMusicFile : String
func playAudio(fname, vol : float):
	var newMusicFile = fname
	if newMusicFile != currMusicFile:
		currMusicFile = newMusicFile
		stream = Util.getAudio("Assets/%s" % fname)
		stop()
		volume_db = vol
		play()

func _ready():
	RNG.randomize()
	pause_mode = Node.PAUSE_MODE_PROCESS
	# Timer for footsteps which play when you start moving and every so often in between
	walkTimer = Timer.new()
	walkTimer.set_wait_time(TIMER_FREQ) # It won't play this often, that will be randomized
	walkTimer.connect("timeout", self, "isWalking")
	add_child(walkTimer)
	walkTimer.start()

## Interface functions
func play_field_theme():
	playAudio("field_theme", -12)

func play_pickup():
	var rnd = RNG.randi_range(1, 2)
	playAudio("Chipmunk_React" + rnd + ".wav", -8.0)

var walkTimer
const TIMER_FREQ = 0.1
var walking : bool = false
var next_walk : float = 0.0 # Seconds to play next sound
func play_walking():
	walking = true
func stop_walking():
	walking = false
	next_walk = 0.5 # Wait at least this long before playing the sound again

func isWalking():
	if next_walk > 0:
		next_walk -= TIMER_FREQ
	elif walking:
		print("play audio")
		playAudio("Chipmunk_Footsteps.wav", -8.0)
		next_walk = RNG.randf_range(1.0, 4.0)

## Resume functions
#func _resume_field():
#	play_field_theme()
#	audioTimer.stop()
