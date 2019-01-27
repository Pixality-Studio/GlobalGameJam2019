extends CanvasLayer

##### TODO #####

#	1. Put is_playing false to a place where the players loses and retruns to this screen
###	2. Make StartButton start a new game and ResumeButton resume a game. (DONE)
###	3. Code difficulty buttons (DONE)
#	4. Input starting game code
#	5. Input new game code
#	6. Input zen mode code
#	7. Input normal mode code

var is_playing = false #Is the game playing now

#This holds what memories have been collected and which ones have not.
var memories = {"Memory1": false, "Memory2": false, "Memory3": false, "Memory4": false}

#When ready...
func _ready():
	if get_parent().name == "Title": #If the parent is the Title screen 
		hide_play() #Hide the in-game HUD
		is_playing = false #The game is not playing
	else: #Otherwise
		hide_start()
		hide_difficulty() #Hide the difficulty screen
		show_play() #Show the in-game HUD 
		is_playing = true #The game is playing!

#This handles moving between menu screens
func transition(new_screen):
	if new_screen == "difficulty": #Checks for the new screen
		hide_start()
		show_difficulty()
	if new_screen == "title":
		show_start("")
		hide_difficulty()

#Handles starting the game
func start_game(type):
	System.difficulty = type #Sets system difficulty
	get_tree().change_scene("res://Raea Adams/Scenes/Main.tscn") #Moves player to the game scene!

#Timed mode only
func pause():
	is_playing = false
	show_start("pause")

#Quits the game
func quit_game():
	get_tree().quit()

#Shows the title screen
func show_start(param):
	$TitleScreen.show()
	if param == "pause":
		hide_play()
		$TitleScreen/NewGame.show()

#Hides the title screen
func hide_start():
	$TitleScreen.hide()

#Shows the difficulty screen
func show_difficulty():
	$DifficultyScreen.show()

#Hides the difficulty screen
func hide_difficulty():
	$DifficultyScreen.hide()

#Shows in-game HUD
func show_play():
	$PlaySpace.show()

#Hides in-game HUD
func hide_play():
	$PlaySpace.hide()
