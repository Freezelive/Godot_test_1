extends Node2D

onready var sprite = preload("./enemy.tscn")
onready var path_to_follow = get_node("Path2D/PathFollow2D")


#global delcarations
var player_kin_body = KinematicBody2D.new()
var player_sprite_texture = preload("./resources/sprite.png")
var player_sprite=Sprite.new()
var player_colision_shape = CollisionShape2D.new()
var player_colision_form= RectangleShape2D.new()
var player_area_2d=Area2D.new()
var player_camera_2d=Camera2D.new()

var speed = 600
var rotation_dir = 0
var rotation_speed = 1.5
var velocity = Vector2()
var target = Vector2()
var pathtofollow=0

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
	player_sprite.texture=player_sprite_texture
	player_colision_form.extents=player_sprite_texture.get_size()/2 #Vector based. Half vector to match sprite size 
	player_colision_shape.shape=player_colision_form
	player_area_2d.connect("area_entered",self,"entering_object_influence")
	player_kin_body.add_child(player_colision_shape)
	player_camera_2d.make_current()
	player_kin_body.add_child(player_sprite)
	player_kin_body.add_child(player_camera_2d)
	player_kin_body.position=Vector2(200,200)

	add_child(player_kin_body)
	spanw_enemy()
	set_process(true)
	pass # Replace with function body.

func entering_object_influence(body):
	#print (body)
	pass

func spanw_enemy():
	var s = sprite.instance()
	add_child(s)
	return

func _process(delta):
	path_to_follow.set_offset(path_to_follow.get_offset() + 360 * delta)
	print(get_node("Path2D/PathFollow2D").offset)

func _physics_process(delta):
	grid_move()
	var tmp =player_kin_body.move_and_collide(velocity*delta)
	if Input.is_action_pressed("ui_cancel"):
		if get_tree().change_scene("res://mainMenu.tscn") != OK:
			print ("An unexpected error occured when trying to switch to the Readme scene")


