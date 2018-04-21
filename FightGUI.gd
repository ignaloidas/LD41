extends HBoxContainer

var player_clicks=0
var enemy_clicks=0
var player_turn=true
var fight_started=false
export var WIN_POINTS=100
export var MAX_TURN_TIME=5

signal fight_start
signal player_click
signal next_turn

func _ready():
	$PlayerProgress/TextureProgress.max_value=WIN_POINTS
	$EnemyProgress/TextureProgress.max_value=WIN_POINTS
	$VBoxContainer/PlayerTurn.max_value = MAX_TURN_TIME
	$VBoxContainer/EnemyTurn.max_value = MAX_TURN_TIME

func _process(delta):
	$EnemyProgress/TextureProgress.value=enemy_clicks
	$PlayerProgress/TextureProgress.value = player_clicks
	$VBoxContainer/Player/TextureButton/PlayerScoreLabel.text = str(player_clicks)
	$VBoxContainer/Enemy/TextureRect/PlayerScoreLabel.text = str(enemy_clicks)
	if player_turn:
		$VBoxContainer/PlayerTurn.value=$TurnTimer.time_left
	else:
		$VBoxContainer/EnemyTurn.value=$TurnTimer.time_left

func _input(event):
	if fight_started:
		if event.is_action_pressed('fight_click_1') or event.is_action_pressed('fight_click_2') or event.is_action_pressed('fight_click_3') or event.is_action_pressed('fight_click_4'):
			_on_Player_click()

func _on_Player_click():
	emit_signal('player_click')

func _on_CountdownTimer1_timeout():
	$CountdownTimer2.start()
	$VBoxContainer/Art/TextureButton.texture_normal = preload("res://assets/countdown_2.png")


func _on_CountdownTimer2_timeout():
	$CountdownTimer3.start()
	$VBoxContainer/Art/TextureButton.texture_normal = preload("res://assets/countdown_1.png")


func _on_CountdownTimer3_timeout():
	$VBoxContainer/Art/TextureButton.texture_normal = preload("res://assets/fight.png")
	$VBoxContainer/Art/TextureButton.disabled = true
	$VBoxContainer/Player/TextureButton.disabled = false
	fight_started=true
	$TurnTimer.wait_time=rand_range(1,11)
	$TurnTimer.start()

func _on_ReadyButton_pressed():
	$CountdownTimer1.start()
	$VBoxContainer/Art/TextureButton.disabled = true
	$VBoxContainer/Art/TextureButton.texture_normal = preload("res://assets/countdown_3.png")

func _on_TurnTimer_timeout():
	player_turn=!player_turn
	emit_signal('next_turn')

func set_turn_lenght(time):
	$TurnTimer.wait_time = time

func enemy_click():
	enemy_clicks+=1
	
func player_click():
	player_clicks+=1