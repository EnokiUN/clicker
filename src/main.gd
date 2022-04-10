extends Control

var cash: int = 0
var clicked: int = 0
var rng: RandomNumberGenerator = RandomNumberGenerator.new()
export var mincash: int = 0
export var maxcash: int = 100
var counting: bool = false
var elapsed: float = 0

onready var coin_label = $"CoinLabel"
onready var timer_label = $"TimeLabel"

func _ready():
	rng.randomize()

func _process(delta):
	if counting:
		elapsed += delta
		timer_label.text = "Time: %.2fs\nClicks: %d\nCPS: %.2fs\nAVG coins/click: %.2fs SusCoins" % [elapsed, clicked, clicked / elapsed, float(cash) / clicked]

func _on_MoneyButton_pressed():
	if !counting:
		counting = true
	cash += rng.randi_range(mincash, maxcash)
	clicked += 1
	if cash >= 10_000:
		counting = false
	coin_label.text = "%d SusCoins" % cash