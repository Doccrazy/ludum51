extends ColorRect

var showCount = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	showCount = max(showCount - delta, 0)
	visible = showCount > 0

func showOverlay():
	showCount += 1.0
