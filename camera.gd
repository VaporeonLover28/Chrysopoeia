extends Camera3D

@export var zoom_duration: float = 1  # Duration in seconds

var tween: Tween

func zoom_anim():
	#cancela outro zoom se tiver algum
	if tween:
		tween.kill()
	
	#cria um tween
	tween = create_tween()
	#propriedades do tween
	tween.set_trans(Tween.TRANS_QUART)
	tween.set_ease(Tween.EASE_OUT)
	#o tween em si
	#tweena a propriedade FOV da câmera de atual (normalmente 75) até 40 em zoom_duration segundos
	tween.tween_property(self, "fov", 40.0, zoom_duration)

func zoom_out_anim():
	#cancela outro zoom se tiver algum
	if tween:
		tween.kill()
	
	#cria um tween
	tween = create_tween()
	#propriedades do tween
	tween.set_trans(Tween.TRANS_QUART)
	tween.set_ease(Tween.EASE_OUT)
	#o tween em si
	#tweena a propriedade FOV da câmera de atual até 75 em zoom_duration segundos
	tween.tween_property(self, "fov", 75.0, zoom_duration * 1.25)
