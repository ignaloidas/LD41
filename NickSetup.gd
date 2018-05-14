extends VBoxContainer

signal nick_enter(nick)

func _on_TextureButton_pressed():
	emit_signal('nick_enter',$LineEdit.text)
