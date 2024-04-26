extends VBoxContainer

class_name LifeBar

@onready var progress_bar = $TextureProgressBar
@onready var label = $Label

var target: float

func init(max_hp: float):
    target = max_hp
    $TextureProgressBar.set_max(max_hp)
    $TextureProgressBar.set_value(max_hp)
    $Label.text = str(max_hp) + '/' + str(max_hp)

func flip(flipped: bool):
    if flipped:
        set_layout_direction(Control.LAYOUT_DIRECTION_RTL)
        progress_bar.set_fill_mode(TextureProgressBar.FILL_RIGHT_TO_LEFT)
    else:
        set_layout_direction(Control.LAYOUT_DIRECTION_LTR)
        progress_bar.set_fill_mode(TextureProgressBar.FILL_LEFT_TO_RIGHT)

func _process(_delta):
    progress_bar.set_value(max(progress_bar.value-progress_bar.step, target) if progress_bar.value>target else min(progress_bar.value+progress_bar.step, target))
    var ratio = progress_bar.value / progress_bar.max_value
    if (ratio > 0.5): progress_bar.tint_progress = Color.GREEN
    elif (ratio > 0.25): progress_bar.tint_progress = Color.ORANGE
    else: progress_bar.tint_progress = Color.RED
    label.text = str(ceil(progress_bar.value)) + '/' + str(progress_bar.max_value)
