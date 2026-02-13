extends Interactable

@export_file("*.json") var d_file

var dialogue = []
var current_dialogue_id = 0
var d_active = false

func _ready():
	$Dialogue/NinePatchRect.visible = false

func start():
	print("Is talking")
	if d_active:
		return
	d_active = true
	$Dialogue/NinePatchRect.visible = true
	dialogue = load_dialogue()
	current_dialogue_id = -1
	next_script()



func load_dialogue():
	var file = FileAccess.open("res://Dialogue/npc_dialogue1.json", FileAccess.READ)
	var content = JSON.parse_string(file.get_as_text())
	return content

func next_script():
	current_dialogue_id += 1
	if current_dialogue_id >= len(dialogue):
		d_active = false
		$Dialogue/NinePatchRect.visible = false
		return
	$Dialogue/NinePatchRect/Text.text = dialogue[current_dialogue_id]['text']


func _on_interacted(body: Variant) -> void:
	#if !d_active:
		#return
	print("Am interacting")
	next_script()
	start()

func _on_npc_area_body_exited(body: Node3D) -> void:
	if body.is_in_group("Player"):
		$Dialogue/NinePatchRect.visible = false
		print(current_dialogue_id)

func _on_npc_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		start()
