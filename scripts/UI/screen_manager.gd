extends CanvasLayer

var screen_stack: Array = []

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	_init_scene_ui()

func _init_scene_ui():
	var current_scene = get_tree().current_scene
	if current_scene.name == "TankCustomization":
		_push_screen($TankCustomizationScreen)
	elif current_scene.name == "Main":
		_push_screen($GameUI)
	elif current_scene.name == "MainMenu":
		_push_screen($MainMenu)


func open_screen(screen: Screen) -> void:
	_push_screen(screen)

func back() -> void:
	if screen_stack.size() > 0:
		_pop_screen()

func clear() -> void:
	_clear_stack()

func exit_to_game() -> void:
	while screen_stack.size() > 1:
		_pop_screen()

func _push_screen(screen: Screen) -> void:
	if screen_stack.size() > 0:
		var current_screen = screen_stack.back()
		if not screen.opens_on_top:  
			current_screen.deactivate()
	screen_stack.append(screen)
	screen.activate()

	if screen.pauses_time:
		get_tree().paused = true 
	else:
		get_tree().paused = false 

func _pop_screen() -> void:
	var current_screen = screen_stack.back()
	if screen_stack.size() == 0 or current_screen.is_base_screen:
		return
	
	current_screen = screen_stack.pop_back()
	current_screen.deactivate()

	if screen_stack.size() > 0:
		var previous_screen = screen_stack.back()
		if not current_screen.opens_on_top:
			previous_screen.activate()
	
	_update_paused_state()

func _clear_stack() -> void:
	while screen_stack.size() > 0:
		_pop_screen()

func _update_paused_state() -> void:
	var should_pause = false
	for screen in screen_stack:
		if screen.pauses_time:
			should_pause = true
			break
	get_tree().paused = should_pause
	
func _input(event: InputEvent) -> void:
	var current_screen = screen_stack.back()
	if Input.is_action_just_pressed("pause"):
		if !screen_stack.back().is_base_screen:
			back()
		elif current_screen.allows_pause: 
			togglePause()
	
func toggleScreen(screen: Screen):
	if screen.is_active:
		_pop_screen()
	else:
		_push_screen(screen)

func togglePause():
	toggleScreen($PauseScreen)

func toggleSettings():
	toggleScreen($SettingsScreen)
	
