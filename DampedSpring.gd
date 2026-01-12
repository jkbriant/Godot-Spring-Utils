class_name DampedSpring

var _pos: float = 0.0
var _vel: float = 0.0

var _params := SpringUtils.DampedSpringMotionParams.new()

var position: float:
	get:
		return _pos

var velocity: float:
	get:
		return _vel

func reset(value: float) -> void:
	_pos = value
	_vel = 0.0

func set_state(pos: float, vel: float = 0.0) -> void:
	_pos = pos
	_vel = vel

func step(
	delta: float,
	equilibrium_pos: float,
	angular_frequency: float,
	damping_ratio: float
) -> void:
	SpringUtils.calc_damped_spring_motion_params(
		_params,
		delta,
		angular_frequency,
		damping_ratio
	)

	var old_pos = _pos - equilibrium_pos
	var old_vel = _vel

	_pos = (
		old_pos * _params.pos_pos_coef
		+ old_vel * _params.pos_vel_coef
		+ equilibrium_pos
	)

	_vel = (
		old_pos * _params.vel_pos_coef
		+ old_vel * _params.vel_vel_coef
	)

func nudge(impulse: float) -> void:
	_vel += impulse
