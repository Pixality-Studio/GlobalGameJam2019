extends Area2D

#	Christian Hardy
#	1/25/2018
#	working on 

export(Texture) var ItemImage
export (int) var object_num

var can_pickup = false

func _process(delta):
	if can_pickup:
		if Input.is_action_pressed("interact"):
			PickUp()

func PickUp():
	get_node("/root/PlaySpace/Player").scaledown()
	get_node("/root/PlaySpace/Player").objects.remove(object_num)
	emit_signal("PickUp")
	queue_free()

func _on_Items_body_entered(body):
	if body.is_in_group('player'):
		can_pickup = true

func _on_Items_body_exited(body):
	if body.is_in_group("player"):
		can_pickup = false
		
