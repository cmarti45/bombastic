extends Spatial
export var HEIGHT = 8
export var WIDTH = 8
const TILESIZE = 2
const OFFSET = 1
var tileData = []
var fillMap = []
var lightMap = []
var gamePaused = false
var cubeCount = 0
export var playerCount = 1
var currCube
onready var rollingCube = preload("res://CubeKB.tscn")
onready var playerScn = preload("res://Player.tscn")
onready var playerContainer = $Players
var rng = RandomNumberGenerator.new()
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func getValue(cubePos):
	return getSquare(cubePos).getValue()
func printArray(var tileData):
	var line = ""
	for i in range (0,HEIGHT):
		for j in range (0,WIDTH):
			if tileData[i][j] == null:
				line += "-"
			else:
				line += str(tileData[i][j])
		print(line)
		line = ""
func cubeQuant():
	var cubeCount = 0
	for rows in tileData:
		for cube in rows:
			if cube != null:
				cubeCount += 1
	return cubeCount
	
func chainExplode(var player, var dieValue, var cubePos, var cube):
	var tileToCheck
	var lightSquares = []
	for j in range (0,4):
		for i in range (1,dieValue+1):
			tileToCheck = cubePos + ([Vector2(i,0), Vector2(-i,0), Vector2(0,i), Vector2(0,-i)])[j]
			if !isTileEmpty(tileToCheck):
				if getValue(tileToCheck) == dieValue -1 or getValue(tileToCheck) == dieValue:
					lightSquares.append(tileToCheck)
				cube.fireEffect.setLength(j, i)
				break
	yield(cube.fireEffect.explode(dieValue, player), "completed")
	
	for lightCube in lightSquares:
		if !isTileEmpty(lightCube):
			getSquare(lightCube).light(player)
	removeCube(cubePos)
	pass
	
func removeCube(cubePos):
	cubeCount-= 1
	remove_child(getSquare(cubePos))
	tileData[cubePos.x][cubePos.y] = null

func instantiatePlayer(var i, var j, var id):
	var newPlayer = playerScn.instance()
	newPlayer.setLoc(i,j)
	newPlayer.setId(id)
	newPlayer.cube = getSquare(Vector2(i,j))
	newPlayer.randomColor(id)
	newPlayer.WIDTH = WIDTH
	newPlayer.HEIGHT = HEIGHT
	playerContainer.add_child(newPlayer)
	pass

func instantiateCube(var i, var j):
	var cube = rollingCube.instance()
	cube.translation = Vector3(2*i+OFFSET, 0, 2*j+OFFSET)
	add_child(cube)
	cubeCount+=1
	cube.connect("explosion", self, "chainExplode")
	cube.gridPos = Vector2(i,j)
	cube.randomOrientation()
	tileData[i][j] = cube
func spawnCube():
	var spawnIndex = rng.randi_range(0, (HEIGHT * WIDTH)  - cubeQuant() - 1)
	
	for i in range (0,HEIGHT):
		for j in range (0, WIDTH):
			if tileData[i][j] == null:
				if spawnIndex == 0:
					instantiateCube(i,j)
					return
				else:
					spawnIndex -= 1
					
	
	get_tree().reload_current_scene()
			

func _ready():
	var tempArray = []
	rng.randomize()
	for i in range (0,HEIGHT):
		tileData.append([null,null,null,null,null,null,null,null])
	if playerCount > 0:
		instantiateCube(0,0)
		instantiatePlayer(0,0, 0)
	if playerCount > 1:
		instantiateCube(0, HEIGHT-1)
		instantiatePlayer(0, HEIGHT-1, 1)
	if playerCount > 2:
		instantiateCube(WIDTH-1, HEIGHT-1)
		instantiatePlayer(WIDTH-1, HEIGHT-1, 2)
	if playerCount > 3:
		instantiateCube(0, HEIGHT-1)
		instantiatePlayer(0, HEIGHT-1, 3)
	#currCube = getSquare(playerGridPos(mainPlayer))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if !gamePaused:
		for player in playerContainer.get_children():
			movePlayer(player)
		
		
