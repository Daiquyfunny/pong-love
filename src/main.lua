local radket = require("radket")
local ball = require("ball")

local love = require("love")
local screenWidth = love.graphics.getWidth()
local screenHeight = love.graphics.getHeight()
local constSpeedRadket = 235
local constSpeedBall = 300

local radketR = radket.new(100 / 2, screenWidth - 65, screenHeight, constSpeedRadket)
local radketL = radket.new(100 / 2, 50, screenHeight, constSpeedRadket)
local tennis = ball.new(screenWidth / 2, screenHeight / 2, 10, constSpeedBall)

function love.load() end

local function collisionDetection(circle, rect)
	return circle.x >= rect.x
		and circle.x <= rect.x + rect.width
		and circle.y >= rect.y
		and circle.y <= rect.y + rect.height
end

local function bounceBall(circle, paddle)
	circle.vx = -circle.vx

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
		bounceBall(tennis, radketR)
		print(tennis.vy)
	elseif collisionDetection(tennis, radketL) then
		bounceBall(tennis, radketL)
		print(tennis.vy)
	end

	if tennis.y >= screenHeight - 20 or tennis.y <= 0 then
		tennis.vy = -tennis.vy
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
