class_name State_Carry extends State

@export var move_speed : float = 80.0
@export var throw_audio : AudioStream

var walking : bool = false
var throwable : Throwable

@onready var idle: State_Idle = $"../Idle"
@onready var stun: State_Stun = $"../Stun"


#what happens when we initialize this state?
func init() -> void:
	pass


#what happens when the player enters this state?
func Enter() -> void:
	player.UpdateAnimation( "carry" )
	walking = false
	pass
	
# what happens when the player exits this state?
func Exit() -> void:
	#throw object
	if throwable:
		# Throw direction 
		if player.direction == Vector2.ZERO:
			throwable.throw_direction = player.cardinal_direction
		else:
			throwable.throw_direction = player.direction
		# Was Player stunned? if so drop item 
		if state_machine.next_state == stun:
			#drop item
			throwable.throw_direction = throwable.throw_direction.rotated( PI )
			throwable.drop()
			pass
		else:
			#throw item
			player.audio.stream = throw_audio
			player.audio.play()
			throwable.throw()
			pass
		
		pass
	pass
	
#what happens during the _process update in this state?
func Process( _delta : float) -> State:
	if player.direction == Vector2.ZERO:
		walking = false
		player.UpdateAnimation( "carry" )
	elif player.SetDirection() or walking == false:
		player.UpdateAnimation( "carry_walk" )
		walking = true
	player.velocity = player.direction * move_speed
	return null

#what happens during the _physics_process update in this state?
func Physics(_delta : float) -> State:
	return null

#what happens with input events in this state?
func HandleInput(_event : InputEvent) -> State:
	if _event.is_action_pressed( "attack" ) or _event.is_action_pressed( "interact" ):
		return idle
	return null
