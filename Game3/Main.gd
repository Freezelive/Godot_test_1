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
var player_camera = Camera2D.new()
#var active_follow_camera=follow_camera



#global variables
var speed = 400
var rotation_dir = 0
var rotation_speed = 1.5
var velocity = Vector2()
var target = Vector2()


func alfatest(body):
	print (body)
	


func object_spawn(global_posiion=Vector2(0,0)):
	
	#use screen size as reference
	var screen_x=screen_size.x+screen_size.x/20
	var screen_y=screen_size.y+screen_size.y/2
	
	var additional_object_sprite_main_position
	#print (additional_object_sprite_main_position)
	#additional objects
	var objects_list =[]
	var tmp
	
	var global_position_of_object_x=[screen_x,-screen_x,0,0,screen_x,screen_x,-screen_x,-screen_x]
	var global_position_of_object_y=[0,0,screen_y,-screen_y,screen_y,-screen_y,screen_y,-screen_y]
	
	var i =0
	while i<8 :
		var additional_object_sprite_main = Sprite.new() 
		var additional_object_sprite_texture  = preload("./resources/sprite_object.jpg")
		var additional_object_colission = CollisionShape2D.new()
		var additional_object_colission_circleshape=CircleShape2D.new()
		var additional_object_area=Area2D.new()
		var additioanl_optional_camera=Camera2D.new()
		
		additional_object_area.add_to_group("obeject_list_area")
		additional_object_sprite_main.scale=Vector2(0.1,0.1)
		additional_object_sprite_main.texture=additional_object_sprite_texture
		additional_object_colission.modulate=Color( 0, 0, 0.55, 1 )
		additional_object_colission_circleshape.radius=screen_size.x*2
		additional_object_colission.shape=additional_object_colission_circleshape
		additional_object_area.monitoring=true
		additional_object_area.monitorable=true
		additional_object_area.add_child(additional_object_colission)
		additioanl_optional_camera.name="active_camera"
		additional_object_area.add_child(additioanl_optional_camera,true)
		additional_object_sprite_main.add_child(additional_object_area)
		additional_object_sprite_main_position=additional_object_sprite_main.get_transform()
		additional_object_sprite_main_position[2]=-Vector2(global_position_of_object_x[i]-global_posiion.x,global_position_of_object_y[i]-global_posiion.y)
		additional_object_sprite_main.add_to_group("obeject_list")
		additional_object_sprite_main.set_transform(additional_object_sprite_main_position)
		add_child(additional_object_sprite_main)
		#print(additional_object_sprite_main.get_children())
		objects_list.push_front(additional_object_sprite_main)
		i +=1
		
			
		pass
	
	
	pass


# Called when the node enters the scene tree for the first time.
func _ready():
	#body of player
	player_sprite.texture=player_sprite_texture
	player_sprite.scale=Vector2(0.1,0.1) #set sprite size
	#player_colision_form.extents=player_sprite.scale
	player_colision_form.extents=player_sprite.texture.get_size()*0.3
	player_colision_shape.shape=player_colision_form
	
	
	player_kin_body.position=Vector2(0,0)
	
	player_area_2d.connect("area_entered",self,"entering_object_influence")
	player_area_2d.connect("area_exited",self,"exit_object_influence")
	player_area_2d.monitoring=true
	player_area_2d.monitorable=true
	player_area_2d.add_child(player_colision_shape)
	player_sprite.add_child(player_area_2d)
	
	
	
	player_kin_body.add_child(player_sprite)
	
	player_camera.name="active_camera" 
	player_kin_body.add_child(player_camera,true) 
	
	#camera
	#follow_camera.make_current()  #make this camera current
	#follow_camera.name="active_camera" #set name to be used later
	#player_kin_body.add_child(follow_camera,true) #add camra to body and keep name else it will be just index
	
	add_child(player_kin_body) #add body to main scene
	
	move_camera_focus(player_kin_body)
	#for i in player_kin_body.get_child_count():  #this for iterates all the children in the $player_kin_body and checks the name set above and save varaible for later use
	#	if player_kin_body.get_child(i).name == follow_camera:
	#		active_player_follow_camera=player_kin_body.get_child(i)
	#	
	
	#set camera margins 
	player_camera.set_drag_margin(0,0)
	player_camera.set_drag_margin(1,0)
	player_camera.set_drag_margin(2,0)
	player_camera.set_drag_margin(3,0)
	
	object_spawn(player_kin_body.position)
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


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#print(active_follow_camera)
	grid_move()
	#print(player_kin_body.position)
	var tmp=player_kin_body.move_and_collide(velocity*delta)


func move_camera_focus(owner):
	print(owner)
	for i in owner.get_child_count():  #this for iterates all the children in the $player_kin_body and checks the name set above and save varaible for later use
		if owner.get_child(i).name == "active_camera":
			print(owner.get_child(i))
			owner.get_child(i).make_current()
			#active_follow_camera.make_current()
	pass

func exit_object_influence(boxy):
	move_camera_focus(player_kin_body)
	#print ("test")
	call_deferred("object_spawn",player_kin_body.position)
	pass

func entering_object_influence(body):
	#print ("test1")
	var save_new_origin=body.get_parent()
	if body.is_in_group("obeject_list_area"):
		for obj in get_tree().get_nodes_in_group("obeject_list"):
			if obj != save_new_origin:
				obj.call_deferred('free')
				remove_child(obj)
				
	print(body.get_children())
	move_camera_focus(body)
	pass # Replace with function body.
