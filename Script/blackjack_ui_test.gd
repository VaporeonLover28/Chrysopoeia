extends Control

@onready var game = $"../.."
@onready var q: VBoxContainer = $Panel/HBoxContainer/Q
@onready var e: VBoxContainer = $Panel/HBoxContainer/E
@onready var f: VBoxContainer = $Panel/HBoxContainer/F
@onready var r: VBoxContainer = $Panel/HBoxContainer/R

var is_up = false

var tween : Tween

func _process(delta: float) -> void:
	if game.dealer_can_hit:
		q.modulate = Color.WHITE
	else:
		q.modulate = Color.DIM_GRAY
	
	if game.dealer_can_stand:
		e.modulate = Color.WHITE
	else:
		e.modulate = Color.DIM_GRAY
	
	if !game.round_started and game.playing_npcs.size() < 5:
		r.modulate = Color.WHITE
	else:
		r.modulate = Color.DIM_GRAY
	
	if game.playing_npcs.size() > 1 and game.whose_turn != -1:
		f.modulate = Color.WHITE
	else:
		f.modulate = Color.DIM_GRAY

func _slide():
	if is_up:
		_slide_down()
	else:
		_slide_up()

func _slide_up():
	is_up = true
	#para a barra aonde ela tá ao parar o tween de ir pra baixo
	#caso esteja parada é meio fodase
	if tween:
		tween.kill()
	
	#cria um tween
	tween = create_tween()
	#propriedades do tween
	tween.set_trans(Tween.TRANS_QUART)
	tween.set_ease(Tween.EASE_OUT)
	#o tween em si
	#tweena a posição da barra até o topo em meio segundo
	tween.tween_property(self, "position", Vector2(0, 553), 0.5)

func _slide_down():
	is_up = false
	#para a barra aonde ela tá ao parar o tween de ir pra baixo
	#caso esteja parada é meio fodase
	if tween:
		tween.kill()
	
	#cria um tween
	tween = create_tween()
	#propriedades do tween
	tween.set_trans(Tween.TRANS_QUART)
	tween.set_ease(Tween.EASE_OUT)
	#o tween em si
	#tweena a posição da barra até fora da tela em meio segundo
	tween.tween_property(self, "position", Vector2(0, 650), 0.5)
