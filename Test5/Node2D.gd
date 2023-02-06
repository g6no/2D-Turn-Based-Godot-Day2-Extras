extends Node2D
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var rand_num = randi() % 2
	print(rand_num)
