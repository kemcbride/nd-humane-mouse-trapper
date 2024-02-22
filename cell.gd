extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	var rng = RandomNumberGenerator.new()
	var anim_idx = rng.randi() % 4
	var rotation_idx = rng.randi() % 4
	$AnimatedSprite2D.play("cell%d" % anim_idx)
	$AnimatedSprite2D.rotate(rotation_idx * (PI / 2))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
