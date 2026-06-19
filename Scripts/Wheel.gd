extends Control

@onready var spin_button: Button = $spin_button
@onready var result_label: Label = $result_label


var spinning = false

func _ready():
	spin_button.pressed.connect(_on_spin_pressed)

func _on_spin_pressed():
	if spinning:
		return
	spinning = true
	spin_button.disabled = true
	await spin_wheel()
	spinning = false
	spin_button.disabled = false

func spin_wheel() -> int:
	# fake "spinning" visual: show random numbers fast
	var spin_duration = 0.8
	var elapsed = 0.0
	var interval = 0.05
	while elapsed < spin_duration:
		result_label.text = str(randi_range(0, 4))
		await get_tree().create_timer(interval).timeout
		elapsed += interval
		# final real result, using your weighted odds
	var final_result = get_weighted_result()
	result_label.text = str(final_result)
	return final_result

func get_weighted_result() -> int:
	var roll = randf() * 100
	if roll < 10:
		return 0
	elif roll < 35:
		return 1
	elif roll < 65:
		return 2
	elif roll < 90:
		return 3
	else:
		return 4
