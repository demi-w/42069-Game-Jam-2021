extends Node2D
class_name Level

signal start_descent()
signal switch_scene(next_level)

const factory = preload("res://src/Factory/Factory.tscn")

export (int) var planet_health = 100
export (int) var stardust_cap = 100
export (String) var end_dialogue
export (String) var next_level_resource

onready var planet = $Planet
onready var HUD = $CanvasLayer/Healthbar
onready var pause_menu = $CanvasLayer/PauseMenu

export (int) var number_of_factories

var dialog = null
var over = false

func _ready():
	GameData.reset()
	dialog = Dialogic.start('Game Start') 
	add_child(dialog)
	HUD.set_health_max(planet_health)
	HUD.set_stardust_max(stardust_cap)
	dialog.connect("dialogic_signal", self, "on_dialogue_end", [], CONNECT_ONESHOT)
	GameData.set_things(self, get_node("Planet/Player"))
	spawn_factories()
	start_coroutine()
	


func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel") && dialog == null:
		var tree = get_tree()
		tree.paused = not tree.paused
		if tree.paused:
			pause_menu.open()
		else:
			pause_menu.close()
		get_tree().set_input_as_handled()

func added_refinery():
	GameData.refinery_count += 1


func removed_refinery():
	GameData.refinery_count -= 0


func spawn_factories():
	for i in number_of_factories:
		spawn_factory(i * (2*PI / number_of_factories))


func spawn_factory(angle):
	var spawnSpot = Vector2(cos(angle) * 512, sin(angle)*512)
	var new_factory = factory.instance()
	planet.add_child(new_factory)
	new_factory.set_position(spawnSpot)
	new_factory.set_rotation(angle + PI/2)
	new_factory.add_to_group("Factories")


func start_coroutine():
	while HUD.get_health() > 0 && HUD.get_stardust() < stardust_cap:
		GameData.stardust += GameData.refinery_count
		if GameData.stardust != HUD.get_stardust():
			HUD.set_stardust(GameData.stardust)
		if GameData.planet_health != HUD.get_health():
			HUD.set_health(GameData.planet_health)
		yield(get_tree().create_timer(1), "timeout")
	if GameData.stardust >= stardust_cap:
		win_game()
	if GameData.planet_health <= 0:
		lose_game()


func win_game():
	dialog = Dialogic.start(end_dialogue)
	add_child(dialog)
	dialog.connect("dialogic_signal", self, "open_next_level")

func lose_game():
	dialog = Dialogic.start("failure")
	add_child(dialog)
	dialog.connect("dialogic_signal", self, "open_next_level")


func on_dialogue_end(string):
	emit_signal("start_descent")
	dialog.queue_free()
	dialog = null

func open_next_level(_blank):
	var next_level = load(next_level_resource)
	emit_signal("switch_scene", next_level)
