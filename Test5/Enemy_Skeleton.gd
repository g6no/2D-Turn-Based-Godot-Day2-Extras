extends Node2D

signal player_won
signal enemy_attacks(value)

var hp : int = 35 setget set_hp
var shielding = false
var block = 0

onready var hp_text = $HPLabel
onready var anim_player = $AnimationPlayer
onready var anim = $AnimatedSprite
onready var sprite = $Sprite
onready var attack_timer = $AttackTimer
onready var grid = get_node("/root/Main/CanvasLayer/UI/GridContainer")

func _ready():
	hp_text.text = str(hp) + " Hp"

func set_hp(new_hp):
	print(new_hp)
	var prev_hp = hp
	hp = (new_hp + block)
	hp_text.text = str(hp) + " Hp"
	
	if hp <= 0:
		emit_signal("player_won")
		queue_free()
	else:
		if not shielding and prev_hp != hp:
			play_animation("Take_Hit")
			yield(anim,"animation_finished")
			play_animation("Idle")
		elif prev_hp != hp:
			sprite.modulate = Color(1,0,0,1)
			play_animation("Shield")
			yield(anim,"animation_finished")
			sprite.modulate = Color(1,1,1,1)
		else:
			play_animation("Idle")
		
		attack_timer.start()
		yield(attack_timer, "timeout")
		attack()

func attack():
	if not shielding:
		grid.hide()
		randomize()
		var rand_num = randi() % 5
		if rand_num < 3:
			light_attack()
		else:
			shield()
	else:
		shield()

func light_attack():
	play_animation("Attack")
	yield(anim, "animation_finished")
	play_animation("Idle")
	grid.show()
	emit_signal("enemy_attacks", 5)
	block = 0
	shielding = false

func shield():
	if not shielding:
		play_animation("Shield")
		emit_signal("enemy_attacks", 0)
		grid.show()
		shielding = true
		block = (randi() % 4) + 2
	else:
		grid.show()
		emit_signal("enemy_attacks", 0)
		shielding = false

func play_animation(animation):
	if anim.animation != animation:
		anim.play(animation)
