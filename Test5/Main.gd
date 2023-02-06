extends Node2D

export var damage : int = 4

var block = 0
var level = 1

var player_lines = [
	"Let's see if rats can swim",
	"I hope you're ready for a rat-astrophe",
	"I'll rat-ionally handle this situation",
	"I'll make ratatouille out of you",
	"Rats? More like bats... out of hell",
	"You're in for a rat-tling good time",
	"I've got some cheese for you",
	"I'll be your rodent-icide",
	"You're in for a mouse-terpiece of a battle",
	"Looks like you've been caught in a rat trap",
	"I'll give you the cheese, but it'll be the last thing you'll taste",
	"I hope you're ready for some rat-tling good action",
	"You're in for a rat-tling good time",
	"I'll make you squeal like a pig",
	"I'll send you running back to the rat race",
	"Looks like I'll be the rat king of this dungeon",
	"Looks like you're in for a rat-tling good defeat",
	"I'll make you scurry away",
	"You're in for a rat-tling good end",
	"I'll show you who's the real rat king of this dungeon"
]


onready var enemy = $Enemy
onready var player = $Player
onready var ui = $CanvasLayer/UI
onready var chat_label = $CanvasLayer/UI/TextPanel/ChatLabel
onready var enemy_pos = $Position2D
onready var start_screen = $CanvasLayer/StartScreen
onready var hp_label = $CanvasLayer/UI/StatsPanel/HBoxContainer/HPLabel

func _on_UI_sword():
	block = 0
	chat_label.text = "Player:\n" + "Attacking!!"
	enemy.hp -= damage


func _on_Enemy_enemy_dead():
	if level == 1:
		level += 1
		ui.start_level("LEVEL 2")
		instance_enemy("res://Enemy_Slime.tscn", "Enemy_Slime")
	elif level == 2:
		level += 1
		ui.start_level("LEVEL 3")
		instance_enemy("res://Enemy_Skeleton.tscn", "Enemy_Skeleton")

func instance_enemy(path, node_name):
	var enemy_instance = load(path).instance()
	enemy_instance.connect("enemy_attacks", self, "_on_Enemy_enemy_attacks")
	if level  == 3:
		enemy_instance.connect("player_won", self, "victory")
	else:
		enemy_instance.connect("enemy_dead", self, "_on_Enemy_enemy_dead")
	enemy_instance.position = enemy_pos.position
	add_child(enemy_instance)
	enemy = get_node(node_name)


func _on_Enemy_enemy_attacks(value):
	var enemy_damage = (randi() % (value+1)) + value
	enemy_damage -= block
	player.cur_hp -= enemy_damage


func _on_UI_magic():
	block = 0
	if player.cur_mp >= 2:
		chat_label.text = "Player:\n" + "Casting!!"
		player.cur_mp -= 2
		enemy.hp -= 80
	else:
		chat_label.text = "Player:\n" + "Not enough mp :("


func _on_UI_chat():
	block = 0
	randomize()
	var chat_line = randi() % player_lines.size()
	chat_label.text = "Player:\n" + player_lines[chat_line]
	#enemy.attack()
	enemy.hp -= 0


func _on_UI_block():
	block = (randi() % 2) + 1
	chat_label.text = "Player:\n" + "Blocking!!"
	#enemy.attack()
	enemy.hp -= 0


func _on_Button_pressed():
	start_game()

func start_game():
	player.cur_hp = player.max_hp
	if get_node_or_null("Enemy") == null:
		instance_enemy("res://Enemy.tscn", "Enemy")
	start_screen.hide()
	ui.start_level("LEVEL 1")
	
func victory():
	ui.show_victory()

func _on_Player_player_dead():
	ui.show_lose()
