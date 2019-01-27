extends Node

func _ready():
	for letter in $CanvasLayer/Label.text:
		$CanvasLayer/Label.visible_characters += 1
		yield(get_tree().create_timer(0.1),"timeout")

func _on_StartGame_timeout():
	$LevelAnim.play("Intro")


func _on_LevelAnim_animation_finished(anim_name):
	$Player.paused = false
	$CanvasLayer/Label.hide()
	$CanvasLayer/ColorRect.hide()