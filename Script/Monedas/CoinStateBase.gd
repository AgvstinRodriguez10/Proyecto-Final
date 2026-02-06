class_name CoinStateBase extends StateBase

var coin: CoinBase:
	set(value):
		controlled_node = value
	get:
		return controlled_node

func get_show_distance_sq() -> float:
	return coin.show_distance_sq
