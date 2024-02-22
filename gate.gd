extends Node2D

enum State {OPEN, CLOSED}
var STATE = State.OPEN # All gates default open.

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_2d_input_event(viewport, event, shape_idx):
	if (event is InputEventMouseButton && event.pressed):
		$AnimationPlayer.play(get_next_animation())
		toggle_state()
		
		
func get_next_animation():
	if STATE == State.OPEN:
		return "close"
	return "open"
	
func toggle_state():
	if STATE == State.OPEN:
		STATE = State.CLOSED
	else:
		STATE = State.OPEN
