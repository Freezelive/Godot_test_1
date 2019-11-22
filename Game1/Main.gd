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
	sprite_body.global_position=Vector2(100,100) #set location of body
	#add_child(sprite_body) #add body to scene
	#return the newly created sprite
	return sprite_body

var bodyque = [] #hold elemnts creating an array
var bodyque_lifetime=[]
var screen_size=get_viewport()


func sprite_manage(var body_collection):
	var current = 0
	while current < len(body_collection):
		print("Graham ate all the",body_collection[current])
		print (randf())
		current += 1
		pass

func remove_object_to_scene():
	pass

func add_object_to_scene():
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	#bodyque=insert.create_object_on_scene()
	bodyque.push_front (create_object_on_scene()) #store nely created sprite
	
	add_object_to_scene()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
