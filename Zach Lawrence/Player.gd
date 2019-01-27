extends KinematicBody2D

export (PackedScene) var Ghost # change the file path in final project ###################

var velocity = Vector2()
var speed = 200

var currently_losing_sanity = false # false = at home, true = away from home

var sanity = 100 # amount of sanity
var sanity_seconds = 1 # amount of time elapsed before decrementing sanity
var sanity_loss = 2 # amount of sanity lost per trigger

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

func _on_GhostSpawnerTimer_timeout():
	spawn_ghost()

func spawn_ghost():
	var ghost = Ghost.instance()
	get_parent().add_child(ghost)
	ghost.start(sanity, Vector2(rand_range(position.x - 400, position.x + 400), rand_range(position.y - 400, position.y + 400)))

