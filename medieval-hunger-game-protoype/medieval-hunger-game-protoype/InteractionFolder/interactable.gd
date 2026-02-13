extends CollisionObject3D
class_name Interactable

signal interacted(body)

## The Base code for every interactable in a game.
## An exported var that allows me to change the prompt shown for an interactable
@export var prompt_message = "Interact"
##Allows for different buttons to bet set as the interact button
@export var prompt_input = "interact"

func get_prompt():
	var key_name = ""
	
	##Finds out the key associated with the input action needed for the interactable
	for action in InputMap.action_get_events(prompt_input):
		if action is InputEventKey:
			key_name = action.as_text_physical_keycode()
			break
	
	return prompt_message + "\n[" + key_name + "]"

func interact(body):
	interacted.emit(body)
