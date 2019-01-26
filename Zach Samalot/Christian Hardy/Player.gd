extends KinematicBody2D

# the only difference for this game mode is that the house needs to have a collision shape circle attached to it
# so that the their can be detection when 

var velocity = Vector2()
var speed = 200

# the house needs to have an area2d as a child of it with a big circle hitbox 

var currently_losing_sanity = false # false = at home, true = away from home

var sanity = 100 # amount of sanity
var sanity_seconds = 10 # amount of time elapsed before decrementing sanity
var sanity_loss = 10 # amount of sanity lost per trigger

func _ready():
	get_node("SanityTimer").wait_time = sanity_seconds # sets the timer to correct time

func _process(delta):
	get_node("ProgressBar/ProgressBar").value = sanity # update progress bar
	get_input()
	velocity = move_and_slide(velocity) * speed

func get_input():
	velocity = Vector2(0, 0)
	if Input.is_action_pressed("ui_up"):
		velocity.y -= speed
	if Input.is_action_pressed("ui_down"):
		velocity.y += speed
	if Input.is_action_pressed("ui_left"):
		velocity.x -= speed
	if Input.is_action_pressed("ui_right"):
		velocity.x += speed


# SANITY RESET ON ITEM PICKUP
# whenever the signal is received that an item has been picked up
# call reset_sanity()


func _on_SanityTimer_timeout():
	sanity -= sanity_loss # decrease your sanity on timeout

func reset_sanity():
	sanity = 100

func _on_Area2D_area_entered(area): # if this is copied in make sure to connect this area2d (from the player)
	if area.is_in_group("house"): # if you enter the house
		reset_sanity()
		get_node("SanityTimer").stop() 

func _on_Area2D_area_exited(area): # same as above
	if area.is_in_group("house"):
		get_node("SanityTimer").start()

