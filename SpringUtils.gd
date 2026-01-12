class_name SpringUtils

class DampedSpringMotionParams:
	var pos_pos_coef: float
	var pos_vel_coef: float
	var vel_pos_coef: float
	var vel_vel_coef: float

static func calc_damped_spring_motion_params(
	out_params: DampedSpringMotionParams,
	delta_time: float,
	angular_frequency: float,
	damping_ratio: float
) -> void:
	const EPSILON = 0.0001

	if damping_ratio < 0.0:
		damping_ratio = 0.0
	if angular_frequency < 0.0:
		angular_frequency = 0.0
	
	if angular_frequency < EPSILON:
		out_params.pos_pos_coef = 1.0
		out_params.pos_vel_coef = 0.0
		out_params.vel_pos_coef = 0.0
		out_params.vel_vel_coef = 1.0
		return
	
	if damping_ratio > 1.0 + EPSILON:
		# Overdamped
		var za = -angular_frequency * damping_ratio
		var zb = angular_frequency * sqrt(damping_ratio * damping_ratio - 1.0)
		var z1 = za - zb
		var z2 = za + zb

		var e1 = exp(z1 * delta_time)
		var e2 = exp(z2 * delta_time)

		var inv_two_zb = 1.0 / (2.0 * zb)

		var e1_over = e1 * inv_two_zb
		var e2_over = e2 * inv_two_zb

		var z1e1 = z1 * e1_over
		var z2e2 = z2 * e2_over

		out_params.pos_pos_coef = e1_over * z2 - z2e2 + e2
		out_params.pos_vel_coef = -e1_over + e2_over
		out_params.vel_pos_coef = (z1e1 - z2e2 + e2) * z2
		out_params.vel_vel_coef = -z1e1 + z2e2
	
	elif damping_ratio < 1.0 - EPSILON:
		# Underdamped
		var omega_zeta = angular_frequency * damping_ratio
		var alpha = angular_frequency * sqrt(1.0 - damping_ratio * damping_ratio)

		var exp_term = exp(-omega_zeta * delta_time)
		var cos_term = cos(alpha * delta_time)
		var sin_term = sin(alpha * delta_time)

		var inv_alpha = 1.0 / alpha

		var exp_sin = exp_term * sin_term
		var exp_cos = exp_term * cos_term
		var exp_omega_sin = exp_term * omega_zeta * sin_term * inv_alpha

		out_params.pos_pos_coef = exp_cos + exp_omega_sin
		out_params.pos_vel_coef = exp_sin * inv_alpha
		out_params.vel_pos_coef = -exp_sin * alpha - omega_zeta * exp_omega_sin
		out_params.vel_vel_coef = exp_cos - exp_omega_sin

	else:
		# Critically damped
		var exp_term = exp(-angular_frequency * delta_time)
		var time_exp = delta_time * exp_term
		var time_exp_freq = time_exp * angular_frequency

		out_params.pos_pos_coef = time_exp_freq + exp_term
		out_params.pos_vel_coef = time_exp
		out_params.vel_pos_coef = -angular_frequency * time_exp_freq
		out_params.vel_vel_coef = -time_exp_freq + exp_term