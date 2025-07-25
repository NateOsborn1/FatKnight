extends Node

# Handles all momentum types, decay rates, caps

signal momentum_changed(old_value: float, new_value: float, change_reason: String)
signal momentum_milestone_reached(milestone_value: int)
signal perfect_timing_achieved(action_type: String, bonus_momentum: float)
signal momentum_lost(amount_lost: float, reason: String)

#enum momentum_type {
	#IDLE = 0,
	#WALKING = 1,
	#ATTACKING = 2,
	#ABSORBING = 3,
	#RUNNING = 4
	#}

# Momentum Configuration
@export var max_momentum:= 10.0
@export var hold_duration:= 3.0
@export var decay_rate:= 6.0
@export var minimum_momentum:= 0.0 # floor


## Momentum gain rates for different actions
var momentum_gains: Dictionary = {
	"idle": 0.0,
	"walking": 1.5,          # Momentum per second while walking
	"running": 3.0,          # Momentum per second while running
	"attacking": 2.0,        # Base momentum per attack
	"perfect_attack": 4.0,   # Bonus for well-timed combo attacks
	"absorbing": 1.0,        # Base momentum per second while absorbing
	"perfect_absorb": 6.0,   # Big bonus for well-timed blocks
	"counter_attack": 5.0    # Bonus for counter-attacking after perfect absorb
}

# Momentum loss penalties
var momentum_penalties: Dictionary = {
	"attack_whiff": 2.0,     # Penalty for missing attacks
	"attack_interrupt": 3.0, # Penalty for attacks being interrupted
	"poor_combo_timing": 1.5,# Penalty for mistimed combos
	"failed_absorb": 2.5,    # Penalty for mistimed blocks
	"environmental_hit": 1.0 # Penalty for running into walls, etc.
}

# Current momentum state
var current_momentum:= 0.0
var last_activity_time:= 0
var is_decaying:= false

# Combo tracking
var last_attack_time:= 0.0
var combo_window:= 0.8 # EDIT LATER, HAVE VISUAL CLOCK/TIME (time spin circle to land in an area)
var perfect_combo_window:= 0.3
var current_combo_count:= 0
var max_combo_count:= 5

# Absorb/blocking tracking
var absorb_start_time:= 0.0
var perfect_absorb_window:= 0.2
var is_absorbing:= false
var can_counter_attack:= false
var counter_attack_window:= 0.5

func _ready():
	set_process(true)

func _process(delta):
	_update_momentum_decay(delta)
	_update_combo_timing()
	_update_absorb_timing()

func _update_momentum_decay(delta):
	var time_since_activity = Time.get_time_dict_from_system()["unix"] - last_activity_time
	
	if time_since_activity > hold_duration:
		if not is_decaying: 
			is_decaying = true
	
	if current_momentum > minimum_momentum:
		var old_momentum = current_momentum
		current_momentum = max(minimum_momentum, current_momentum - (decay_rate * delta))
		
		if abs(current_momentum - old_momentum) > 0.01:
			momentum_changed.emit(old_momentum, current_momentum, "decay")
	else:
		is_decaying = false

func _update_combo_timing():
	var time_since_attack = Time.get_time_dict_from_system()["unix"] - last_attack_time
	
	# Reset combo if too much time has passed
	if time_since_attack > combo_window and current_combo_count > 0:
		current_combo_count = 0

func _update_absorb_timing():
	# Update counter attack availability
	if can_counter_attack:
		var time_since_absorb = Time.get_time_dict_from_system()["unix"] - absorb_start_time
		if time_since_absorb > counter_attack_window:
			can_counter_attack = false

func _reset_activity_timer():
	last_activity_time = Time.get_time_dict_from_system()["unix"]

## ============ MOMENTUM GAINING FUNCTIONS ============

# Gain momentum from continuous actions (walking, running, absorbing)
func gain_momentum_continuous(action: String, delta: float) -> void:
	var gain_rate = momentum_gains.get(action, 0.0)
	if gain_rate > 0.0:
		_add_momentum(gain_rate * delta, action)

