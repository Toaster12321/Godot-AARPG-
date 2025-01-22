class_name State_Death extends State

@export var exhaust_audio : AudioStream
@onready var audio : AudioStreamPlayer2D = $"../../Audio/AudioStreamPlayer2D"


#what happens when we initialize this state?
func init() -> void:
	pass


#what happens when the player enters this state?
func Enter() -> void:
	player.animation_player.play("death")
	audio.stream = exhaust_audio
	audio.play()
	#trigger game over UI
	AudioManager.play_music( null )
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
