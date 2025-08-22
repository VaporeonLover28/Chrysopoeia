extends PanelContainer

@onready var border: MarginContainer = $MarginContainer
@onready var vbox: VBoxContainer = $MarginContainer/VBoxContainer
@onready var value: ProgressBar = $Disappear/progress
@onready var time_left: Timer = $Disappear/time_left

@export var tutorial : String
@export var dis_time : float
@export var vec_size : Vector2
@export var pos : Vector2
@export_enum("Text", "TextKey", "Key") var panel_type
@export var text : String
@export var key : Texture2D
@export var key_text : String

func _ready() -> void:
	size = vec_size
	position = pos
	value.size = Vector2(vec_size.x, 4)
	value.position.y = size.y - 9
	match panel_type:
		0:
			var label = Label.new()
			label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
			label.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
			label.custom_minimum_size = Vector2(160, 20)
			label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
			label.text = text
			vbox.add_child(label)
		1:
			var label = Label.new()
			label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
			label.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
			label.custom_minimum_size = Vector2(200, 20)
			label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
			label.text = text.insert(text.length(), "\n")
			vbox.add_child(label)
			var keyspr = TextureRect.new()
			keyspr.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
			keyspr.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
			keyspr.texture = key
			vbox.add_child(keyspr)
			var key_label = Label.new()
			key_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			key_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
			key_label.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
			key_label.uppercase = true
			key_label.text = key_text
			key_label.add_theme_font_size_override("font_size", 20)
			vbox.add_child(key_label)
		2:
			var keyspr = TextureRect.new()
			keyspr.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
			keyspr.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
			keyspr.texture = key
			vbox.add_child(keyspr)
			var key_label = Label.new()
			key_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			key_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
			key_label.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
			key_label.uppercase = true
			key_label.text = key_text
			vbox.add_child(key_label)
	
	if dis_time < 100:
		time_left.start(dis_time)

func _process(delta: float) -> void:
	if time_left.time_left < 100:
		value.value = time_left.time_left / dis_time * 100
	else:
		value.value = 0

func _on_time_left_timeout() -> void:
	clear()

func clear():
	##marks this panel's preset tutorial to already shown in the manager
	TutorialManager.tutorials[tutorial] = true
	queue_free()
