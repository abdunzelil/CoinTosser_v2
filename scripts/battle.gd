extends Node2D

var coin_tosses_left = 5
# @onready var animated_sprite_2d = $Outcome/AnimatedSprite2D
@onready var button1 = $Button
@onready var button2 = $Button2
@onready var button3 = $Button3
@onready var button4 = $Button4
@onready var button5 = $Button5
@onready var boss_hp = $Enemy/BossHPBar
@onready var coin_toss_button = $CoinTossButton
@onready var label = $CoinTossButton/Label
@onready var music = $AudioStreamPlayer
@onready var button1_audio = $Button/AudioStreamPlayer2D
@onready var button2_audio = $Button2/AudioStreamPlayer2D
@onready var button3_audio = $Button3/AudioStreamPlayer2D
@onready var button4_audio = $Button4/AudioStreamPlayer2D
@onready var button5_audio = $Button5/AudioStreamPlayer2D
@onready var boss_animation_player = $Enemy/AnimationPlayer
@onready var boss_hp_indicator_text = $Enemy/HPLabel


var button1_should_be_disabled = false
var button2_should_be_disabled = false
var button3_should_be_disabled = false
var button4_should_be_disabled = false
var button5_should_be_disabled = false


func _ready():
	$Player/PlayerHPBar.visible = false
	update_buttons()
	
func _on_coin_toss_button_pressed():
	coin_tosses_left -= 1
	label.text = str(coin_tosses_left) + " / 5"
	
	var outcome = flip_coin()
	update_outcome_history()
	update_buttons()

func flip_coin() -> String:
	var rand_num = randi() % 2
	var outcome = "Heads" if rand_num == 0 else "Tails"
	Global.add_outcome(outcome)
	return outcome

func update_outcome_history():
	pass

func set_texture_of_the_coin(index: int, outcome: String):
	var node_wanted = get_node("VBoxContainer/HBoxContainer2/HoT_Texture%s" % str(index + 1))
	if outcome == "Heads":
		node_wanted.texture = load("res://assets/heads.png")
	else:
		node_wanted.texture = load("res://assets/tails.png")
	
func update_coin_textures():
	if Global.outcomes.size() > 0:
		for i in range(Global.outcomes.size()):
			if Global.outcomes[Global.outcomes.size() - 1 - i] == "Heads":
				set_texture_of_the_coin(i, "Heads")
			elif Global.outcomes[Global.outcomes.size() - 1 - i] == "Tails":
				set_texture_of_the_coin(i, "Tails")
	else:
		for i in range(5):
			var node_wanted = get_node("VBoxContainer/HBoxContainer2/HoT_Texture%s" % str(i + 1))
			node_wanted.texture = null
		
func update_buttons():
	# Check if the recent outcomes match the required sequences for each button.
	update_outcome_history()
	update_coin_textures()
	$Player/HPLabel.text = str($Player/PlayerHPBar.value)
	coin_toss_button.disabled = coin_tosses_left <= 0
	label.text = str(coin_tosses_left) + " / 5"
	if button1_should_be_disabled:
		button1.disabled = true
	else:
		button1.disabled = not has_recent_sequence(["Heads"])
		
	if button2_should_be_disabled:
		button2.disabled = true
	else:
		button2.disabled = not has_recent_sequence(["Heads", "Heads"])
	
	if button3_should_be_disabled:
		button3.disabled = true
	else:
		button3.disabled = not has_recent_sequence(["Heads", "Heads", "Heads"])
		
	if button4_should_be_disabled:
		button4.disabled = true
	else:
		button4.disabled = not has_recent_sequence(["Tails"])
		
	if button5_should_be_disabled:
		button5.disabled = true
	else:
		button5.disabled = not has_recent_sequence(["Heads", "Tails"])
		
	$Button/Chains.visible = button1_should_be_disabled
	$Button2/Chains2.visible = button2_should_be_disabled
	$Button3/Chains3.visible = button3_should_be_disabled
	$Button4/Chains4.visible = button4_should_be_disabled
	$Button5/Chains5.visible = button5_should_be_disabled

func has_recent_sequence(sequence: Array) -> bool:
	# This function checks if the most recent outcomes match the given sequence.
	var count = sequence.size()
	if Global.outcomes.size() < count:
		return false
	for i in range(count):
		if Global.outcomes[i] != sequence[count - i - 1]:
			return false
	return true


func _on_button_pressed():
	button1_audio.play()
	boss_hp.value -= 5
	boss_hp_indicator_text.text = str(boss_hp.value)
	boss_animation_player.play("take_damage")
	button1_should_be_disabled = true
	Global.outcomes = []
	update_buttons()

func _on_button_2_pressed():
	button2_audio.play()
	boss_hp.value -= 15
	boss_hp_indicator_text.text = str(boss_hp.value)
	boss_animation_player.play("take_damage")
	button2_should_be_disabled = true
	Global.outcomes = []
	update_buttons()

func _on_button_3_pressed():
	button3_audio.play()
	boss_hp.value -= 25
	boss_hp_indicator_text.text = str(boss_hp.value)
	boss_animation_player.play("take_damage")
	button3_should_be_disabled = true
	Global.outcomes = []
	update_buttons()
	
func _on_button_4_pressed():
	button4_audio.play()
	boss_hp.value -= 25
	boss_hp_indicator_text.text = str(boss_hp.value)
	boss_animation_player.play("take_damage")
	button4_should_be_disabled = true
	Global.outcomes = []
	update_buttons()
	
func _on_button_5_pressed():
	button5_audio.play()
	boss_hp.value -= 25
	boss_hp_indicator_text.text = str(boss_hp.value)
	boss_animation_player.play("take_damage")
	button5_should_be_disabled = true
	Global.outcomes = []
	update_buttons()


func _on_end_turn_pressed():
	$Player/PlayerHPBar.value -= 10
	coin_tosses_left = 5
	Global.outcomes = []
	button1_should_be_disabled = false
	button2_should_be_disabled = false
	button3_should_be_disabled = false
	button4_should_be_disabled = false
	button5_should_be_disabled = false
	update_buttons()
