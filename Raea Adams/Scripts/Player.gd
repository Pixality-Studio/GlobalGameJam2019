extends KinematicBody2D

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
	saturation_update() #Updates the saturation level

func get_input():
	#Variable input shortcuts
	var up = Input.is_action_pressed("up")
	var down = Input.is_action_pressed("down")
	var right = Input.is_action_pressed("right")
	var left = Input.is_action_pressed("left")
	
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

#I did math!
func saturation_update():
	var distance #Distance is how far away is an object
	var for_count = 0 #This is use for the for statement to count the objects
	
	#For each object in the objects array
	for current in objects: 
		distance = objects[for_count].Pos.distance_to(self.position) #Distance is set to the current object's distance from the mouse or the character
		
		#If it's the first object
		if for_count == 0: 
			closest_pos = distance #The closest position is set to the first object by default
			closest_obj = objects[for_count].Name #The closest object is set to the first object by default
		
		#If the distance is less than the closest position so far
		if distance < closest_pos: 
			closest_obj = objects[for_count].Name #Sets a new closest object
			closest_pos = distance #Sets a new closest position
		for_count += 1 #Adds for count by 1
		
		#This handles range of when the different saturation levels occur
		if closest_pos > 3000: #Main Change
			$CharCam/Saturation.environment.adjustment_saturation = 0.01
		if closest_pos == 3000: #Main Change
			$CharCam/Saturation.environment.adjustment_saturation = 0.03
		if closest_pos < 3000 and closest_pos >= 2700:
			$CharCam/Saturation.environment.adjustment_saturation = 0.05
		if closest_pos < 2700 and closest_pos >= 2600:
			$CharCam/Saturation.environment.adjustment_saturation = 0.07
		if closest_pos < 3000 and closest_pos >= 2500: #Main Change
			$CharCam/Saturation.environment.adjustment_saturation = 0.2
		if closest_pos < 2500 and closest_pos >= 2300:
			$CharCam/Saturation.environment.adjustment_saturation = 0.22
		if closest_pos < 2300 and closest_pos >= 2100:
			$CharCam/Saturation.environment.adjustment_saturation = 0.25
		if closest_pos < 2500 and closest_pos >= 2000: #Main Change
			$CharCam/Saturation.environment.adjustment_saturation = 0.3
		if closest_pos < 2000 and closest_pos >= 1500: #Main Change
			$CharCam/Saturation.environment.adjustment_saturation = 0.4
		if closest_pos < 1500 and closest_pos >= 1000: #Main Change
			$CharCam/Saturation.environment.adjustment_saturation = 0.5
		if closest_pos < 1000 and closest_pos >= 500: #Main Change
			$CharCam/Saturation.environment.adjustment_saturation = 0.6
		if closest_pos < 500 and closest_pos > 350: #Main Change
			$CharCam/Saturation.environment.adjustment_saturation = 0.7
		if closest_pos < 200: #Main Change
			$CharCam/Saturation.environment.adjustment_saturation = 1.0


#Couldn't find the proper property path
#func tween_it(new_sat):
#	$Tween.interpolate_property($CharCam/Saturation, "CharCam/Saturation:Environment:Adjustments:Saturation", $CharCam/Saturation.environment.adjustment_saturation, new_sat, 0.3,Tween.TRANS_SINE,Tween.EASE_IN_OUT)
#	$Tween.start()

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

