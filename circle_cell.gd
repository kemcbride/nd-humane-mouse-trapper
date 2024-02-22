extends Node2D

enum Direction {HORIZONTAL = 0, VERTICAL = 1}
var DIR_STATE = Direction.HORIZONTAL  # Vertical. I wish I knew how to do shared constants LOL

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_area_2d_input_event(viewport, event, shape_idx):
	if (event is InputEventMouseButton && event.pressed):
		$AnimationPlayer.play("rotate_%s" % get_rotation_direction())
		toggle_dir_state()
		
		
func get_rotation_direction():
	if DIR_STATE == Direction.HORIZONTAL:
		return "counterclockwise"
	return "clockwise"
	
func toggle_dir_state():
	if DIR_STATE == Direction.HORIZONTAL:
		DIR_STATE = Direction.VERTICAL
	else:
		DIR_STATE = Direction.HORIZONTAL
