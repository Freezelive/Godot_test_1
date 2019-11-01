extends Container


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var window_size=OS.get_screen_size()
#window_size gives (1920, 1200) similar to (x,y)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_mainMenu_container_ready():
	#fit screen on window
	OS.window_size = Vector2(1027,968)
	var sd=get_node("VBoxContainer/TextureRect").get_rect()
	var sd2=get_node("VBoxContainer/TextureRect2").get_rect()
	var vboxnode=get_node("VBoxContainer").get_scale()
	var vboxnode2=get_node("VBoxContainer").get_rect()
	print(sd)
	print(vboxnode)
	print(vboxnode2)
	pass # Replace with function body.
