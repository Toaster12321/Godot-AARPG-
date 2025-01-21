class_name EnemyState extends Node


##Stores a reference to the enemy that this state belongs to
var enemy : Enemy 
var state_machine : EnemyStateMachine

#what happens when we initialize this state?
func init() -> void:
	pass

#what happens when the enemy enters this state?
func enter() -> void:
	pass
	
# what happens when the enemy exits this state?
func exit() -> void:
	pass
	
#what happens during the _process update in this state?
func process(_delta : float) -> EnemyState:
	return null

#what happens during the _physics_process update in this state?
func physics(_delta : float) -> EnemyState:
	return null
