extends KinematicBody2D

#Changes/Additions/Comments:
	#line 59-62, Comment:
		#You need to set Up, Down, Left, and Right in the Projects Settings/Input map to be albe to use those shortcuts
	#line 67-75, Addition/Change:
		#I added a way for the player to stop moving if the is_playing bool is false
	#line 64-65, Addition:
		#I added a check for when the escape button is pressed. This will pause the game.





#Dark mode comments what is going to be used only in the harder difficulty

# the only difference for this game mode is that the house needs to have a collision shape circle attached to it
# so that the their can be detection when 
var objects = []
var closest_pos = 0.0
var closest_obj

var velocity = Vector2()
var speed = 200

# the house needs to have an area2d as a child of it with a big circle hitbox 

var currently_losing_sanity = false # false = at home, true = away from home

#Sanity is the amount of sanity you have
#SanityDecreaseTime is the amount of wait_time the decrease timer will have
#SanityDecrease is the amount of sanity you will lose
var new_game_plus = {"Sanity": 100, "DecreaseTime": 10, "SanityDecrease": 10}

func _ready():
	var while_count = 3
	
	#Dark Mode
	get_node("SanityTimer").wait_time = new_game_plus.DecreaseTime # sets the timer to correct time
	
	#Universal Mode
	#This sets up the objects array
	while while_count != -1:
		#Appends the object as a dictionary into the Objects array
		objects.append({"Name": "Object%s" % while_count, "Pos": get_node("/root/PlaySpace/Object%s" % while_count).rect_position})
		while_count -= 1 #Subtracts 1 from the while_count

func _process(delta):
	#Dark Mode 
	get_node("SanityUI/SanityBar").value = new_game_plus.Sanity # update progress bar
	
	#Universal 
	velocity = Vector2(0, 0)
	get_input()
	move_and_slide(velocity) * speed

func get_input():
	#Variable input shortcuts
	var up = Input.is_action_pressed("up")
	var down = Input.is_action_pressed("down")
	var right = Input.is_action_pressed("right")
	var left = Input.is_action_pressed("left")
	
	if Input.is_action_just_pressed("ui_cancel"):
		get_node("HUD").pause()
	
	if get_node("HUD").is_playing == true:
		if up:
			velocity.y -= speed
		if down:
			velocity.y += speed
		if left:
			velocity.x -= speed
		if right:
			velocity.x += speed
	

# SANITY RESET ON ITEM PICKUP
# whenever the signal is received that an item has been picked up
# call reset_sanity()

func _on_SanityTimer_timeout():
	new_game_plus.Sanity -= new_game_plus.SanityDecrease # decrease your sanity on timeout

func reset_sanity():
	new_game_plus.Sanity = 100

func _on_Area2D_area_entered(area): # if this is copied in make sure to connect this area2d (from the player)
	if area.is_in_group("house"): # if you enter the house
		reset_sanity()
		get_node("SanityTimer").stop() 

func _on_Area2D_area_exited(area): # same as above
	if area.is_in_group("house"):
		get_node("SanityTimer").start()

