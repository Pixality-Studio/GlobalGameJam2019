extends KinematicBody2D

# the only difference for this game mode is that the house needs to have a collision shape circle attached to it
# so that the their can be detection when 
# the house needs to have an area2d as a child of it with a big circle hitbox 
#Dark mode comments what is going to be used only in the harder difficulty

var new_anim = "" #This holds what the current animation that should be playing is

var velocity = Vector2() #This is holds how much the character will move by
var speed = 200 #This holds movement speed

var saturate = true #This tells whether saturation can occur or not. Allows cinematic saturation over automatic

var objects = [] #This holds the position and name of each object
var closest_pos = 0.0 #This holds the closest object's distance
var closest_obj #This holds the name of the closest object

#Sanity is the amount of sanity you have
#SanityDecreaseTime is the amount of wait_time the decrease timer will have
#SanityDecrease is the amount of sanity you will lose
var darkmode = {"Sanity": 100, "DecreaseTime": 10, "SanityDecrease": 10}
var currently_losing_sanity = false # false = at home, true = away from home
var paused = true

func _ready():
	var while_count = 3
	
	#Dark Mode
	if System.difficulty == 1:
		$SanityUI/SanityBar.show()
		$SanityTimer.wait_time = darkmode.DecreaseTime # sets the timer to correct time
		$SanityTimer.start()
	if System.difficulty == 1 and !paused:
		$SanityUI/SanityBar.value = darkmode.Sanity # update progress bar
	
	#Universal Mode
	#This sets up the objects array
	while while_count != -1:
		#Appends the object as a dictionary into the Objects array
		objects.append({"Name": "Object%s" % while_count, "Pos": get_node("/root/PlaySpace/Object%s" % while_count).position})
		while_count -= 1 #Subtracts 1 from the while_count

func _process(delta):
	#Dark Mode 
	if System.difficulty == 1 and paused: #If the game is paused, pause the timer
		$SanityTimer.paused = true
	if System.difficulty == 1 and !paused: #If the game is not paused then resume the timer
		$SanityTimer.paused = false
	
	#Universal 
	if !paused:
		if $CharAnim.current_animation != new_anim: #If the current animation is not the animation that should be playing then switch it out
			$CharAnim.play(new_anim)
		if velocity == Vector2(0,0): #If velocity == 0 then Idle
			$CharAnim.stop()
		velocity = Vector2(0, 0) #Velocity is set to 0 so the player does not slide
		
		get_input() #Checks for inputs
		move_and_slide(velocity)
	
	if saturate: #If saturation is allowed then update the saturation level
		saturation_update() #Updates the saturation level

func get_input():
	#Variable input shortcuts
	var up = Input.is_action_pressed("up")
	var down = Input.is_action_pressed("down")
	var right = Input.is_action_pressed("right")
	var left = Input.is_action_pressed("left")
	
	#Basic Movement
	if up:
		velocity.y -= speed
		#new_anim = "Up"
	if down:
		velocity.y += speed
		new_anim = "Down"
	if left:
		velocity.x -= speed
		#new_anim = "Left"
	if right:
		velocity.x += speed
		#new_anim = "Right"
	

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
	if closest_pos < 2000 and closest_pos >= 1800:
		$CharCam/Saturation.environment.adjustment_saturation = 0.32
	if closest_pos < 1800 and closest_pos >= 1700:
		$CharCam/Saturation.environment.adjustment_saturation = 0.35
	if closest_pos < 1700 and closest_pos >= 2500:
		$CharCam/Saturation.environment.adjustment_saturation = 0.2
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

#This smoothly brings the saturation to bleak (Used for pickup effect)
func scaledown():
	saturate = false #Sets saturation to false so auto saturation cannot occur
	$CharCam/Saturation.environment.adjustment_saturation = 1.0 #New saturation level
	yield(get_tree().create_timer(0.2), "timeout") #Timer to wait for next saturation level change
	#REPEAT
	$CharCam/Saturation.environment.adjustment_saturation = 0.7
	yield(get_tree().create_timer(0.2), "timeout")
	$CharCam/Saturation.environment.adjustment_saturation = 0.5
	yield(get_tree().create_timer(0.2), "timeout")
	$CharCam/Saturation.environment.adjustment_saturation = 0.4
	yield(get_tree().create_timer(0.2), "timeout")
	$CharCam/Saturation.environment.adjustment_saturation = 0.3
	yield(get_tree().create_timer(0.2), "timeout")
	$CharCam/Saturation.environment.adjustment_saturation = 0.25
	yield(get_tree().create_timer(0.2), "timeout")
	$CharCam/Saturation.environment.adjustment_saturation = 0.22
	yield(get_tree().create_timer(0.2), "timeout")
	$CharCam/Saturation.environment.adjustment_saturation = 0.2
	yield(get_tree().create_timer(0.2), "timeout")
	$CharCam/Saturation.environment.adjustment_saturation = 0.17
	yield(get_tree().create_timer(0.2), "timeout")
	$CharCam/Saturation.environment.adjustment_saturation = 0.15
	yield(get_tree().create_timer(0.2), "timeout")
	$CharCam/Saturation.environment.adjustment_saturation = 0.12
	yield(get_tree().create_timer(0.2), "timeout")
	$CharCam/Saturation.environment.adjustment_saturation = 0.1
	yield(get_tree().create_timer(0.2), "timeout")
	$CharCam/Saturation.environment.adjustment_saturation = 0.08
	yield(get_tree().create_timer(0.2), "timeout")
	$CharCam/Saturation.environment.adjustment_saturation = 0.05
	yield(get_tree().create_timer(0.2), "timeout")
	$CharCam/Saturation.environment.adjustment_saturation = 0.02
	yield(get_tree().create_timer(0.2), "timeout")
	$CharCam/Saturation.environment.adjustment_saturation = 0.01
	saturate = true

#Couldn't find the proper property path to tween it.
#func tween_it(new_sat):
#	$Tween.interpolate_property($CharCam/Saturation, "CharCam/Saturation:Environment:Adjustments:Saturation", $CharCam/Saturation.environment.adjustment_saturation, new_sat, 0.3,Tween.TRANS_SINE,Tween.EASE_IN_OUT)
#	$Tween.start()


# SANITY RESET ON ITEM PICKUP
# whenever the signal is received that an item has been picked up
# call reset_sanity()
func reset_sanity():
	darkmode.Sanity = 100

#Handles what happens when the sanity timer runs out.
func _on_SanityTimer_timeout():
	darkmode.Sanity -= darkmode.SanityDecrease # decrease your sanity on timeout

func _on_Area2D_area_entered(area): # if this is copied in make sure to connect this area2d (from the player)
	if area.is_in_group("house"): # if you enter the house
		if System.difficulty == 1:
			reset_sanity()
			get_node("SanityTimer").stop() 

func _on_Area2D_area_exited(area): # same as above
	if area.is_in_group("house"):
		if System.difficulty == 1:
			get_node("SanityTimer").start()
