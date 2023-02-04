extends TileMap

enum CELL_TYPES { ROAD }
const SHIFT = Vector2(1, 1)

func _ready():
	for i in range (2, 5):
		var cell : Vector2 = Vector2(1, i)
		set_cellv(cell, CELL_TYPES.ROAD)
		update_bitmask_region(cell - SHIFT, cell + SHIFT)
