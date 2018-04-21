extends MarginContainer

signal singleplayer
signal multiplayer


func _on_Singleplayer_pressed():
	emit_signal('singleplayer')


func _on_Multiplayer_pressed():
	emit_signal('multiplayer')
