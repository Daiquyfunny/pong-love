local ball = {}
ball.__index = ball

function ball.new(x, y, radius, vx)
	local newBall = setmetatable({}, ball)
	newBall.x = x
	newBall.y = y
	newBall.radius = radius
	newBall.vx = vx
	newBall.vy = 0

	return newBall
end

function ball:draw()
	love.graphics.circle("fill", self.x, self.y, self.radius)
end

return ball
