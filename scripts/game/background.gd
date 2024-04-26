extends Sprite2D

@export var backgrounds_path: Array = [
	"res://assets/backgrounds/City1/City1.png",
	"res://assets/backgrounds/City2/City2.png",
	"res://assets/backgrounds/City3/City3.png",
	"res://assets/backgrounds/City4/City4.png"
]

func _init():
	set_texture(load(backgrounds_path[randi() % backgrounds_path.size()]))
