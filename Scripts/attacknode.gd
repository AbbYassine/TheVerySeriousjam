extends Node

func Attack():
	var target = get_parent().CurrentTarget
	var damage = CalculateDamage()


func CalculateDamage():
	pass
