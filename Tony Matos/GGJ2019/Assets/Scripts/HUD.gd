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
	show_start("")
	get_node("StartScreen/ResumeButton").hide() #Hide resume button
	get_node("StartScreen/NewGameButton").hide() #Hide newgame button
	hide_difficulty()
	hide_play()
	is_playing = false

func show_start(param):
	get_node("StartScreen").show()
	if param == "pause":
		hide_play()
		get_node("StartScreen/StartButton").hide()
		get_node("StartScreen/NewGameButton").show()
		get_node("StartScreen/ResumeButton").show()

func hide_start():
	get_node("StartScreen").hide()

func show_difficulty():
	get_node("DifficultySelectScreen").show()

func hide_difficulty():
	get_node("DifficultySelectScreen").hide()

func show_play():
	get_node("PlayScreen").show()

func hide_play():
	get_node("PlayScreen").hide()

func _on_StartButton_pressed():
	#Input start code
	hide_start()
	show_difficulty()
	hide_play()
	#status.is_playing = true
	
func _on_Resume_Button_pressed():
	#Input resume code
	show_play()
	hide_difficulty()
	hide_start()
	is_playing = true

func _on_QuitButton_pressed():
	get_tree().quit() #quit the game

func _on_NewGame_pressed():
	#Input new game code
	show_start("")
	hide_difficulty()
	hide_play()

func _on_ZenModeButton_pressed():
	#Input ZenMode Code
	show_play()
	hide_difficulty()
	hide_start()
	is_playing = true

func _on_NormalModeButton_pressed():
	#Input NormalMode Code
	show_play()
	hide_difficulty()
	hide_start()
	is_playing = true

func _on_BackButton_pressed():
	show_start("")
	hide_difficulty()
	hide_play()

func pause():
	is_playing = false
	show_start("pause")