func movePlayer(var player):
	var newRow = player.getNextRow()
	var newColumn = player.getNextColumn()
	var playerRow = player.getRow()
	var playerColumn = player.getColumn()
	
	if newRow < 0:
		player.velocity.x -= newRow
	if newRow > WIDTH*TILESIZE:
		player.velocity.x = WIDTH*TILESIZE - playerRow
	if newColumn < 0:
		player.velocity.z -= newColumn
	if newColumn > HEIGHT*TILESIZE:
		player.velocity.z = HEIGHT*TILESIZE - playerColumn
		
		
	var startingSquare = player.gridPos()
	
		
	
	if player.pushed:
		if (player.pushTarget.x != startingSquare.x or player.pushTarget.y != startingSquare.y):
			if player.pushVelocity.x != 0:
				player.velocity.x = player.pushVelocity.x
			if player.pushVelocity.y != 0:
				player.velocity.z = player.pushVelocity.y
	
		else:
			player.pushed = false
		
	
	player.translate(player.velocity)
	
	var endingSquare = player.gridPos()
	if endingSquare.x != startingSquare.x and endingSquare.y != startingSquare.y:
		player.translate(-player.velocity)
		player.velocity.z=0
		player.translate(player.velocity)
		endingSquare = player.gridPos()
	
	if endingSquare != startingSquare:
		var direction = endingSquare - startingSquare		
		if isTileEmpty(endingSquare):
			
			
			if !player.cube.rolling and !player.pushed:
				roll(direction, startingSquare, player)
			else:
				if direction.x != 0:
					player.setRow(playerRow)
				if direction.y != 0:
					player.setColumn(playerColumn)
				if endingSquare != player.pushTarget and player.pushed:
					player.setRow(playerRow + player.pushVelocity.x)
					player.setColumn(playerColumn + player.pushVelocity.y)
				#halted = true	
func lightCount(lightMap):
	if lightMap.size() < 1:
		return
	var lightNum = 0
	for lights in lightMap:
		if lights.size() == 2:
			if lights[1]:
				lightNum += 1
	return lightNum
		
func getSquare(cubePos):
	return tileData[cubePos.x][cubePos.y]

func avoidCorners():
	pass



func roll(var dir, var cubePos, var player):
	if getSquare(cubePos) == null:
		get_tree().reload_current_scene()
	var rollDir
	
	if dir == Vector2.UP:
		rollDir = Vector3.FORWARD
		getSquare(cubePos).gridPos += Vector2(0,-1)
	elif dir == Vector2.DOWN:
		rollDir = Vector3.BACK
		getSquare(cubePos).gridPos += Vector2(0,1)
	elif dir == Vector2.LEFT:
		rollDir = Vector3.LEFT
		getSquare(cubePos).gridPos += Vector2(-1,0)
	elif dir == Vector2.RIGHT:
		rollDir = Vector3.RIGHT
		getSquare(cubePos).gridPos += Vector2(1,0)
	
	roll_co(cubePos, player, rollDir)#tileData[cubePos.x][cubePos.y].roll(rollDir, player.speed)
	tileData[cubePos.x + dir.x][cubePos.y+dir.y] = tileData[cubePos.x][cubePos.y]
	player.cube = tileData[cubePos.x + dir.x][cubePos.y+dir.y]
	tileData[cubePos.x][cubePos.y] = null
	player.rolling = true
	
	for players in playerContainer.get_children():
		if players != player and players.gridPos() == cubePos:
			players.cube = tileData[cubePos.x + dir.x][cubePos.y+dir.y]
			players.push(cubePos + dir, dir, player.speed)

func roll_co(cubePos, player, rollDir):
	if !isTileEmpty(cubePos):
		checkCombo(yield(tileData[cubePos.x][cubePos.y].roll(rollDir, player.speed), "completed"), player)
	else:
		print(cubePos)
func checkCombo(cubePos, player):
	fillMap = []
	lightMap = []
	for i in range (0,HEIGHT):
		fillMap.append([])
		for j in range (0,WIDTH):
			if getSquare(Vector2(i,j)) == null:
				fillMap[i].append(0)
			else:
				fillMap[i].append(getValue(Vector2(i,j)))
	#printArray(fillMap) #prints dice values (rotated on XY axis)
	fill(cubePos, fillMap, getValue(cubePos))
	if getValue(cubePos) > 1 and lightCount(lightMap) >= getValue(cubePos):
		for lightPos in lightMap:
			if lightPos[1]:
				getSquare(lightPos[0]).light(player)

func fill(cubePos, fillMap, fillVal):
	if isTileEmpty(cubePos):
		return
	else:
		if lightMap.has([cubePos,true]) or lightMap.has([cubePos,false]):
			return
		else:
			if fillMap[cubePos.x][cubePos.y] == fillVal:
				lightMap.append([cubePos, true])
				fill (Vector2(cubePos.x+1, cubePos.y), fillMap, fillVal)
				fill (Vector2(cubePos.x-1, cubePos.y), fillMap, fillVal)
				fill (Vector2(cubePos.x, cubePos.y+1), fillMap, fillVal)
				fill (Vector2(cubePos.x, cubePos.y-1), fillMap, fillVal)
			else:
				lightMap.append([cubePos, false])
		
	pass
func isLit(playerPos):
	pass
func isTileEmpty(var playerPos):
	if playerPos.x >= tileData.size() or playerPos.x < 0:
		return true
	if playerPos.y >= tileData[0].size() or playerPos.y < 0:
		return true
	if tileData[playerPos.x][playerPos.y] == null:
		return true
	return false




func _on_Timer_timeout():
	
	spawnCube()
	for players in playerContainer.get_children():
		players.speed += 0.0001
	pass # Replace with function body.
