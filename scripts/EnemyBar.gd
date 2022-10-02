extends TextureProgressBar

@export var texRed: GradientTexture2D
@export var texYellow: GradientTexture2D
@export var texGreen: GradientTexture2D

var flash = false

# Called when the node enters the scene tree for the first time.
func _ready():
	setGreen()
	
func _process(delta):
	var count = get_tree().get_nodes_in_group("enemies").size()
	if count > 0:
		setRed()
	elif Global.isSpawning():
		setYellow()
	else:
		setGreen()

func setRed():
	flash = true
	texture_progress = texRed
	$Label.text = "Enemies nearby"

func setYellow():
	flash = true
	texture_progress = texYellow
	$Label.text = "Enemy alerted"

func setGreen():
	flash = false
	texture_progress = texGreen
	$Label.text = "All clear"

func _on_timer_timeout():
	if flash:
		value = 0 if value else 100
	else:
		value = 100
