extends TextureProgressBar

@export var texRed: GradientTexture2D
@export var texYellow: GradientTexture2D
@export var texGreen: GradientTexture2D

# Called when the node enters the scene tree for the first time.
func _ready():
	setGreen()
	
func _process(delta):
	var count = get_tree().get_nodes_in_group("enemies").size()
	if count > 0:
		setRed("Enemies nearby")
	elif Global.isSpawning():
		setRed("Enemy alerted")
	else:
		setYellow()

func setRed(text: String):
	texture_progress = texRed
	$Label.text = text

func setYellow():
	texture_progress = texYellow
	$Label.text = "Anomalies detected"

func setGreen():
	texture_progress = texGreen
	$Label.text = "All systems nominal"

func _on_timer_timeout():
	value = 0 if value else 100
