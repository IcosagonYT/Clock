# digital.gd
# - Digital clock script
# - By Icosagon

extends Control

# UI Variables
export var time_label_path = NodePath()
export var date_label_path = NodePath()
export var background_path = NodePath()
onready var time_label = get_node(time_label_path)
onready var date_label = get_node(date_label_path)
onready var background = get_node(background_path)

# Clock variables
var date_time # Date & Time dictionary

# Time values
var hour
var minute
var second

# Date values
var day
var weekday_no
var weekday
var month_no
var month
var year

# Clock settings
export var background_color = Color(0,0,0)
export var foreground_color = Color(1,1,1)
export var fullscreen = false
export var alot = false # Always on top
export var hide_title = false # Hide title bar

export var twentyfour = false
export var utc = false
export var weekday_list = ["Monday","Tuesday","Wednesday", "Thursday","Friday","Saturday","Sunday"]
export var month_list = ["January", "February", "March", "April", "May", "June", "July","August", "September", "October", "November", "December"]

func _ready():
	pass

func _process(_delta):
	# Input
	if(Input.is_action_just_pressed("fullscreen")): # Fullscreen
		fullscreen = OS.is_window_fullscreen()
		if(fullscreen):
			OS.set_window_fullscreen(false)
		else:
			OS.set_window_fullscreen(true)

	if(Input.is_action_just_pressed("exit")): # Quit
		get_tree().quit()
	
	# Get time dictionary
	date_time = OS.get_datetime(utc)

	# Set time values
	hour = date_time.get("hour")
	minute = date_time.get("minute")
	second = date_time.get("second")
	
	# Set date values
	day = date_time.get("day")
	weekday_no = date_time.get("weekday")
	month_no = date_time.get("month")
	year = date_time.get("year")

	# Fix single digits
	if(second<10):
		second = "0" + str(second)

	if(minute<10):
		minute = "0" + str(minute)

	# Fix week day
	weekday = weekday_list[weekday_no+1]
	
	# Fix month
	month = month_list[month_no+1]

	# Set hour to 24/12 hr
	if(twentyfour):
		pass
	else:
		if(hour>12):
			hour -= 12

	# Set label text
	time_label.set_text(str(hour) + ":" + str(minute) + ":" + str(second))
	date_label.set_text(str(weekday) + ", " + str(month) + " " + str(day))


func settings_button_pressed():
	$dialogs/settings_dialog.show()

func fullscreen_checkbox_pressed():
	fullscreen = OS.is_window_fullscreen()
	if(fullscreen):
		OS.set_window_fullscreen(false)
	else:
		OS.set_window_fullscreen(true)

func utc_checkbox_pressed():
	if(utc):
		utc = false
	else:
		utc = true

func hours_checkbox_pressed():
	if(twentyfour):
		twentyfour = false
	else:
		twentyfour = true


func background_color_picker_color_changed(color):
	background_color = color
	background.color = background_color

func foreground_color_picker_color_changed(color):
	foreground_color = color
	time_label.set("custom_colors/font_color", foreground_color)
	date_label.set("custom_colors/font_color", foreground_color)


func alot_checkbox_pressed():
	if(alot):
		OS.set_window_always_on_top(false)
		alot = false
	else:
		OS.set_window_always_on_top(true)
		alot = true

func title_checkbox_pressed():
	if(hide_title):
		OS.set_borderless_window(false)
		hide_title = false
	else:
		OS.set_borderless_window(true)
		hide_title = true
