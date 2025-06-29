extends Control

var is_up = false

var tween : Tween

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
	tween.tween_property(self, "position", Vector2(0, 568), 0.5)
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
	tween.tween_property(self, "position", Vector2(0, 648), 0.5)
