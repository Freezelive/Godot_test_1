extends Node2D

#global delcarations
var player_kin_body = KinematicBody2D.new()
var player_sprite_texture = preload("./resources/sprite.png")
var player_sprite=Sprite.new()
var screen_size=OS.get_window_safe_area().size #get screen size
var player_colision_shape = CollisionShape2D.new()
var player_colision_form= RectangleShape2D.new()
var player_area_2d=Area2D.new()

#camera
var player_follow_camera = Camera2D.new()
var active_player_follow_camera="active_player_follow_camera"



#global variables
var speed = 400
var rotation_dir = 0
var rotation_speed = 1.5
var velocity = Vector2()
var target = Vector2()


func alfatest(body):
	print (body)
	


func object_spawn():
	
	#use screen size as reference
	var screen_x=screen_size.x+screen_size.x/2
	var screen_y=screen_size.y+screen_size.y/2
	
	#additional objects
	var objects_list =[]
	var tmp
	
	var global_position_of_object_x=[screen_x,-screen_x,0,0,screen_x,screen_x,-screen_x,-screen_x]
	var global_position_of_object_y=[0,0,screen_y,-screen_y,screen_y,-screen_y,screen_y,-screen_y]
	
	var i =0
	while i<8 :
#		var additional_object_body =  StaticBody2D.new()
#		var additional_object_sprite = Sprite.new() 
#		var additional_object_sprite_texture  = preload("./resources/sprite_object.jpg")
#		var additional_object_colission = CollisionShape2D.new()
#		var additional_object_colission_circleshape=CircleShape2D.new()
#		var additional_object_area=Area2D.new()
#		additional_object_sprite.scale=Vector2(0.1,0.1)
#		additional_object_sprite.texture=additional_object_sprite_texture
#		additional_object_body.add_child(additional_object_sprite)
#		
#		additional_object_colission_circleshape.radius=screen_size.x/2
#		additional_object_colission.shape=additional_object_colission_circleshape
#		
#		additional_object_body.add_child(additional_object_area)
#		additional_object_body.add_child(additional_object_colission)
#		additional_object_body.add_to_group("list_of_objects")
#		additional_object_body.global_position=(Vector2(global_position_of_object_x[i],global_position_of_object_y[i]))
#		add_child(additional_object_body)
#		objects_list.push_front(additional_object_body)
		
		var additional_object_sprite_main = Sprite.new() 
		var additional_object_sprite_texture  = preload("./resources/sprite_object.jpg")
		var additional_object_colission = CollisionShape2D.new()
		var additional_object_colission_circleshape=CircleShape2D.new()
		var additional_object_area=Area2D.new()
		
		additional_object_sprite_main.scale=Vector2(0.1,0.1)
		additional_object_sprite_main.texture=additional_object_sprite_texture
		
		additional_object_colission_circleshape.radius=screen_size.x*5
		additional_object_colission.shape=additional_object_colission_circleshape
		
		#additional_object_area.connect("body_entered",self,"alfatest",[self])
		
		additional_object_sprite_main.add_child(additional_object_area)
		additional_object_sprite_main.add_child(additional_object_colission)
		#additional_object_sprite_main.connect("body_entered",self,"_on_Area2D_body_entered")
		additional_object_sprite_main.global_position=(Vector2(global_position_of_object_x[i],global_position_of_object_y[i]))
		
		add_child(additional_object_sprite_main)
		objects_list.push_front(additional_object_sprite_main)
		i +=1
		
			
		pass
	
	
	pass




# Called when the node enters the scene tree for the first time.
func _ready():
	object_spawn()
	#body of player
	player_sprite.texture=player_sprite_texture
	player_sprite.scale=Vector2(0.1,0.1) #set sprite size
	player_colision_form.extents=player_sprite.texture.get_size()*0.09
	player_kin_body.add_child(player_sprite)
	player_colision_shape.shape=player_colision_form
	player_kin_body.add_child(player_colision_shape)
	player_kin_body.position=Vector2(100,100)
	
	player_area_2d.connect("body_entered",self,"_on_Area2D_body_entered")
	#player_area_2d.connect("body_entered",self,"_on_Area2D_body_entered")
	player_kin_body.add_child(player_area_2d)
	print(player_area_2d.get_property_list().find("connect"))
	#camera
	player_follow_camera.make_current()  #make this camera current
	player_follow_camera.name=active_player_follow_camera #set name to be used later
	player_kin_body.add_child(player_follow_camera,true) #add camra to body and keep name else it will be just index
	
	add_child(player_kin_body) #add body to main scene
	for i in player_kin_body.get_child_count():  #this for iterates all the children in the $player_kin_body and checks the name set above and save varaible for later use
	#	print (player_kin_body.get_child(i).name)
	#	print (active_player_follow_camera)
		if player_kin_body.get_child(i).name == active_player_follow_camera:
			active_player_follow_camera=player_kin_body.get_child(i)
	#		print (active_player_follow_camera)
		
	
	
	#set camera margins 
	active_player_follow_camera.set_drag_margin(0,0)
	active_player_follow_camera.set_drag_margin(1,0)
	active_player_follow_camera.set_drag_margin(2,0)
	active_player_follow_camera.set_drag_margin(3,0)
	
	pass # Replace with function body.


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






func layer_and_mask_manager(body,change=false):
	if body != null:
		for i in range(20):
			if change==false:
				print("maks ",i, '\t', player_kin_body.get_collision_mask_bit(i)," | layer ",i, '\t', player_kin_body.get_collision_layer_bit(i))
			if player_kin_body.get_collision_mask_bit(i) == true && change==true:
				player_kin_body.set_collision_mask_bit(i,false)
				player_kin_body.set_collision_layer_bit(i,false)
				print ("changing bit ",i," from true to false")
	pass





# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#print(active_player_follow_camera.get_drag_margin(0),"-",active_player_follow_camera.get_drag_margin(1),"--",active_player_follow_camera.get_drag_margin(2),"---",active_player_follow_camera.get_drag_margin(3))
	
	
	grid_move()
	#player_kin_body.move_and_slide(velocity)
	#var tmp = player_kin_body.move_and_collide(velocity*delta)
	var tmp=player_kin_body.move_and_collide(velocity*delta)
	#print (tmp, " ", player_kin_body)
	#if tmp != null:
	#	layer_and_mask_manager(tmp,true)
	#pass



func _on_Area2D_body_entered(body):
	print (body)
	print ("2")
	pass # Replace with function body.
