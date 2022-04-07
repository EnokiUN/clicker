extends Button

export var cash: int = 0
var rng = RandomNumberGenerator.new()

onready var label = get_node("../Label")

func _ready():
	rng.randomize()

func _on_Button_pressed():
	cash += rng.randi_range(1, 100)
	label.text = "%d SusCoin" % cash
