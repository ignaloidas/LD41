extends Node

func multiplayer():
	pass
func singleplayer():
	for child in get_children():
		child.queue_free()
	var singleplayer=preload("res://Singleplayer.tscn").instance()
	$".".add_child(singleplayer)
	singleplayer.connect('main_menu', $".","main_menu")
func main_menu():
	for child in get_children():
		child.queue_free()
	var main_menu=preload("res://MainMenu.tscn").instance()
	$".".add_child(main_menu)
	main_menu.connect('singleplayer', $".","singleplayer")
	main_menu.connect('multiplayer', $".","multiplayer")
