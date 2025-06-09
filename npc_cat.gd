extends Node2D

const speed = 50
var current_state = IDLE

var dir = Vector2.RIGHT
var start_pos

var is_roaming = true
var is_chatting = false

var player_in_area = false

var player
var player_in_chat_zone = false
enum{
	IDLE,
	NEW_DIR,
	MOVE
}

func _ready():
	randomize()
	start_pos = position
	
func _process(delta):
	if player_in_area:
		if Input.is_action_just_pressed("f"):
			run_dialogue("catGiving")
	if current_state == 0 or  current_state == 1:
		$AnimatedSprite2D.play("idle")
	elif current_state == 2 and !is_chatting:
		if dir.x == -1:
			$AnimatedSprite2D.play("walk left")
		if dir.x == 1:
			$AnimatedSprite2D.play("walk right")
		if dir.y == -1:
			$AnimatedSprite2D.play("walk up")
		if dir.y == 1:
			$AnimatedSprite2D.play("walk down")
			
	if is_roaming:
		match current_state:
			IDLE:
				pass
			NEW_DIR:
				dir = choose([Vector2.RIGHT, Vector2.UP, Vector2.LEFT, Vector2.DOWN])
			MOVE:
				move(delta)
	


func run_dialogue(dialogue_string):
	is_chatting = true
	is_roaming = false
	
	Dialogic.start(dialogue_string)



func choose(array):
	array.shuffle()
	return array.front()
	
func move(delta):
	if !is_chatting:
		position += dir * speed * delta
		





func _on_timer_timeout():
	$Timer.wait_time = choose([0.5,1,1.5])
	current_state =choose([IDLE, NEW_DIR, MOVE])


func _on_dialogue_dialogue_finished():
	is_chatting = false
	is_roaming = true 


func _on_chat_detection_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player_in_area = true


func _on_chat_detection_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		player_in_area = false
