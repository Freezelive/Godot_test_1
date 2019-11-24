extends Node


#------------------------------------
#-------------------------------------
#Createa a static bodys in random locations with random size all from code. 
#-------------------------------------
#------------------------------------



func create_object_on_scene():
	#-------------------------------------
	#Declare the items for a sprite
	#-------------------------------------
	var sprite_texture = preload("./resources/sprite.png")
	var sprite_body = StaticBody2D.new()
	var sprite_item=Sprite.new() 
	
	
	#-------------------------------------
	#merge sprite items  togheder
	#-------------------------------------
	sprite_item.texture = sprite_texture #add texture to sprite
	sprite_item.scale=Vector2(0.5,0.5) #set sprite size
	sprite_body.add_child(sprite_item) #add sprite to body
	#return the newly created sprite
	return sprite_body
var rng = RandomNumberGenerator.new()
var bodyque = [] #hold elemnts creating an array
var bodyque_lifetime=[]
var screen_size=OS.get_window_safe_area().size #get screen size

func remove_object_to_scene(var body):
	body.queue_free()
	pass

func add_object_to_scene(var body):
	body.add_to_group("printed")  #adds body to group printed this also created the group printe if 
	add_child(body)
	pass


func sprite_manage(var body_collection):
	var current = 0
	var tmp
	while current < len(body_collection):
		#print_debug(get_tree().get_root())
		print ( get_tree().get_nodes_in_group("printed").size())
		if !body_collection[current].is_in_group("printed"): #check if body is in group printed
			add_object_to_scene(body_collection[current])
			bodyque_lifetime.push_front(rng.randf_range (10, 20)) #a variable to set lifetime of body
			body_collection[current].scale=Vector2(randf(),randf()) #set sprite size
			body_collection[current].global_position=Vector2(rng.randf_range (0, screen_size.x ),rng.randf_range (0, screen_size.y )) #set position
		bodyque_lifetime[current]=bodyque_lifetime[current]-1 #used for body lifetime
		
		if bodyque_lifetime[current]<0: #if body lifetime is smaller then 0 destroy it 
			tmp=body_collection[current] #tmp var used to store body that will be destroyed
			body_collection.remove(current)
			bodyque_lifetime.remove(current)
			remove_object_to_scene(tmp)
			current-=1
		current += 1
		pass

# Called when the node enters the scene tree for the first time.
func _ready():
	#bodyque=insert.create_object_on_scene()
	Engine.target_fps=60

	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	bodyque.push_front (create_object_on_scene()) #store nely created sprite
	sprite_manage(bodyque) #process newly created/existing bodys
	
	pass