# Gain momentum from discrete actions (timed attacks, perfect blocks)
func gain_momentum_action(action: String, multiplier:= 1.0) -> float:
	var base_gain = momentum_gains.get(action, 0.0)
	var actual_gain = base_gain * multiplier
	
	if actual_gain > 0.0:
		_add_momentum(actual_gain, action)
	
	return actual_gain

# Perform an attack and gain momentum based on timing
func perform_attack() -> Dictionary:
	var current_time = Time.get_time_dict_from_system()["unix"]
	var time_since_last = current_time - last_attack_time
	var result = {
		"momentum_gained": 0.0,
		"combo_count": 0,
		"perfect_timing": false,
		"can_chain": false
	}
	
	# Check combo timing
	if current_combo_count > 0 and time_since_last <= combo_window:
		# This is a combo attack
		current_combo_count += 1
		
		if time_since_last <= perfect_combo_window:
			# Perfect combo timing
			result.momentum_gained = gain_momentum_action("perfect_attack")
			result.perfect_timing = true
			result.can_chain = current_combo_count < max_combo_count
			perfect_timing_achieved.emit("combo_attack", result.momentum_gained)
		else:
			# Good combo timing
			result.momentum_gained = gain_momentum_action("attacking")
			result.can_chain = current_combo_count < max_combo_count
	else:
		# First attack or combo reset
		current_combo_count = 1
		result.momentum_gained = gain_momentum_action("attacking")
		result.can_chain = true
	
	result.combo_count = current_combo_count
	last_attack_time = current_time
	_reset_activity_timer()
	
	return result

# Handle poor combo timing
func fail_combo_timing() -> void:
	lose_momentum("poor_combo_timing")
	current_combo_count = 0

# start absorbing/blocking
func start_absorbing() -> void:
	if not is_absorbing:
		is_absorbing = true
		absorb_start_time = Time.get_time_dict_from_system()["unix"]
		_reset_activity_timer()

# Stop absorbing/blocking
func stop_absorbing() -> void:
	is_absorbing = false
	can_counter_attack = false

# Handle incoming damage while absorbing
func absorb_damage(damage_amount: float, damage_timing: float = 0.0) -> Dictionary:
	var result = {
		"momentum_gained": 0.0,
		"perfect_absorb": false,
		"can_counter": false,
		"damage_absorbed": 0.0
	}
	
	if not is_absorbing:
		return result
	
	var absorb_duration = Time.get_time_dict_from_system()["unix"] - absorb_start_time
	
	# Check for perfect absorb timing
	if absorb_duration <= perfect_absorb_window:
		# Perfect absorb! 
		result.momentum_gained = gain_momentum_action("perfect_absorb")
		result.perfect_absorb = true
		result.can_counter = true
		result.damage_absorbed = damage_amount  # Absorb all damage
		can_counter_attack = true
		perfect_timing_achieved.emit("perfect_absorb", result.momentum_gained)
	else:
		# Regular absorb
		result.momentum_gained = gain_momentum_action("absorbing")
		result.damage_absorbed = damage_amount * 0.5  # Absorb 50% damage
	
	_reset_activity_timer()
	return result

## Perform counter attack after perfect absorb
func perform_counter_attack() -> Dictionary:
	var result = {
		"momentum_gained": 0.0,
		"counter_successful": false
	}
	
	if can_counter_attack:
		result.momentum_gained = gain_momentum_action("counter_attack")
		result.counter_successful = true
		can_counter_attack = false
		_reset_activity_timer()
	
	return result

## ============ MOMENTUM LOSING FUNCTIONS ============

