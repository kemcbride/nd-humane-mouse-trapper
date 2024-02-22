extends Node2D

var BEAT = 0;
# Called when the node enters the scene tree for the first time.
func _ready():
	$MousePlayer.play("Rock")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_timer_timeout():
	BEAT = (BEAT + 1) % 4;
