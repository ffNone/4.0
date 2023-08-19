extends Button

func _ready():
	Gotm.initialize()
	

func join_global_lobby(mode):
	var fetch = GotmLobbyFetch.new()
	fetch.filter_properties.mode = mode
	var lobbies = await fetch.first(1).completed

	if not lobbies.empty():
		var success = await lobbies[0].join().completed

	else:
		Gotm.host_lobby()
		Gotm.lobby.mode = mode
		Gotm.lobby.hidden = false

