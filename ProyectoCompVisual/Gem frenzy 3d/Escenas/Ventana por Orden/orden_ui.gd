class_name OrdenUI
extends Control

signal sonido_orden_out_of_time

@export var Dimension := 32

@onready var pb = $TextureProgressBar
var orden_logica : OrderGem
@onready var cambiadorDeColor = StyleBoxFlat.new()
#var cliente_asociado : Cliente

func _ready():
	pb.tint_progress= Color("6ABE30")
	cambiadorDeColor.bg_color = Color("008000")
	#pb.add_theme_stylebox_override("fill", cambiadorDeColor)
	pb.max_value = orden_logica.get_time_left() # ésto dará error si se instancia antes que la orden
	$AnimationPlayer.play("slideIn")

func _physics_process(_delta):
	if !orden_logica.tmr.is_stopped():
		pb.value = orden_logica.get_time_left()
	if pb.value == 20:
		pb.tint_progress=Color("DAC641")
		cambiadorDeColor.bg_color = Color("FFFF00")
		#pb.add_theme_stylebox_override()
		
	elif pb.value == 10:
		pb.tint_progress=Color("D23333")
		cambiadorDeColor.bg_color = Color("FF0000")
		

# Llamadas

func getOrden() -> int:
	return GlobalRecetas.encontrarReceta(orden_logica.requirements)

func setOrden(orden : OrderGem) -> void:
	#cliente_asociado = cliente
	orden_logica = orden
	add_child(orden)
	orden.out_of_time.connect(orden_out_of_time)
	
	var t = orden.requirements.size()
	for i in range(t):
		$HBoxContainer.get_child((i + t + 1) % t).frame = orden.requirements[i]
	$recetaSprite.frame = GlobalRecetas.encontrarReceta(orden.requirements) # revisar

func free():
	fade_out()
	#orden_logica.queue_free()
	#queue_free()
	
# Señales

func orden_out_of_time():
	sonido_orden_out_of_time.emit()
	orden_logica.finalizar_orden()
	fade_out()
	#orden_logica.queue_free()
	#queue_free()
	
	
func orden_deliver():
	if $TextureProgressBar.value<1:
		GlobalLogros.DeliverInTime.emit()
	if GlobalTiempo.tiempoHoraDia== GlobalTiempo.horacierre-1 and GlobalTiempo.tiempoMinutoDia>=59:
		GlobalLogros.justOneMore.emit()
	OrderManager.orden_exitosa.emit(orden_logica)
	OrderManager._on_order_delivered(orden_logica.precio)
	orden_logica.tmr.stop()
	$AnimationPlayer.play("slideOut")
	await get_tree().create_timer(0.27).timeout
	orden_logica.finalizar_orden()
	orden_logica.queue_free()
	queue_free()


func fade_out():
	$AnimationPlayer.play("slideOut")
	await $AnimationPlayer.animation_finished
	orden_logica.queue_free()
	queue_free()
