class_name CoinBase extends Node3D

# Para crear una coin nueva, se duplcia alguna existente.
# Se le setea el modelo en el inspector para el control base
# Se puede modificar la distancia de renderizado
# Se puede (o no) setear un sonido
# Y se elije de la lista el tipo de coin, en caso de necesitar uno nuevo se debe agregar en la lsita de "CoinTypes.gd"
# Por ultimo se debe agregar al modelo el shader de animacion y volver a colocar en el inspector de las propiedades de shader la textura del modelo

## Asignar modelo a animar sin las colisiones
@export var ModelAnimatable: Node3D

## Variable referencia a el player
@onready var player :Player = get_tree().get_first_node_in_group("Player")

## Distancia a la que se ve y funciona la moneda
@export var show_distance := 150.0
@onready var show_distance_sq := show_distance * show_distance

@export var coinSound: AudioStream
@onready var collision: CollisionShape3D = $Area3D/CollisionShape3D

@export var coin_type: CoinTypes.ListTypesCoin
