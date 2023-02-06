extends Node2D

signal hp_changed(value)
signal mp_changed(value)
signal player_dead

var max_hp : int = 100
var cur_hp : int = max_hp setget set_hp

var max_mp : int = 10
var cur_mp : int = max_mp setget set_mp

var sword_damage : int = 3
var magic_damage : int = 5

func set_hp(new_hp):
	cur_hp = new_hp
	if cur_hp <= 0:
		emit_signal("player_dead")
	emit_signal("hp_changed", cur_hp)
	
func set_mp(new_mp):
	cur_mp = new_mp
	emit_signal("mp_changed", cur_mp)
