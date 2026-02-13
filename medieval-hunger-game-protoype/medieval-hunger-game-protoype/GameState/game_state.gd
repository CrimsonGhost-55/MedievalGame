extends Node

var state :={
	"bread knife": false,
	"running shoes": false,
	"letter": false,
	"scraps": 0,
	"food": 0,
	"health": 100,
	"hunger": 100
}

func get_value(food):
	if state.has(food):
		return state[food]
	
	printerr("Scraps not present in state: ", food)

func set_value(food, value):
	state[food] = value
