extends TileMap

onready var tilemap = self
onready var normalPoint = preload("res://Pacman/Scenes/Point.tscn")
onready var parent = self.get_parent()
#onready var superPoint = preload()
var superPointsLocations : Array = [Vector2(1,2), Vector2(1,20), Vector2(19,2), Vector2(19,20)]
var pointlessRects = [Rect2(Vector2(62,48), Vector2(7,6)), Rect2(Vector2(55,48), Vector2(4,2)), Rect2(Vector2(72,48), Vector2(4,2)), Rect2(Vector2(72,53), Vector2(4,2)), Rect2(Vector2(55,53), Vector2(4,2)) ]
var pointlessArray = getPointlessArray()
enum Modes{NONE, BOTTOM_HALF, UPPER_HALF}

onready var astar = AStar.new()
onready var mapSize = get_used_rect().size
onready var mapOffset = get_used_rect().position

var pointToDisconnect

var pathStartPosition = Vector2() setget setPathStartPosition
var pathEndPosition = Vector2() setget setPathEndPosition

var pointPath = []

onready var obstacles = get_used_cells() ## by id if obstacles changed in runtime
onready var halfCellSize = self.cell_size /2

func _enter_tree():
	pass
	
func _init():
	pass

func _ready():
	initTiles()
	var walkableCellsList = astarAddWalkableCells(obstacles)
	astarConnectWalkableCells(walkableCellsList)
	for point in astar.get_points():
		print('id: ', point, '| pos: ', astar.get_point_position(point))
#	getPathToRandomTile(Vector2(512,468))

func astarAddWalkableCells(obstacles = []):
	var pointsArray = []
	for y in range(mapSize.y):
		for x in range(mapSize.x):
			var point = Vector2(mapOffset.x + x,mapOffset.y + y)
			if point in obstacles:
				continue
			pointsArray.append(point)
			var pointIndex = calculatePointIndex(point)
			astar.add_point(pointIndex, Vector3(point.x, point.y, 0.0))
#	print('pointsArray', pointsArray)
	return pointsArray
	
func astarConnectWalkableCells(pointsArray):
	for point in pointsArray:
		var pointIndex = calculatePointIndex(point)
		var pointsRelative = PoolVector2Array([
			Vector2(point.x + 1, point.y),
			Vector2(point.x - 1, point.y),
			Vector2(point.x, point.y + 1),
			Vector2(point.x, point.y - 1)])
		for pointRelative in pointsRelative:
			var pointRelativeIndex = calculatePointIndex(pointRelative)
			if isOutsideMapBounds(pointRelative):
				continue
			if not astar.has_point(pointRelativeIndex):
				continue
			astar.connect_points(pointIndex, pointRelativeIndex, true)
func isOutsideMapBounds(point):
	return point.x < mapOffset.x or point.y < mapOffset.y or point.x >= mapSize.x + mapOffset.x or point.y >= mapSize.y + mapOffset.y
	
func calculatePointIndex(point):
	return (mapOffset.x + point.x) + mapSize.x * (mapOffset.y + point.y)
	
func getPath(worldStart, worldEnd):
	self.pathStartPosition = world_to_map(worldStart)
	self.pathEndPosition = world_to_map(worldEnd)
	recalculatePath()
	print('Finding new path from ', pathStartPosition, ' to ', pathEndPosition, '.')
	var pathWorld = []
	for point in pointPath:
		var pointWorld = map_to_world(Vector2(point.x, point.y)) + halfCellSize
		pathWorld.append(pointWorld)
	return pathWorld
	
func getPathToRandomTile(start, mode):
	randomize()
	self.pathStartPosition = world_to_map(start)
	var threshold = mapOffset.y + mapSize.y / 2
	var tmp = astar.get_point_position(astar.get_points()[randi() % astar.get_points().size()])
	while mode == 1 and tmp.y < threshold:
		tmp = astar.get_point_position(astar.get_points()[randi() % astar.get_points().size()])
	while mode == 2 and tmp.y >= threshold:
		tmp = astar.get_point_position(astar.get_points()[randi() % astar.get_points().size()])		
	self.pathEndPosition = Vector2(tmp.x, tmp.y)
#	var randx = randi() % int(mapSize.x)
#	var randy = randi() % int(mapSize.y)
#	self.pathEndPosition = Vector2(mapOffset.x + randx, mapOffset.y + randy)
	print('Finding new path from ', pathStartPosition, ' to ', pathEndPosition, '.')	
	recalculatePath()
	var pathWorld = []
	for point in pointPath:
		var pointWorld = map_to_world(Vector2(point.x,point.y)) + halfCellSize
		pathWorld.append(pointWorld)
	return pathWorld
	
func recalculatePath():
	var startPointIndex = calculatePointIndex(pathStartPosition)
	var endPointIndex = calculatePointIndex(pathEndPosition)
	if pointToDisconnect != null:
		astar.set_point_weight_scale(pointToDisconnect, 9999.0)
		var tmp = astar.get_point_connections(pointToDisconnect)
		pointPath = astar.get_point_path(startPointIndex, endPointIndex)
		astar.set_point_weight_scale(pointToDisconnect, 1.0)
	else:
		pointPath = astar.get_point_path(startPointIndex, endPointIndex)		

func setPathStartPosition(value):
	if value in obstacles:
		return
	if isOutsideMapBounds(value):
		return
	
	pathStartPosition = value
	if pathEndPosition and pathEndPosition != pathStartPosition:
		recalculatePath()
		
func setPathEndPosition(value):
	if value in obstacles:
		return
	if isOutsideMapBounds(value):
		return
	
	pathEndPosition = value
	if pathStartPosition != value:
		recalculatePath()

func getPointlessArray():
	var array = []
	for rect in pointlessRects:
		for i in range (rect.position.x, rect.position.x+rect.size.x):
			for j in range (rect.position.y, rect.position.y+rect.size.y):
				array.append(Vector2(i,j))
	return array
	
func initTiles():
	print('Initializing navigational tiles')
	var tile = tilemap.get_used_rect()
	for i in range (tile.size.x):
		for j in range (tile.size.y):
			var x = tile.position.x+i
			var y = tile.position.y+j
			if tilemap.get_cell(x,y) == -1:
				tilemap.set_cell(x,y,2)
				var worldPos = tilemap.map_to_world(Vector2(x,y))
				if not pointlessArray.has(Vector2(x,y)):
					var np = normalPoint.instance()
					np.global_position = worldPos + tilemap.cell_size/2
					parent.addPoint(np)


#func addPoint(pt):
#	$Points.add_child(pt)