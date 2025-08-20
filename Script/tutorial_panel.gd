extends PanelContainer

@onready var border: MarginContainer = $MarginContainer
@onready var vbox: VBoxContainer = $MarginContainer/VBoxContainer

@export_enum("Text", "TextKey", "Key") var panel_type
@export var text : String
@export var key : Texture2D
@export var key_text : String

func _ready() -> void:
	load_and_appear()

func load_and_appear():
	match panel_type:
		0:
			var label = Label.new()
			label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
			label.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
			label.custom_minimum_size = Vector2(200, 20)
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
