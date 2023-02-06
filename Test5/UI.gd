extends Control

signal sword
signal block
signal magic
signal chat

onready var hp_label = $StatsPanel/HBoxContainer/HPLabel
onready var mp_label = $StatsPanel/HBoxContainer/MPLabel
onready var level_screen = $LevelScreen
onready var victory_screen = $VictoryScreen
onready var lose_screen = $LoseScreen
onready var label = $LevelScreen/LevelLabel

onready var start_screen = get_node("/root/Main/CanvasLayer/StartScreen")


func _on_SwordButton_pressed():
	emit_signal("sword")

func _on_BlockButton_pressed():
	emit_signal("block")

func _on_MagicButton_pressed():
	emit_signal("magic")

func _on_ChatButton_pressed():
	emit_signal("chat")

func _on_Player_hp_changed(value):
	hp_label.text = "HP\n"+str(value)

func _on_Player_mp_changed(value):
	mp_label.text = "MP\n"+str(value)
	
func start_level(thing):
	label.text = thing
	level_screen.show()
	yield(get_tree().create_timer(2), "timeout")
	level_screen.hide()

func show_victory():
	victory_screen.show()
	yield(get_tree().create_timer(3), "timeout")
	victory_screen.hide()
	start_screen.show()

func show_lose():
	lose_screen.show()
	yield(get_tree().create_timer(3), "timeout")
	lose_screen.hide()
	start_screen.show()
