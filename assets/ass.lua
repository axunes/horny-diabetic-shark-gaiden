function math.clamp(v, min, max)
	return math.max(min, math.min(max, v))
end



Vector2 = {new = function(x, y) end}

Vector2 = {
	mt = {
		__add = function (a, b) 
			return Vector2.new(a.x + b.x, a.y + b.y)
		end,

		__sub = function (a, b) 
			return Vector2.new(a.x - b.x, a.y - b.y)
		end,

		__mul = function (a, b) 
			return Vector2.new(a.x * b.x, a.y * b.y)
		end,

		__eq = function (a, b) 
			return (a.x == b.x) and (a.y == b.y)
		end
	},

	new = function(x, y)
		local v = {
			x = x or 0,
			y = y or 0,
		}

		v.clamp = Vector2.clamp
		v.floor = Vector2.floor
		
		setmetatable(v, Vector2.mt)
	
		return v
	end
}

Vector2.ZERO = Vector2.new()


function Vector2.clamp(self, min, max)
	return Vector2.new(
		math.clamp(self.x, min.x, max.x),
		math.clamp(self.y, min.y, max.y)
	)
end

function Vector2.floor(self)
	return Vector2.new(
		math.floor(self.x),
		math.floor(self.y)
	)
end


local player = {
	ACCELERATION = 0.5,
	DECELERATION = 0.5,
	MAX_VELOCITY = 5,

	position = Vector2.new(),
	velocity = Vector2.new(),
	
	tick = function(self, v)
		local joy_vector = get_arrows()
		if joy_vector == Vector2.ZERO then
			self.velocity = self.velocity - Vector2.new(
				self.velocity.x > 0 and self.DECELERATION or self.velocity.x < 0 and -self.DECELERATION or 0,
				self.velocity.y > 0 and self.DECELERATION or self.velocity.y < 0 and -self.DECELERATION or 0
			)
		else
			self.velocity = (self.velocity + joy_vector * Vector2.new(self.ACCELERATION, self.ACCELERATION)):clamp(Vector2.new(-self.MAX_VELOCITY, -self.MAX_VELOCITY), Vector2.new(self.MAX_VELOCITY, self.MAX_VELOCITY))
		end

		self.position = (self.position + self.velocity):floor()
	end
}






function get_arrows()
	return Vector2.new(
		(btn(Button.p1.right) and 1 or 0) - (btn(Button.p1.left) and 1 or 0),
		(btn(Button.p1.down) and 1 or 0) - (btn(Button.p1.up) and 1 or 0)
	)
end