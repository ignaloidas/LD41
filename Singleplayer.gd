extends Node

var player_clicks_this_turn=0
var turn_lenght=0

signal main_menu

func _ready():
	randomize()

func _process(delta):
	pass

func _on_Fight_player_click():
	if $Fight.player_turn:
		$Fight.player_click()
		player_clicks_this_turn+=1
	else:
		$Fight.enemy_click()
		player_clicks_this_turn+=1
	if $Fight.player_clicks>=$Fight.WIN_POINTS:
		$Fight.queue_free()
		$AIClickTimer.stop()
		var winscreen=preload("res://WinScreen.tscn").instance()
		$".".add_child(winscreen)
		winscreen.connect('main_menu', $".","_go_to_main_menu")


func _on_Fight_next_turn():
	if !$Fight.player_turn:
		turn_lenght=rand_range(1,5)
	var ai_clicks=player_clicks_this_turn + randi()%11-4
	var clicking_period=INF
	if ai_clicks>0:
		clicking_period=turn_lenght/ai_clicks
	$AIClickTimer.wait_time=clicking_period
	$AIClickTimer.stop()
	$AIClickTimer.start()
	player_clicks_this_turn=0
	$Fight.set_turn_lenght(turn_lenght)

func _on_AIClickTimer_timeout():
	if $Fight.player_turn:
		$Fight.player_click()
	else:
		$Fight.enemy_click()


func _on_Fight_fight_start():
	$AIClickTimer.start()

func _go_to_main_menu():
	emit_signal('main_menu')