## Lose momentum due to poor play or mistakes
func lose_momentum(reason: String, multiplier: float = 1.0) -> float:
	var base_loss = momentum_penalties.get(reason, 0.0)
	var actual_loss = base_loss * multiplier
	
	if actual_loss > 0.0:
		var old_momentum = current_momentum
		current_momentum = max(minimum_momentum, current_momentum - actual_loss)
		momentum_lost.emit(actual_loss, reason)
		momentum_changed.emit(old_momentum, current_momentum, "penalty_" + reason)
		_reset_activity_timer()
	
	return actual_loss

## Handle attack missing target
func attack_whiffed() -> void:
	lose_momentum("attack_whiff")
	current_combo_count = 0  # Reset combo on whiff

## Handle attack being interrupted
func attack_interrupted() -> void:
	lose_momentum("attack_interrupt")
	current_combo_count = 0  # Reset combo on interrupt

## Handle failed absorb (getting hit while trying to block)
func absorb_failed() -> void:
	lose_momentum("failed_absorb")
	stop_absorbing()

## Handle environmental damage (running into walls, etc.)
func environmental_damage() -> void:
	lose_momentum("environmental_hit")

## ============ INTERNAL HELPER FUNCTIONS ============

func _add_momentum(amount: float, reason: String) -> void:
	var old_momentum = current_momentum
	current_momentum = min(max_momentum, current_momentum + amount)
	
	if abs(current_momentum - old_momentum) > 0.01:
		momentum_changed.emit(old_momentum, current_momentum, reason)
		_check_milestones(old_momentum, current_momentum)
	
	_reset_activity_timer()

func _check_milestones(old_value: float, new_value: float) -> void:
	# Check for momentum milestones (every 2 points)
	var milestones = [2, 4, 6, 8, 10]
	
	for milestone in milestones:
		if old_value < milestone and new_value >= milestone:
			momentum_milestone_reached.emit(milestone)

## ============ GETTERS AND UTILITY FUNCTIONS ============

func get_current_momentum() -> float:
	return current_momentum

func get_momentum_percentage() -> float:
	return (current_momentum / max_momentum) * 100.0

func get_combo_count() -> int:
	return current_combo_count

func can_chain_combo() -> bool:
	var time_since_attack = Time.get_time_dict_from_system()["unix"] - last_attack_time
	return current_combo_count > 0 and time_since_attack <= combo_window and current_combo_count < max_combo_count

func is_in_perfect_combo_window() -> bool:
	var time_since_attack = Time.get_time_dict_from_system()["unix"] - last_attack_time
	return current_combo_count > 0 and time_since_attack <= perfect_combo_window

func can_perform_counter_attack() -> bool:
	return can_counter_attack

func is_momentum_decaying() -> bool:
	return is_decaying

func get_time_until_decay() -> float:
	var time_since_activity = Time.get_time_dict_from_system()["unix"] - last_activity_time
	return max(0.0, hold_duration - time_since_activity)

## ============ CONFIGURATION FUNCTIONS ============

func set_momentum_gain(action: String, gain_amount: float) -> void:
	momentum_gains[action] = gain_amount

func set_momentum_penalty(reason: String, penalty_amount: float) -> void:
	momentum_penalties[reason] = penalty_amount

func set_combo_window(window_duration: float) -> void:
	combo_window = window_duration

func set_perfect_combo_window(window_duration: float) -> void:
	perfect_combo_window = window_duration

func set_perfect_absorb_window(window_duration: float) -> void:
	perfect_absorb_window = window_duration

## ============ DEBUG FUNCTIONS ============

func debug_print_state() -> void:
	print("=== Momentum State ===")
	print("Current Momentum: %.2f / %.2f (%.1f%%)" % [current_momentum, max_momentum, get_momentum_percentage()])
	print("Decaying: %s (Time until decay: %.1fs)" % [is_decaying, get_time_until_decay()])
	print("Combo Count: %d (Can chain: %s)" % [current_combo_count, can_chain_combo()])
	print("Perfect combo window: %s" % is_in_perfect_combo_window())
	print("Absorbing: %s (Can counter: %s)" % [is_absorbing, can_counter_attack])
	print("====================")
