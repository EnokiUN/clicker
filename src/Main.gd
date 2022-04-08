extends Control

export var cash: int = 0
var rng: RandomNumberGenerator = RandomNumberGenerator.new()
var counting: bool = false
var elapsed: float = 0

onready var coin_label = $"CoinLabel"
onready var timer_label = $"TimeLabel"

func _ready():
	rng.randomize()

func _process(delta):
	if counting:
		elapsed += delta
		timer_label.text = "Time: %.2f" % elapsed

func _on_MoneyButton_pressed():
	if !counting:
		counting = true
	cash += rng.randi_range(1, 100)
	if cash >= 10_000:
		counting = false
	coin_label.text = "%d SusCoins" % cash
