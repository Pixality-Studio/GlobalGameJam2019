extends Node2D

var objects = []
var closest_pos = 0.0
var closest_obj

func _ready():
	var while_count = 3
	
	#This sets up the objects array
	while while_count != -1:
		objects.append({"Name": "Object%s" % while_count, "Pos": get_node("/root/TestingGrounds/Object%s" % while_count).rect_position})
		while_count -= 1

func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		saturation_update() #Updates the saturation level

#I did math!
func saturation_update():
	var distance #Distance is how far away is an object
	var for_count = 0 #This is use for the for statement to count the objects
	
	#For each object in the objects array
	for current in objects: 
		distance = objects[for_count].Pos.distance_to(get_global_mouse_position()) #Distance is set to the current object's distance from the mouse or the character
		
		#If it's the first object
		if for_count == 0: 
			closest_pos = distance #The closest position is set to the first object by default
			closest_obj = objects[for_count].Name #The closest object is set to the first object by default
		
		#If the distance is less than the closest position so far
		if distance < closest_pos: 
			closest_obj = objects[for_count].Name #Sets a new closest object
			closest_pos = distance #Sets a new closest position
		for_count += 1 #Adds for count by 1
	get_node("/root/TestingGrounds/%s" % closest_obj).modulate += Color(0.2,0.2,0.2,1) #This will modulate the tilemaps later
