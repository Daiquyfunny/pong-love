local radket = {}
radket.__index = radket

function radket.new(size, x, screenHeight, vy)
	local newRadket = setmetatable({}, radket)
	newRadket.width = 1 / 3 * size
	newRadket.height = 3 * size
	newRadket.x = x
	newRadket.y = screenHeight / 2 - newRadket.height / 2
	newRadket.vy = vy

	return newRadket
end

function radket:draw()
	love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end

function radket:move(bool, dt)
	if bool then
		self.y = self.y + self.vy * dt
	elseif bool == false then
		self.y = self.y - self.vy * dt
	end
end

return radket
