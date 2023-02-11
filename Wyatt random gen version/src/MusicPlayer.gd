extends AudioStreamPlayer

# Note: Must be mono.  Wave and ogg are treated differently.
#       See Utils.playAudio for details on format and mix rate.
var RNG = RandomNumberGenerator.new()

var currMusicFile : String
func playAudio(fname, vol : float):
	var newMusicFile = fname
	if newMusicFile != currMusicFile:
		currMusicFile = newMusicFile
		stream = Util.getAudio("Assets/audio/%s" % fname)
		stop()
		play()
	volume_db = vol
#	if mfile != null:
#		mainTimer = Timer.new()
#		mainTimer.set_wait_time(2) # It won't play this often, that will be randomized
#		mainTimer.connect("timeout", self, "playMainMusic")
#		add_child(mainTimer)
#		mainTimer.start()

var mainTimer : Timer
var mfile
var mvol : float
func setMainMusic(fname, vol : float):
	mfile = fname
	mvol = vol
func playMainMusic():
	if mainTimer != null:
		mainTimer.stop()
	stream = Util.getAudio("Assets/audio/%s" % mfile)
	stop()
	play()
	volume_db = mvol

func _ready():
	RNG.randomize()
	pause_mode = Node.PAUSE_MODE_PROCESS
	# Timer for footsteps which play when you start moving and every so often in between
	walkTimer = Timer.new()
	walkTimer.set_wait_time(TIMER_FREQ) # It won't play this often, that will be randomized
	walkTimer.connect("timeout", self, "isWalking")
	add_child(walkTimer)
	walkTimer.start()

func play_pickup():
	var rnd = RNG.randi_range(1, 2)
	playAudio("Chipmunk_React%d.wav" % rnd, -8.0)

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
#		playAudio("Chipmunk_Footsteps.wav", -1.0)
		next_walk = RNG.randf_range(1.0, 4.0)

## Resume functions
#func _resume_field():
#	play_field_theme()
#	audioTimer.stop()
