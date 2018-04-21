extends VBoxContainer

signal main_menu

func _on_TextureButton_pressed():
	emit_signal('main_menu')
