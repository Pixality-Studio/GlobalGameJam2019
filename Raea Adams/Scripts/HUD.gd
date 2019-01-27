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
var memory_toggled = false
var mem_count = 0

func _process(delta):
	if memories.Memory1 and memories.Memory2 and memories.Memory3 and memories.Memory4:
		get_tree().change_scene("res://Raea Adams/Scenes/EndGame.tscn")
	if memory_toggled and Input.is_action_just_pressed("interact"):
		memory_toggled = false
		get_node("/root/PlaySpace/Player").paused = false
		$MemoryTemplate.hide()
		$Memory1.hide()
		$Memory2.hide()
		$Memory3.hide()
		$Memory4.hide()
		$PlaySpace/Memory1.pressed = false
		$PlaySpace/Memory2.pressed = false
		$PlaySpace/Memory3.pressed = false
		$PlaySpace/Memory4.pressed = false
		yield(get_tree().create_timer(0.3), "timeout")
	

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

func play_music():
	if mem_count == 1:
		get_node("/root/PlaySpace/Player/MemMusic").stream = load("res://Raea Adams/Audio/Music/A_Little_Bit_of_Color.ogg")
		get_node("/root/PlaySpace/Player/MemMusic").play()
	if mem_count == 2:
		get_node("/root/PlaySpace/Player/MemMusic").stream = load("res://Raea Adams/Audio/Music/Feels_Closer.ogg")
		get_node("/root/PlaySpace/Player/MemMusic").play()
	if mem_count == 3:
		get_node("/root/PlaySpace/Player/MemMusic").stream = load("res://Raea Adams/Audio/Music/Somewhere_Like_Home.ogg")
		get_node("/root/PlaySpace/Player/MemMusic").play()

func memory_toggle(button_pressed, memory):
	if button_pressed:
		get_node("/root/PlaySpace/Player").paused = true
		memory_toggled = true
		$MemoryTemplate.show()
	if memory == 1:
		$Memory1.show()
	if memory == 2:
		$Memory2.show()
	if memory == 3:
		$Memory3.show()
	if memory == 4:
		$Memory4.show()
