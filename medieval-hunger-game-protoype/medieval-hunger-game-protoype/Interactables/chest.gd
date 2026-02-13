extends Interactable

@export var itemID := "someItem"
@export var item_amount = 0

var playback : AnimationNodeStateMachinePlayback
var open := false

func _ready() -> void:
	playback = $AnimationTree.get("parameters/playback")

func _on_interacted(body: Variant) -> void:
	if not open:
		open = true
		GameState.set_value("food", GameState.get_value("food") + item_amount)
		playback.travel("ChestOpen")
		GameState.set_value(itemID, true)
