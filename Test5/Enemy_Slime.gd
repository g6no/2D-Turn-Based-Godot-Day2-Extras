extends Node2D

signal enemy_dead
signal enemy_attacks(value)

var hp : int = 35 setget set_hp
var attacking = false

onready var hp_text = $HPLabel
onready var anim_player = $AnimationPlayer
onready var sprite = $Sprite
onready var attack_timer = $AttackTimer
onready var grid = get_node("/root/Main/CanvasLayer/UI/GridContainer")

func _ready():
	hp_text.text = str(hp) + " Hp"

func set_hp(new_hp):
	print(new_hp)
	var prev_hp = hp
	hp = new_hp
	hp_text.text = str(hp) + " Hp"
	
	if hp <= 0:
		emit_signal("enemy_dead")
		queue_free()
	else:
		if not attacking and prev_hp != hp:
			sprite.modulate = Color(1,0,0,1)
			anim_player.play("Damaged")
			yield(anim_player, "animation_finished")
			sprite.modulate = Color(1,1,1,1)
		elif prev_hp != hp:
			sprite.modulate = Color(1,0,0,1)
			anim_player.play("Damaged_Attacking")
			yield(anim_player, "animation_finished")
			sprite.modulate = Color(0.726,0.208,0.475,1)
		
		attack_timer.start()
		yield(attack_timer, "timeout")
		attack()

func attack():
	if not attacking:
		grid.hide()
		randomize()
		var rand_num = randi() % 5
		if rand_num < 3:
			light_attack()
		else:
			heavy_attack()
	else:
		heavy_attack()

func light_attack():
	sprite.modulate = Color(0.722,0.275,0.275,1)
	anim_player.play("Attack")
	yield(anim_player, "animation_finished")
	grid.show()
	emit_signal("enemy_attacks", 3)
	sprite.modulate = Color(1,1,1,1)
	attacking = false

func heavy_attack():
	if not attacking:
		sprite.modulate = Color(0.726,0.208,0.475,1)
		anim_player.play("Heavy_Attack_Start")
		yield(anim_player, "animation_finished")
		grid.show()
		emit_signal("enemy_attacks", 0)
		attacking = true
	else:
		print("Heavy attack Finished")
		anim_player.play("Heavy_Attack_End")
		yield(anim_player, "animation_finished")
		grid.show()
		emit_signal("enemy_attacks", 6)
		sprite.modulate = Color(1,1,1,1)
		attacking = false
