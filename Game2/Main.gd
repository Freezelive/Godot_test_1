extends Node2D


#global delcarations
var player_kin_body = KinematicBody2D.new()
var player_sprite_texture = preload("./resources/sprite.png")
var player_sprite=Sprite.new()

var screen_size=OS.get_window_safe_area().size #get screen size
var Player_movement_option = 0

var selected_option_title = TextEdit.new()



#create the buttons on the right to eanble disable movement options. 
func create_menu():
	var movement_options=["no option","Grid","rocket modde","mouse track","click and move"]  #menu list
	var button_padding=0
	for item in movement_options:
		var button_item =Button.new()
		var button_location=StaticBody2D.new()
		button_item.set_text(item)
		button_item.rect_size=Vector2(4,1.5)
		button_item.rect_position=Vector2(screen_size.x-button_item.rect_size.x-20,20+button_padding)
		button_item.add_to_group("button_list")
		button_item.connect("button_up", self, "movement_selector",[button_item,get_tree().get_nodes_in_group("button_list").size()])
		button_location.add_child(button_item)
		button_padding+=30
		add_child(button_location)
	#print (button_item.rect_position)
	

#this keeps track of what button was pressed to enable movement option
func movement_selector(target="No movement option",idx=0):
	#print (target.get_text())
	Player_movement_option = idx
	selected_option_title.text=target.get_text()

#global variables
var speed = 200
var rotation_dir = 0
var rotation_speed = 1.5
var velocity = Vector2()
var target = Vector2()


func mouse_track(player_rotation):
	velocity = Vector2()
	if Input.is_action_pressed('down'):
		velocity = Vector2(-speed, 0).rotated(player_rotation)
	if Input.is_action_pressed('up'):
		velocity = Vector2(speed, 0).rotated(player_rotation)

func rocket_modde(player_rotation):
	rotation_dir = 0
	velocity = Vector2()
	if Input.is_action_pressed('ui_right'):
		rotation_dir += 1
	if Input.is_action_pressed('ui_left'):
		rotation_dir -= 1
	if Input.is_action_pressed('ui_down'):
		velocity = Vector2(-speed, 0).rotated(player_rotation)
	if Input.is_action_pressed('ui_up'):
		velocity = Vector2(speed, 0).rotated(player_rotation)
	pass

func grid_move():
	velocity = Vector2()
	if Input.is_action_pressed('ui_right'):
		velocity.x += 1
	if Input.is_action_pressed('ui_left'):
		 velocity.x -= 1
	if Input.is_action_pressed('ui_down'):
		velocity.y += 1
	if Input.is_action_pressed('ui_up'):
		velocity.y -= 1
	velocity = velocity.normalized() * speed
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	selected_option_title.rect_position=Vector2(screen_size.x/2,0)
	selected_option_title.rect_size=Vector2(200,30)
	selected_option_title.set_text("No movement option")
	add_child(selected_option_title)
	player_sprite.texture=player_sprite_texture
	player_sprite.scale=Vector2(0.1,0.1) #set sprite size
	player_kin_body.add_child(player_sprite)
	player_kin_body.position=Vector2(100,100)
	add_child(player_kin_body)
	movement_selector(selected_option_title,0)
	create_menu()
	pass # Replace with function body.


func _input(event):    #global event used for point and click movemnt option
 	if event.is_action_pressed('click'):
 		target = get_global_mouse_position()



#func _process(delta):

#this enables the movement option
func  _physics_process(delta):
	if Player_movement_option == 1:
		grid_move()
	if Player_movement_option == 2:
		rocket_modde(player_kin_body.rotation)
		player_kin_body.rotation += rotation_dir * rotation_speed * delta
	if Player_movement_option == 3:
		player_kin_body.look_at(get_global_mouse_position())
		mouse_track(player_kin_body.rotation)
	if Player_movement_option == 4:
		velocity = (target - player_kin_body.position).normalized() * speed
		player_kin_body.rotation = velocity.angle()
		if (target - player_kin_body.position).length() < 5:
			velocity = Vector2()
			#velocity = player_kin_body.move_and_slide(velocity)
	player_kin_body.move_and_slide(velocity)
	pass
