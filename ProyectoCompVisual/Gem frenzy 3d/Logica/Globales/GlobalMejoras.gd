extends Node

# Este singleton contiene las mejoras activas y las posibles mejoras a ganar
@warning_ignore("unused_signal")
signal mejora_cambiada
var mejora_final_comprada
enum nombre_mejoras {
	CofreMineral,
	MejoraDeMejoras,
	MasReciclaje,
	ClientesZen,
	MasTiempo,
	PanchaSpeedUp,
	RecompensaMejorada,
	Gato,
}
var mejora_final = {
	"ContratoFinal": {
		"Key" : "ContratoFinal",
		"Nombre" : tr("CONTRACT"),
		"Precio" : 10,
		"PrecioEscalar" : 0,
		"Maximo" : 1,
		"Textura" : 'res://Gem frenzy 3d/Sprites/mejoras/contrato.png',
		"Descripcion" : tr("CONTRACT_DESC"),
	}}
func llenar_mejora_final():
	mejora_final = {
	"ContratoFinal": {
		"Key" : "ContratoFinal",
		"Nombre" : tr("CONTRACT"),
		"Precio" : 10,
		"PrecioEscalar" : 0,
		"Maximo" : 1,
		"Textura" : 'res://Gem frenzy 3d/Sprites/mejoras/contrato.png',
		"Descripcion" : tr("CONTRACT_DESC"),
	}}
var info_mejoras = {}

func llenar_mejoras() -> void:
	info_mejoras = {
	nombre_mejoras.CofreMineral : { # que aumente de a 2 por mejora
		"Key" : nombre_mejoras.CofreMineral,
		"Nombre" : tr("CHEST"),
		"Precio" : 2,
		"PrecioEscalar" : 2,
		"Maximo" : 4,
		"Textura" : 'res://Gem frenzy 3d/Sprites/mejoras/cofre con marco.png',
		"Descripcion" : tr("CHEST_DESC"),
	},
		nombre_mejoras.MejoraDeMejoras : {
		"Key" : nombre_mejoras.MejoraDeMejoras,
		"Nombre" : tr("MANY_UPGRADES"),
		"PrecioEscalar" : 1,
		"Precio" : 5,
		"Maximo" : 1,
		"Textura" : 'res://Gem frenzy 3d/Sprites/mejoras/mejora de mejoras.png',
		"Descripcion" : tr("MANY_UPGRADES_DESC"),
	},
	nombre_mejoras.ClientesZen : { # implementada en Order.gd
		"Key" : nombre_mejoras.ClientesZen,
		"Nombre" : tr("ZEN_CLIENTS"),
		"Precio" : 6,
		"PrecioEscalar" : 3,
		"Maximo" : 2,
		"Textura" : 'res://Gem frenzy 3d/Sprites/mejoras/Mejora zen.png',
		"Descripcion" : tr("ZEN_CLIENTS_DESC"),
	},
	nombre_mejoras.MasTiempo : {
		"Key" : nombre_mejoras.MasTiempo,
		"Nombre" : tr("MORE_TIME"),
		"Precio" : 7,
		"PrecioEscalar" : 12,
		"Maximo" : 3,
		"Textura" : 'res://Gem frenzy 3d/Sprites/mejoras/reloj mejorado.png',
		"Descripcion" : tr("MORE_TIME_DESC"),
	},
	
	nombre_mejoras.PanchaSpeedUp : { # implementada en pancha speed
		"Key" : nombre_mejoras.PanchaSpeedUp,
		"Nombre" : tr("SPEED_UP"),
		"Precio" : 12,
		"PrecioEscalar" : 14,
		"Maximo" : 2,
		"Textura" : 'res://Gem frenzy 3d/Sprites/mejoras/pancha_speed.png',
		"Descripcion" : tr("SPEED_UP_DESC"),
	},
	nombre_mejoras.MasReciclaje : {
		"Key" : nombre_mejoras.MasReciclaje,
		"Nombre" : tr("RECYCLE"),
		"PrecioEscalar" : 14,
		"Precio" : 6,
		"Maximo" : 2,
		"Textura" : 'res://Gem frenzy 3d/Sprites/mejoras/RECYCLE.png',
		"Descripcion" : tr("RECYCLE_DESC"),
	},
		nombre_mejoras.RecompensaMejorada : { # implementada en OrderManager.gd
		"Key" : nombre_mejoras.RecompensaMejorada,
		"Nombre" : tr("MORE_PROFITS"),
		"Precio" : 9,
		"PrecioEscalar" : 11,
		"Maximo" : 3,
		"Textura" : 'res://Gem frenzy 3d/Sprites/mejoras/monedaMejorada.png',
		"Descripcion" : tr("MORE_PROFITS_DESC"),
	},
		nombre_mejoras.Gato : { # implementada en GeneradorClientes.gd
		"Key" : nombre_mejoras.Gato,
		"Nombre" : tr("CATO"),
		"Precio" : 13,
		"PrecioEscalar" : 13,
		"Maximo" : 2,
		"Textura" : 'res://Gem frenzy 3d/Sprites/mejoras/gatomejora.png',
		"Descripcion" : tr("CATO_DESC"),
	},
}

