extends Area2D


"""

	Christian Hardy
	1/25/2018
	working on 

TODO:
	signals
	
"""


#signal PickUp


export(Texture) var ItemImage
export(String) var ItemName
var player
onready var toggle = $Button.visible


func Output():
	return ItemName
	

func PickUp():
	
	queue_free()
#	emit_signal("PickUp")
	pass

func TextureLoad(image):
	$Sprite.texture = image


func _ready():
	TextureLoad(ItemImage)

func ButtonToggle():

	if toggle:
		toggle = false
		$Button.visible = toggle
	else:
		toggle = true
		$Button.visible = toggle


func _on_Items_area_entered(area):
	if area.is_in_group('player'):
		print('in')
		player = area
		ButtonToggle()
		


func _on_Button_pressed():
	PickUp()

func _on_Items_area_exited(area):
	if area.is_in_group("player"):
		ButtonToggle()

func _on_Items_body_entered(body):
	if body.is_in_group('player'):
#		print('in')
		player = body
		ButtonToggle()

func _on_Items_body_exited(body):
	if body.is_in_group("player"):
		ButtonToggle()


func _process(delta):
	if toggle:
		if Input.is_action_pressed("ui_accept"):
			PickUp()
	