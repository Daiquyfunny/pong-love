local radket = require("radket")
local ball = require("ball")

local love = require("love")
local screenWidth = love.graphics.getWidth()
local screenHeight = love.graphics.getHeight()
local constSpeedRadket = 235
local constSpeedBall = 300

local radketR = radket.new(100 / 2, 725, screenHeight, constSpeedRadket)
local radketL = radket.new(100 / 2, 65, screenHeight, constSpeedRadket)
local tennis = ball.new(screenWidth / 2, screenHeight / 2, 10, constSpeedBall)

function love.load() end

local function collisionDetection(circle, rect)
	local closestX = math.max(rect.x, math.min(circle.x, rect.x + rect.width))
	local closestY = math.max(rect.y, math.min(circle.y, rect.y + rect.height))

	local distance = math.sqrt((circle.x - closestX) ^ 2 - (circle.y - closestY) ^ 2)
	return distance <= circle.radius
end

local function bounceBall(circle, paddle)
	circle.vx = -circle.vx

	-- Optional: Add variation to vertical velocity based on where it hits the paddle
	local hitPosition = (circle.y - paddle.y) / paddle.height
	local newAngle = hitPosition * math.pi / 4
	local newSpeed = math.sqrt(circle.vx ^ 2 + circle.vy ^ 2)
	local randomStuff = math.random(0, 1)
	if randomStuff == 1 then
		circle.vy = newSpeed * math.sin(newAngle)
	end
end

local function respawnBall(circle)
	circle.x = screenWidth / 2
	circle.y = screenHeight / 2
	circle.vy = 0
end

function love.update(dt)
	tennis.x = tennis.x + tennis.vx * dt
	tennis.y = tennis.y + tennis.vy * dt

	if love.keyboard.isDown("up") then
		radketR:move(false, dt)
	elseif love.keyboard.isDown("down") then
		radketR:move(true, dt)
	end

	if love.keyboard.isDown("w") then
		radketL:move(false, dt)
	elseif love.keyboard.isDown("s") then
		radketL:move(true, dt)
	end

	if collisionDetection(tennis, radketR) then
		--tennis.vx = -math.abs(tennis.vx)

		bounceBall(tennis, radketR)
	elseif collisionDetection(tennis, radketL) then
		--tennis.vx = math.abs(tennis.vx)
		bounceBall(tennis, radketL)
	end

	if tennis.y >= screenHeight or tennis.y <= 0 then
		tennis.vy = math.sqrt(tennis.vx ^ 2 + tennis.vy ^ 2) * math.sin(math.random(-math.pi / 4, math.pi / 4))
	end

	if tennis.x <= 0 then
		print("right radket wins")
		respawnBall(tennis)
	elseif tennis.x >= screenWidth then
		print("left radket wins")
		respawnBall(tennis)
	end

	--print(tennis.x)
end

function love.draw()
	radketR:draw()
	radketL:draw()

	tennis:draw()
end
