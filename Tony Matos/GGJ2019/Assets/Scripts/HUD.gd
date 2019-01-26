extends CanvasLayer

##### TODO #####
#	1. Put is_playing false to a place where the players loses and retruns to this screen
###	2. Make StartButton start a new game and ResumeButton resume a game. (DONE)




var new_game = true
var is_playing = false

func _process(delta):
	if is_playing:
		get_node("StartScreen").hide()
		get_node("PlayScreen").show()
	elif is_playing == false:
		get_node("PlayScreen").hide()
		get_node("StartScreen").show()
		if new_game == true:
			get_node("StartScreen/NewGame").hide()
			get_node("StartScreen/StartButton").show()
			get_node("StartScreen/ResumeButton").hide()
		elif new_game == false:
			get_node("StartScreen/NewGame").show()
			get_node("StartScreen/StartButton").hide()
			get_node("StartScreen/ResumeButton").show()

func _on_StartButton_pressed():
	#Input start code
	is_playing = true
	new_game = false
	
func _on_Resume_Button_pressed():
	#Input resume code
	is_playing = true

func _on_QuitButton_pressed():
	get_tree().quit()

func _on_NewGame_pressed():
	#Input new game code
	new_game = true
