class_name CoinBase extends Node3D

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
