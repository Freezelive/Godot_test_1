extends Control


func _ready():
	return



func _on_button_game_1_pressed():
	if get_tree().change_scene("res://Game1/Main.tscn") != OK:
		print ("An unexpected error occured when trying to switch to the Readme scene")


func _on_button_game_2_pressed():
	if get_tree().change_scene("res://Game2/Main.tscn") != OK:
		print ("An unexpected error occured when trying to switch to the Readme scene")


func _on_button_game_3_pressed():
	if get_tree().change_scene("res://Game3/Main.tscn") != OK:
		print ("An unexpected error occured when trying to switch to the Readme scene")


func _on_button_game_4_pressed():
	if get_tree().change_scene("res://Game4/Main.tscn") != OK:
		print ("An unexpected error occured when trying to switch to the Readme scene")
