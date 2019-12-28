extends Node2D

var target_to_go_towards

var my_body
var direction=Vector2(0,0)
var ignore_object_by_name_stack=["TileMap"]

# Called when the node enters the scene tree for the first time.
func _ready():
	my_body=get_node("KinematicBody2D")
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	move_to_enemy(target_to_go_towards)
	pass

func move_to_enemy(body):
	if body!=null:
		var direction = (body.position - my_body.position).normalized()
		my_body.move_and_collide(direction)
		direction=Vector2(0,0)
	pass

func _on_Area2D_body_entered(body):
	if body != my_body :
		if target_to_go_towards!=body:
			for i in ignore_object_by_name_stack.size():
				if body.get_class() != ignore_object_by_name_stack[i]:
					target_to_go_towards=body
	pass # Replace with function body.


func _on_Area2D_body_exited(body):
	target_to_go_towards=null
	pass # Replace with function body.
