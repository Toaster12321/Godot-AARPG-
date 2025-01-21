class_name State_ChargeAttack extends State

@export var charge_duration : float = 1.0
@export var move_speed : float = 80
@export var sfx_charged : AudioStream
@export var sfx_spin : AudioStream

var timer : float = 0.0
var walking : bool = false
var is_attacking : bool = false
var particles : ParticleProcessMaterial

@onready var idle: State_Idle = $"../Idle"
@onready var charge_hurt_box: HurtBox = %ChargeHurtBox
@onready var charge_spin_hurt_box: HurtBox = %ChargeSpinHurtBox
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $"../../Audio/AudioStreamPlayer2D"
@onready var spin_effect_sprite_2d: Sprite2D = $"../../Sprite2D/SpinEffectSprite2D"
@onready var spin_animation_player: AnimationPlayer = $"../../Sprite2D/SpinEffectSprite2D/AnimationPlayer"
@onready var gpu_particles_2d: GPUParticles2D = $"../../Sprite2D/ChargeHurtBox/GPUParticles2D"



#what happens when we initialize this state?
func init() -> void:
	gpu_particles_2d.emitting = false
	particles = gpu_particles_2d.process_material as ParticleProcessMaterial
	spin_effect_sprite_2d.visible = false
	pass


#what happens when the player enters this state?
func Enter() -> void:
	timer = charge_duration
	is_attacking = false
	walking = false
	charge_hurt_box.monitoring = true
	gpu_particles_2d.emitting = true
	gpu_particles_2d.amount = 4
	gpu_particles_2d.explosiveness = 0
	particles.initial_velocity_min = 10
	particles.initial_velocity_max = 30
	pass


# what happens when the player exits this state?
func Exit() -> void:
	charge_hurt_box.monitoring = false
	charge_spin_hurt_box.monitoring = false
	spin_effect_sprite_2d.visible = false
	gpu_particles_2d.emitting = false
	pass
	
#what happens during the _process update in this state?
func Process( _delta : float) -> State:
	#Handle Timer, when complete show player charge is complete
	if timer > 0:
		timer -= _delta
		if timer <= 0:
			timer = 0
			charge_complete()
			
	#detect input, walking or not?
	if is_attacking == false:
		if player.direction == Vector2.ZERO:
			walking = false
			player.UpdateAnimation( "charge" )
		elif player.SetDirection() or walking == false:
			walking = true
			player.UpdateAnimation( "charge_walk" )
			pass
	#move the player
	player.velocity = player.direction * move_speed
	return null

#what happens during the _physics_process update in this state?
func Physics( _delta : float) -> State:
	return null

#what happens with input events in this state?
func HandleInput( _event : InputEvent) -> State:
	if _event.is_action_released( "attack" ):
		if timer > 0:
			return idle
		elif is_attacking == false:
			charge_attack()
	return null


func charge_attack() -> void:
	is_attacking = true
	#play animation
	player.animation_player.play( "charge_attack" )
	player.animation_player.seek( get_spin_frame() )
	play_audio( sfx_spin )
	spin_effect_sprite_2d.visible = true
	spin_animation_player.play( "spin" )
	var _duration : float = player.animation_player.current_animation_length
	player.make_invulnerable( _duration )
	charge_spin_hurt_box.monitoring = true
	#wait for spin attack to compelete
	await get_tree().create_timer( _duration * 0.875 ).timeout
	
	state_machine.ChangeState( idle )
	pass


func get_spin_frame() -> float:
	var interval : float = 0.05
	match player.cardinal_direction:
		Vector2.DOWN:
			return interval * 0
		Vector2.UP:
			return interval * 4
		_:
			return interval * 6


func charge_complete() -> void:
	play_audio( sfx_charged )
	
	#increase particles 
	gpu_particles_2d.amount = 50
	gpu_particles_2d.explosiveness = 1
	particles.initial_velocity_min = 50
	particles.initial_velocity_max = 100
	#wait
	await get_tree().create_timer( 0.5 ).timeout
	#decrease particles
	gpu_particles_2d.amount = 10
	gpu_particles_2d.explosiveness = 0
	particles.initial_velocity_min = 10
	particles.initial_velocity_max = 30
	pass


func play_audio( _audio : AudioStream ) -> void:
	audio_stream_player_2d.stream = _audio
	audio_stream_player_2d.play()
	pass
