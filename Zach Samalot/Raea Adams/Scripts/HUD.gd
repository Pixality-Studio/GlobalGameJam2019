extends CanvasLayer

##### TODO #####

#	1. Put is_playing false to a place where the players loses and retruns to this screen
###	2. Make StartButton start a new game and ResumeButton resume a game. (DONE)
###	3. Code difficulty buttons (DONE)
#	4. Input starting game code
#	5. Input new game code
#	6. Input zen mode code
#	7. Input normal mode code

var is_playing = false

#When ready...
func _ready():
	if get_node("/root/Title") == get_parent():
		hide_play()
		is_playing = false
	else:
		$TitleScreen/NewGame.hide() #Hide newgame button
		hide_difficulty()
		show_play()
		is_playing = true

func transition(new_area):
	if new_area == "difficulty":
		hide_start()
		show_difficulty()
	if new_area == "title":
		show_start("")
		hide_difficulty()

func start_game(type):
	show_play()
	hide_difficulty()
	hide_start()
	is_playing = true
	System.difficulty = type
	get_tree().change_scene("res://Raea Adams/Scenes/Main.tscn")

#Timed mode only
func pause():
	is_playing = false
	show_start("pause")

func quit_game():
	get_tree().quit()

func show_start(param):
	$TitleScreen.show()
	if param == "pause":
		hide_play()
		$TitleScreen/NewGame.show()

func hide_start():
	$TitleScreen.hide()

func show_difficulty():
	$DifficultyScreen.show()

func hide_difficulty():
	$DifficultyScreen.hide()

func show_play():
	$PlaySpace.show()

func hide_play():
	$PlaySpace.hide()
