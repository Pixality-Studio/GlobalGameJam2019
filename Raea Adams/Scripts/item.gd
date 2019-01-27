extends Area2D

#	Christian Hardy
#	1/25/2018
#	working on 

signal PickUP

export (int) var object_num #The number of the object

var can_pickup = false #Can it be picked up or not

func _process(delta):
	if can_pickup: #If the item can be picked up
		if Input.is_action_pressed("interact"): #And the interaction button is pressed
			PickUp() #Call pickup function

#Handles picking up items
func PickUp():
	get_node("/root/PlaySpace/Player").paused = true
	get_node("/root/PlaySpace/HUD").memory_toggled = true
	get_node("/root/PlaySpace/HUD").mem_count += 1
	get_node("/root/PlaySpace/HUD").play_music()
	if object_num == 3: #Checks for item number
		get_node("/root/PlaySpace/HUD").memories.Memory1 = true #Sets corresponding memory to true
		get_node("/root/PlaySpace/HUD").memory_toggle(true,1)
		get_node("/root/PlaySpace/HUD/PlaySpace/Memory1").disabled = false
	if object_num == 2:
		get_node("/root/PlaySpace/HUD").memories.Memory2 = true
		get_node("/root/PlaySpace/HUD").memory_toggle(true,2)
		get_node("/root/PlaySpace/HUD/PlaySpace/Memory2").disabled = false
	if object_num == 1:
		get_node("/root/PlaySpace/HUD").memories.Memory3 = true
		get_node("/root/PlaySpace/HUD").memory_toggle(true,3)
		get_node("/root/PlaySpace/HUD/PlaySpace/Memory3").disabled = false
	if object_num == 0:
		get_node("/root/PlaySpace/HUD").memories.Memory4 = true
		get_node("/root/PlaySpace/HUD").memory_toggle(true,4)
		get_node("/root/PlaySpace/HUD/PlaySpace/Memory4").disabled = false
	get_node("/root/PlaySpace/Player").scaledown() #Scales saturation from colored to grey
	get_node("/root/PlaySpace/Player").objects.remove(object_num) #Removes the object info from the objects array
	emit_signal("PickUp") #Emit Pickup signal
	queue_free() #DeRezz.

func _on_Items_body_entered(body):
	if body.is_in_group('player'):
		can_pickup = true

func _on_Items_body_exited(body):
	if body.is_in_group("player"):
		can_pickup = false
		
