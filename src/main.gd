extends Control


const STAT_STRING: String = "Time: %.2fs\nClicks: %d\nCPS: %.2fs\nAVG coins/click: %.2fs SusCoins"

export var mincash: int = 0
export var maxcash: int = 100
var cash: int = 0
var clicked: int = 0
var rng: RandomNumberGenerator = RandomNumberGenerator.new()
var counting: bool = false
var elapsed: float = 0
var events: int = 0

onready var coin_label: Label = $CoinLabel
onready var notification_label: Label = $NotificationLabel
onready var timer_label: Label = null
onready var stat_scroll: ScrollContainer = $StatScroll
onready var stat_label_container: VBoxContainer = $StatScroll/StatLabelContainer
onready var button: TextureButton = $MoneyButton


func _ready():
	rng.randomize()


func _process(delta):
	if counting:
		elapsed += delta
		var cps: float = float(clicked) / elapsed
		timer_label.text = STAT_STRING % [elapsed, clicked, cps, float(cash) / clicked]


func _on_MoneyButton_pressed():
	if !counting:
		counting = true
		create_label()
	var increase = rng.randi_range(mincash, maxcash)
	increase_cash(increase)
	if increase % 2 == 0 and cash % 7 == 0 and cash % 11 == 0:
		random_event()
	clicked += 1
	if cash >= 10_000:
		reset()


func _on_RestartButton_pressed():
	reset()


func create_label():
	if len(stat_label_container.get_children()) > 0:
		var seperator: HSeparator = HSeparator.new()
		stat_label_container.add_child(seperator)
		stat_label_container.move_child(seperator, 0)
	timer_label = Label.new()
	timer_label.rect_min_size = Vector2(stat_scroll.rect_size.x, 0)
	timer_label.autowrap = true
	stat_label_container.add_child(timer_label)
	stat_label_container.move_child(timer_label, 0)


func random_event():
	events += 1
	match rng.randi_range(0, 10):
		0:
			increase_cash(cash * 0.1)
			notify("You found a 10% bonus!")
		1:
			var screen_size = get_viewport().get_visible_rect().size
			button.set_position(Vector2(rng.randi_range(0, screen_size.x - button.rect_size.x), rng.randi_range(0, screen_size.y - button.rect_size.y)))
			notify("Button moved around :trol:")
		3:
			if rng.randi_range(0, 2) == 0:
				reset()
				notify("Yo, take a break (I reset your coins for you)")
		4:
			increase_cash(-(cash / 2))
			notify("Hippity hoppity half your money is now my property")
		5:
			if button.disabled:
				return
			notify("Chill bruv, imma disable the button for a bit")
			button.disabled = true
			yield(get_tree().create_timer(rng.randi_range(1, 5)), "timeout")
			button.disabled = false
			notify("Button is back to normal")
		_:
			pass


func reset():
	counting = false
	cash = 0
	elapsed = 0
	clicked = 0
	coin_label.text = "0 SusCoins"


func increase_cash(amount: int):
	cash += amount
	coin_label.text = "%d SusCoins" % cash


func notify(message: String):
	notification_label.text = message
	notification_label.visible = true
	var label = Label.new()
	label.rect_min_size = Vector2(stat_scroll.rect_size.x, 0)
	label.text = "%.2f: %s" % [elapsed, message]
	label.autowrap = true
	stat_label_container.add_child(label)
	stat_label_container.move_child(label, 1)
	var last_events = events
	yield(get_tree().create_timer(5), "timeout")
	if events == last_events:
		notification_label.visible = false

