extends Control


func _ready():
	return




func _on_button_game_1_pressed():
	get_tree().change_scene("res://Game1/Main.tscn")


func _on_button_game_2_pressed():
	get_tree().change_scene("res://Game2/Main.tscn")
	pass # Replace with function body.
	
#func _process(delta):
#	if Input.is_action_pressed("ui_cancel"):
#		get_tree().quit()
		
