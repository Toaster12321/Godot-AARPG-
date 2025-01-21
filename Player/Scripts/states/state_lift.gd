class_name State_Lift extends State

@export var lift_audio : AudioStream

@onready var carry : State = $"../Carry"



#what happens when the player enters this state?
func Enter() -> void:
	player.UpdateAnimation( "lift" )
	player.animation_player.animation_finished.connect( state_complete )
	player.audio.stream = lift_audio
	player.audio.play()
	pass
	
# what happens when the player exits this state?
func Exit() -> void:
	pass
	
#what happens during the _process update in this state?
func Process(_delta : float) -> State:
	player.velocity = Vector2.ZERO
	return null

#what happens during the _physics_process update in this state?
func Physics(_delta : float) -> State:
	return null

#what happens with input events in this state?
func HandleInput(_event : InputEvent) -> State:
	return null


func state_complete( _a : String ) -> void:
	player.animation_player.animation_finished.disconnect( state_complete )
	state_machine.ChangeState( carry )
	pass
