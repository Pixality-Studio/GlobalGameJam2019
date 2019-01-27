extends Area2D

var agressive_level # 0 is none, 1 is 15%, 2 is 30%, 3 is 50%, 4 is 70%, each with respectful alpha values

var tween_alpha_val # the value of the alpha for the sprite to modulate to
var tween_fully_modulated = false # detection for tweening when the first tween is completed
var prepare_to_queue_free = false # detection for tweenign when the second tween is completed

func start(player_sanity, pos):
	position = pos 
	modulate = Color(1,1,1,0)
	# set the corrosponding aggresion level to the players sanity
	if player_sanity >= 80:
		agressive_level = 0
	if player_sanity < 79 and player_sanity >= 60:
		agressive_level = 1
	if player_sanity < 59 and player_sanity >= 40:
		agressive_level = 2
	if player_sanity < 39 and player_sanity >= 20:
		agressive_level = 3
	if player_sanity < 19 and player_sanity >= 0:
		agressive_level = 4

func _process(delta):
	assign_variables() # check varibales
	# if the tween has not been started, start the first tweeing process
	if get_node("Tween").is_active() == false and tween_fully_modulated == false:
		get_node("Tween").interpolate_property(self, "modulate", Color(1,1,1,0), Color(1,1,1,tween_alpha_val), 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		get_node("Tween").start()
		tween_fully_modulated = true

func assign_variables(): # setting the tween_alpha_val
	if agressive_level == 0:
		tween_alpha_val = 0.2
	elif agressive_level == 1:
		tween_alpha_val = 0.4
	elif agressive_level == 2:
		tween_alpha_val = 0.6
	elif agressive_level == 3:
		tween_alpha_val = 0.8
	elif agressive_level == 4:
		tween_alpha_val = 1

func _on_Tween_tween_completed(object, key):
	if prepare_to_queue_free:
		queue_free()
	if tween_fully_modulated:
		get_node("Tween").interpolate_property(self, "modulate", Color(1,1,1,tween_alpha_val), Color(1,1,1,0), 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		get_node("Tween").start()
		prepare_to_queue_free = true
