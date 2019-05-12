extends TileMap

#######################
#tiles ids
#0 wall
#1 pathway with normal point
#3 portal
#4 pathway with uber point
#5 pathway without points
#6 empty tiles, no nav
#######################

onready var normalPoint = preload("res://Pacman/Scenes/Point.tscn")
onready var portalScene = preload("res://Pacman/Portal.tscn")
onready var parent = self.get_parent()
onready var superPoint = preload("res://Pacman/Point/SuperPoint.tscn")
enum Modes{NONE, BOTTOM_HALF, UPPER_HALF}

onready var astar = AStar.new()
onready var mapSize = get_used_rect().size
onready var mapOffset = get_used_rect().position

var pointToDisconnect

var pathStartPosition = Vector2() setget setPathStartPosition
var pathEndPosition = Vector2() setget setPathEndPosition

var pointPath = []

onready var obstacles = get_used_cells_by_id(0) ## by id if obstacles changed in runtime
onready var halfCellSize = self.cell_size /2
onready var portals = get_used_cells_by_id(3)
onready var emptyTiles = get_used_cells_by_id(6)

func _enter_tree():
	pass
	
func _init():
	pass

func _ready():
	initTiles()
	var walkableCellsList = astarAddWalkableCells(obstacles)
	astarConnectWalkableCells(walkableCellsList)

func astarAddWalkableCells(obstacles = []):
	var pointsArray = []
	for y in range(mapSize.y):
		for x in range(mapSize.x):
			var point = Vector2(mapOffset.x + x,mapOffset.y + y)
			if point in obstacles or point in emptyTiles:
				continue
			pointsArray.append(point)
			var pointIndex = calculatePointIndex(point)
			astar.add_point(pointIndex, Vector3(point.x, point.y, 0.0))
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
	astarConnectPortals(portals)
			
func astarConnectPortals(portals = []):
	var a = calculatePointIndex(portals[0])
	var b = calculatePointIndex(portals[1])
	astar.connect_points(a, b, false)

func isOutsideMapBounds(point):
	return point.x < mapOffset.x or point.y < mapOffset.y or point.x >= mapSize.x + mapOffset.x or point.y >= mapSize.y + mapOffset.y
	
func calculatePointIndex(point):
	return (mapOffset.x + point.x) + mapSize.x * (mapOffset.y + point.y)
	
func getPath(worldStart, worldEnd):
	self.pathStartPosition = world_to_map(worldStart)
	self.pathEndPosition = world_to_map(worldEnd)
	recalculatePath()
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
	while mode == 1 and tmp.y < threshold or (tmp.x == pathStartPosition.x and tmp.y == pathStartPosition.y):
		tmp = astar.get_point_position(astar.get_points()[randi() % astar.get_points().size()])
	while mode == 2 and tmp.y >= threshold or (tmp.x == pathStartPosition.x and tmp.y == pathStartPosition.y):
		tmp = astar.get_point_position(astar.get_points()[randi() % astar.get_points().size()])
	self.pathEndPosition = Vector2(tmp.x, tmp.y)
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
	
func initTiles():
	var tile = self.get_used_rect()
	for i in range (tile.size.x):
		for j in range (tile.size.y):
			var x = tile.position.x+i
			var y = tile.position.y+j
			var worldPos = self.map_to_world(Vector2(x,y))
			if self.get_cell(x,y) == 3:
				var portal = portalScene.instance()
				portal.global_position = worldPos + self.cell_size / 2
				parent.addPortal(portal)
			if self.get_cell(x,y) == 4:
				var sp = superPoint.instance()
				sp.global_position = worldPos + self.cell_size/2
				parent.addPoint(sp)
			if self.get_cell(x,y) == -1:
				var np = normalPoint.instance()
				np.global_position = worldPos + self.cell_size/2
				parent.addPoint(np)
			