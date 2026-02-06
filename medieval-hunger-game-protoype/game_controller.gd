extends Node


var total_food: int = 0

func food_collected(value: int):
	total_food += value
	EventController.emit.signal("food_collected", total_food)
	
