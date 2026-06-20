extends Node

@onready var player_hp_label: Label = $UI/PlayerHPLabel
@onready var enemy_hp_label: Label = $UI/EnemyHPLabel
@onready var turn_label: Label = $UI/TurnLabel
@onready var spin_button: Button = $UI/SpinButton
@onready var result_label: Label = $UI/ResultLabel

var player_hp = 100
var enemy_hp = 100
var is_player_turn = true

func _ready():
	spin_button.pressed.connect(_on_spin_pressed)
	update_labels()
	start_player_turn()

func start_player_turn():
	is_player_turn = true
	turn_label.text = "Your turn"
	spin_button.disabled = false

func _on_spin_pressed():
	spin_button.disabled = true
	var attack_count = get_weighted_result()
	if attack_count == 0:
		result_label.text = "Spell failed!"
	else:
		var total_damage = attack_count * 10
		enemy_hp -= total_damage
		result_label.text = "Hit for " + str(total_damage) + " damage!"
	update_labels()
	check_win_loss()
	if enemy_hp > 0 and player_hp > 0:
		await get_tree().create_timer(1.0).timeout
		start_enemy_turn()

func start_enemy_turn():
	is_player_turn = false
	turn_label.text = "Enemy turn"
	var attack_count = get_weighted_result()
	if attack_count == 0:
		result_label.text = "Enemy spell failed!"
	else:
		var total_damage = attack_count * 8
		player_hp -= total_damage
		result_label.text = "Enemy hit you for " + str(total_damage) + " damage!"
	update_labels()
	check_win_loss()
	if enemy_hp > 0 and player_hp > 0:
		await get_tree().create_timer(1.0).timeout
		start_player_turn()

func get_weighted_result() -> int:
	var roll = randf() * 100
	if roll < 10: return 0
	elif roll < 35: return 1
	elif roll < 65: return 2
	elif roll < 90: return 3
	else: return 4

func update_labels():
	player_hp_label.text = "Player HP: " + str(player_hp)
	enemy_hp_label.text = "Enemy HP: " + str(enemy_hp)

func check_win_loss():
	if enemy_hp <= 0:
		turn_label.text = "You win!"
		spin_button.disabled = true
	elif player_hp <= 0:
		turn_label.text = "You lose!"
		spin_button.disabled = true
