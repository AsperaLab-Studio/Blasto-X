extends Sprite

var positions = []
var index = 0

func _ready():
	for node in get_parent().get_children():
		if node is Label and node.visible:
			positions.append(node)
		
	
	_set_selection(0)
	


func _set_selection(newIndex): 
	if(0 <= newIndex and newIndex < len(positions)): 
		index = newIndex
		var selectedNode = positions[index]
		
		position = Vector2(
			selectedNode.rect_position.x - (get_rect().size.x)*scale.x/2,
			selectedNode.rect_position.y + selectedNode.rect_size.y/2 - 10
		)
	

func _process(delta): 
	if(Input.is_action_just_pressed("move_up")):
		_set_selection(index - 1)
	if(Input.is_action_just_pressed("move_down")):
		_set_selection(index + 1)
	
