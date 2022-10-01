extends Timer


# Called when the node enters the scene tree for the first time.
func _ready():
	timeout.connect(_on_timeout)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_timeout():
	get_parent().visible = !get_parent().visible
