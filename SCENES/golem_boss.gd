extends CharacterBody2D

@onready var player = get_parent().find_child("player")
@onready var sprite = $Sprite2D
@onready var progress_bar = $UI/ProgressBar
@onready var laser_damage_area = $LaserDamageArea # Already there

var direction : Vector2
var DEF = 0 # Defense stat

var health = 100:
	set(value):
		health = value
		progress_bar.value = value
		if value <= 0:
			progress_bar.visible = false
			find_child("FiniteStateMachine").change_state("Death")
		elif value <= progress_bar.max_value / 2 and DEF == 0:
			DEF = 5 # Increase defense when health is half or less
			find_child("FiniteStateMachine").change_state("ArmorBuff") # Transition to ArmorBuff state

func _ready():
	set_physics_process(false)
	progress_bar.max_value = health
	progress_bar.value = health
	if laser_damage_area: # Ensure this check if you might not have the node
		laser_damage_area.monitoring = false
		laser_damage_area.monitorable = false
		laser_damage_area.body_entered.connect(_on_laser_damage_area_body_entered)

func _process(_delta):
	direction = player.position - position

	if direction.x < 0:
		sprite.flip_h = true
	else:
		sprite.flip_h = false

func _physics_process(delta):
	velocity = direction.normalized() * 40
	move_and_collide(velocity * delta)

func take_damage(amount: int):
	var final_damage = max(0, amount - DEF)
	health -= final_damage
	health = max(0, health)
	print("Boss health: ", health)
	if health <= 0:
		progress_bar.visible = false
		find_child("FiniteStateMachine").change_state("Death")

func _on_laser_damage_area_body_entered(body):
	if body == player:
		player.take_damage(10)

# --- NEW FUNCTION FOR MELEE DAMAGE ---
func deal_melee_damage_to_player():
	# You can add a check here if the player is within melee range,
	# or just assume the animation timing implies a hit.
	# A simple check: Is the player very close to the enemy?
	if player.global_position.distance_to(self.global_position) < 70: # Adjust range as needed
		player.take_damage(20) # Adjust damage amount as needed (e.g., 20 damage)
		print("Player hit by melee attack! Health: ", player.health)
