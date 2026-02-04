class_name CoinStateBase extends StateBase

var coin: CoinBase:
	set(value):
		controlled_node = value
	get:
		return controlled_node
