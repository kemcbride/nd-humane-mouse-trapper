extends Node2D

enum Difficulty {EASY = 0, MEDIUM = 1, HARD = 2}
enum Speed {SLOW = 8, NORMAL = 4, FAST = 2}

var GAME_DIFFICULTY = Difficulty.MEDIUM;
var SPEED = Speed.NORMAL;
# Called when the node enters the scene tree for the first time.
func _ready():
	if GAME_DIFFICULTY == Difficulty.EASY:
		SPEED = Speed.SLOW;
	elif GAME_DIFFICULTY == Difficulty.MEDIUM:
		SPEED = Speed.NORMAL;
	elif GAME_DIFFICULTY == Difficulty.HARD:
		SPEED = Speed.FAST;
		
	# This is where the main game setup will go, probably.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
