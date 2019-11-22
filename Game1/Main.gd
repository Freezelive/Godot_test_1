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
	var sprite_texture = preload("res://Game1/resources/sprite.jpg")
	var sprite_body = StaticBody2D.new()
	var sprite_item=Sprite.new() 
	
	#-------------------------------------
	#merge them togheder
	#-------------------------------------
	sprite_item.texture = sprite_texture #add texture to sprite
	sprite_item.scale=Vector2(0.5,0.5) #set sprite size
	sprite_body.add_child(sprite_item) #add sprite to body
	sprite_body.global_position=Vector2(0,0) #set location of body
	#add_child(sprite_body) #add body to scene
	#return the newly created sprite
	return sprite_body
var rng = RandomNumberGenerator.new()
var bodyque = [] #hold elemnts creating an array
var bodyque_lifetime=[]
var screen_size=OS.get_window_safe_area().size
var bodies_to_be_removed=[]
func remove_object_to_scene(var body):
	body.queue_free()
	pass

func add_object_to_scene(var body):
	add_child(body)
	pass


func sprite_manage(var body_collection):
	var current = 0
	var tmp
	while current < len(body_collection):
		if body_collection[current].global_position == Vector2(0,0):
			bodyque_lifetime.push_front(rng.randf_range (10, 20))
			body_collection[current].scale=Vector2(randf(),randf()) #set sprite size
			body_collection[current].global_position=Vector2(rng.randf_range (0, screen_size.x ),rng.randf_range (0, screen_size.y ))
			add_object_to_scene(body_collection[current])
		bodyque_lifetime[current]=bodyque_lifetime[current]-2
		
		if bodyque_lifetime[current]<0:
			tmp=body_collection[current]
			body_collection.remove(current)
			bodyque_lifetime.remove(current)
			remove_object_to_scene(tmp)
			current-=1
		current += 1
		pass

# Called when the node enters the scene tree for the first time.
func _ready():
	#bodyque=insert.create_object_on_scene()
	

	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	bodyque.push_front (create_object_on_scene()) #store nely created sprite
	sprite_manage(bodyque)
	pass
