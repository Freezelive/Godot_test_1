extends Node2D



#Delcaring the elements for the  palyer body.
var player_kin_body = KinematicBody2D.new()
var player_sprite_texture = preload("./resources/sprite.png")
var player_sprite=Sprite.new()
var screen_size=OS.get_window_safe_area().size #get screen size
var player_colision_shape = CollisionShape2D.new()
var player_colision_form= RectangleShape2D.new()
var player_area_2d=Area2D.new()
var player_camera = Camera2D.new()


#global variables
var speed = 400
var velocity = Vector2()



#create 7 bojects a fixed distance in regards to the $global_posiion.
#I use  this to spawn the objects a fixed distnace fro mthe player position
func object_spawn(global_posiion=Vector2(0,0)):
	
	var screen_x=screen_size.x+screen_size.x/20
	var screen_y=screen_size.y+screen_size.y/2
	
	var additional_object_sprite_main_position
	var objects_list =[]
	
	#psoiion array. Spawn objcts a fixed distance using the screen size and set them in this array
	var global_position_of_object_x=[screen_x,-screen_x,0,0,screen_x,screen_x,-screen_x,-screen_x]
	var global_position_of_object_y=[0,0,screen_y,-screen_y,screen_y,-screen_y,screen_y,-screen_y]
	
	
	#the loop that creates the 7 sprites to be dispalyed all around. 
	for i in range(0,8):
		#declaration
		var additional_object_sprite_main = Sprite.new() 
		var additional_object_sprite_texture  = preload("./resources/sprite_object.jpg")
		var additional_object_colission = CollisionShape2D.new()
		var additional_object_colission_circleshape=CircleShape2D.new()
		var additional_object_area=Area2D.new()
		var additioanl_optional_camera=Camera2D.new()
		
		additioanl_optional_camera.name="active_camera" #name camera to find later
		
		additional_object_area.add_to_group("obeject_list_area")#used later to check object
		additional_object_area.add_child(additional_object_colission)
		
		additional_object_colission_circleshape.radius=screen_size.x*2
		additional_object_colission.shape=additional_object_colission_circleshape
		additional_object_area.add_child(additioanl_optional_camera,true) #true is needed to save name of object else it gies a random number
		
		additional_object_sprite_main.scale=Vector2(0.1,0.1)
		additional_object_sprite_main.texture=additional_object_sprite_texture
		additional_object_sprite_main_position=additional_object_sprite_main.get_transform()
		additional_object_sprite_main_position[2]=-Vector2(global_position_of_object_x[i]-global_posiion.x,global_position_of_object_y[i]-global_posiion.y)
		additional_object_sprite_main.add_child(additional_object_area)
		additional_object_sprite_main.add_to_group("obeject_list")
		additional_object_sprite_main.set_transform(additional_object_sprite_main_position)
		
		add_child(additional_object_sprite_main) #add object to scene
		objects_list.push_front(additional_object_sprite_main)
		
		pass
	
	
	pass


# Called when the node enters the scene tree for the first time.
func _ready():
	#body of player
	player_sprite.texture=player_sprite_texture
	player_sprite.scale=Vector2(0.1,0.1) #set sprite size
	player_colision_form.extents=player_sprite.texture.get_size()*0.3
	player_colision_shape.shape=player_colision_form
	
	player_kin_body.position=Vector2(0,0)
	
	#connect 2 triggers to player on body entered and boy exited. 
	player_area_2d.connect("area_entered",self,"entering_object_influence")
	player_area_2d.connect("area_exited",self,"exit_object_influence")
	
	player_area_2d.add_child(player_colision_shape)
	player_sprite.add_child(player_area_2d)
	player_kin_body.add_child(player_sprite)
	
	player_camera.name="active_camera"  
	player_kin_body.add_child(player_camera,true)  #true is needed to save name of object else it gies a random number
	
	add_child(player_kin_body) #add body to main scene
	
	move_camera_focus(player_kin_body) #make palyer camera main viewport. will follow player
	
	#camera margins. How far away does the object has to move before the camera moves with it "padding"
	player_camera.set_drag_margin(0,0)
	player_camera.set_drag_margin(1,0)
	player_camera.set_drag_margin(2,0)
	player_camera.set_drag_margin(3,0)
	
	#spawn objects 
	object_spawn(player_kin_body.position)
	pass # Replace with function body.


#player movement. 
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


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	grid_move()
	player_kin_body.move_and_collide(velocity*delta)
	if Input.is_action_pressed("ui_cancel"):
		get_tree().change_scene("res://mainMenu.tscn")



#set focues to object that has camera named "ative_camera"
#this will work with any camera that has the name active_camera
func move_camera_focus(owner):
	print(owner)
	for i in owner.get_child_count():  #this for iterates all the children  of owner
		if owner.get_child(i).name == "active_camera":
			owner.get_child(i).make_current()
	pass

#when moving otusde of area give spawn new objects nad give player body camera focus
func exit_object_influence(boxy):
	move_camera_focus(player_kin_body)
	call_deferred("object_spawn",player_kin_body.position)
	pass

#when moving inside 2darea delete all objects except the one that you just entered
#after that move camera focus to remaining focus
func entering_object_influence(body):
	var save_new_origin=body.get_parent()
	if body.is_in_group("obeject_list_area"):
		for obj in get_tree().get_nodes_in_group("obeject_list"):
			if obj != save_new_origin:
				obj.call_deferred('free') # execute commands queue_free when program is in idle time
				remove_child(obj)
				
	move_camera_focus(body)
	pass # Replace with function body.
