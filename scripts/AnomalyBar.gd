extends TextureProgressBar

@export var texRed: GradientTexture2D
@export var texYellow: GradientTexture2D
@export var texGreen: GradientTexture2D

var flash = false

# Called when the node enters the scene tree for the first time.
func _ready():
	setGreen()
	
func _process(delta):
	var count = get_tree().get_nodes_in_group("anomalies").size()
	if count > 0:
		setYellow(count)
	else:
		setGreen()

func setRed(text: String):
	flash = true
	texture_progress = texRed
	$Label.text = text

func setYellow(count: int):
	flash = true
	texture_progress = texYellow
	$Label.text = str(count) + " anomalies detected"

func setGreen():
	flash = false
	texture_progress = texGreen
	$Label.text = "All systems nominal"

func _on_timer_timeout():
	if flash:
		value = 0 if value else 100
	else:
		value = 100