var disponible_mejoras = []
var activas_mejoras = []

# TEST para noestar comprando mejoras
func test_final():
	for i in range(0,nombre_mejoras.size()):
		disponible_mejoras[i] = 0
		activas_mejoras[i] = info_mejoras[i]["Maximo"]

func reiniciar_mejoras() -> void:
	for i in range(0,nombre_mejoras.size()):
		disponible_mejoras[i] = info_mejoras[i]["Maximo"]
		activas_mejoras[i] = 0

func _ready() -> void:
	llenar_mejoras()
	disponible_mejoras = []
	activas_mejoras = []
	for i in range(0,nombre_mejoras.size()):
		disponible_mejoras.append(info_mejoras[i]["Maximo"])
		activas_mejoras.append(0)
	#test_final()

func obtener_mejora_random_disponible():
	#verifica en las disponibles y devuelve alguna al azar
	var posibles_mejoras : Array = []
	var mejoras_seleccionadas : Array = []
	
	#si no se ha terminado de mejorar los cofres, se fuerza su aparicion en un 50%
	#if disponible_mejoras[nombre_mejoras.CofreMineral]>0 and randf() >= 0.5:
		#mejoras_seleccionadas.append(nombre_mejoras.CofreMineral)

	# Añade a la pool mejoras disponibles
	for i in range(0, len(nombre_mejoras)):
		if disponible_mejoras[i] > 0:
			posibles_mejoras.append(i)
	# Elije las mejoras de la pool
	if len(posibles_mejoras) > 3:
		# selecciona 2 + mejora de mejoras
		while mejoras_seleccionadas.size()<2 + activas_mejoras[nombre_mejoras.MejoraDeMejoras]:
			# Busqueda de menor precio
			var minPrecio = 1000
			var mejoraSeleccionada
			var chanceComplemento=0.35
			#deja el progreso del dia 1 al 3 casi siempre el mismo
			if GlobalTiempo.diaActual<=3:
				chanceComplemento=0.15
			for mejora in posibles_mejoras:
				var precioActual = info_mejoras[mejora]["Precio"] +\
				 (info_mejoras[mejora]["PrecioEscalar"] * activas_mejoras[mejora])
				
				if randf() >=chanceComplemento:
					print("aloa")
					if precioActual < minPrecio:
						minPrecio = precioActual
						mejoraSeleccionada = mejora
			
			posibles_mejoras.pop_at(posibles_mejoras.find(mejoraSeleccionada))
			if mejoraSeleccionada != null:
				mejoras_seleccionadas.append(info_mejoras[mejoraSeleccionada])
		
		# Forzar contra
	
	else:
		for i in posibles_mejoras:
			mejoras_seleccionadas.append(info_mejoras[i])  
		
	if GlobalTiempo.diaActual>=9:
		mejoras_seleccionadas.append(mejora_final["ContratoFinal"])
	return mejoras_seleccionadas
			
