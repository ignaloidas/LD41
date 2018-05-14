extends Node

signal main_menu

var ip = "127.0.0.1"
var client
var nickname
var channel = "#LD-game"
var connected=false
var names
var waiting_for_names=false

func _on_nick_enter(nick):
	nickname=nick
	$NickSetup.queue_free()
	var lobby=preload("res://Lobby.tscn").instance()
	$".".add_child(lobby)
	client = StreamPeerTCP.new()
	client.connect_to_host(ip, 6667)
	client.put_data(("USER "+ nick +" "+ nick +" "+ nick + " :TEST\n").to_utf8())
	client.put_data(("NICK "+ nick +"\n").to_utf8())
	client.put_data(("JOIN "+ channel +"\n").to_utf8())
	client.put_data(("NAMES "+channel).to_utf8())
	waiting_for_names=true
	names=''
	connected=true

func _physics_process(delta):
	if connected:
		if client.is_connected_to_host() && client.get_available_bytes() >0:
					var a = str(client.get_utf8_string(client.get_available_bytes()))
					print(a)
					a = a.split('\n')
					for b in a:
						b = b.split(' ')
						if b.size() > 1:
							if b[0] == "PING":
								client.put_data(("PONG "+ str(b[1]) +"\n").to_utf8())
							elif b[1] == "PRIVMSG":
								var text = ""
								for i in range (3, b.size()):
									text += b[i] + " "
								text = text.substr(1, text.length()-1)
								#TODO
							elif b[1] == "353":
								var tmp=''
								for i in range (5, b.size()):
									tmp += b[i] + " "
								tmp.erase(0,1)
								names+=tmp
							elif b[1] == '366':
								waiting_for_names=false
								$NameUpdateTimer.start()
								names = names.replace(' ' ,'\n')
								$Lobby.names=names
								print(names)

func get_name_user (value):
	var a = value.find("!")
	return value.substr(1, a-1)

func send_msg(msg):
	client.put_data(("PRIVMSG "+ channel + " :" + str(msg +"\n")).to_utf8())

func _on_NameUpdateTimer_timeout():
	names=''
	waiting_for_names=false
	client.put_data(("NAMES "+channel+'\r\n').to_utf8())
